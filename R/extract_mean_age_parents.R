#' Extract mean age of parents information from text lines of Retriever output.
#'
#' This function extracts the mean age of parents information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#' @param parent A character string ("fathers" for sires or "mothers" for dams).
#'
#' @return A data frame containing the extracted mean age of parents information with columns:
#' \itemize{
#'   \item Year of birth
#'   \item Average age of parents (in years)
#' }
#'
#' @seealso \code{\link{extract_text}}, \code{\link{extract_section}}
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
#'
#' @export

extract_mean_age_parents <- function(lines, language, parent) {
  table <- get_crossref_table()

  if(parent == "fathers") {
    lines = extract_text(
      content_lines = lines,
      keyword = table[table$lang == language & table$section == "agefathers", "keyword"]
    )
  } else if(parent == "mothers") {
    lines = extract_text(
      content_lines = lines,
      keyword = table[table$lang == language & table$section == "agemothers", "keyword"]
    )
  }

  extract_section(lines = lines,
                  fill_colnames = "parents_age"
  )
}
