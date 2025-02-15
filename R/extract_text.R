#' Extract Text Between Underscore Delimiters
#'
#' This function extracts text from a vector of content lines, starting from a specified keyword
#' and returning the text between lines that contain at least five consecutive underscores.
#'
#' @param content_lines A character vector representing the lines of a file.
#' @param keyword A character string indicating the keyword to locate in the file.
#'
#' @return A character vector containing the extracted text between the underscore delimiters.
#'
#' @details
#' - The function searches for the first occurrence of the given keyword in the content lines.
#' - After locating the keyword, it identifies the first and last lines that contain at least five
#' consecutive underscores, treating them as delimiters.
#' - The function then returns the text between these two delimiters.
#' - If the keyword is not found, the function will calculate the Jaccard similarity to find the closest match in the text and will return a warning message with the closest match information.
#' - If the keyword is found in multiple places, only the first match will be used, and a warning will be issued.
#'
#' @examples
#' content <- c("Some text", "Keyword", "______", "Extract this text", "______", "More text")
#' extract_text(content, "Keyword")
#'
#' @export
extract_text <- function(content_lines, keyword) {
  # Find keyword location on file
  matches <- str_which(content_lines, fixed(keyword))

  # Give a warning if multiple matches are found
  if (length(matches) == 1) {
    keyword_line <- matches
  } else if (length(matches) > 1) {
    keyword_line <- matches[1]
    warning(
      paste0("Keyword '", keyword, "' was found in multiple places. Only the first match is going to be used. \n Matched line numbers are:\n", matches),
      paste0(matches, sep = " ")
    )
  # if keyword is not found, return what info we are looking for that are not matched
  } else if (length(matches) == 0) {
    # Calculate Jaccard similarity to find closest match
    similarity <- stringdist::stringdistmatrix(keyword, trimws(content_lines), method = "jaccard")
    closest_match <- lines[which.min(similarity)] # Find the closest match

    message_string <- c(
      "One or both of the phrases below were not found in the provided text file:\n",
      "Keyword: ", keyword, "\n",
      "Please check your input file for containing these lines.\n",
      "When an exact match is NOT found the function do not run and stats are not extracted."
    )
    message_string2 <- c(
      "\n\nThe closest match found in your provided file is:\n",
      closest_match,
      "\n\nPlease open a GitHub issue (see below) and include the following information:\n\n",
      "1. Description of the problem\n",
      "2. Output of the closest match found\n\n",
      "Thank you for your cooperation! \n"
    )

    # GitHub issues link
    github_issues_link <- "https://github.com/bonifazi/labradoR/issues/new"
    # Format the message with a clickable link
    # issue_message <- sprintf('<a href="%s">%s</a>', github_issues_link, "Open GitHub Issue")
    issue_message <- c("Open GitHub Issue here:\n", github_issues_link)

    # Output the message with the clickable link
    warning(message_string, "\n", message_string2, "\n", issue_message, "\n")

    stop("Keyword not found in file")
  }

  # regex: match any line that contains only underscores and at least 5 underscores anywhere in the line (with any leading whitespace (optional))
  regex <- "^\\s*_{5,}$"

  # Find the first year in table based on regex
  table_start <- str_which(content_lines[(keyword_line + 1):length(content_lines)], regex)[2] + keyword_line + 1
  if (is.na(table_start)) stop("Table start (underscores) not found after keyword")
  # Find the last year in table based on regex
  table_end <- str_which(content_lines[table_start:length(content_lines)], regex)[1] + table_start - 2
  if (is.na(table_end)) stop("Table end (empty line) not found")

  # return content between first and last year in table
  return(content_lines[table_start:table_end])
}
