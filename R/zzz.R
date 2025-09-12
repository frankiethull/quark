ag_tabular    <- NULL

.onLoad <- function(libname, pkgname) {
  reticulate::py_require("autogluon")

  # autogluon modules
  ag_tabular    <<- reticulate::import("autogluon.tabular",    delay_load = TRUE)
  ag_timeseries <<- reticulate::import("autogluon.timeseries", delay_load = TRUE)
  ag_multimodal <<- reticulate::import("autogluon.multimodal", delay_load = TRUE)

}
