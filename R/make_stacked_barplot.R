#' Create a stacked bar plot
#'
#' This function generates a stacked bar plot based on the provided data and the specified order of levels.
#'
#' @param data A data frame containing the data to be plotted. The first column is used as x-axis.
#' @param levels_order A vector specifying the order of levels for stacking.
#'
#' @return A ggplot object representing the stacked bar plot.
#'
#' @examples
#' data <- data.frame(Year = c(2000, 2001, 2002),
#'                    Group1 = c(10, 20, 15),
#'                    Group2 = c(5, 10, 8))
#' levels_order <- c("Group1", "Group2")
#' make_stacked_barplot(data, levels_order)
#'
#' @importFrom dplyr %>%
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 ggplot aes geom_bar scale_x_continuous ylim labs guides guide_legend
#' @importFrom ggsci scale_color_npg
#'
#' @export

make_stacked_barplot <- function(data, levels_order) {
  data %>%
    pivot_longer(cols = -Year,
                 names_to = "group",
                 values_to = "value")  %>%
    ggplot(aes(x = Year, y = value,
               fill = factor(group, levels = levels_order)
    )
    ) +
    geom_bar(stat="identity", color = "black") +
    ylim(c(0,100)) +
    scale_x_continuous(
      breaks = seq(
        from = find_closest_multiple_of_x(min(data$Year), 5),
        to =   find_closest_multiple_of_x(max(data$Year), 5),
        by = 5)
    ) +
    theme_labrador() +  # custom theme
    scale_color_npg()+
    guides(color = guide_legend(title = NULL),
           shape = guide_legend(title = NULL)
    )+
    labs(fill = NULL) # no legend title
}
