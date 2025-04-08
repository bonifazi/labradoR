#' Safely Execute an Extraction Function with Error Logging
#'
#' This function attempts to execute a given function and captures any errors
#' or warnings that occur during execution. Errors and warnings are logged in an `error_log`
#' variable located in the parent environment.
#'
#' @param function_to_exec A function to be executed within a `tryCatch` block.
#' @param ... Additional arguments passed to `function_to_exec`.
#' @param return_error Logical; if `TRUE`, errors and warnings are logged in `error_log`.
#'
#' @return The result of `function_to_exec(...)` if successful, otherwise `NULL` if error is detected.
#'         If a warning or message is detected, the results of `function_to_exec()` are still returned.
#' @examples
#' error_log <- list()  # Initialize an error log
#' safe_extract(log, -1)  # Example usage with a function that may generate warnings/errors
#'
#' @export
safe_extract <- function(function_to_exec, ..., return_error = TRUE) {
  func_name <- deparse(substitute(function_to_exec))
  parent_env <- parent.frame()  # Capture parent environment outside tryCatch

  # # Print the current content of error_log before proceeding
  # cat("\n Current error_log content before extraction attempt: \n")
  # print(get("error_log", envir = parent_env))

  result <- tryCatch({
    withCallingHandlers({
      function_to_exec(...)
    }, warning = function(w) { # warnings will return results nonetheless
      warn_msg <- paste("Warning in", func_name, ":", w$message)
      cat("\n", warn_msg, "\n")
      if (return_error) {
        error_log <- get("error_log", envir = parent_env)
        new_error_log <- c(error_log, list(warn_msg))
        assign("error_log", new_error_log, envir = parent_env)
      }
    })
  }, error = function(e) {
    error_msg <- paste("Error in", func_name, ":", e$message)
    cat("\n", error_msg, "\n")
    if (return_error) {
      # Use the PRE-CAPTURED parent_env (process_retriever's environment)
      error_log <- get("error_log", envir = parent_env)
      new_error_log <- c(error_log, list(error_msg))
      assign("error_log", new_error_log, envir = parent_env)
    }
    return(NULL)
  })

  # After the extraction attempt, print the updated content of error_log
  # cat("\n Updated error_log content after extraction attempt: \n")
  # print(get("error_log", envir = parent_env))

  return(result)
}
