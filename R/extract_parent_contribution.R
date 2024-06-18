#' Extract parent contribution information from text lines of Retriever output.
#'
#' This function extracts parent contribution information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted parent contribution information.
#'
#' @examples
#' lines <- c("Top sires and their contribution per year",
#'            " ", " ", " ", " ", " ",
#'            "2000 5 0.2 0.15 0.1 0.08 0.07 0.05 0.04 0.03 0.02 0.01",
#'            "2001 5 0.22 0.17 0.12 0.1 0.08 0.06 0.05 0.03 0.02 0.01",
#'            "2002 6 0.25 0.2 0.15 0.12 0.1 0.08 0.07 0.05 0.03 0.02",
#'            " ", " ", " ",
#'            "INBREEDING")
#' extract_parent_contribution(lines, "ENG")
#'
#' @export

extract_parent_contribution <- function(lines, language) {
  if (language == "DUT") {
    start_with <- "Topvaders en hun aandeel per jaar"
    ends_with = "INTEELT"
  } else if (
    language == "ENG") {
    start_with <- "Top sires and their contribution per year"
    ends_with = "INBREEDING"
  }

  extract_section(lines = lines,
                  start_with = start_with,
                  ends_with = ends_with,
                  # force_first_grep_start = F,
                  force_first_grep_end = T,
                  skip_initial_n_lines = 6,
                  skip_last_n_lines = 4,
                  exclude_between_char = "|", # exclude content within '|' characters because some rows may have inconsistent "-" for the sire name creating issues
                  column_names = c("Year",
                                   "Nr_sires",
                                   # "sire_name",  # skipped by exclude_between_chr
                                   # "topsire_id", # skipped by exclude_between_chr
                                   paste0(
                                     "topsire ", c(1:10), ""
                                   )
                  ),
  )
}
