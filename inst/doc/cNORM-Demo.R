## ----setup, include = FALSE-------------------------------
knitr::opts_chunk$set(tidy.opts=list(width.cutoff=60),
  collapse = TRUE,
  comment = "#>"
)
library(cNORM)
library(ggplot2)


## ----echo=FALSE, fig.align='center', fig.width=10---------
knitr::include_graphics("plos.png")

## ----eval=FALSE-------------------------------------------
#  ## Basic example code for modeling the sample dataset
# 
# library(cNORM)
# 
# # Start the graphical user interface (needs shiny installed)
# # The GUI includes the most important functions. For specific cases,
# # please use cNORM on the console.
# 
# cNORM.GUI()
# 
# # Using the syntax on the console: The function 'cnorm' performs
# # all steps automatically. Please specify the raw score and the
# # grouping variable. The resulting object contains the ranked data
# # via object$data and the model via object$model.
# 
# cnorm.elfe <- cnorm(raw = elfe$raw, group = elfe$group)
# 
# # Plot different indicators of model fit depending on the number of
# # predictors
# 
# plot(cnorm.elfe, "subset", type=0) # plot R2
# plot(cnorm.elfe, "subset", type=3) # plot MSE
# 
# # NOTE! At this point, you usually select a good fitting model and rerun
# # the process with a fixed number of terms, e. g. 4. Avoid models
# # with a high number of terms:
# 
# cnorm.elfe <- cnorm(raw = elfe$raw, group = elfe$group, terms = 4)
# 
# # Powers of age can be specified via the parameter 't'.
# # Cubic modeling is usually sufficient, i.e., t = 3.
# # In contrast, 'k' specifies the power of the person location.
# # This parameter should be somewhat higher, e.g., k = 5.
# 
# cnorm.elfe <- cnorm(raw = elfe$raw, group = elfe$group, k = 5, t = 3)
# 
# # Visual inspection of the percentile curves of the fitted model
# 
# plot(cnorm.elfe, "percentiles")
# 
# # Visual inspection of the observed and fitted raw and norm scores
# 
# plot(cnorm.elfe, "norm")
# plot(cnorm.elfe, "raw")
# 
# # In order to compare different models, generate a series of percentile
# # plots with an ascending number of predictors, in this example between
# # 5 and 14 predictors.
# 
# plot(cnorm.elfe, "series", start=5, end=14)
# 
# # Cross validation in order to choose appropriate number of terms
# # with 80% of the data for training and 20% for validation. Due to
# # the time consumption, the maximum number of terms is limited to 10
# # in this example with 3 repetitions of the cross validation.
# 
# cnorm.cv(cnorm.elfe$data, max=10, repetitions=3)
# 
# # Cross validation with prespecified terms of an already
# # existing model
# 
# cnorm.cv(cnorm.elfe, repetitions=3)
# 
# # Print norm table (in this case: 0, 3 or 6 months at grade level 3)
# # (Note: The data is coded such that 3.0 represents the beginning and
# # 3.5 the middle of the third school year)
# 
# normTable(c(3, 3.25, 3.5), cnorm.elfe)
# 

## ----eval=FALSE-------------------------------------------
# # Application of cNORM for the generation of conventional norms
# # for a specific age group (in this case age group 3):
# 
# data <- elfe[elfe$group == 3,]
# cnorm(raw=data$raw)

## ----eval=FALSE-------------------------------------------
#     # Creates a grouping variable for the variable 'age'
#     # of the ppvt data set. In this example, 12 equidistant
#     # subgroups are generated.
# 
#     group <- getGroups(ppvt$age, 12)

## ----fig0, fig.height = 4, fig.width = 7------------------
library(cNORM)
# Models the 'raw' variable as a function of the discrete 'group' variable
model <- cnorm(raw = elfe$raw, group = elfe$group)

## ---------------------------------------------------------
print(model)

## ----eval=FALSE-------------------------------------------
# # Generates a series of percentile plots with increasing number of predictors
# 
# plotPercentileSeries(model, start = 1, end = 15)

## ----fig1, fig.height = 4, fig.width = 7------------------
    plot(model, "subset", type = 0)

## ---------------------------------------------------------
predictNorm(15, 4.7, model, minNorm = 25, maxNorm = 75)


## ---------------------------------------------------------
predictRaw(55, 4.5, model, minRaw = 0, maxRaw = 28)

# ... or for several norm scores and age levels ...
predictRaw(c(45, 50, 55), c(2.5, 3, 3.5), model) 

## ---------------------------------------------------------
normTable(3, model, minRaw = 0, maxRaw = 28, minNorm=30.5, maxNorm=69.5, step = 1)

## ---------------------------------------------------------
rawTable(3.5, model, minRaw = 0, maxRaw = 28, minNorm = 25, maxNorm = 75, step = 1, CI = .95, reliability = .89)

# generate several raw tables
table <- rawTable(c(2.5, 3.5, 4.5), model, minRaw = 0, maxRaw = 28)

## ----fig2, fig.height = 7, fig.width = 7------------------
plot(model, "raw", group = TRUE)

## ----fig3, fig.height = 7, fig.width = 7------------------
plot(model, "norm", group = TRUE, minNorm = 25, maxNorm = 75)

## ----fig4, fig.height = 4, fig.width = 7------------------
plot(model, "density", group = c (2, 3, 4))

## ----fig5, fig.height = 4, fig.width = 7------------------
plot(model, "derivative")

