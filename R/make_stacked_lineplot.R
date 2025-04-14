#' Create a stacked area plot
#'
#' This function generates a stacked area plot based on the provided data.
#'
#' @param data A data frame containing the data to be plotted. First column must be named 'Year'.
#' @param dots A logical (default = F) to turn on/off plotting dots following the stacked area lines
#' @param levels_order A vector specifying the order of levels for stacking.
#'
#'
#' @return A ggplot object representing the stacked area plot.
#'
#' @import dplyr tidyr ggsci ggplot2
#' @importFrom dplyr %>%
#' @importFrom tidyr pivot_longer
#' @importFrom ggsci scale_color_npg
#' @importFrom ggplot2 geom_area
#' @importFrom ggplot2 guides
#' @importFrom ggplot2 guide_legend
#'
#' @examples
#' data <- data.frame(Year = c(2000, 2001, 2002),
#'                    Group1 = c(10, 20, 15),
#'                    Group2 = c(5, 10, 8))
#' levels_order <- c("Group1", "Group2")
#' make_stacked_lineplot(data, levels_order = levels_order)
#'
#' @export

make_stacked_lineplot <- function(data, dots = F, levels_order = NULL) {
  if(dots) {
    plot_dots <- geom_point(position = "stack", size = 1)
  } else plot_dots <- NULL
  data %>%
    pivot_longer(cols = -Year,
                 names_to = "group",
                 values_to = "value") %>%
    ggplot(aes(x = Year, y = value,
               fill = factor(group, levels = levels_order))
           ) +
    geom_area(color = "black")+
    plot_dots +
    scale_x_continuous(
      breaks = seq(
        from = find_closest_multiple_of_x(min(data$Year), 5),
        to = find_closest_multiple_of_x(max(data$Year), 5),
        by = 5)
    ) +
    theme_labrador() +  # custom theme
    scale_color_npg()+
    guides(color = guide_legend(title = NULL),
           shape = guide_legend(title = NULL))+
    labs(fill = NULL) # no legend title
}
