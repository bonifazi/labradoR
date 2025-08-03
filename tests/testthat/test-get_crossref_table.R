
test_that("returns expected cross-reference table structure", {
  crossref <- get_crossref_table()

  expect_s3_class(crossref, "data.frame")
  expect_named(crossref, c("lang", "section", "keyword"))
  expect_equal(nrow(crossref), 16)
  expect_equal(unique(crossref$lang), c("ENG", "DUT"))
})

test_that("contains expected English-Dutch mappings", {
  crossref <- get_crossref_table()

  eng_rows <- crossref[crossref$lang == "ENG",]
  dut_rows <- crossref[crossref$lang == "DUT",]

  expect_equal(nrow(eng_rows), nrow(dut_rows))

  expect_equal(
    eng_rows$keyword[eng_rows$section == "popsize"],
    "POPULATIONSIZE: number"
  )
  expect_equal(
    dut_rows$keyword[dut_rows$section == "popsize"],
    "POPULATIEOMVANG: aantal"
  )
})

test_that("handles stringsAsFactors correctly", {
  crossref <- get_crossref_table()
  expect_type(crossref$lang, "character")
  expect_type(crossref$section, "character")
  expect_type(crossref$keyword, "character")
})
