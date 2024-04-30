#' Make a line plot with points with year of birth on the x-axis
#'
#' This function generates a line plot with line-points for each column in the input data and year of birth in the x-axis
#'
#' @param data A data frame containing the data to be plotted. First column must be named 'Year'.
#'
#' @return A ggplot object representing the line plot with points.
#'
#' @import dplyr tidyr ggsci ggplot2
#' @importFrom dplyr %>%
#' @importFrom tidyr pivot_longer
#' @importFrom ggsci scale_color_npg
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 guides
#' @importFrom ggplot2 guide_legend
#'
#' @examples
#' data <- data.frame(Year = c(2000, 2001, 2002),
#'                    Group1 = c(10, 20, 15),
#'                    Group2 = c(5, 10, 8))
#' make_linepoint_plot(data)
#'
#' @export
#'
make_linepoint_plot <- function(data) {
  data %>%
    pivot_longer(cols = -Year,
                 names_to = "group",
                 values_to = "value") %>%
    ggplot(aes(x = Year, y = value, color = group, shape = group)) +
    geom_line() +
    geom_point()+
    scale_x_continuous(
      breaks = seq(
        from = find_closest_multiple_of_x(min(data$Year), 5),
        to = find_closest_multiple_of_x(max(data$Year), 5),
        by = 5)
    ) +
    theme_labrador() +  # custom theme
    scale_color_npg()+
    guides(color = guide_legend(title = NULL),
           shape = guide_legend(title = NULL))
}
