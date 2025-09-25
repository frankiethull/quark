# minimal wrappers for autogluons to ease use in R
# ------------------------------------------------

#' AutoGluon Tabular Fitted Model In-Sample Information
#'
#' @param object a fitted autogluons model of class (autogluon.tabular.predictor.predictor.TabularPredictor)
#'
#' @returns a list of in-sample metrics with model and data information
autogluon_tabular_fit_info <- \(object){
  problem_type <- object$problem_type
  best_model <- object$model_best
  eval_models <- object$model_names()
  xregs <- object$feature_metadata$get_features()
  xreg_meta <- object$feature_metadata$print_feature_metadata_full()
  loss <- object$eval_metric$name
  fit_leaderboard <- object$leaderboard()

  jsonlite::toJSON(list(
    problem_type = problem_type,
    best_model = best_model,
    eval_models = eval_models,
    xregs = xregs,
    xreg_meta = xreg_meta,
    loss = loss,
    fit_leaderboard = fit_leaderboard
  ), auto_unbox = TRUE)

}

#' AutoGluon Tabular Function
#'
#' @param target a variable to "target" for within the training data
#'
#' @returns a list of the initial fit (for other processes) and the predictions
ag_tabular_module <- \(target = "target_variable"){

  fit <- ag_tabular$TabularPredictor(label = target)$fit(paste0(here::here(), "/training.csv"))

  fit_info <- autogluon_tabular_fit_info(fit)

  preds <- fit$predict(paste0(here::here(), "/testing.csv")) |> stack()

  fit_loc <- paste0("fitted model located at: ", paste0(here::here(), "/AutogluonModels/", list.files("AutogluonModels") |> max()))
  ldrbrd <- fit$leaderboard(paste0(here::here(), "/testing.csv"))

  ret <- list(
    fit_location = fit_loc,
    fit_information = fit_info,
    leaderboard = ldrbrd,
    predictions = preds
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

  predictions <- fit$predict(paste0(here::here(), "/testing.csv")) |> utils::stack()

  ret <- list(fit = fit, 
              predictions = predictions
            )

}

#' summarizes and saves a training data as csv
#'
#' @param training_data The training dataframe
#' @return saves dataset and returns a summary for context
summarize_and_save_training_data_csv <- \(training_data = "mtcars"){
  arrow::write_csv_arrow(get(training_data), sink = paste0(here::here(), "/training.csv")) 
  skimr::skim(get(training_data))
}

#' summarizes and saves testing data as csv
#'
#' @param testing_data The testing dataframe
#' @return saves dataset and returns a summary for context
summarize_and_save_testing_data_csv <- \(testing_data = "mtcars"){
  arrow::write_csv_arrow(get(testing_data), sink = paste0(here::here(), "/testing.csv")) 
  skimr::skim(get(testing_data))
}


#' summarizes, splits, and saves datasets
#' @description
#' if the user shares an entire data, instead of train/test, 
#' this tool will split the data for the user and stage testing and training for them
#' 
#'  
#' @param all_data 
#' @return splits data into training/testing, saves datasets, and returns a data summary for context
summarize_split_and_save_data_csv <- \(all_data = "mtcars"){

  data_split <- rsample::initial_split(get(all_data), prop = .80)
  training_data <- rsample::training(data_split)
  testing_data <- rsample::testing(data_split)

  arrow::write_csv_arrow(training_data, sink = paste0(here::here(), "/training.csv"))
  arrow::write_csv_arrow(testing_data, sink = paste0(here::here(), "/testing.csv"))
  skimr::skim(get(all_data))
}
