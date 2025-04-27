#' Process Retriever Output Log File
#'
#' This function processes a Retriever output log file, extracting various population metrics and generating corresponding plots based on the content.
#'
#' @param file_name A character string with the full path of the Retriever log file.
#' @param language A character string specifying the language of the log file. Valid options are "DUT" (Dutch) or "ENG" (English).
#' @param verbose A logical value. If `TRUE`, prints progress messages. Default is `TRUE`.
#' @param xinterval A numeric vector of length 2 specifying the x-axis limits for plots. It can be used to focus on specific year intervals. Default is `NULL`, meaning plots will show all available years.
#' @param delta_intervals A numeric vector specifying the intervals (in years) for which to compute the annual and generational deltas for inbreeding and kinship. Default is `NULL`, meaning deltas will not be computed.
#' @param return_error_log A logical value. If `TRUE`, returns a list containing the results as well as a log of any errors or warnings encountered during processing. Default is `FALSE`.
#' @return A list containing processed data (as data frames) and plots for varius metrics, including:
#'   - Population size
#'   - Inbreeding
#'   - Generation intervals
#'   - Mean age of parents (fathers and mothers)
#'   - Pedigree completeness
#'   - Litter size
#'   - Top sires' contribution
#'   If `return_error_log` is `TRUE`, the returned list will also include an error log.
#'
#' @examples
#' # Process a Retriever log file in English
#' # results <- process_retriever("path/to/retriever.log", "ENG")
#'
#' # Access processed data and plots
#' # str(results, max.level = 1, give.attr = FALSE) # look into the extracted data frames and plots
#' # results$pop_size # Population size data
#' # results$pop_size_plot # Population size plot
#'
#' @importFrom stringr str_split
#' @importFrom readr read_file
#' @importFrom dplyr %>% mutate select starts_with any_of rowwise across c_across ungroup contains
#' @import ggplot2
#'
#' @export

process_retriever <- function(file_name, language, verbose = T, xinterval = NULL, delta_intervals = NULL, return_error_log = FALSE) {
  results <- list() # store results in a list
  error_log <- list() # store errors and warnings

  # 1. Read the entire text file ----
  file_content <- readr::read_file(file_name)
  # [possible base approach to remove readr dependency]
  # file_content <- paste(readLines(file_name, warn = FALSE), collapse = "\n")

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
  if (verbose) { cat("\n >> Extracting Population Size") }

  results$pop_size <- safe_extract(extract_pop_size, content_lines, language)

  if(!is.null(results$pop_size)) {
    results$pop_size_plot <- make_linepoint_plot(
      data = results$pop_size[, setdiff(colnames(results$pop_size), "%_males_calves")]) + # do not plot sex_ratio %_males_calves
      interval +
      labs(y = "Number") + labs(title = "Population size")
    # sex ratio in a separate plot (due to its scale)
    results$sex_ratio_plot <- make_linepoint_plot(
      data = results$pop_size[, c("Year", "%_males_calves"), drop = F]) +
      interval +
      labs(y = "Number") + labs(title = "Sex ratio (% of male calves)")
  }

  # ___4.2 Inbreeding ----
  if (verbose) { cat("\n >> Extracting Inbreeding") }
  results$inbreeding <- safe_extract(extract_inbreeding, content_lines, language)

  if(!is.null(results$inbreeding)) {
    results$inbreeding_plot <- make_linepoint_plot(data = results$inbreeding) +
      interval +
      labs(title = "Inbreeding & kinship")
  }

  # ___4.3. Generation Intervals ----
  if (verbose) { cat("\n >> Extracting Generation Intervals") }
  results$gen_intervals <- safe_extract(extract_gen_interval, content_lines, language)

  if(!is.null(results$gen_intervals_plot)) {
    results$gen_intervals_plot <- make_linepoint_plot(data = results$gen_intervals) +
      interval +
      ylab("") + labs(title = "Generation intervals")
  }

  # ___4.4. Mean Age Fathers ----
  if (verbose) { cat("\n >> Extracting Mean Age of Fathers") }
  results$mean_age_fathers <- safe_extract(extract_mean_age_parents, content_lines, language, parent = "fathers")

  if(!is.null(results$mean_age_fathers)) {
    results$mean_age_fathers_plot <- results$mean_age_fathers %>%
      mutate("Age_>10" = rowSums(  # group all 10+ as single col
        select(., starts_with("Age_")) %>%
        select(-any_of(paste0("Age_", c(1:10))))
        )) %>%
      select(any_of(c("Year", paste0("Age_", c(1:10)), "Age_>10"))) %>%
      make_stacked_lineplot(levels_order = paste0("Age_", c(">10", 10:1))) +
      labs(title = "Mean age of fathers") +
      interval
  }

  # ___4.5. Mean Age Mothers ----
  if (verbose) { cat("\n >> Extracting Mean Age of Mothers") }
  results$mean_age_mothers <- safe_extract(extract_mean_age_parents, content_lines, language, parent = "mothers")

  if(!is.null(results$mean_age_mothers)){
    results$mean_age_mothers_plot <- results$mean_age_mothers %>%
       mutate("Age_>10" = rowSums(  # group all 10+ as single col
        select(., starts_with("Age_")) %>%
        select(-any_of(paste0("Age_", c(1:10))))
        )) %>%
      select(any_of(c("Year", paste0("Age_", c(1:10)), "Age_>10"))) %>%
      make_stacked_lineplot(levels_order = paste0("Age_", c(">10", 10:1))) +
      labs(title = "Mean age of mothers") +
      interval
  }

  # ___4.6. Pedigree Completeness ----
  if (verbose) { cat("\n >> Extracting Pedigree Completeness") }
  results$pedigree_completeness <- safe_extract(extract_pedigree_completeness, content_lines, language)

  if(!is.null(results$pedigree_completeness)){
    results$pedigree_completeness_plot <-
      results$pedigree_completeness %>%
      # rename cols & skip average_generation_equivalent
      select(-average_generation_equivalent) %>%
      setNames(., c("Year", "0", "1", "2", "3", "4", "5+")) %>%
      # standardize 0 to 5+ values on a 0-100% scale (this is for fixing some rounding for which the sum is 0.99 or 1.01)
      rowwise() %>%
      mutate(across('0':'5+', ~ . / sum(c_across('0':'5+')))) %>%
      ungroup() %>%
      make_stacked_lineplot(dots = T, levels_order = c("0", "1", "2", "3", "4", "5+")) +
      ylim(0,1.01) + # the .01 is to avoid small rounding corrections in ggplot
      interval +
      theme(legend.position = "bottom") +
      # scale_fill_discrete(breaks = c("0", "1", "2", "3", "4", "5+")) +
      scale_fill_manual(values = c("0" = "#e0f7fa", "1" = "#b2ebf2", "2" = "#80deea", "3" = "#4dd0e1", "4" = "#26c6da", "5+" = "#0079a1")) +
      labs(title = "Pedigree completedness",
           subtitle = "Percentage of animals with N generations in pedigree completely known",
           y = "%")


    # plot average number of generation equivalent
    results$average_generation_equivalent_plot <- results$pedigree_completeness %>%
      select(Year, average_generation_equivalent) %>%
      make_linepoint_plot() +
      labs(title = "Average generation equivalent") +
      theme(legend.position = "bottom")
  }

  # ___4.7. Litter Size Information ----
  if (verbose) { cat("\n >> Extracting Litter Size Information") }
  results$littersize <- safe_extract(extract_parent_littersize, content_lines, language)

  if(!is.null(results$littersize)) {
    results$littersize_plot <- make_linepoint_plot(data = results$littersize) +
      interval +
      theme(legend.position = "bottom") + labs(title = "Litter size")
  }

  # ___4.8. Top Sires Contribution ----
  if (verbose) { cat("\n >> Extracting Top Sires Contribution") }
  results$topsires <- safe_extract(extract_parent_contribution, content_lines, language)

  if(!is.null(results$topsires)){
    results$topsires_plot <- results$topsires %>%
      select(Year, contains("topsire")) %>%
      make_stacked_barplot(levels_order = paste0("topsire ", 10:1)) +
      ylab("Percentage") +
      interval_ext +
      theme(legend.position = "bottom") + labs(title = "Top sires contribution")
  }

  # 5. Compute Deltas ----
  if(!is.null(delta_intervals)) {
    if (verbose) { cat("\n >> Extracting Compute Deltas") }
    results$deltas <- safe_extract(compute_deltas,
                                   intervals = delta_intervals,
                                   generation_intervals = results$gen_intervals,
                                   inbreeding = results$inbreeding)
  }

  # Return results and the error_log if required
  if (return_error_log) {
    return(list(results = results, error_log = error_log))
  } else {
    return(results)
  }
}
