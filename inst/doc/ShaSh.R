## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(tidy.opts=list(width.cutoff=60),
  collapse = TRUE,
  comment = "#>",
  eval = TRUE  # Disabled due to computational intensity
)

## ----fig0, fig.height = 4, fig.width = 7--------------------------------------
library(cNORM)

# Examine the data structure and distribution
str(ppvt)
plot(ppvt$age, ppvt$raw, main="PPVT Raw Scores by Age", 
     xlab="Age", ylab="Raw Score", pch=16, col=rgb(0,0,0,0.3))

# Examine distributional characteristics
hist(ppvt$raw, breaks=30, main="Distribution of Raw Scores", 
     xlab="Raw Score", probability=TRUE, col="lightblue")

## ----fig1, fig.height = 4, fig.width = 7--------------------------------------
# Fit ShaSh model with default settings
# Default: mu_degree=3, sigma_degree=2, epsilon_degree=2, delta=1
model.shash <- cnorm.shash(age = ppvt$age, score = ppvt$raw)

# The function automatically displays percentile plots
print(model.shash)

## -----------------------------------------------------------------------------
# Obtain comprehensive diagnostics
summary(model.shash, age = ppvt$age, score = ppvt$raw)

## ----fig2, fig.height = 4, fig.width = 7--------------------------------------
# Example with more complex parameterization (not executed due to computation time)
model.custom <- cnorm.shash(age = ppvt$age, score = ppvt$raw,
                           mu_degree = 3,        # Curvelinear pattern
                           sigma_degree = 3,     # Complex variability changes  
                           epsilon_degree = 2,   # Age-varying skewness
                           delta_degree = 2)     # Changing tail weights across age

# Compare models
compare(model.shash, model.custom, age = ppvt$age, score = ppvt$raw,
        title = "ShaSh Model Comparison")

## ----fig3, fig.height = 4, fig.width = 7--------------------------------------
# More conservative parameterization for demonstration
model.simple <- cnorm.shash(age = ppvt$age, score = ppvt$raw,
                           mu_degree = 2,        # Quadratic location pattern
                           sigma_degree = 1,     # Linear variability change  
                           epsilon_degree = 1,   # Linear skewness change
                           delta = 1.1)          # Slightly heavy tails

# This model balances flexibility with stability

## ----fig4, fig.height = 4, fig.width = 7--------------------------------------
# Calculate post-stratification weights
margins <- data.frame(variables = c("sex", "sex", "migration", "migration"),
                     levels = c(1, 2, 0, 1),
                     share = c(.52, .48, .7, .3))

weights <- computeWeights(ppvt, margins)

# Fit weighted ShaSh model
model.weighted <- cnorm.shash(ppvt$age, ppvt$raw, weights = weights)

# Compare weighted vs. unweighted
compare(model.shash, model.weighted, age = ppvt$age, score = ppvt$raw,
        title = "Unweighted vs. Weighted ShaSh Models")

## -----------------------------------------------------------------------------
# Generate norm scores for specific age-score combinations
ages <- c(10.25, 10.75, 11.25, 11.75)
raw_scores <- c(180, 185, 190, 195)

norm_scores <- predict(model.shash, ages, raw_scores)
prediction_table <- data.frame(
  Age = ages, 
  Raw_Score = raw_scores, 
  Norm_Score = round(norm_scores, 1)
)
print(prediction_table)

## -----------------------------------------------------------------------------
# Generate detailed norm tables for multiple ages
tables <- normTable.shash(model.shash, 
                         ages = c(10.25, 10.75), 
                         start = 150, 
                         end = 220,
                         step = 1,
                         CI = 0.95, 
                         reliability = 0.94)

# Display sample from first table
head(tables[[1]], 10)

## ----fig5, fig.height = 4, fig.width = 7--------------------------------------
# Compare ShaSh with other approaches
# Beta-Binomial models should work worse, since the test has stop rules,
# leading to non-binomial distributions. Distribution-free models (Taylor)
# should be able to model the data flexibly as well.
model.bb <- cnorm.betabinomial(ppvt$age, ppvt$raw, n = 228)
model.taylor <- cnorm(group = ppvt$group, raw = ppvt$raw)

# Visual comparisons
compare(model.shash, model.bb, age = ppvt$age, score = ppvt$raw,
        title = "ShaSh vs. Beta-Binomial")

compare(model.taylor, model.shash, age = ppvt$age, score = ppvt$raw,
        title = "Distribution-Free vs. ShaSh")

