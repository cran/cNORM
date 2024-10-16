## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(cNORM)
library(ggplot2)


## ----fig0, fig.height = 4, fig.width = 7--------------------------------------
library(cNORM)
# Models the 'raw' variable as a function of the discrete 'group' variable
model <- cnorm(raw = elfe$raw, group = elfe$group)

## -----------------------------------------------------------------------------
print(model)

## ----fig1, fig.height = 4, fig.width = 7--------------------------------------
    plot(model, "subset", type = 0)

## -----------------------------------------------------------------------------
predictNorm(15, 4.7, model, minNorm = 25, maxNorm = 75)


## -----------------------------------------------------------------------------
predictRaw(55, 4.5, model, minRaw = 0, maxRaw = 28)

# ... or for several norm scores and age levels ...
predictRaw(c(45, 50, 55), c(2.5, 3, 3.5), model) 

## -----------------------------------------------------------------------------
normTable(3, model, minRaw = 0, maxRaw = 28, minNorm=30.5, maxNorm=69.5, step = 1)

## -----------------------------------------------------------------------------
rawTable(3.5, model, minRaw = 0, maxRaw = 28, minNorm = 25, maxNorm = 75, step = 1, CI = .95, reliability = .89)

# generate several raw tables
table <- rawTable(c(2.5, 3.5, 4.5), model, minRaw = 0, maxRaw = 28)

## ----fig2, fig.height = 7, fig.width = 7--------------------------------------
plot(model, "raw", group = TRUE)

## ----fig3, fig.height = 7, fig.width = 7--------------------------------------
plot(model, "norm", group = TRUE, minNorm = 25, maxNorm = 75)

## ----fig4, fig.height = 4, fig.width = 7--------------------------------------
plot(model, "density", group = c (2, 3, 4))

## ----fig5, fig.height = 4, fig.width = 7--------------------------------------
plot(model, "derivative")

