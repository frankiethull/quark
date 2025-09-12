
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quark

<!-- badges: start -->

<!-- badges: end -->

The goal of quark is to streamline a no-code solutions with AutoGluons.

## Installation (R Dependencies)

You can install the development version of quark like so:

``` r
devtools::install_github("frankiethull/quark")
```

## Setup (Environment + Python Dependencies)

``` r
# 1) Create the virual env
quark::create_quark_env()

# 2) Use the env
quark::use_quark_env()

# 3) install packages
quark::install_quark_dependencies()
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(quark)
quark::use_quark_env()
```

``` r
# add training and testing data to my environment
mtcars_train <- mtcars |> head(20)
mtcars_test <- mtcars |> tail(5)
 
provider <- "ollama"
llm <- "mistral-nemo"

question <- "please use 'mtcars_train' as training data and 'mtcars_test' as testing data and run the tabular module. I want to predict 'mpg'."

agent_fit_and_preds <- chat_quark(provider = provider, model = llm, prompt = question)

agent_fit_and_preds$agent_summary
#> I have run the AutoGluon Tabular module using 'mtcars_train' as training data 
#> and 'mtcars_test' as testing data to predict 'mpg'. The best performing model 
#> based on cross-validation is WeightedEnsemble_L2 with a score of -0.8674 on the
#> validation set.
#> 
#> Here are the top five models from the leaderboard:
#> 
#> 1. WeightedEnsemble_L2: Score (Validation) = -0.8674, Pred Time (Test/Val) = 
#> 0.011 / 0.0018 seconds, Fit Time = 2.4972 seconds
#> 2. XGBoost: Score (Validation) = -1.2595, Pred Time (Test/Val) = 0.0068 / 
#> 0.0012 seconds, Fit Time = 0.0698 seconds
#> 3. LightGBMLarge: Score (Validation) = -3.8789, Pred Time (Test/Val) = 0.0009 /
#> 0.0003 seconds, Fit Time = 0.1422 seconds
#> 4. ExtraTreesMSE: Score (Validation) = -2.8635, Pred Time (Test/Val) = 0.0312 /
#> 0.0511 seconds, Fit Time = 0.2987 seconds
#> 5. CatBoost: Score (Validation) = -2.2423, Pred Time (Test/Val) = 0.0033 / 
#> 0.0004 seconds, Fit Time = 2.424 seconds
#> 
#> The predicted MPG values for the first five points in the testing dataset are 
#> as follows:
#> 
#> 1. Mazda RX4: Predicted MPG = 26.09
#> 2. Mazda RX4 Wag: Predicted MPG = 18.76
#> 3. Datsun 710: Predicted MPG = 20.62
#> 4. Hornet Sportabout: Predicted MPG = 14.99
#> 5. Merc 280C: Predicted MPG = 22.68
```
