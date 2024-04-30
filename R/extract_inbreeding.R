#' Extract inbreeding information from text lines of Retriever output.
#'
#' This function extracts inbreeding information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted inbreeding information.
#'
#' @examples
#' lines <- c("INBREEDING",
#'            " ", " "," "," "," ",
#'            "2000 0.10 0.05 0.06 0.03 0.02 0.01",
#'            "2001 0.12 0.06 0.07 0.04 0.03 0.02",
#'            "2002 0.15 0.08 0.09 0.05 0.04 0.03",
#'            " "," "," "," ")
#' extract_inbreeding(lines, "ENG")
#'
#' @export

extract_inbreeding <- function(lines, language) {
  if (language == "DUT") {
    start_with <- "INTEELT"
  } else if (
    language == "ENG") {
    start_with <- "INBREEDING"
  }

  extract_section(lines = lines,
                  start_with = start_with,
                  ends_with = "deltaF     deltaF      Ne",
                  skip_initial_n_lines = 6,
                  skip_last_n_lines = 4,
                  column_names =  c("Year", "F_all_animals",
                                    "f_inc.self", "f_exc.self",
                                    "f_parents", "f_sires", "f_dams")
  )
}
