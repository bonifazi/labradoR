#' Extract population size information from text lines of Retriever output.
#'
#' This function extracts population size information from text lines based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever.
#' @param language A character string specifying the language of the text ("DUT" for Dutch or "ENG" for English).
#'
#' @return A data frame representing the extracted population size information.
#'
#' @seealso \code{\link{extract_text}}, \code{\link{extract_section}}
#'
#' @examples
#' lines <- c(
#'   "POPULATIONSIZE: number of calves born per year",
#'   "__________________________________________________________________",
#'   "geb.        bulls      |    cows       |      total     | sex ratio",
#'   "jaar     unused fathers| unused mothers| unused parents | % male calves",
#'   "__________________________________________________________________",
#'   "2000  10  20   15  5  30  50  40.0",
#'   "2001  15  25   20  10  35  60  48.0",
#'   "2002  20  30   25  15  40  70  52.0" ,
#'   "__________________________________________________________________"
#' )
#'
#' extract_pop_size(lines, "ENG")
#'
#' @export
extract_pop_size <- function(lines, language) {
  table <- get_crossref_table()

  extract_section(
    lines = extract_text(
       content_lines = lines,
       keyword = table[table$lang == language & table$section == "popsize", "keyword"]
      ),
    trim_asterisks = T,
    column_names = c(
      "Year",
      "Sires_unused", "Sires_fathers",
      "Dams_unused", "Dams_mothers",
      "Total_unused", "Total_parents",
      "%_males_calves"
    )
  )
}
