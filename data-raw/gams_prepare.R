library(dplyr)
library(igraph)
library(magrittr)

data_filename <- "./data-raw/dados_comarcas_empresas.rds"
data_varas <- readRDS(data_filename)

gams_filename <- "./data-raw/ALOC_VARAS.GMS"
arquivo_gams <- file(gams_filename)

n_comarcas <- dim(data_varas)[1]
linhas_set <- paste("SET c comarcas / c1*c",
                    as.character(n_comarcas),
                    " /;", sep = "")
linhas_set %<>%
  paste("\n", "ALIAS(c,v)", "\n", sep = "")

perc_processos <- round(unlist(data_varas[, 2] / sum(data_varas[, 2])), 4)
linhas_parameter <- "PARAMETER p(c) percentual de processos por comarca \n"
linhas_parameter %<>%
  paste("\t/ c1 ", perc_processos[1], "\n", sep = "")
for (ii in 2:(n_comarcas - 1)) {
  linhas_parameter %<>%
    paste("\t  c", ii, " ", perc_processos[ii], "\n", sep = "")
}
linhas_parameter %<>%
  paste("\t  c", n_comarcas, " ", perc_processos[n_comarcas], " /;\n", sep = "")
dist_comarcas <- data_varas[1:n_comarcas, 3:(n_comarcas+2)] %>%
  as.matrix() %>%
  graph.adjacency(mode="undirected") %>%
  distances()

linhas_parameter_2 <- "TABLE d(c,v) distancia entre comarcas\n"
for (jj in 0:(n_comarcas %/% 10)) {
  indices <- jj * 10 + 1:10
  indices <- indices[which(indices <= n_comarcas)]
  linha_cols <- ifelse(jj, "+ ", "")
  cols <- indices %>%
    sapply(function(idx) paste("\tc", idx, sep = "")) %>%
    paste(collapse = " ")
  linha_cols %<>% paste(cols, sep = "")
  linhas_parameter_2 %<>%
    paste(linha_cols, "\n", sep = "")
  for (ii in 1:n_comarcas) {
    linha_distancias <- paste("c", ii, " ", sep = "")
    dist_string <- dist_comarcas[ii,indices] %>%
      sapply(function(dist) paste("\t", dist, sep = "")) %>%
      paste(collapse = " ")
    linha_distancias %<>%
      paste(dist_string,"\n", sep = "")
    linhas_parameter_2 %<>%
      paste(linha_distancias, sep = "")
  }
}

linhas_parameter_2 %<>% paste(";\n", sep = "")
linhas_parameter_3 <- "SCALAR numvaras numero de varas a ser alocadas /2/;\n"
linha_variables <- c("VARIABLES",
                     "\tj(c,v) \tjurisdicao da vara v sobre a comarca c",
                     "\te(v)   \texistencia de vara na comarca",
                     "\tz      \tcusto de transporte;\n",
                     "BINARY VARIABLE j;",
                     "BINARY VARIABLE e;\n")
linha_equations <- c("EQUATIONS",
                     "\tdemanda(c) \ttoda comarca alocada a uma unica vara",
                     "\tfact(c,v) \tcomarcas apenas alocadas a varas",
                     "\toferta \tnumero maximo de varas",
                     "\tobjetivo \tfuncao objetivo;\n",
                     "demanda(c).. \tsum(v, j(c,v)) =e= 1;",
                     "fact(c,v).. \tj(c,v) =l= e(v);",
                     "oferta.. \tsum(v, e(v)) =e= numvaras;",
                     "objetivo.. \tz =e= sum((c,v), p(c)*j(c,v)*d(c,v));\n")
linha_model <- "MODEL alocvaras / all /;\n"
linha_options <- "OPTION iterlim = 200000;\n"
linha_solve <- "SOLVE alocvaras using MIP minimizing z;\n";
linha_display <- "DISPLAY j.l, e.l;\n"
linhas_gams <- c(linhas_set,
                 linhas_parameter,
                 linhas_parameter_2,
                 linhas_parameter_3,
                 linha_variables,
                 linha_equations,
                 linha_model,
                 linha_options,
                 linha_solve,
                 linha_display)

writeLines(linhas_gams, arquivo_gams)
close(arquivo_gams)

