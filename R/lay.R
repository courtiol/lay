#' lay down
#'
#' @param .data A data frame or data frame extension (e.g. a tibble).
#' @param .fn A function to apply to each row of `.data`. May also be a formula, see [rlang::as_function()]. Should return a scalar or a list.
#' @param ... Additional arguments for the function calls in `fn`.
#'
#' @examples
#' - each row of `.data` is materialized into a vector via [vctrs::vec_c()]
#' - `fn` is applied to that vector
#' - All results are finally combined together with [vctrs::vec_c()]
#'
#'
#' if (require("dplyr")) {
#'
#'   # for printing
#'   iris <- as_tibble(iris)
#'
#'   # apply mean for each row
#'   iris %>%
#'     mutate(Sepal.Mean = lay(across(starts_with("Sepal")), mean))
#'
#'   # not that useful because there is `rowMeans` already
#'   iris %>%
#'     mutate(Sepal.Mean = rowMeans(across(starts_with("Sepal"))))
#'
#'   # but then we can lay other functions, e.g. median
#'   iris %>%
#'     mutate(Sepal.Median = lay(across(starts_with("Sepal")), median))
#'
#'   # you can pass arguments to the function
#'   iris_with_NA <- iris
#'   iris_with_NA[1, 1] <- NA
#'   iris_with_NA %>%
#'     mutate(Sepal.Mean = lay(across(starts_with("Sepal")), mean))
#'   iris_with_NA %>%
#'     mutate(Sepal.Mean = lay(across(starts_with("Sepal")), mean, na.rm = TRUE))
#'
#'   # you can also lay into a tibble if you want multiple results
#'   iris %>%
#'     mutate(Sepal.Mean = lay(
#'       across(starts_with("Sepal")),
#'       ~ tibble(min = min(.x), mean = mean(.x), max = max(.x))
#'     ))
#'
#'   # the previous example creates a df-column called `Sepal.Mean`,
#'   # which you could unpack with `tidyr::unpack()`, but
#'   # if you skip `Sepal.Mean =` things get auto spliced for you!
#'   iris %>%
#'     mutate(lay(
#'       across(starts_with("Sepal")),
#'       ~ tibble(min = min(.x), mean = mean(.x), max = max(.x))
#'     ))
#'
#'   # if your function returns a vector and not a scalar,
#'   # just wrap it up in list (note also the use of the lambda syntax ~ fn(.x) here)
#'   iris %>%
#'     mutate(Sepal.Quantiles = lay(across(starts_with("Sepal")), ~ list(quantile(.x))))
#'
#'   # the previous example creates a list-column called `Sepal.Quantiles`,
#'   # which you could unnest with `tidyr::unnest_wider()`, but
#'   # you can once again rely on a tibble and skip the column name to get the output
#'   # auto spliced for you!
#'   if (require("tibble")) {
#'     iris %>%
#'       mutate(lay(across(starts_with("Sepal")), ~ as_tibble_row(quantile(.x))))
#'   }
#' }
#'
#' @export
lay <- function(.data, .fn, ...) {
    fn <- rlang::as_function(.fn)
    args <- rlang::list2(...)
    bits <- purrr::pmap(.data, function(...) rlang::exec(fn, vctrs::vec_c(...), !!!args))
    vctrs::vec_c(!!!bits)
  }
