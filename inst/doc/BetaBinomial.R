## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----fig0, fig.height = 4, fig.width = 7--------------------------------------
library(cNORM)
str(ppvt)
max(ppvt$raw)
plot(ppvt$age, ppvt$raw, main="PPVT Raw Scores by Age", xlab="Age", ylab="Raw Score")

## ----fig1, fig.height = 4, fig.width = 7--------------------------------------
# Data can be fitted over a continuous variable like age without the prerequisite of defining
# age groups. We will use the data on vocabulary development (ppvt) included in cNORM. The test
# has a maximum score of 228, which is however not reached in the sample:
model.betabinomial <- cnorm.betabinomial(ppvt$age, ppvt$raw, n = 228)

# In order to use different optimization functions, you can specify different 
# control parameters, e.g., including methods from the optimx package. 
# The default is the L-BFGS algorithm.

# To retrieve fit indices, use the 'diagnostic.betabinomial' or the 'summary' function
# If age and raw scores are provided, R2, RMSE and bias are computed in comparison
# to manifest norm scores.
summary(model.betabinomial)


## -----------------------------------------------------------------------------
# Predict norm scores for new data. Since we used the default T-score scaling,
# the output will as well be a vector with T-scores.
# Usage: predict(model, age, raw)
predict(model.betabinomial, c(8.9, 10.1, 9.3, 8.7), c(123, 98, 201, 165))

## -----------------------------------------------------------------------------
# Generate norm tables for age 2, 3 and 4 and compute confidence intervals with a 
# reliability of .9. The output is by default limited to +/- 3 standard deviations.
tables <- normTable(model = model.betabinomial, A = c(2, 3, 4), reliability=0.9)
head(tables[[1]]) # head is used to show only the first few rows of the table

## ----fig2, fig.height = 4, fig.width = 7--------------------------------------
margins <- data.frame(variables = c("sex", "sex",
                                   "migration", "migration"),
                      levels = c(1, 2, 0, 1),
                      share = c(.52, .48, .7, .3))
weights <- computeWeights(ppvt, margins)
model_weighted <- cnorm.betabinomial(ppvt$age, ppvt$raw, n = 228, weights = weights)


