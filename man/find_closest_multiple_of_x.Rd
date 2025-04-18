% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_closest_multiple.R
\name{find_closest_multiple_of_x}
\alias{find_closest_multiple_of_x}
\title{Find the closest multiple of x to a given value}
\usage{
find_closest_multiple_of_x(value, x)
}
\arguments{
\item{value}{Numeric. The value for which the closest multiple of x needs to be found.}

\item{x}{Numeric. The number to find the closest multiple of.}
}
\value{
Numeric. The closest multiple of x to the given value.
}
\description{
This function calculates the closest multiple of a specified number (x) to a given value.
}
\examples{
find_closest_multiple_of_x(17, 5)
# Output: 15

find_closest_multiple_of_x(23, 10)
# Output: 20

}
