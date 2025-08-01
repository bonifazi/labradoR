# suppressWarnings is needed for warnings test due to cat() in safe_extact()
# the cat() returned structure interfers with the tests
test_that("safe_extract returns NULL and logs error message on error", {
  error_log <- list()
  result <- safe_extract(function(x) stop("test error"), "foo")
  expect_null(result)
  expect_match(error_log[[1]], "Error in function.*test error")
})

test_that("safe_extract returns result and logs warning on warning", {
  error_log <- list()
  result <- suppressWarnings(
    safe_extract(function(x) { warning("test warning"); 42 }, "foo")
  )
  expect_equal(result, 42)
  expect_match(error_log[[1]][1], "Warning in function(x)", fixed = TRUE)
})

test_that("safe_extract returns result without logging when return_error = FALSE", {
  error_log <- list()

  # Warning case
  result1 <- suppressWarnings(
    safe_extract(function(x) {warning("test warning"); 42}, "foo", return_error = FALSE)
  )
  expect_equal(result1, 42)
  expect_length(error_log, 0)

  # Error case
  result2 <- safe_extract(function_to_exec = function(x) stop("test error"), return_error = FALSE)
  expect_null(result2)
  expect_length(error_log, 0)
})

test_that("safe_extract passes through arguments correctly", {
  error_log <- list()
  test_fn <- function(x, y) x + y
  expect_equal(safe_extract(test_fn, 1, 2), 3)
})

test_that("safe_extract preserves function name in messages", {
  error_log <- list()
  result <- suppressWarnings(
    safe_extract(log, -1)
  )
  expect_match(error_log[[1]], "Warning in log : NaNs produced")
})
