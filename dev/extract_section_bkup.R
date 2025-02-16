#' Extract a section from a character vector
#'
#' This function extracts a section from a character vector based on specified start and end phrases, skipping initial and final lines, and optionally excluding content between specified characters.
#'
#' @param lines A character vector containing the lines of text to use as input.
#' @param start_with A character string indicating the phrase marking the start of the section.
#' @param ends_with A character string indicating the phrase marking the end of the section.
#' @param force_first_grep_start Logical (default = FALSE). If TRUE, only the first match of \code{start_with} will be considered.
#' @param force_first_grep_end Logical (default = FALSE). If TRUE, only the first match of \code{ends_with} after the start match will be considered.
#' @param skip_initial_n_lines Numeric. The number of lines to skip after the start match.
#' @param skip_last_n_lines Numeric. The number of lines to skip before the end match.
#' @param column_names Optional. A character vector specifying column names for the resulting data frame.
#' @param fill_colnames Optional. A character string specifying how to fill column names in specific situations (e.g., "parents_age").
#' @param skipcols Optional. A numeric vector specifying column indices to skip.
#' @param exclude_between_char Optional. A character string indicating characters between which content should be excluded.
#'
#' @return A data frame representing the extracted section from the input.
#'
#' @import dplyr purrr stringr
#' @importFrom dplyr %>%
#' @importFrom purrr map
#' @importFrom purrr discard
#' @importFrom stringr str_split
#'
#' @examples
#' lines <- c("GENERATION INTERVAL  ",
#'            " some text to skip", "some text to skip ",
#'            "",  "", "", # empty lines are skipped automatically
#'            "2000 5 6 5.5",
#'            "2001 5.5 6.5 6",
#'            "2002 6 7 6.5",
#'            "",  "", "", # empty lines are skipped automatically
#'            "some text to skip ", "some text to skip ",
#'            "PEDIGREE COMPLETENESS    ")
#' lines
#' extract_section(lines, start_with = "GENERATION INTERVAL",
#'            ends_with = "PEDIGREE COMPLETENESS", skip_initial_n_lines = 3,
#'            skip_last_n_lines = 3)
#'
#' @export
#'

extract_section <- function(lines,
                            start_with,
                            ends_with,
                            force_first_grep_start = F,
                            force_first_grep_end = F,
                            skip_initial_n_lines,
                            skip_last_n_lines,
                            column_names = NA,
                            fill_colnames = NA,
                            skipcols = NA,
                            exclude_between_char = NA
) {

  # Find the line number where the phrases occur
  start_lines <- str_which(lines, start_with)
  end_lines_total <- str_which(lines, ends_with)
  # stop if finding multiple matches for start or end
  if (length(start_lines) > 1     & force_first_grep_start == F ) {
    stop("multiple matches found in start_with grep string", print(start_lines))
  }

  if (length(end_lines_total) > 1 & force_first_grep_end == F ) {
    stop("multiple matches found in ends_with grep string", print(end_lines_total))
  }

  # if force is active take the first start hit and the first end hit (which is larger and closest to start)
  if(force_first_grep_start == T) {
    start_lines <- start_lines[1] # take the first hit
  }
  # Find the closest hit in end_lines_total that is greater than start_lines
  if(force_first_grep_end == T) {
    end_lines_total <- min(end_lines_total[end_lines_total > start_lines])
  }

  # Check if matches are found
  if (length(start_lines) > 0 & length(end_lines_total) > 0) {
    # Extract the content from the 6th line after the starting match
    start_index <- start_lines + skip_initial_n_lines
    # Extract until x lines before the final line match
    end_index_total <- end_lines_total - skip_last_n_lines
    # Extract content
    selected_content <- lines[start_index:end_index_total]

    # Remove content between consecutive symbols if called by user
    if(!is.na(exclude_between_char)) {
      selected_content <- str_replace_all(selected_content, paste0("\\", exclude_between_char, ".*?\\", exclude_between_char), " ")
    }

    # Split each line by white space and remove empty elements
    split_lines <- str_split(selected_content, "\\s+") %>%
      map(~ discard(.x, ~ .x == ""))
    # Convert the split lines into a data frame
    extr_data <- as.data.frame(do.call(rbind, split_lines), stringsAsFactors = F)
    # skip user-defined cols
    if (!is.na(skipcols)[1]) {
      extr_data <- extr_data[-skipcols] # remove cols to skip
    }
    # Set column names based on user-provided arg
    if (!anyNA(column_names)) {
      colnames(extr_data) <- column_names
    }
    # Set column names with var number for specific situations
    if(!is.na(fill_colnames) & fill_colnames == "parents_age") {
      colnames(extr_data) <- c("Year",
                               paste0("Age_", seq(1:(ncol(extr_data)-1))) )
    }
    # Set all cols to numeric
    extr_data <- mutate(extr_data, across(everything(), as.numeric))

    return(extr_data)
  } else {
    # if string is not found, return what info we are looking for that are not matched
    # Calculate Jaccard similarity to find closest match
    similarity <- stringdist::stringdistmatrix(start_with, trimws(lines), method = "jaccard")
    closest_match <- lines[which.min(similarity)] # Find the closest match

    message_string <- c(
      "One or both of the phrases below were not found in the provided text file:\n",
      "Starts with: ", start_with, "\n",
      "Ends with: ", ends_with, "\n\n",
      "Please check your input file for containing these lines.\n",
      "When an exact match is NOT found the function do not run and stats are not extracted."
    )
    message_string2 <- c(
      "\n\nThe closest match found in your provided file is:\n",
      closest_match,
      "\n\nPlease open a GitHub issue (see below) and include the following information:\n\n",
      "1. Description of the problem\n",
      "2. Output of the closest match found\n\n",
      "Thank you for your cooperation! \n")

    # GitHub issues link
    github_issues_link <- "https://github.com/bonifazi/labradoR/issues/new"
    # Format the message with a clickable link
    # issue_message <- sprintf('<a href="%s">%s</a>', github_issues_link, "Open GitHub Issue")
    issue_message <- c("Open GitHub Issue here:\n", github_issues_link)

    # Output the message with the clickable link
    warning(message_string, "\n", message_string2, "\n", issue_message, "\n")

  }
}
