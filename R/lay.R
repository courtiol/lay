#' lay down
#'
#' @param .data A data frame or data frame extension (e.g. a tibble).
#' @param .fn A function to apply to each row of `.data`. May also be a formula, see [rlang::as_function()]. Should return a scalar or a list.
#' @param ... Additional arguments for the function calls in `fn`.
#'
#' @details
#' - each row of `.data` is materialized into a vector via [vctrs::vec_c()]
#' - `fn` is applied to that vector
#' - All results are finally combined together with [vctrs::vec_c()]
#'
#'
#' @examples
#' if (require("dplyr")) {
#'
#'   # for printing
#'   iris <- as_tibble(iris)
#'
#'   # apply mean for each row
#'   iris %>%
#'     mutate(sepal = lay(across(starts_with("Sepal")), mean))
#'
#'   # not that useful because there is `rowMeans` already
#'   iris %>%
#'     mutate(sepal = rowMeans(across(starts_with("Sepal"))))
#'
#'   # but then we can lay other functions, e.g. median
#'   iris %>%
#'     mutate(sepal = lay(across(starts_with("Sepal")), median))
#'
#'   # or lay into a tibble if you want multiple results
#'   iris %>%
#'     mutate(sepal = lay(
#'       across(starts_with("Sepal")),
#'       ~tibble(min = min(.), mean = mean(.), max = max(.))
#'     ))
#'
#'   # and if you skip `sepal =` things get auto spliced for you
#'   iris %>%
#'     mutate(lay(
#'       across(starts_with("Sepal")),
#'       ~tibble(min = min(.), mean = mean(.), max = max(.))
#'     ))
#' }
#'
#' @export
lay <- function(.data, fn) {
  fn <- as_function(fn)
  bits <- pmap(.data, function(...) {
    fn(vec_c(...))
  })
  vec_c(!!!bits)
}
