#' Extract inbreeding information from text lines of Retriever output.
#'
#' This function extracts inbreeding information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text. Supported values are:
#'   \itemize{
#'     \item `"DUT"` for Dutch
#'     \item `"ENG"` for English
#'   }
#'
#' @return A data frame containing extracted inbreeding and kinship information with the following columns:
#'   \itemize{
#'     \item `Year` -  The year of birth of animals.
#'     \item `F_all_animals` - The average inbreeding coefficient for all individuals born in a year.
#'     \item `f_inc.self` - The average kinship coefficient (including selfing) for all individuals born in a year.
#'     \item `f_exc.self` - The average kinship coefficient (excluding selfing) for all individuals born in a year.
#'     \item `f_parents` - The average kinship coefficient (excluding selfing) for animals born in a year, which later become a parent.
#'     \item `f_sires` - The average kinship coefficient (excluding selfing) for animals born in a year, which later become a sire.
#'     \item `f_dams` - The average kinship coefficient (excluding selfing) for animals born in a year, which later become a dam.
#'   }
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
#' @seealso \code{\link{extract_text}}, \code{\link{extract_section}}
#'
#' @export

extract_inbreeding <- function(lines, language) {
  table <- get_crossref_table()

  extract_section(
    lines = extract_text(
      content_lines = lines,
      keyword = table[table$lang == language & table$section == "inbreeding", "keyword"]
    ),
    column_names =  c(
      "Year",
      "F_all_animals",
      "f_inc.self", "f_exc.self",
      "f_parents",
      "f_sires", "f_dams"),
    fixed_col_width = c(
      4,  # First is always Year which is 4
      rep(8, 6) # remaining are with width provided and as many as colnames provided -1
    )
  )
}
