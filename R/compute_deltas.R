#' Compute Deltas for given Intervals
#'
#' This function computes the annual and generational deltas for inbreeding and kinship coefficients over specified intervals. The computation for annual deltas follows the method outlined by Pérez-Enciso (1995).
#'
#' @param intervals A numeric vector representing the intervals for computation.
#' @param generation_intervals A data frame (as that from labradoR's output `gen_intervals`) containing the generation intervals.
#' @param inbreeding A data frame (as that from labradoR's output `inbreeding`) containing inbreeding and kinship coefficients.
#' @param round An integer (default = 2) specifying the number of decimal places to which the results should be rounded.
#'
#' @return A data frame with the computed deltas for each interval pair. The data frame includes:
#' \item{interval}{The interval pair in the format "start-end".}
#' \item{annual_delta_F}{The annual delta for all animals' inbreeding coefficient, expressed as a percentage.}
#' \item{annual_delta_f}{The annual delta for the inbreeding coefficient excluding selfing, expressed as a percentage.}
#' \item{L}{The average age of both parents within the interval, rounded to specified decimal places.}
#' \item{generation_delta_F}{The generational delta for all animals' inbreeding coefficient, expressed as a percentage.}
#' \item{generation_delta_f}{The generational delta for the inbreeding coefficient excluding selfing, expressed as a percentage.}
#' Values are rounded to the `round` coefficient (default = 2).
#' @export
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' intervals <- c(2000, 2010, 2020)
#' generation_intervals <- data.frame(Year = 2000:2020, mean_age_both_parents = runif(21, 2, 4))
#' inbreeding <- data.frame(Year = 2000:2020, F_all_animals = runif(21, 0, 0.1), f_exc.self = runif(21, 0, 0.1))
#' compute_deltas(intervals, generation_intervals, inbreeding, 2)

compute_deltas <- function(intervals, generation_intervals, inbreeding, round = 2) {
  deltas_list <- list() # create an empty list to store results
  if(!is.numeric(intervals) ) {
    stop("`intervals` provided to compute_deltas are not numeric! Provide numeric intervals, e.g., intervals <- c(2000, 2010, 2020)")
  }
  for(i in 1:(length(intervals)-1)) {  # loop for intervals pairs
    # define start-end interval
    interval_1 <- intervals[i]
    interval_2 <- intervals[i+1]
    # cat("\n", interval_1, "-", interval_2, "\n")

    # compute average_L for both parents in interval
    average_L <- generation_intervals %>%
      filter(Year >= interval_1 & Year <= interval_2) %>%
      summarise(ave_mean_age = mean(mean_age_both_parents)) %>%
      as.numeric()


    tmp <- inbreeding %>%
      filter(Year >= interval_1 & Year <= interval_2) %>%
      # compute LN_F and ln_f
      mutate(
        LN_1_minus_F = log(1 - F_all_animals),
        LN_1_minus_f = log(1 - f_exc.self)
      )

    # compute annual deltas as in Pérez-Enciso, 1995:
    # -slope( y = LN_x, x = years)
    # and express as %
    annual_delta_F <- (-(coef(lm(tmp$LN_1_minus_F ~ tmp$Year))[2]))*100
    annual_delta_f <- (-(coef(lm(tmp$LN_1_minus_f ~ tmp$Year))[2]))*100
    # compute delta_generation as:
    #  -slope( y = LN_x, x = years) / average_L
    generation_delta_F <-  annual_delta_F * (average_L)
    generation_delta_f <-  annual_delta_f * (average_L)

    # bind all results
    deltas <- data.frame(
      intervals = paste0(interval_1, "-", interval_2),
      annual_delta_F =     round(annual_delta_F,     round),
      annual_delta_f =     round(annual_delta_f,     round),
      average_L =          round(average_L,          round),
      generation_delta_F = round(generation_delta_F, round),
      generation_delta_f = round(generation_delta_f, round),
      row.names = NULL
    )

    deltas_list[[i]] <- deltas # Store looped results
  }
  return(do.call(rbind, deltas_list)) # Combine all results into a single data frame
}
