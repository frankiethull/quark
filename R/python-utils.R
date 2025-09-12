# binders between Python, R, and venv dependency helpers
# ------------------------------------------------------


#' Create Virtual Environment Wrapper
#'
#' @param envname virtual environment to create
#' @param ... additional passes for `create_virtualenv`
#'
#' @return creation of virtual environment
#' @export
create_quark_env <- \(envname = "quark", ...){
  reticulate::virtualenv_create(envname, ...)
}

#' Use Virtual Environment Wrapper
#'
#' @param envname virtual environment to use
#' @param ...  additional passes for `use_virtualenv`
#'
#' @return sets environment to virtualenv
#' @export
use_quark_env <- \(envname = "quark", ...){
  reticulate::use_virtualenv(envname, ...)
}

#' Install AutoGluons
#'
#' @param envname virtual environment name
#' @param method  method defaults to "auto"
#' @param ...     additional passes for `py_install`
#'
#' @return installs autogluon to "quark" by default
#' @export
install_quark_dependencies <- \(envname = "quark", method = "auto", ...) {
  reticulate::py_install("autogluon",
                         envname = envname,
                         method = method, ...)
}
