#' Extract mean age of parents information from text lines of Retriever output.
#'
#' This function extracts the mean age of parents information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#' @param parent A character string ("fathers" for sires or "mothers" for dams).
#'
#' @return A data frame representing the extracted mean age of parents information.
#'
#' @examples
#' lines <- c("AGE fathers",
#'            " ", " "," "," ",
#'            "2000 30 25",
#'            "2001 32 26",
#'            "2002 35 28",
#'            " ", " "," "," ",
#'            "AGE mothers")
#' extract_mean_age_parents(lines, "ENG", parent = "fathers")
#'
#' @export

extract_mean_age_parents <- function(lines, language, parent) {
  if(parent == "fathers") {

    if (language == "DUT") {
      start_with <- "LEEFTIJD vaders"
      ends_with = "LEEFTIJD moeders"
      skip_initial_n_lines = 5
    } else if (
      language == "ENG") {
      start_with <- "AGE fathers"
      ends_with = "AGE mothers"
      skip_initial_n_lines = 5
    }
  } else if(parent == "mothers") {

    if (language == "DUT") {
      start_with <- "LEEFTIJD moeders"
      ends_with = "GENERATIEINTERVAL"
      skip_initial_n_lines = 6
    } else if (
      language == "ENG") {
      start_with <- "AGE mothers"
      ends_with = "GENERATION INTERVAL"
      skip_initial_n_lines = 6
    }
  }

  extract_section(lines = lines,
                  start_with = start_with,
                  ends_with = ends_with,
                  skip_initial_n_lines = skip_initial_n_lines,
                  skip_last_n_lines = 5,
                  fill_colnames = "parents_age"
  )
}
