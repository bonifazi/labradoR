
test_that("rounds to closest multiple", {
  expect_equal(find_closest_multiple_of_x(17, 5), 15)
  expect_equal(find_closest_multiple_of_x(23, 10), 20)
  expect_equal(find_closest_multiple_of_x(52, 25), 50)
  expect_equal(find_closest_multiple_of_x(76, 25), 75)
})

test_that("handles edge cases correctly", {
  expect_equal(find_closest_multiple_of_x(0, 5), 0)
  expect_equal(find_closest_multiple_of_x(2.6, 1), 3)
  expect_equal(find_closest_multiple_of_x(-17, 5), -15)
})

test_that("handles exact multiples", {
  expect_equal(find_closest_multiple_of_x(20, 5), 20)
  expect_equal(find_closest_multiple_of_x(100, 25), 100)
  expect_equal(find_closest_multiple_of_x(0, 10), 0)
})
