#' Custom theme for Labrador package
#'
#' This function defines a custom theme for use in plots within the Labrador package.
#'
#' @return A ggplot2 theme object.
#' @import ggplot2
#' @export
theme_labrador <- function() {
  theme_bw() +
    theme(
      text = element_text(size = 14),
      axis.text.x = element_text(angle = +90)
    )
}
