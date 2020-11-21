#' Apply a function within each row.
#'
#' Create efficiently new column(s) in data frame (including tibble) by applying a function one row
#' at a time.
#'
#' `lay()` create a vector or a data frame (or tibble), by considering in turns each row of a data
#' frame (`.data`) as the vector input of some function(s) `.fn`.
#'
#' This makes the creation of new columns based on a rowwise operation both simple (see
#' **Examples**; below) and efficient (see the vignette [**benchmarks**](../doc/benchmark.html)).
#'
#' The function should be fully compatible with `{dplyr}`-based workflows and follows a syntax close
#' to [dplyr::across()].
#'
#' Yet, it takes `.data` instead of `.cols` as a main argument, which makes it possible to also use
#' `lay()` outside `dplyr` verbs (see **Examples**).
#'
#' The function `lay()` should work in a wide range of situations, provided that:
#'
#' - The input `.data` should be a data frame (including tibble) with columns of same class, or of
#' classes similar enough to be easily coerced into a single class. Note that `.method = "apply"`
#' also allows for the input to be a matrix and is more permissive in terms of data coercion.
#'
#' - The output of `.fn` should be a scalar (i.e. vector of length 1) or a 1 row data frame (or
#' tibble).
#'
#'
#' @param .data A data frame or tibble (or other data frame extensions).
#' @param .fn A function to apply to each row of `.data`.
#' Possible values are:
#'
#'   - A function, e.g. `mean`
#'   - A purrr-style lambda, e.g. `~ mean(.x, na.rm = TRUE)`
#'
#'     (wrap the output in a data frame to apply several functions at once, e.g.
#'     `~ tibble(min = min(.x), max = max(.x))`)
#'
#' @param ... Additional arguments for the function calls in `.fn` (must be named!).
#' @param .method This is an experimental argument that allows you to control which internal method
#'   is used to apply the rowwise job:
#'   - "apply", the default internally uses the function [apply()].
#'   - "tidy", internally uses [purrr::pmap()] and is stricter with respect to class coercion
#'   across columns.
#'
#'   The default has been chosen based on these [**benchmarks**](../doc/benchmark.html).
#'
#' @importFrom vctrs vec_c
#' @importFrom rlang list2 exec as_function
#' @importFrom purrr pmap
#'
#' @examples
#'
#' # usage without dplyr -------------------------------------------------------------------------
#'
#' # lay can return a vector
#' lay(iris[1:5, c("Sepal.Length", "Sepal.Width")], mean)
#'
#' # lay can return a data frame
#' lay(iris[1:5, c("Sepal.Length", "Sepal.Width")],
#'    function(.x) data.frame(Min = min(.x), Mean = mean(.x), Max = max(.x)))
#'
#' # lay can be used to augment a data frame
#' lay(iris[1:5, c("Sepal.Length", "Sepal.Width")],
#'    function(.x) cbind(iris[1:5, ], data.frame(Min = min(.x), Mean = mean(.x), Max = max(.x))))
#'
#'
#' # usage with dplyr ----------------------------------------------------------------------------
#'
#' if (require("dplyr")) {
#'
#'   # for enhanced printing
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
#'       ~ tibble(Min = min(.x), Mean = mean(.x), Max = max(.x))
#'     ))
#'
#'   # the previous example creates a df-column called `Sepal.Mean`,
#'   # which you could unpack with `tidyr::unpack()`, but
#'   # if you skip `Sepal.Mean =` things get auto spliced for you!
#'   iris %>%
#'     mutate(lay(
#'       across(starts_with("Sepal")),
#'       ~ tibble(Min = min(.x), Mean = mean(.x), Max = max(.x))
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
#'   iris %>%
#'     mutate(lay(across(starts_with("Sepal")), ~ as_tibble_row(quantile(.x))))
#' }
#'
#' @export
lay <- function(.data, .fn, ..., .method = "apply") {
    fn <- as_function(.fn)
    if (.method == "tidy") {
      args <- list2(...)
      bits <- pmap(.data, function(...) exec(fn, vec_c(...), !!!args))
    } else if (.method == "apply") {
      bits <- apply(.data, 1, fn, ...)
    } else stop(".method input unknown")
    vec_c(!!!bits)
}
