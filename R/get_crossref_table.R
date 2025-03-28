#' Get Cross-Reference Table
#'
#' This function builds and returns a cross-reference table mapping section names and language to keywords
#'
#' @return A data frame with three columns: "lang" (language), "section" (section name), and "keyword" (corresponding keyword).
#'
#' @examples
#' crossref_table <- get_crossref_table()
#'
#' @export
get_crossref_table <- function() {
  crossref_table <- as.data.frame(
    matrix(
      c(
        "ENG", 	"popsize", 	   "POPULATIONSIZE: number",
        "DUT",  "popsize",  	 "POPULATIEOMVANG: aantal",
        "ENG", 	"inbreeding",  "INBREEDING",
        "DUT",  "inbreeding",  "INTEELT",
        "ENG", 	"geninterval", "GENERATION INTERVAL",
        "DUT",  "geninterval", "GENERATIEINTERVAL",
        "ENG", 	"agefathers",  "AGE fathers",
        "DUT",  "agefathers",  "LEEFTIJD vaders",
        "ENG", 	"agemothers",  "AGE mothers",
        "DUT",  "agemothers",  "LEEFTIJD moeders",
        "ENG", 	"pedcomplet",  "PEDIGREE COMPLETENESS",
        "DUT",  "pedcomplet",  "COMPLEETHEID stamboom",
        "ENG", 	"littersize",  "Number of parents and litter size per year",
        # "DUT",  "littersize",  "aantal ouders en nestgrootte per jaar",
        # "DUT",  "littersize",  "aantal ouders en worpgrootte per jaar",
        "DUT",  "littersize",  "aantal ouders en ",
        "ENG", 	"topcontribution", "Top sires and their contribution per year",
        "DUT",  "topcontribution", "Topvaders en hun aandeel per jaar"
      ),
      ncol = 3, byrow = T
    ), stringsAsFactors = FALSE
  )
  colnames(crossref_table) <- c("lang", "section", "keyword")
  return(crossref_table)
}
