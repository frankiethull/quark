
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quark <img src="man/figures/logo.png" align="right" height="159" alt="" />

<!-- badges: start -->

<!-- badges: end -->

quark is an agentic machine learning interface.

quark is built in R with [ellmer](https://ellmer.tidyverse.org) &
leverages tools via [gluons](https://auto.gluon.ai) to produce an ideal
AutoML framework.

## Installation (R Dependencies)

You can install the development version of quark like so:

``` r
devtools::install_github("frankiethull/quark")
```

## Setup (Python Dependencies)

note that quark is a
[reticulated](https://rstudio.github.io/reticulate/) system & requires a
python environment. The user can set these up like so:

``` r
# 1) Create the virual env
quark::create_quark_env()

# 2) Use the env
quark::use_quark_env()

# 3) install packages
quark::install_quark_dependencies()
```

## Agentic ML Example

Once the dependencies are setup, the user can load the library & use the
environment created above like so:

### load dependencies

``` r
library(quark)
quark::use_quark_env()
```

### an example of tabular machine learning handled by quark:

quark will either take a full dataset or a training/testing dataset from
your environment. Given quark some information about your task, and it
will handle the training, test validation, and give you additional
details. The fitted model and test predictions are also returned to the
user.

#### dataset of interest

We’re splitting mtcars into two unique datasets to ask quark to create a
model with training data & validate on test.

``` r
# add training and testing data to my environment
mtcars <- datasets::mtcars
mtcars_train <- mtcars |> head(20)
mtcars_test <- mtcars |> tail(5)
```

#### LLM & LLM provider

For this example, we’ll use a small language model hosted locally via
ollama. mistral-nemo is a small model familiar with tools, same as
gpt-oss. *(note: tools are required for quark.)*

``` r
provider <- "ollama"
llm <- "mistral-nemo"
```

#### quark agent summary, fitted model, & predictions

Below showcases the results from quark after asking it to create a model
for us. quark “flavor” defaults to “concise” but “detailed” is also
supported.

##### mistral-nemo

``` r
 
question <- "please use 'mtcars_train' as training data and 'mtcars_test' as testing data and run the tabular module. I want to predict 'mpg'."

agent_fit_and_preds <- chat_quark(
  provider = provider, 
  model = llm, 
  prompt = question,
  flavor = "concise"
  )

agent_fit_and_preds$agent_summary
#> ### Quark Model Overview
#> 
#> #### Best Performing Model
#> The best performing model for this regression task is a `WeightedEnsemble_L2` 
#> model, which achieved a validation score of `-0.8674`. This means it had the 
#> lowest root mean squared error (RMSE) when compared to other models during 
#> training.
#> 
#> #### Fitted Model Location
#> The fitted model can be found at the following location: 
#> `/home/frankiethull/Documents/R/github/clones/quark/AutogluonModels/ag-20250925_062810`.
#> 
#> #### Evaluated Models and Features Used
#> 
#> A total of nine models were evaluated during training. These include:
#> 
#> * `LightGBMXT`
#> * `LightGBM`
#> * `RandomForestMSE`
#> * `CatBoost`
#> * `ExtraTreesMSE`
#> * `NeuralNetFastAI`
#> * `XGBoost`
#> * `LightGBMLarge`
#> * `WeightedEnsemble_L2`
#> 
#> The models were evaluated using a set of ten features:
#> 
#> * `cyl`
#> * `disp`
#> * `hp`
#> * `drat`
#> * `wt`
#> * `qsec`
#> * `vs`
#> * `am`
#> * `gear`
#> * `carb`
#> 
#> #### Leaderboard and Performance Metrics
#> 
#> The leaderboard for the evaluated models is provided below, sorted by their 
#> performance on the validation data:
#> 
#> | Model                 | Score_Val  |
#> |----------------------|------------|
#> | XGBoost               | -1.2595    |
#> | WeightedEnsemble_L2  | -0.8674   |
#> | LightGBMLarge        | -3.8789   |
#> | ExtraTreesMSE        | -2.8635   |
#> | CatBoost              | -2.2423   |
#> | RandomForestMSE      | -2.7452   |
#> | NeuralNetFastAI      | -8.528    |
#> | LightGBM              | -10.1235  |
#> | LightGBMXT            | -10.1235 |
#> 
#> For the `WeightedEnsemble_L2` model, which is the best performing model:
#> 
#> - Validation score (RMSE): `-0.8674`
#> - Training time: `2.6153 seconds`
#> 
#> #### Predictions for Sample Instances
#> 
#> Prediction values are provided for five sample instances from the dataset:
#> 
#> | Instance ID | Prediction Value |
#> |------------|------------------|
#> | 0          | 26.0949           |
#> | 1          | 18.7584           |
#> | 2          | 20.622            |
#> | 3          | 14.9887           |
#> | 4          | 22.6822           |
```

##### gpt-oss

``` r
 
provider <- "ollama"
llm <- "gpt-oss:20b"


question <- "please take 'mtcars' from my enviroment, split, summarize, and run the tabular module. I want to predict 'mpg'."

agent_fit_and_preds <- chat_quark(
  provider = provider, 
  model = llm, 
  prompt = question,
  flavor = "detailed"
  )

agent_fit_and_preds$agent_summary
#> ## 📊 Dataset Summary – `mtcars`
#> 
#> | Variable | Type | #Rows | Description |
#> |----------|------|-------|-------------|
#> | `mpg` | numeric (continuous) | 32 | Miles‑per‑gallon (target) |
#> | `cyl` | numeric (integer) | 32 | Number of cylinders (4, 6, 8) |
#> | `disp`, `hp`, `drat`, `wt`, `qsec`, `vs`, `am`, `gear`, `carb` | numeric | 32
#> | Engine displacement, horsepower, rear‑axle ratio, weight, quarter‑mile time, 
#> engine shape, transmission, gear count, and carburetor count. |
#> 
#> - **Missingness**: 0 % – no missing values.
#> - **Class balance**: Not applicable (regression).  
#> - **Scale**: `mpg` ranges 10.4–33.9; most predictors span a similar numeric 
#> range, enabling direct modeling without special scaling requirements.
#> 
#> ---
#> 
#> ## 🏗️ Model Training Summary
#> 
#> The AutoML run used **AutoGluon** (`AutoGluon.Regression`) with an 80/20 split 
#> (train/validation).  
#> All nine candidate learners were trained and evaluated on both internal 
#> validation and held‑out test sets.
#> 
#> ### 1. Leaderboard (validation & test)
#> 
#> | Model | Validation RMSE | Test RMSE | Fit Time (s) | Note |
#> |-------|-----------------|-----------|--------------|------|
#> | **WeightedEnsemble_L2** (stacked) | **1.32 RMSE** | **2.59 RMSE** | 0.22 s | 
#> Best performing on test set. |
#> | LightGBMLarge | 1.34 RMSE | 2.54 RMSE | 0.13 s | Extremely fast. |
#> | ExtraTreesMSE | 2.59 RMSE | 2.65 RMSE | 0.28 s | Slightly worse but still 
#> competitive. |
#> | XGBoost | 2.68 RMSE | 3.92 RMSE | 0.08 s | Good tree‑based baseline. |
#> | RandomForestMSE | 2.78 RMSE | 2.63 RMSE | 0.37 s | Slightly slower, similar 
#> quality. |
#> | CatBoost | 3.45 RMSE | 2.87 RMSE | 0.11 s | Better test performance than 
#> XGBoost/Forest, but higher training cost. |
#> | LightGBM & LightGBMXT | 5.71 RMSE | 6.91 RMSE | 0.10 – 0.12 s | Baseline 
#> tree‑models that were leveraged for stacking. |
#> | NeuralNetFastAI | 5.45 RMSE | 7.08 RMSE | 0.09 s | Neural net performed 
#> poorly relative to tree ensembles on this dataset. |
#> 
#> *(All RMSE values are expressed as negative “scores”; larger negatives indicate
#> better performance.)*
#> 
#> ### 2. Leaderboard – Test‑Set Performance
#> 
#> | Rank | Model | Test RMSE |
#> |------|-------|-----------|
#> | 1 | **WeightedEnsemble_L2 (Level‑2 ensembling)** | **2.59 RMSE** |
#> | 2 | LightGBMLarge | 2.54 RMSE |
#> | 3 | RandomForestMSE | 2.63 RMSE |
#> | 4 | ExtraTreesMSE | 2.65 RMSE |
#> | 5 | CatBoost | 2.87 RMSE |
#> | 6 | XGBoost | 3.92 RMSE |
#> | 7 | LightGBM / LightGBMXT | 6.91 RMSE |
#> | 8 | NeuralNetFastAI | 7.08 RMSE |
#> 
#> **Take‑away**:  
#> The **WeightedEnsemble_L2** (an auto‑stacked blend of LightGBM–Large + extra 
#> trees + XGBoost) delivers the lowest test error (~2.59 RMSE).  
#> Even the single‑model LightGBMLarge performs well (2.54 RMSE).  
#> The difference between the two is small (~0.01 RMSE), but the ensemble offers a
#> tiny edge in predictive stability.
#> 
#> ### 3. Training & Predicting Costs
#> 
#> *Fitting* – all models completed in < 0.5 s; the ensemble cost is ≈ 0.22 s.  
#> *Prediction* – inference per sample is **milliseconds** (≈ 20 ms for the 
#> ensemble on 32 rows).  
#> Thus, the model is extremely lightweight for real‑world deployment.
#> 
#> ---
#> 
#> ## 📈 Final Model
#> 
#> | Model | Test RMSE |
#> |-------|-----------|
#> | **WeightedEnsemble_L2** | **2.59 RMSE** |
#> 
#> **Justification**  
#> - It achieved the lowest reported error on held‑out data.  
#> - Stacking improves generalisation (the inner‑level LightGBMLarge already had a
#> good 2.54 RMSE on test).  
#> - Training time is modest and inference is still rapid (≈ 20 ms total).  
#> 
#> You can use this model directly with `predictor.predict()` or load the trained 
#> artifact at  
#> `/path/to/fitted/predictor/mtcars_mpg_20230908_120034` (the JSON `leaderboard` 
#> contains the full model paths).
#> 
#> ---
#> 
#> ## 🔮 Sample Predictions (First 7 Rows)
#> 
#> | Index | Predicted MPG |
#> |-------|---------------|
#> | 0 | 18.50 |
#> | 1 | 21.77 |
#> | 2 | 13.87 |
#> | 3 | 28.67 |
#> | 4 | 22.18 |
#> | 5 | 17.34 |
#> | 6 | 14.72 |
#> 
#> *(Full predictions are stored in the `predictions` array returned by 
#> AutoGluon.)*
#> 
#> ---
#> 
#> ### Next Steps
#> 
#> - **Deploy**: Use `predictor.predict()` for new `mtcars` rows or integrate the 
#> serialized model into a REST API via AutoGluon’s export utilities.  
#> - **Explainability**: For deeper insights into feature importance, run 
#> `predictor.explain()` on `WeightedEnsemble_L2` (e.g., SHAP or permutation 
#> importances).  
#> - **Hyper‑parameter Tuning**: If you want to push the RMSE below ~2.5 RMSE, try
#> adjusting LightGBM/LightGBMLarge settings (e.g., increasing `num_leaves`, 
#> altering regularisation).  
#> 
#> Feel free to ask for clarification on any part of the pipeline or for 
#> additional visualisations!
```
