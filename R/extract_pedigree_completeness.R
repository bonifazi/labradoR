#' Extract pedigree completeness information from text lines of Retriever output.
#'
#' This function extracts pedigree completeness information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted pedigree completeness information.
#'
#' @seealso \code{\link{extract_text}}, \code{\link{extract_section}}
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
  table <- get_crossref_table()

  extract_section(
    lines = extract_text(
      content_lines = lines,
      keyword = table[table$lang == language & table$section == "pedcomplet", "keyword"]
    ),
    column_names = c("Year",
                     "average_generation_equivalent",
                     "%_animals_with_0_generations_in_pedigree_completely_known",
                     "%_animals_with_1_generations_in_pedigree_completely_known",
                     "%_animals_with_2_generations_in_pedigree_completely_known",
                     "%_animals_with_3_generations_in_pedigree_completely_known",
                     "%_animals_with_4_generations_in_pedigree_completely_known",
                     "%_animals_with_5+_generations_in_pedigree_completely_known"
    ),
    fixed_col_width = c(4, 14, rep(8, 6))
  )
}
