# Run GAMS model
path <-  "data-raw"
gams_path <- paste0(path, "/gams24.9_linux_x64_64_sfx/")
system(sprintf("chmod +x -R %s", gams_path))
gdxrrw::igdx(normalizePath(paste0(path, "/gams24.9_linux_x64_64_sfx")))
res <- gdxrrw::gams(paste0(path, '/ALOC_VARAS.GMS'))
out_file <- sprintf("%s/ALOC_VARAS.lst", getwd())
file.copy(out_file, path, overwrite = TRUE)
file.remove(out_file)
saveRDS(res, paste0(path, "/result.rds"))
