% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities.R
\name{weighted.quantile.type7}
\alias{weighted.quantile.type7}
\title{Weighted type7 quantile estimator}
\usage{
weighted.quantile.type7(x, probs, weights = NULL)
}
\arguments{
\item{x}{A numerical vector}

\item{probs}{Numerical vector of quantiles}

\item{weights}{A numerical vector with weights; should have the same length as x.
If no weights are provided (NULL), it falls back to the base quantile function, type 7}
}
\value{
the quantiles
}
\description{
Computes weighted quantiles; code from Andrey Akinshin (2023) "Weighted quantile estimators" arXiv:2304.07265 [stat.ME]
Code made available via the CC BY-NC-SA 4.0 license
}
