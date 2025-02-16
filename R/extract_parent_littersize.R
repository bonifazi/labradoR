#' Extract parent and litter size information from text lines of Retriever output.
#'
#' This function extracts parent and litter size information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted parent and litter size information.
#'
#' @seealso \code{\link{extract_text}}, \code{\link{extract_section}}
#'
#' @examples
#' lines <- c(
#'   "Number of parents and litter size per year",
#'   "________________________________________________________",
#'   "Y of   number   calves/   number   litter   calves/ ",
#'   "birth   litter   litter   fathers  /father   father ",
#'   "________________________________________________________",
#'   "2000       100      2.0       50      2.0      1.0",
#'   "2001       110      2.5       55      2.2      1.1",
#'   "2002       120      3.0       60      2.5      1.2",
#'   "________________________________________________________"
#' )
#'
#' extract_parent_littersize(lines, "ENG")
#'
#' @export
#'
extract_parent_littersize <- function(lines, language) {
  table <- get_crossref_table()

  extract_section(
    lines = extract_text(
      content_lines = lines,
      keyword = table[table$lang == language & table$section == "littersize", "keyword"]
    ),
    column_names = c("Year",
                     "Number_nests",
                     "calves_per_nest",
                     "number_fathers",
                     "nests_per_father",
                     "calves_per_father"

    ),
    fixed_col_width = c(4, rep(8, 5))
  )
}
