#' Extract and Process a Section of Data
#'
#' This function extracts tabular data from a list of lines, processes column names,
#' removes unwanted content, and converts extracted data into a numeric data frame.
#'
#' @param lines A character vector containing lines of text to be processed.
#' @param exclude_between_char A character indicating a delimiter (e.g., `"_"`) for removing text enclosed between consecutive occurrences of the character.
#' @param trim_asterisks Logical (default `FALSE`). If `TRUE`, removes all asterisks (`*`) from the text.
#' @param skipcols A numeric vector specifying column indices to be removed from the extracted data.
#' @param column_names A character vector of column names. If provided, it must match the number of extracted columns.
#' @param fill_colnames A special keyword (e.g., `"parents_age"`) to automatically generate column names.
#' @param fixed_col_width A numeric vector specifying the fixed column widths for parsing the data. If `NA`, whitespace-based splitting is used instead.

#' @return A data frame with processed numeric values and appropriately assigned column names.
#'
#' @details
#' - The function automatically splits lines into columns based on whitespace.
#' - All extracted values are converted to numeric.
#' - If `exclude_between_char` is provided, content between matching symbols is removed.
#' - If `trim_asterisks = TRUE`, all `*` symbols are stripped.
#' - If `fill_colnames = "parents_age"`, the function auto-generates column names with `Year` followed by `Age_1`, `Age_2`, etc.
#' - If `column_names` is provided, its length must match the number of extracted columns, otherwise an error is thrown.
#' - If `fixed_col_width` do not count leading spaces for first col which hare removed.
#'
#' @examples
#' lines <- c("2020 25 30 35", "2021 26 31 36")
#' extract_section(lines, column_names = c("Year", "Age_A", "Age_B", "Age_C"))
#'
#' @export
extract_section <- function(lines,
                            exclude_between_char = NA,
                            trim_asterisks = F,
                            skipcols = NA,
                            column_names = NA,
                            fill_colnames = NA,
                            fixed_col_width = NA
) {
  # 1. Handle special cases when called ------
  # Remove content between consecutive symbols
  if(!is.na(exclude_between_char)) {
    lines <- str_replace_all(lines, paste0("\\", exclude_between_char, ".*?\\", exclude_between_char), " ")
  }
  # Remove asterisks (usually next to `Year`)
  if(!is.na(trim_asterisks)) {
    lines <- str_replace_all(lines, "\\*", "")
  }

  # 2. Parse text -----
  # if col values are complete, split by white spaces
  if(anyNA(fixed_col_width)) {
    # Split each line by white space and remove empty elements
    split_lines <- str_split(lines, "\\s+") %>%
      map(~ discard(.x, ~ .x == ""))
    # Convert the split lines into a data frame
    extr_data <- as.data.frame(do.call(rbind, split_lines), stringsAsFactors = F)
    # skip user-defined cols
    if (!is.na(skipcols)[1]) {
      extr_data <- extr_data[-skipcols] # remove cols to skip
    }

    # if col values are incomplete, split by user-defined number of columns
  } else if (!anyNA(fixed_col_width)) {
    lines <- trimws(lines) # Remove leading spaces and trailing (\r return)characters

    # Read the data from vector of lines using a text connection
    extr_data <- read.fwf(
      file = textConnection(lines),
      widths = fixed_col_width, # user-defined col width
      strip.white = TRUE,   # Remove extra spaces from each field
      na.strings = NA_real_ # Convert empty strings to NA (here NA_real_ as cols are expected to be numeric)
    )

  }

  # 3. Assign column names ----

  # Set column names based on user-provided arg
  if (!anyNA(column_names)) {
    # check: stop if given colnames are not enough
    if(length(column_names) != length(colnames(extr_data))){
      cat("\n Provided colnames are:\n", column_names)
      stop(
        paste0("\n Provided colnames (n=", length(column_names), ") are not matching those of the extracted columns (n=", length(colnames(extr_data)), ").")
      )
    } else {
      colnames(extr_data) <- column_names
    }
  }
  # Special-case for parents age -> set column names with a variable number (1 to nth)
  if(!is.na(fill_colnames) & fill_colnames == "parents_age") {
    colnames(extr_data) <- c("Year", paste0("Age_", seq(1:(ncol(extr_data)-1))) )
  }

  # 4. Convert all to numeric -----
  extr_data <- mutate(extr_data, across(everything(), as.numeric))

  return(extr_data)
}
