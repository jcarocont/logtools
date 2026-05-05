.install_env <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  dll_path <- system.file("libs", paste0("capture_fd", .Platform$dynlib.ext), package = pkgname)
  if (nzchar(dll_path) && file.exists(dll_path)) {
    dyn.load(dll_path)
  }
}
