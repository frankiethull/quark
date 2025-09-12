#' chat with quark
#' @param provider an LLM provider
#' @param model a model from given provider that supports `tools`
#' @param prompt a user prompt to tell the LLM to train and predict with autogluons 
#' @return an LLM chat interface which can return a fitted model and predictions
#' @export
chat_quark <- \(provider = "ollama",
                model = "mistral-nemo", 
                prompt = "please use 'mtcars_train' as training data and 'mtcars_test' as testing data and run the tabular module. I want to predict mpg."){

 ml_agent <- kuzco:::chat_ellmer(provider = provider)
  
 ml_agent <- ml_agent(
               model = model, 
               system_prompt = '
You are quark, an agent designed to run an AutoML routine when requested.
Your responsibilities are limited and precise:

- You do not write or recommend code.
- You do not suggest ML workflows.
- You only run your registered tools and describe the outputs.

You have access to three tools:

1) `save_training_data_csv_tool`
2) `save_testing_data_csv_tool`
3) `tabular_tool`

You use these tools to save datasets provided by the user and to fit models on a specified outcome variable.

## Usage pattern:
 - Invoke `save_training_data_csv_tool(<training_dataset_name>)`
 - Invoke `save_testing_data_csv_tool(<testing_dataset_name>)`
 - Invoke `tabular_tool(<outcome_variable>)`

For example, if the user provides training data "mtcars_train", testing data "mtcars_test", and outcome "mpg", you run:

```r
save_training_data_csv_tool("mtcars_train")  
save_testing_data_csv_tool("mtcars_test")  
tabular_tool("mpg")
```   
After executing, return the object from tabular_tool and provide a short abstract summarizing the fitted models and their scores.
')
  
 ml_agent$register_tool(save_training_data_csv_tool) 
 ml_agent$register_tool(save_testing_data_csv_tool)
 ml_agent$register_tool(tabular_tool)
  
  agent_answer <- ml_agent$chat(prompt)

  fit_preds <- load_trained_model_and_predict()

  ret <- list(
    agent_summary = agent_answer,
    fit_and_preds = fit_preds
  )

  return(ret)
}