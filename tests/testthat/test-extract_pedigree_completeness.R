
test_that("extracts pedigree completeness for English text", {
  test_lines <- c(
    "PEDIGREE COMPLETENESS",
    "________________________________________________________________________",
    "Y of   average      | percentage animals with # of generations ",
    "birth  generation   | in pedigree completely known",
    "equivalent   |    0       1       2       3       4    5 or more  ",
    "________________________________________________________________________",
    "2000       2.5    20.0    15.0    25.0    20.0    10.0    10.0",
    "2001       2.7    18.0    17.0    24.0    21.0    10.0    10.0",
    "2002       3.0    15.0    20.0    22.0    23.0    10.0    10.0",
    "________________________________________________________________________"
  )

  result <- extract_pedigree_completeness(test_lines, "ENG")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_equal(ncol(result), 8)
  expect_equal(result$Year, c(2000, 2001, 2002))
  expect_equal(result$average_generation_equivalent, c(2.5, 2.7, 3.0))
})

test_that("extracts pedigree completeness for Dutch text", {
  test_lines <- c(
    "COMPLEETHEID stamboom",
    "________________________________________________________________________",
    "G van  gemiddeld    | percentage dieren met # generaties ",
    "eboorte generatie   | in stamboom volledig bekend",
    "equivalent   |    0       1       2       3       4    5 of meer  ",
    "________________________________________________________________________",
    "2000       2.5    20.0    15.0    25.0    20.0    10.0    10.0",
    "2001       2.7    18.0    17.0    24.0    21.0    10.0    10.0",
    "2002       3.0    15.0    20.0    22.0    23.0    10.0    10.0",
    "________________________________________________________________________"
  )

  result <- extract_pedigree_completeness(test_lines, "DUT")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_equal(ncol(result), 8)
  expect_equal(result$Year, c(2000, 2001, 2002))
  expect_equal(result$average_generation_equivalent, c(2.5, 2.7, 3.0))
})

test_that("handles empty input appropriately", {
  expect_error(extract_pedigree_completeness(character(), "ENG"))
})

test_that("fails on invalid language", {
  test_lines <- c("PEDIGREE COMPLETENESS", "some data")
  expect_error(extract_pedigree_completeness(test_lines, "INVALID"))
})
