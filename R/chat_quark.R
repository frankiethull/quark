#' chat with quark
#' @param provider an LLM provider
#' @param model a model from given provider that supports `tools`
#' @param prompt a user prompt to tell the LLM to train and predict with autogluons 
#' @param flavor a quark "style", either "concise", "detailed", or "refined"
#' @return an LLM chat interface which can return a fitted model and predictions
#' @export
chat_quark <- \(provider = "ollama",
                model = "mistral-nemo", 
                prompt = "please use 'mtcars_train' as training data and 'mtcars_test' as testing data and run the tabular module. I want to predict mpg.",
                flavor = "concise"){

 prompt_flavor <- system.file(paste0("system-quark-", flavor, ".md"), package = "quark") |> 
                  readLines(warn = FALSE) |>
                  paste(collapse = "\n") # |> cat()


 ml_agent <- kuzco:::chat_ellmer(provider = provider)
  
 ml_agent <- ml_agent(
               model = model, 
               system_prompt = prompt_flavor)
  
 ml_agent$register_tool(summarize_and_save_training_data_csv_tool) 
 ml_agent$register_tool(summarize_and_save_testing_data_csv_tool)
 ml_agent$register_tool(summarize_split_and_save_data_csv_tool)
 ml_agent$register_tool(tabular_tool)
  
  agent_answer <- ml_agent$chat(prompt)

  fit_preds <- load_trained_model_and_predict()

  ret <- list(
    agent_summary = agent_answer,
    fit_and_preds = fit_preds
  )

  return(ret)
}