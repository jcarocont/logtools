#' Factory de wrappers savelog
#' @param fn función de instalación a wrappear
#' @return función con captura de log activada
#' @noRd
.make_savelog_wrapper <- function(fn) {
  function(...) {
    log_path <- tempfile(fileext = ".log")
    .Call("start_capture", log_path)
    on.exit({
      .Call("stop_capture")
      .install_env$log <- readLines(log_path)
    })
    fn(...)
  }
}
#' Wrappers de instalación con captura de log
#'
#' @description
#' Wrappers sobre \code{install.packages} y las funciones \code{install_*} de
#' \code{remotes} que capturan stdout/stderr del proceso de compilación,
#' incluyendo bloques ANTICONF de dependencias de sistema.
#'
#' @details
#' \subsection{Internals}{
#'   Todos los wrappers se generan con \code{.make_savelog_wrapper}, que
#'   maneja el ciclo start_capture / on.exit / stop_capture.
#' }
#' \subsection{install.packages.savelog}{
#'   Wrapper sobre \code{base::install.packages}.
#' }
#' \subsection{install_git.savelog}{
#'   Wrapper sobre \code{remotes::install_git}.
#' }
#' \subsection{install_github.savelog}{
#'   Wrapper sobre \code{remotes::install_github}.
#' }
#' \subsection{install_gitlab.savelog}{
#'   Wrapper sobre \code{remotes::install_gitlab}.
#' }
#' \subsection{install_bioc.savelog}{
#'   Wrapper sobre \code{remotes::install_bioc}.
#' }
#' \subsection{install_bitbucket.savelog}{
#'   Wrapper sobre \code{remotes::install_bitbucket}.
#' }
#' \subsection{install_cran.savelog}{
#'   Wrapper sobre \code{remotes::install_cran}.
#' }
#' \subsection{install_local.savelog}{
#'   Wrapper sobre \code{remotes::install_local}.
#' }
#' \subsection{install_url.savelog}{
#'   Wrapper sobre \code{remotes::install_url}.
#' }
#' \subsection{install_version.savelog}{
#'   Wrapper sobre \code{remotes::install_version}.
#' }
#' \subsection{get_anticonf}{
#'   Parsea el log capturado y retorna los bloques delimitados por ANTICONF,
#'   con 6 líneas de contexto por bloque.
#' }
#'
#' @param ... argumentos pasados a la función subyacente
#' @return Las funciones \code{install_*.savelog} retornan invisiblemente lo
#'   que retorna la función subyacente. \code{get_anticonf} retorna una lista
#'   de character vectors, uno por bloque ANTICONF encontrado.
#'
#' @examples
#' \dontrun{
#' install.packages.savelog("V8")
#' get_anticonf()
#' }
#'
#' @name savelog-wrappers
NULL

#' @rdname savelog-wrappers
#' @export
install.packages.savelog <- .make_savelog_wrapper(install.packages)

#' @rdname savelog-wrappers
#' @export
install_git.savelog <- .make_savelog_wrapper(remotes::install_git)

#' @rdname savelog-wrappers
#' @export
install_github.savelog <- .make_savelog_wrapper(remotes::install_github)

#' @rdname savelog-wrappers
#' @export
install_gitlab.savelog <- .make_savelog_wrapper(remotes::install_gitlab)

#' @rdname savelog-wrappers
#' @export
install_bioc.savelog <- .make_savelog_wrapper(remotes::install_bioc)

#' @rdname savelog-wrappers
#' @export
install_bitbucket.savelog <- .make_savelog_wrapper(remotes::install_bitbucket)

#' @rdname savelog-wrappers
#' @export
install_cran.savelog <- .make_savelog_wrapper(remotes::install_cran)

#' @rdname savelog-wrappers
#' @export
install_local.savelog <- .make_savelog_wrapper(remotes::install_local)

#' @rdname savelog-wrappers
#' @export
install_url.savelog <- .make_savelog_wrapper(remotes::install_url)

#' @rdname savelog-wrappers
#' @export
install_version.savelog <- .make_savelog_wrapper(remotes::install_version)

#' @rdname savelog-wrappers
#' @export
get_anticonf <- function() {
  log <- .install_env$log
  if (is.null(log) || length(log) == 0) return("Log vacío")
  idx <- grep("ANTICONF", log)
  if (length(idx) == 0) return("No se encontraron bloques ANTICONF")
  lapply(idx, \(i) log[i:min(i+6, length(log))])
}
