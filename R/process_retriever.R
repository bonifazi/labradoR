#' Process Retriever output log file
#'
#' This function processes a Retriever output log file, extracting various metrics and generating plots based on the content.
#'
#' @param file_name A character string with the full path of the Retriever log file.
#' @param language A character string specifying the language of the log file ("DUT" for Dutch or "ENG" for English).
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
#'
#' @export

process_retriever <- function(file_name, language) {
  results <- list() # store results in a list

  # Read the entire text file
  file_content <- readr::read_file(file_name)

  # Split the content into lines
  content_lines <- content_lines <- stringr::str_split(file_content, "\n")[[1]]

  # population size
  results$pop_size <- extract_pop_size(content_lines, language = language)
  results$pop_size_plot <- make_linepoint_plot(data = results$pop_size) +
    labs(y = "Number") + labs(title = "Population size")

  # Inbreeding
  results$inbreeding <- extract_inbreeding(content_lines, language = language)
  results$inbreeding_plot <- make_linepoint_plot(data = results$inbreeding) +
    labs(title = "Inbreeding & kinship")

  # generation intervals
  results$gen_intervals <- extract_gen_interval(content_lines, language = language)
  results$gen_intervals_plot <- make_linepoint_plot(data =  results$gen_intervals) +
    ylab("") + labs(title = "gen. intervals")

  # mean age fathers
  results$mean_age_fathers <- extract_mean_age_parents(content_lines, language = language, parent = "fathers")
  results$mean_age_fathers_plot <-  results$mean_age_fathers %>%
    mutate("Age_10+" = rowSums(select(., starts_with("Age_"))[, -c(1:10)])) %>% # group all 10+ as single col
    select(any_of(c("Year", paste0("Age_", c(1:10)), "Age_10+")) ) %>%
    make_stacked_lineplot()

  # mean age mothers
  results$mean_age_mothers <- extract_mean_age_parents(content_lines, language = language, parent = "mothers")
  results$mean_age_mothers_plot <-  results$mean_age_mothers %>%
    mutate("Age_10+" = rowSums(select(., starts_with("Age_"))[, -c(1:10)])) %>% # group all 10+ as single col
    select(any_of(c("Year", paste0("Age_", c(1:10)), "Age_10+")) ) %>%
    make_stacked_lineplot()

  # pedigree completeness
  results$pedigree_completeness <- extract_pedigree_completeness(content_lines, language = language)
  results$pedigree_completeness_plot <- make_linepoint_plot(data = results$pedigree_completeness) +
    theme(legend.position = "bottom") + labs(title = "Pedigree completedness")

  # litter size information
  results$littersize <- extract_parent_littersize(content_lines, language = language)
  results$littersize_plot <- make_linepoint_plot(data =  results$littersize) +
    theme(legend.position = "bottom") + labs(title = "Litter size")

  # top sires contribution
  results$topsires <- extract_parent_contribution(content_lines, language = language)
  results$topsires_plot <- results$topsires %>%
    select(Year, contains("contribution")) %>%
    make_stacked_barplot(levels_order = paste0("topsire_", 10:1, "_contribution"))+
    ylab("Percentage")+
    theme(legend.position = "bottom") + labs(title = "Top sires contribution")

  return(results)
}
