% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getMemberDomain.R
\name{getMemberDomain}
\alias{getMemberDomain}
\title{Define indices for member selection
Define indices for member selection}
\usage{
getMemberDomain(grid, dataset, members)
}
\arguments{
\item{grid}{A java \sQuote{GeoGrid}}

\item{dataset}{Character string indicating teh dataset to be accessed.}

\item{members}{Numeric vector of the members to be selected}
}
\value{
A list of length \emph{n} members, containing a \sQuote{ucar.ma2.Range} object
}
\description{
Define indices for member selection
Define indices for member selection
}
\note{
The function assumes that the ensemble members are internally designated by character strings,
rather than integers than in the former version. Otherwise, the getCoordValues()
method should be used instead of getNames() on the ensemble axis.
}
\author{
J. Bedia
}
\keyword{internal}
