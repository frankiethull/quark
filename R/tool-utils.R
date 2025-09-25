# building tools for ellmer to call autogluon wrappers and helpers
# ----------------------------------------------------------------

#' tabular autogluon tool for ellmer
tabular_tool <- ellmer::tool(
  ag_tabular_module,
  name = "tabular_tool",
  description = "fits an tabular model then returns the fitted model, test predictions, and supplemental info.",
  arguments = list(
    target = ellmer::type_string(
      "a target column for the models to fit for, most likely described by user.",
      required = TRUE
    )
  )
)

#' summarize and save off data as training.csv
summarize_and_save_training_data_csv_tool <- ellmer::tool(
  summarize_and_save_training_data_csv,
  name = "summarize_and_save_training_data_csv_tool",
  description = "Saves off a training dataframe as csv, returns a summary of data for context",
  arguments = list(
    training_data = ellmer::type_string(
      "a dataframe name such as 'mtcars_train' a df in the environment to summarize and save as csv",
      required = TRUE
    )
  )
)

#' summarize and save off data as testing.csv
summarize_and_save_testing_data_csv_tool <- ellmer::tool(
  summarize_and_save_testing_data_csv,
  name = "summarize_and_save_testing_data_csv_tool",
  description = "Saves off a testing dataframe as csv, returns a summary of data for context.",
  arguments = list(
    testing_data = ellmer::type_string(
      "a dataframe name such as 'mtcars_test' a df in the environment to summarize and save as csv",
      required = TRUE
    )
  )
)

#' summarize all data, split into testing/training, save off data as training.csv & testing.csv
summarize_split_and_save_data_csv_tool <- ellmer::tool(
  summarize_split_and_save_data_csv,
  name = "summarize_split_and_save_data_csv_tool",
  description = "This tool is designed for when the user does not
  present both training and testing data but instead shares the full dataset (`all_data`). 
  This tool summarizes the full dataset, then does a 80/20 split into training, testing, and saves both for the tabular module.",
  arguments = list(
    all_data = ellmer::type_string(
      "a dataframe name such as 'mtcars' a df in the environment to split, summarize, and save as csv",
      required = TRUE
    )
  )
)
