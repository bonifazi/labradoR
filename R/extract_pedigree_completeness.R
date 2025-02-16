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
#' lines <- c(
#' "PEDIGREE COMPLETENESS",
#' "________________________________________________________________________",
#' "Y of   average      | percentage animals with # of generations ",
#' "birth  generation   | in pedigree completely known",
#' "equivalent   |    0       1       2       3       4    5 or more  ",
#' "________________________________________________________________________",
#' "2000       2.5    20.0    15.0    25.0    20.0    10.0    10.0",
#' "2001       2.7    18.0    17.0    24.0    21.0    10.0    10.0",
#' "2002       3.0    15.0    20.0    22.0    23.0    10.0    10.0",
#' "________________________________________________________________________"
#' )
#'
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
