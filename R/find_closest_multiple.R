#' Find the closest multiple of x to a given value
#'
#' This function calculates the closest multiple of a specified number (x) to a given value.
#'
#' @param value Numeric. The value for which the closest multiple of x needs to be found.
#' @param x Numeric. The number to find the closest multiple of.
#'
#' @return Numeric. The closest multiple of x to the given value.
#'
#' @examples
#' find_closest_multiple_of_x(17, 5)
#' # Output: 15
#'
#' find_closest_multiple_of_x(23, 10)
#' # Output: 20
#'
#' @export

find_closest_multiple_of_x <- function(value, x) {
  closest <- round(value / x)  * x
}
