test_that("lay works", {

  ## data for tests
  df <- tibble(x = 1:10, y = 11:20, z = 21:30)
  df_na <- df
  df_na[1, 1] <- NA

  ## simple calls
  expect_identical(
    lay(df, mean),
    rowMeans(df)
  )

  expect_identical(
    lay(df, min),
    df$x
  )

  ## call with fn arguments
  expect_identical(
    lay(df_na, mean, na.rm = TRUE),
    rowMeans(df_na, na.rm = TRUE)
  )

  ## auto spliced output
  expect_identical(
    lay(df, ~ tibble(min = min(.x), max = max(.x))),
    tibble(min = df$x, max = df$z)
  )

  ## both methods should lead to same results
  expect_identical(
    lay(df, mean, .method = "tidy"),
    lay(df, mean, .method = "apply")
  )

  expect_identical(
    lay(df, ~ mean(.x), .method = "tidy"),
    lay(df, ~ mean(.x), .method = "apply")
  )

  expect_identical(
    lay(df, ~ tibble(min = min(.x), max = max(.x)), method = "tidy"),
    lay(df, ~ tibble(min = min(.x), max = max(.x)), method = "apply")
  )

  ## handle error properly
  expect_error(
    lay(df, mean, .method = "nonesense")
  )

})
