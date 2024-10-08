% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.R
\name{predictNorm}
\alias{predictNorm}
\title{Retrieve norm value for raw score at a specific age}
\usage{
predictNorm(
  raw,
  A,
  model,
  minNorm = NULL,
  maxNorm = NULL,
  force = FALSE,
  silent = FALSE
)
}
\arguments{
\item{raw}{The raw value, either single numeric or numeric vector}

\item{A}{the explanatory variable (e. g. age), either single numeric or numeric vector}

\item{model}{The regression model or a cnorm object}

\item{minNorm}{The lower bound of the norm score range}

\item{maxNorm}{The upper bound of the norm score range}

\item{force}{Try to resolve missing norm scores in case of inconsistent models}

\item{silent}{set to TRUE to suppress messages}
}
\value{
The predicted norm score for a raw score, either single value or vector
}
\description{
This functions numerically determines the norm score for raw scores depending on the
level of the explanatory variable A, e. g. norm scores for raw scores at given ages.
}
\examples{
# Generate cnorm object from example data
cnorm.elfe <- cnorm(raw = elfe$raw, group = elfe$group)

# return norm value for raw value 21 for grade 2, month 9
specificNormValue <- predictNorm(raw = 21, A = 2.75, cnorm.elfe)

# predicted norm scores for the elfe dataset
# predictNorm(elfe$raw, elfe$group, cnorm.elfe)

}
\seealso{
Other predict: 
\code{\link{derivationTable}()},
\code{\link{getNormCurve}()},
\code{\link{normTable}()},
\code{\link{predict.cnormBetaBinomial}()},
\code{\link{predict.cnormBetaBinomial2}()},
\code{\link{predictRaw}()},
\code{\link{rawTable}()}
}
\concept{predict}
