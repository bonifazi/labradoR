#' Extract population size information from text lines of Retriever output.
#'
#' This function extracts population size information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted population size information.
#'
#' @examples
#' lines <- c("POPULATIONSIZE: number of calves born per year",
#'            " ", " "," "," ",
#'            "2000 10 20 15 5 30 50",
#'            "2001 15 25 20 10 35 60",
#'            "2002 20 30 25 15 40 70",
#'             " "," "," ",
#'            "total number of animals in pedigree")
#' extract_pop_size(lines, "ENG")
#'
#' @export
extract_pop_size <- function(lines, language) {
  if (language == "DUT") {
    start_with <- "POPULATIEOMVANG: aantal kalf geboren per jaar"
    ends_with = "totaal aantal dieren in stamboom"
  } else if (
    language == "ENG") {
    start_with <- "POPULATIONSIZE: number of calves born per year"
    ends_with = "total number of animals in pedigree"
  }

  extract_section(
    lines = lines,
    start_with = start_with,
    ends_with = ends_with,
    skip_initial_n_lines = 5,
    skip_last_n_lines = 4,
    column_names = c(
      "Year", "Sires_unused", "Sires_fathers",
      "Dams_unused", "Dams_mothers", "Total_unused", "Total_parents"
    )
  )
}
