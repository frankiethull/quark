# building tools for ellmer to call autogluon wrappers and helpers
# ----------------------------------------------------------------

#' tabular autogluon tool for ellmer
tabular_tool <- ellmer::tool(
  ag_tabular_module,
  name = "tabular_tool",
  description = "fits an tabular model and returns the model and predictions",
  arguments = list(
    target = ellmer::type_string(
      "a target column for the models to fit for, most likely described by user.",
      required = TRUE
    )
  )
)

#' save off data as training.csv
save_training_data_csv_tool <- ellmer::tool(
  save_training_data_csv,
  name = "save_training_data_csv_tool",
  description = "Saves off a training dataframe as csv.",
  arguments = list(
    training_data = ellmer::type_string(
      "a dataframe name such as 'mtcars' a df in the environment to save as csv",
      required = TRUE
    )
  )
)

#' save off data as testing.csv
save_testing_data_csv_tool <- ellmer::tool(
  save_testing_data_csv,
  name = "save_testing_data_csv_tool",
  description = "Saves off a testing dataframe as csv.",
  arguments = list(
    testing_data = ellmer::type_string(
      "a dataframe name such as 'mtcars' a df in the environment to save as csv",
      required = TRUE
    )
  )
)
