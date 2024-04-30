#' Extract parent and litter size information from text lines of Retriever output.
#'
#' This function extracts parent and litter size information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted parent and litter size information.
#'
#' @examples
#' lines <- c("Number of parents and litter size per year",
#'            " ", " ", " ", " ", " ",
#'            "2000 100 2 50 2 1",
#'            "2001 110 2.5 55 2.2 1.1",
#'            "2002 120 3 60 2.5 1.2",
#'            " ", " ", " ", " ", " ",
#'            "Litter Sizes")
#' extract_parent_littersize(lines, "ENG")
#'
#' @export

extract_parent_littersize <- function(lines, language) {
  if (language == "DUT") {
    start_with <- "aantal ouders en nestgrootte per jaar"
    ends_with = "Worpgrootte"
  } else if (
    language == "ENG") {
    start_with <- "Number of parents and litter size per year"
    ends_with = "Litter Sizes"
  }

  extract_section(lines = lines,
                  start_with = start_with,
                  ends_with = ends_with,
                  # force_first_grep_start = F,
                  force_first_grep_end = T,
                  skip_initial_n_lines = 6,
                  skip_last_n_lines = 6,
                  column_names = c("Year",
                                   "Number_nests",
                                   "calves_per_nest",
                                   "number_fathers",
                                   "nests_per_father",
                                   "calves_per_father"

                  )
  )
}
