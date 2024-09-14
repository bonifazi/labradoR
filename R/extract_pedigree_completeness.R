#' Extract pedigree completeness information from text lines of Retriever output.
#'
#' This function extracts pedigree completeness information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted pedigree completeness information.
#'
#' @examples
#' lines <- c("PEDIGREE COMPLETENESS",
#'            " ", " ", " ", " ", " ",
#'            "2000 2.5 80 65 50 40 30",
#'            "2001 2.7 85 70 55 45 35",
#'            "2002 3.0 90 75 60 50 40",
#'            " ", " ",
#'            "Top sires and their contribution per year")
#' extract_pedigree_completeness(lines, "ENG")
#'
#' @export

extract_pedigree_completeness <- function(lines, language) {
  if (language == "DUT") {
    start_with <- "COMPLEETHEID stamboom"
    ends_with  <- "Topvaders en hun aandeel per jaar"
  } else if (
    language == "ENG") {
    start_with <- "PEDIGREE COMPLETENESS"
    ends_with  <- "Top sires and their contribution per year"
  }

  extract_section(lines = lines,
                  start_with = start_with,
                  ends_with = ends_with,
                  skip_initial_n_lines = 6,
                  skip_last_n_lines = 3,
                  column_names = c("Year",
                                   "average_generation_equivalent",
                                   "perc_of_animals_with_1_generations_in_pedigree_completely_known",
                                   "perc_of_animals_with_2_generations_in_pedigree_completely_known",
                                   "perc_of_animals_with_3_generations_in_pedigree_completely_known",
                                   "perc_of_animals_with_4_generations_in_pedigree_completely_known",
                                   "perc_of_animals_with_>=5_generations_in_pedigree_completely_known"
                  )
  )
}
