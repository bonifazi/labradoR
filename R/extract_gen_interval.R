#' Extract generation interval information from text lines of Retriever output.
#'
#' This function extracts generation interval information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted generation interval information.
#'
#' @examples
#' lines <- c("GENERATION INTERVAL",
#'            " ", " "," "," ",
#'            "2000 5 6 5.5",
#'            "2001 5.5 6.5 6",
#'            "2002 6 7 6.5",
#'            " ", " "," "," ",
#'            "PEDIGREE COMPLETENESS")
#' extract_gen_interval(lines, "ENG")
#'
#' @export

extract_gen_interval <- function(lines, language) {
  if (language == "DUT") {
    start_with <- "GENERATIEINTERVAL"
    ends_with  <- "COMPLEETHEID stamboom"
  } else if (
    language == "ENG") {
    start_with <- "GENERATION INTERVAL"
    ends_with  <- "PEDIGREE COMPLETENESS"
  }

  extract_section(lines = lines,
                  start_with = start_with,
                  ends_with = ends_with,
                  skip_initial_n_lines = 5,
                  skip_last_n_lines = 5,
                  column_names = c("Year",
                                   "mean_age_sires",
                                   "mean_age_dams",
                                   "mean_age_both_parents")
  )
}
