# minimal wrappers for autogluons to ease use in R
# ------------------------------------------------

#' AutoGluon Tabular Function
#'
#' @param target a variable to "target" for within the training data
#'
#' @returns a list of the initial fit (for other processes) and the predictions
ag_tabular_module <- \(target = "target_variable"){

  fit <- ag_tabular$TabularPredictor(label = target)$fit(paste0(here::here(), "/training.csv"))

  preds <- fit$predict(paste0(here::here(), "/testing.csv")) |> stack()

  # ret <- list(
  #   #  No method asJSON S3 class: python.builtin.object issue via ellmer tool (jsonlite::toJSON(fit))
  #   fit = fit,
  #   preds = preds
  #   )

  fit_loc <- paste0("fitted model located at: ", paste0(here::here(), "/AutogluonModels/", list.files("AutogluonModels") |> max()))
  ldrbrd <- fit$leaderboard(paste0(here::here(), "/testing.csv"))

  ret <- list(
    fit_location = fit_loc,
    leaderboard = ldrbrd,
    preds = preds
  )

  return(ret)
}


#' most recently trained gluons model and test preds
#'
#' @return list of python.builtin.object and predictions
load_trained_model_and_predict <- \(){

 fit <- ag_tabular$TabularPredictor$load(
    paste0(here::here(), 
    "/AutogluonModels/", 
    list.files("AutogluonModels") |> max())
  )

  predictions <- fit$predict(paste0(here::here(), "/testing.csv")) |> stack()

  ret <- list(fit = fit, 
              predictions = predictions
            )

}

#' Saves a training data as csv
#'
#' @param training_data The training dataframe
#' @return none
save_training_data_csv <- \(training_data = "mtcars"){
  arrow::write_csv_arrow(get(training_data), sink = paste0(here::here(), "/training.csv")) 
}

#' Saves a testing data as csv
#'
#' @param testing_data The testing dataframe
#' @return none
save_testing_data_csv <- \(testing_data = "mtcars"){
  arrow::write_csv_arrow(get(testing_data), sink = paste0(here::here(), "/testing.csv")) 
}
