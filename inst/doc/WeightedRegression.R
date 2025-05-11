## ----setup, include = FALSE-------------------------------
knitr::opts_chunk$set(tidy.opts=list(width.cutoff=60),
  collapse = TRUE,
  comment = "#>"
)
options(width = 60)

library(cNORM)
library(ggplot2)

## ----message = FALSE--------------------------------------
library(cNORM)
# Assign data to object norm.data
norm.data <- ppvt
head(norm.data)

## ---------------------------------------------------------
# Generate population marginals
marginals <- data.frame(var = c("sex", "sex", "migration", "migration"),
                             level = c(1,2,0,1),
                             prop = c(0.51, 0.49, 0.65, 0.35))
head(marginals)

## ----message=FALSE----------------------------------------
weights <- computeWeights(data = norm.data, population.margins = marginals)

## ----message = FALSE, results = 'hide', warning=FALSE, fig0, fig.height = 4, fig.width = 7----
norm.model <- cnorm(raw = norm.data$raw, group = norm.data$group,
					weights = weights, terms=6)

## ---------------------------------------------------------
summary(norm.model)

## ----message = FALSE, results = 'hide', warning=FALSE, fig1, fig.height = 4, fig.width = 7----
plot(norm.model, "subset")
plot(norm.model, "norm")

