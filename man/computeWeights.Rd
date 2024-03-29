% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raking.R
\name{computeWeights}
\alias{computeWeights}
\title{Weighting of cases through iterative proportional fitting (Raking)}
\usage{
computeWeights(data, population.margins, standardized = TRUE)
}
\arguments{
\item{data}{data.frame with norm sample data.}

\item{population.margins}{A data.frame including three columns, specifying the
variable name in the original dataset used for data stratification, the factor
level of the variable and the according population share. Please ensure, the
original data does not include factor levels, not present in the
population.margins. Additionally, summing up the shares of the different
levels of a variable should result in a value near 1.0. The first column must
specify the name of the stratification variable, the second the level and
the third the proportion}

\item{standardized}{If TRUE (default), the raking weights are scaled to
weights/min(weights)}
}
\value{
a vector with the standardized weights
}
\description{
Computes and standardizes weights via raking to compensate for non-stratified
samples. It is based on the implementation in the survey R package. It reduces
data collection #' biases in the norm data by the means of post stratification,
thus reducing the effect of unbalanced data in percentile estimation and norm
data modeling.
}
\details{
This function computes standardized raking weights to overcome biases in norm
samples. It generates weights, by drawing on the information of population
shares (e. g. for sex, ethnic group, region ...) and subsequently reduces the
influence of over-represented groups or increases underrepresented cases. The
returned weights are either raw or standardized and scaled to be larger than 0.

Raking in general has a number of advantages over post stratification and it
additionally allows cNORM to draw on larger datasets, since less cases have
to be removed during stratification. To use this function, additionally to the
data, a data frame with stratification variables has to be specified. The data
frame should include a row with (a) the variable name, (b) the level of the
variable and (c) the according population proportion.
}
\examples{
# cNORM features a dataset on vocabulary development (ppvt)
# that includes variables like sex or migration. In order
# to weight the data, we have to specify the population shares.
# According to census, the population includes 52\% boys
# (factor level 1 in the ppvt dataset) and 70\% / 30\% of persons
# without / with a a history of migration (= 0 / 1 in the dataset).
# First we set up the popolation margins with all shares of the
# different levels:

margins <- data.frame(variables = c("sex", "sex",
                                    "migration", "migration"),
                      levels = c(1, 2, 0, 1),
                      share = c(.52, .48, .7, .3))
head(margins)

# Now we use the population margins to generate weights
# through raking

weights <- computeWeights(ppvt, margins)


# There are as many different weights as combinations of
# factor levels, thus only four in this specific case

unique(weights)


# To include the weights in the cNORM modelling, we have
# to pass them as weights. They are then used to set up
# weighted quantiles and as weights in the regession.

model <- cnorm(raw = ppvt$raw,
               group=ppvt$group,
               weights = weights)
}
