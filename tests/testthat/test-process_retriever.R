
test_that("processes English log file correctly", {
  test_file <- "C:/Users/bonif002/OneDrive/labradoR_simulation/Retriever/www/upload/sheep_ped.out"

  results <- process_retriever(test_file, "ENG", verbose = FALSE)
  expect_type(results, "list")
  expect_s3_class(results$pop_size, "data.frame")
  expect_s3_class(results$pop_size_plot, "ggplot")
})

test_that("processes Dutch log file correctly", {
  test_file <- "tests/sheep_ped_nl.out"

  results <- process_retriever(test_file, "DUT", verbose = FALSE)
  expect_type(results, "list")
  expect_s3_class(results$pop_size, "data.frame")
  expect_s3_class(results$pop_size_plot, "ggplot")
})

test_that("handles xinterval correctly", {
  test_file <- "tests/sheep_ped.out"

  expect_error(process_retriever(test_file, "ENG", xinterval = "invalid"))
  expect_error(process_retriever(test_file, "ENG", xinterval = 2000))
  expect_error(process_retriever(test_file, "ENG", xinterval = c(2000, 2001, 2002)))

  results <- process_retriever(test_file, "ENG", xinterval = c(2000, 2001), verbose = FALSE)
  expect_type(results, "list")
})

test_that("handles error logging correctly", {
  withr::local_file(test_file <- tempfile())
  writeLines("invalid content", test_file)

  results <- process_retriever(test_file, "ENG", return_error_log = TRUE, verbose = FALSE)
  expect_type(results, "list")
  expect_type(results$error_log, "list")
  expect_type(results$results, "list")
})

test_that("handles missing file gracefully", {
  expect_error(process_retriever("nonexistent.txt", "ENG"))
})
