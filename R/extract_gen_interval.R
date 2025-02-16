#' Extract Generation Interval Information from Retriever Output
#'
#' This function extracts generation interval information from text lines of Retriever output
#' based on the specified language.
#'
#' @param lines A character vector containing the lines of text from Retriever output.
#' @param language A character string specifying the language of the text. Supported values are:
#'   \itemize{
#'     \item `"DUT"` for Dutch
#'     \item `"ENG"` for English
#'   }
#'
#' @return A data frame containing the extracted generation interval information with the following columns:
#'   \itemize{
#'     \item `Year` - The birth year of the offspring.
#'     \item `mean_age_sires` - The average age of sires at the time of birth of their offspring.
#'     \item `mean_age_dams` - The average age of dams at the time of birth of their offspring.
#'     \item `mean_age_both_parents` - The combined average age of both parents at the time of birth of offspring.
#'   }
#'   The generation interval is calculated as the mean parental age at the time of birth of offspring,
#'   based on the difference in birth dates between parents and offspring, expressed in years.
#'
#' @seealso \code{\link{extract_section}}, \code{\link{extract_text}}
#'
#' @export
#'
extract_gen_interval <- function(lines, language) {
  table <- get_crossref_table()

  extract_section(
    lines = extract_text(
      content_lines = lines,
      keyword = table[table$lang == language & table$section == "geninterval", "keyword"]
    ),
    column_names = c("Year",
                     "mean_age_sires",
                     "mean_age_dams",
                     "mean_age_both_parents")
  )
}


