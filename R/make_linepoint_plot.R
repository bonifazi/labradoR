#' Make a line plot with points and customizable ordering & legend labels
#'
#' This function generates a line plot with points for each column in the input data,
#' using the first column (`Year`) on the x‐axis. You can specify a custom drawing order
#' of groups and supply a named `label_map` to relabel and parse legend entries.
#'
#' @param data A data frame containing the data to be plotted. The first column must be named `Year`.
#' @param order Optional character vector giving the desired order of the grouping variables;
#'   any entries not present in the data will be ignored.
#' @param label_map Optional named character vector for relabeling the legend. Names must match
#'   the original group levels and values must be valid R expressions (as strings) to be parsed,
#'   e.g. `c(F_ped = "italic(F)[ped]", f_ped = "italic(f)[ped]")`.
#'
#' @return A `ggplot` object representing the line‐and‐point plot
#'
#' @importFrom dplyr %>% mutate
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 ggplot aes geom_line geom_point scale_x_continuous theme guides guide_legend scale_shape_discrete
#' @importFrom ggsci scale_color_npg
#' @importFrom scales shape_pal
#'
#' @examples
#' df <- data.frame(
#'   Year = 2000:2005,
#'   A    = c(1.0, 2.5, 3.2, 2.8, 4.1, 3.9),
#'   B    = c(0.8, 1.9, 2.7, 2.4, 3.3, 2.8)
#' )
#' # Default plot
#' make_linepoint_plot(df)
#'
#' # Custom order and parsed legend labels
#' order_vec <- c("B", "A")
#' labels   <- c(A = "alpha", B = "beta")
#' make_linepoint_plot(df, order = order_vec, label_map = labels)
#'
#'
#' @export
make_linepoint_plot <- function(data, order = NULL, label_map = NULL) {

  # data preparation
  long_data <- data %>%
    pivot_longer(cols = -Year,
                 names_to = "group",
                 values_to = "value")

  # if order is provided, reorder the groups
  if (!is.null(order)) {
    present_levels <- order[order %in% unique(long_data$group)]
    long_data <- long_data %>%
      mutate(group = factor(group, levels = present_levels))
  }

  # if label_map is provided, assign new labels
  if (!is.null(label_map)) {
    labels <- label_map[names(label_map) %in% levels(long_data$group)]
  } else {
    labels <- NULL
  }

  p <- long_data %>%
    ggplot(aes(x = Year, y = value, group = group, color = group, shape = group)) +
    geom_line() +
    geom_point()+
    scale_x_continuous(
      breaks = seq(
        from = find_closest_multiple_of_x(min(data$Year), 5),
        to = find_closest_multiple_of_x(max(data$Year), 5),
        by = 5)
    ) +
    theme_labrador()  # custom theme

  # if no labels are provided, use default colors and shapes
  if(is.null(labels)) {
    p <- p + scale_color_npg() +
      guides(
        color = guide_legend(title = NULL),
        shape = guide_legend(title = NULL)
      )
  } else if (!is.null(labels)) { # if labels are provided, account for them in color and shape for legend
    # warn if user-supplied labels don’t match the number of groups
    if (length(labels) != nlevels(long_data$group)) {
      warning(
        paste0(
          "make_linepoint_plot: you provided ", length(labels),
          " labels but there are ", nlevels(long_data$group),
          " groups in the data. Only the first ", length(labels),
          " mappings will be used."
        )
      )
    }

    p <- p +
      scale_color_npg(
        name = NULL,
        breaks = names(labels),
        labels = parse(text = labels),
        guide = "legend"
      ) +
      scale_shape_discrete(
        name = NULL,
        breaks = names(labels),
        labels = parse(text = labels),
        guide = "legend") +
      guides(
        color = guide_legend(override.aes = list(shape = scales::shape_pal()(length(labels)))),
        shape = "none", fill = "none"
      )
  }
  return(p)
}
