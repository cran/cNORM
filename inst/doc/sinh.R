## ----setup, include = FALSE-------------------------------
knitr::opts_chunk$set(tidy.opts=list(width.cutoff=60),
  collapse = TRUE,
  comment = "#>"
)
options(width = 60)

#devtools::load_all(".")
library(cNORM)

## ----fig1, fig.height = 4, fig.width = 7------------------
# Fit shash model with custom settings
# The function automatically displays percentile plots
model.shash <- cnorm.shash(age = ppvt$age, score = ppvt$raw)


# Use print(model.shash), diagnostics(model.shash) or summary(model.shash)
# to retrieve information on the data fit.

## ----eval=FALSE-------------------------------------------
# # Conservative parameterization with fixed delta across age
# model.simple <- cnorm.shash(age = ppvt$age, score = ppvt$raw,
#                            mu_degree = 2,        # Quadratic location pattern
#                            sigma_degree = 1,     # Linear variability change
#                            epsilon_degree = 1,   # Linear skewness change
#                            delta_degree = NULL,  # deactivates polynimial fitting for delta
#                            delta = 1.1)          # Slightly heavy tails,
#                                                  # kept constant across age
# 
# # Example with more complex parameterization
# model.complex <- cnorm.shash(age = ppvt$age, score = ppvt$raw,
#                            mu_degree = 4,        # Quadric pattern
#                            sigma_degree = 3,     # Complex variability changes
#                            epsilon_degree = 2,   # Quadratic age-varying skewness
#                            delta_degree = 2)     # Changing tail weights across age (quadratic)
# 
# # Compare models
# compare(model.simple, model.complex, age = ppvt$age, score = ppvt$raw,
#         title = "ShaSh Model Comparison")
# 
# 

## ----eval=FALSE-------------------------------------------
# # Calculate post-stratification weights
# margins <- data.frame(variables = c("sex", "sex", "migration", "migration"),
#                      levels = c(1, 2, 0, 1),
#                      share = c(.52, .48, .7, .3))
# 
# weights <- computeWeights(ppvt, margins)
# 
# # Fit weighted ShaSh model
# model.weighted <- cnorm.shash(ppvt$age, ppvt$raw, weights = weights)
# 
# # Compare weighted vs. unweighted
# compare(model.shash, model.weighted, age = ppvt$age, score = ppvt$raw,
#         title = "Unweighted vs. Weighted ShaSh Models")

## ----eval=FALSE-------------------------------------------
# # Individual Norm Score Prediction:
# # Generate norm scores for specific age-score combinations
# ages <- c(10.25, 10.75, 11.25, 11.75)
# raw_scores <- c(180, 185, 190, 195)
# 
# norm_scores <- predict(model.shash, ages, raw_scores)
# prediction_table <- data.frame(
#   Age = ages,
#   Raw_Score = raw_scores,
#   Norm_Score = round(norm_scores, 1)
# )
# print(prediction_table)
# 
# 
# # Norm Score tables:
# # Generate detailed norm tables for multiple ages
# tables <- normTable.shash(model.shash,
#                          ages = c(10.25, 10.75),
#                          start = 150,
#                          end = 220,
#                          step = 1,
#                          CI = 0.95,
#                          reliability = 0.94)
# 
# # Display head from first table
# head(tables[[1]], 10)

## ----fig5, fig.height = 4, fig.width = 7------------------
# Compare shash with betabinomial models (BB). BB models should work worse,
# since the test has stop rules, leading to non-binomial distributions.
model.bb <- cnorm.betabinomial(ppvt$age, ppvt$raw, n = 228, plot = FALSE)

# Model comparisons
compare(model.shash, model.bb, age = ppvt$group, score = ppvt$raw,
        title = "SinH-ArcSinH vs. Beta-Binomial")


# Compare distribution free Taylor model
model.taylor <- cnorm(group = ppvt$group, raw = ppvt$raw, plot=FALSE)

# Model comparisons shash versus taylor
compare(model.shash, model.taylor, age = ppvt$group, score = ppvt$raw,
        title = "SinH-ArcSinH vs. Taylor")

