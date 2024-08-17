## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(cNORM)
library(ggplot2)


## -----------------------------------------------------------------------------
library(cNORM)
# Displays the first lines of the data of the example dataset 'elfe'
head(elfe)

## -----------------------------------------------------------------------------
# Display some descriptive results by group
by(elfe$raw, elfe$group, summary)

## ----fig0, fig.height = 6, fig.width = 7--------------------------------------
# Convenience method that does everything at once
model <- cnorm(raw=elfe$raw, group=elfe$group)

## ----fig1, fig.height = 6, fig.width = 7--------------------------------------
# plot the information function per number of predictor
plot(model, "subset", type = 0) # R2

## ----fig2, fig.height = 6, fig.width = 7--------------------------------------
plot(model, "subset", type = 3) # RMSE

## -----------------------------------------------------------------------------
# Search for intersecting percentiles
checkConsistency(model, minNorm = 25, maxNorm = 75)

## -----------------------------------------------------------------------------
# Search for intersecting percentiles
checkConsistency(model, minNorm = 25, maxNorm = 75)

## ----fig4, fig.height = 6, fig.width = 7--------------------------------------
plot(model, "norm")

## ----fig5, fig.height = 6, fig.width = 7--------------------------------------
# The plot can be split by group as well:
plot(model, "norm", group = TRUE)    # specifies the grouping variable

## ----fig6, fig.height = 6, fig.width = 7--------------------------------------
plot(model, "derivative", minAge=1, maxAge=6, minNorm=20, maxNorm=80)
# if parameters on age an norm are not specified, cnorm plots within
# the ranges of the current dataset

## -----------------------------------------------------------------------------
# Predict norm score for raw score 15 and age 4.7
predictNorm(15, 4.7, model, minNorm = 25, maxNorm = 75)

# Predict raw score for normal score 55 and age 4.5
predictRaw(55, 4.5, model)

# ... or vectors, if you like ...
predictRaw(c(40, 45, 50, 55, 60), c(2.5, 3, 3.5, 4, 4.5), model)


