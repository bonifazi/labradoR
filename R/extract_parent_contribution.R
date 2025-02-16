#' Extract parent contribution information from text lines of Retriever output.
#'
#' This function extracts parent contribution information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted parent contribution information.
#'
#' @seealso \code{\link{extract_text}}, \code{\link{extract_section}}
#'
#' @examples
#' lines <- c(
#'   "Top sires and their contribution per year",
#'   "_______________________________________________________________________________________________________________________",
#'   "|                  the Topsire             |                   contribution of top 10 sires (%)         |",
#'   "  year #Sires   | name                    id               |    1     2     3     4     5     6     7     8     9    10 |",
#'   "_______________________________________________________________________________________________________________________",
#'   "2000       5    | TopSireA                12345            |  20    15    12    10     9     8     7     6     7     6 |",
#'   "2001       5    | TopSireB                23456            |  22    17    14    10     9     8     7     6     4     3 |",
#'   "2002       6    | TopSireC                34567            |  25    20    15    12    10     8     5     3     2     2 |",
#'      "________________________________________________________"
#' )
#'
#' extract_parent_contribution(lines, "ENG")
#'
#' @export

extract_parent_contribution <- function(lines, language) {
  table <- get_crossref_table()

  extract_section(
    lines = extract_text(
      content_lines = lines,
      keyword = table[table$lang == language & table$section == "topcontribution", "keyword"]
    ),
    # exclude content within '|' characters because some rows may have inconsistent "-" for the sire name creating issues
    exclude_between_char = "|",
    fixed_col_width = c(
      4,  # First is always Year which is 4 (leading spaces are removed)
      11,
      rep(6, 10)
    ),
    column_names = c("Year",
                     "Nr_sires",
                     # "sire_name",  # skipped by exclude_between_chr
                     # "topsire_id", # skipped by exclude_between_chr
                     paste0(
                       "topsire ", c(1:10), ""
                     )
    )
  )
}
