test_that("multiplication works", {
  df <- tibble(x = 1:10, y = 11:20, z = 21:30)

  expect_identical(
    lay(df, mean),
    rowMeans(df)
  )

  expect_identical(
    lay(df, min),
    df$x
  )

  expect_identical(
    lay(df, ~tibble(min = min(.), max = max(.))),
    tibble(min = df$x, max = df$z)
  )

})
