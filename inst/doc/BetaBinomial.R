## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(tidy.opts=list(width.cutoff=60),
  collapse = TRUE,
  comment = "#>"
)

## ----fig0, fig.height = 4, fig.width = 7--------------------------------------
 ## Loads the package and displays the data

library(cNORM)
str(ppvt)
plot(ppvt$age, ppvt$raw, main="PPVT Raw Scores by Age",
              xlab="Age", ylab="Raw score")

## ----fig1, fig.height = 4, fig.width = 7--------------------------------------
# Models the data across a continuos explanatroy variable such as age,
# thereby assuming that the raw scores follow a beta-binomial distribution
# at a given age level:

model.betabinomial <- cnorm.betabinomial(age = ppvt$age, score = ppvt$raw, n = 228)

## -----------------------------------------------------------------------------
# Provides fit indices

diagnostics.betabinomial(model.betabinomial, age = ppvt$age, score = ppvt$raw)

## -----------------------------------------------------------------------------
# Provides norm scores for specified age levels and raw scores.
# If not specified otherwise in the model, the norm scores will
# be returned as T-scores.

predict(model.betabinomial, c(10.125, 10.375, 10.625, 10.875), c(200, 200, 200, 200))

## ----fig2, fig.height = 4, fig.width = 7--------------------------------------
# Calculates weights and models the data:

margins <- data.frame(variables = c("sex", "sex",
                    "migration", "migration"),
                    levels = c(1, 2, 0, 1),
                    share = c(.52, .48, .7, .3))
weights <- computeWeights(ppvt, margins)
model_weighted <- cnorm.betabinomial(ppvt$age, ppvt$raw, weights = weights)


## -----------------------------------------------------------------------------
# Generates norm tables for age 14.25 and 14.75 and computes 95%-confidence
# intervals with a reliability of .97.

tables <- normTable.betabinomial(model.betabinomial, c(14.25, 14.75), CI = .95, reliability = .97)
head(tables[[1]]) # head is used to show only the first few rows of the table

