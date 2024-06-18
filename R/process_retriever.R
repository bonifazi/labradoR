#' Process Retriever output log file
#'
#' This function processes a Retriever output log file, extracting various metrics and generating plots based on the content.
#'
#' @param file_name A character string with the full path of the Retriever log file.
#' @param language A character string specifying the language of the log file ("DUT" for Dutch or "ENG" for English).
#' @param verbose Logical. If `TRUE`, prints progress messages. Default is `FALSE`.
#' @param xinterval Numeric. A numeric vector of length 2 specifying the x-axis limits for plots. It can be used to focus on specific years intervals. Default is `NULL`, i.e., plots show all years.
#' @param delta_intervals Numeric. A numeric vector specifying the intervals for which to compute the annual and generational deltas for inbreeding and kinship. Default is `NULL`.
#'
#' @return A list containing processed data (as data frames) and plots for population size, inbreeding, generation intervals, mean age of parents, pedigree completeness, litter size, and top sires' contribution.
#'
#' @examples
#' # Process a Retriever log file in English
#' # results <- process_retriever("path/to/retriever.log", "ENG")
#'
#' # Access processed data and plots
#' # str(results, max.level = 1, give.attr = F) # look into the extracted data frames and plots
#' # results$pop_size # Population size data
#' # results$pop_size_plot # Population size plot
#'
#' @import stringr readr ggplot2
#' @importFrom stringr str_split
#' @importFrom readr   read_file
#' @importFrom dplyr    %>%
#'
#' @export

process_retriever <- function(file_name, language, verbose = F, xinterval = NULL, delta_intervals = NULL) {
  results <- list() # store results in a list

  # 1. Read the entire text file ----
  file_content <- readr::read_file(file_name)

  # 2. Split the content into lines ----
  content_lines <- content_lines <- stringr::str_split(file_content, "\n")[[1]]

  # 3. Set interval subset ----
  if(!is.null(xinterval)) {
    if (!is.numeric(xinterval) || length(xinterval) != 2) { # check arg
      stop("xinterval must be a numeric vector of length 2, e.g., xinterval = c(1980, 2024)")
    }
    interval <- xlim(xinterval) # define ggplot xlimits based on provided start and end
    interval_ext <- xlim(xinterval[1]-1, xinterval[2]+1) # in some plots like stacked bar plot need -1/+1 to include the limits
  } else {
    # use default, which is `NULL`that once passed to ggplot takes no actions
    interval <- interval_ext <- xinterval
  }

  # 4. Extract sections (order is not important) ----
  # ___4.1 Population size ----
  if (verbose) { cat("\n Extracting population size") }
  results$pop_size <- extract_pop_size(content_lines, language = language)
  results$pop_size_plot <- make_linepoint_plot(data = results$pop_size) +
    interval +
    labs(y = "Number") + labs(title = "Population size")

  # ___4.2 Inbreeding ----
  if (verbose) { cat("\n Extracting inbreeding") }
  results$inbreeding <- extract_inbreeding(content_lines, language = language)
  results$inbreeding_plot <- make_linepoint_plot(data = results$inbreeding) +
    interval +
    labs(title = "Inbreeding & kinship")

  # ___4.3. Generation Intervals ----
  if (verbose) { cat("\n Generation Intervals") }
  results$gen_intervals <- extract_gen_interval(content_lines, language = language)
  results$gen_intervals_plot <- make_linepoint_plot(data = results$gen_intervals) +
    interval +
    ylab("") + labs(title = "gen. intervals")

  # ___4.4. Mean Age Fathers ----
  if (verbose) { cat("\n Mean Age of Fathers") }
  results$mean_age_fathers <- extract_mean_age_parents(content_lines, language = language, parent = "fathers")
  results$mean_age_fathers_plot <- results$mean_age_fathers %>%
    mutate("Age_10+" = rowSums(select(., starts_with("Age_"))[, -c(1:10)])) %>% # group all 10+ as single col
    select(any_of(c("Year", paste0("Age_", c(1:10)), "Age_10+"))) %>%
    make_stacked_lineplot() +
    interval

  # ___4.5. Mean Age Mothers ----
  if (verbose) { cat("\n Mean Age of Mothers") }
  results$mean_age_mothers <- extract_mean_age_parents(content_lines, language = language, parent = "mothers")
  results$mean_age_mothers_plot <- results$mean_age_mothers %>%
    mutate("Age_10+" = rowSums(select(., starts_with("Age_"))[, -c(1:10)])) %>% # group all 10+ as single col
    select(any_of(c("Year", paste0("Age_", c(1:10)), "Age_10+"))) %>%
    make_stacked_lineplot() +
    interval

  # ___4.6. Pedigree Completeness ----
  if (verbose) { cat("\n Pedigree Completeness") }
  results$pedigree_completeness <- extract_pedigree_completeness(content_lines, language = language)
  results$pedigree_completeness_plot <- results$pedigree_completeness %>%
    # rename cols & skip average_generation_equivalent
    select(-average_generation_equivalent) %>%
    setNames(., c("Year", "1", "2", "3", "4", "5+")) %>%
    make_stacked_lineplot(dots = T) +
    interval +
    theme(legend.position = "bottom") +
    scale_fill_discrete(breaks = c("1", "2", "3", "4", "5+")) +
    labs(title = "Pedigree completedness",
         subtitle = "Percentage of animals with N generations in pedigree completely known")

  # plot average number of generation equivalent
  results$average_generation_equivalent <-  results$pedigree_completeness %>%
    select(Year, average_generation_equivalent) %>%
    make_linepoint_plot()

  # ___4.7. Litter Size Information ----
  if (verbose) { cat("\n Litter Size Information") }
  results$littersize <- extract_parent_littersize(content_lines, language = language)
  results$littersize_plot <- make_linepoint_plot(data = results$littersize) +
    interval +
    theme(legend.position = "bottom") + labs(title = "Litter size")

  # ___4.8. Top Sires Contribution ----
  if (verbose) { cat("\n Top Sires Contribution") }
  results$topsires <- extract_parent_contribution(content_lines, language = language)
  results$topsires_plot <- results$topsires %>%
    select(Year, contains("topsire")) %>%
    make_stacked_barplot(levels_order = paste0("topsire ", 10:1)) +
    ylab("Percentage") +
    interval_ext +
    theme(legend.position = "bottom") + labs(title = "Top sires contribution")

  # 5. Compute Deltas ----
  if(!is.null(delta_intervals)) {
    if (verbose) { cat("\n Compute Deltas") }
    results$deltas <- compute_deltas(intervals = delta_intervals,
                                     generation_intervals = results$gen_intervals, inbreeding = results$inbreeding)
  }

  return(results)
}
