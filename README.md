
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="man/figures/logo.png" align="right" height="138" /> **{lay}**

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/lay)](https://CRAN.R-project.org/package=lay)
[![R-CMD-check](https://github.com/courtiol/lay/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/courtiol/lay/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/courtiol/lay/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/courtiol/lay/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

## An R package for simple but efficient rowwise jobs

### Why **{lay}**?

Implementing rowwise operations for tabular data is notoriously awkward
in R.

Many options have been proposed, but they tend to be complicated,
inefficient, or both.

Instead `lay()` – the only function of the package **{lay}** – aims at
reaching a sweet spot between simplicity and efficiency.

The function `lay()` is intended to be used to apply a function on each
row of a data frame or tibble, independently, and across multiple
columns containing values of the same class (e.g. all numeric).

The function has been specifically designed to be combined with
functions from [**{dplyr}**](https://dplyr.tidyverse.org/) and to feel
as if it was part of it (but you can use `lay()` without
[**{dplyr}**](https://dplyr.tidyverse.org/)).

There is hardly any code behind `lay()` (it can be coded in 3 lines), so
this package may just be an interim solution before an established
package fulfils the need… Time will tell.

### Installation

You can install a development version of **{lay}** with:

``` r
# install.packages("remotes")
remotes::install_github("courtiol/lay")
```

### Motivation

Consider the following dataset, which contains information about the use
of pain relievers for non medical purpose.

``` r
library(lay)  ## requires to have installed {lay}
drugs
#> # A tibble: 100 × 8
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int>
#>  1 1            0       0       0       0       0       0       0
#>  2 2            0       0       0       0       0       0       0
#>  3 3            0       0       0       0       0       0       0
#>  4 4            0       0       0       0       0       0       0
#>  5 5            0       0       0       0       0       0       0
#>  6 6            0       0       0       0       0       0       0
#>  7 7            0       0       0       0       0       0       0
#>  8 8            0       0       0       0       0       0       0
#>  9 9            0       0       0       0       0       0       1
#> 10 10           0       0       0       0       0       0       0
#> # ℹ 90 more rows
```

The dataset is [tidy](https://vita.had.co.nz/papers/tidy-data.pdf): each
row represents one individual and each variable forms a column.

Imagine now that you would like to know if each individual did use any
of these pain relievers.

How would you proceed?

### Our solution: `lay()`

This is how you would achieve our goal using `lay()`:

``` r
library(dplyr, warn.conflicts = FALSE)  ## requires to have installed {dplyr}

drugs_full |>
  mutate(everused = lay(pick(-caseid), any))
#> # A tibble: 55,271 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 55,261 more rows
```

We used `mutate()` from [**{dplyr}**](https://dplyr.tidyverse.org/) to
create a new column called *everused*, and we used `pick()` from that
same package to remove the column *caseid* when laying down each row of
the data and applying the function `any()`.

When combining `lay()` and [**{dplyr}**](https://dplyr.tidyverse.org/),
you should always use `pick()` or `across()`. The functions `pick()` and
`across()` let you pick among many [selection
helpers](https://tidyselect.r-lib.org/reference/language.html) from the
package [**{tidyselect}**](https://tidyselect.r-lib.org/), which makes
it easy to specify which columns to consider.

Our function `lay()` is quite flexible! For example, you can pass
argument(s) of the function you wish to apply rowwise (here `any()`):

``` r
drugs_with_NA <- drugs     ## create a copy of the dataset
drugs_with_NA[1, 2] <- NA  ## introduce a missing value

drugs_with_NA |>
  mutate(everused = lay(pick(-caseid), any)) |> ## without additional argument
  slice(1)  ## keep first row only
#> # A tibble: 1 × 9
#>   caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>   <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#> 1 1           NA       0       0       0       0       0       0 NA
  
drugs_with_NA |>
  mutate(everused = lay(pick(-caseid), any, na.rm = TRUE)) |>  ## with additional argument
  slice(1)
#> # A tibble: 1 × 9
#>   caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>   <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#> 1 1           NA       0       0       0       0       0       0 FALSE
```

Since one of the backbones of `lay()` is
[**{rlang}**](https://rlang.r-lib.org), you can use the so-called
[*lambda* syntax](https://rlang.r-lib.org/reference/as_function.html) to
define anonymous functions on the fly:

``` r
drugs_with_NA |>
 mutate(everused = lay(pick(-caseid), ~ any(.x, na.rm = TRUE))) ## same as above, different syntax
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1           NA       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

We can also apply many functions at once, as exemplified with another
dataset:

``` r
data("world_bank_pop", package = "tidyr")  ## requires to have installed {tidyr}

world_bank_pop |>
  filter(indicator == "SP.POP.TOTL") |>
  mutate(lay(pick(matches("\\d")),
             ~ tibble(min = min(.x), mean = mean(.x), max = max(.x))), .after = indicator)
#> # A tibble: 266 × 23
#>    country indicator        min   mean    max `2000` `2001` `2002` `2003` `2004`
#>    <chr>   <chr>          <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#>  1 ABW     SP.POP.TOTL   8.91e4 9.81e4 1.05e5 8.91e4 9.07e4 9.18e4 9.27e4 9.35e4
#>  2 AFE     SP.POP.TOTL   4.02e8 5.08e8 6.33e8 4.02e8 4.12e8 4.23e8 4.34e8 4.45e8
#>  3 AFG     SP.POP.TOTL   1.95e7 2.73e7 3.56e7 1.95e7 1.97e7 2.10e7 2.26e7 2.36e7
#>  4 AFW     SP.POP.TOTL   2.70e8 3.45e8 4.31e8 2.70e8 2.77e8 2.85e8 2.93e8 3.01e8
#>  5 AGO     SP.POP.TOTL   1.64e7 2.26e7 3.02e7 1.64e7 1.69e7 1.75e7 1.81e7 1.88e7
#>  6 ALB     SP.POP.TOTL   2.87e6 2.96e6 3.09e6 3.09e6 3.06e6 3.05e6 3.04e6 3.03e6
#>  7 AND     SP.POP.TOTL   6.61e4 7.32e4 8.02e4 6.61e4 6.78e4 7.08e4 7.39e4 7.69e4
#>  8 ARB     SP.POP.TOTL   2.87e8 3.52e8 4.24e8 2.87e8 2.94e8 3.00e8 3.07e8 3.13e8
#>  9 ARE     SP.POP.TOTL   3.28e6 6.58e6 9.07e6 3.28e6 3.45e6 3.63e6 3.81e6 3.99e6
#> 10 ARG     SP.POP.TOTL   3.71e7 4.05e7 4.40e7 3.71e7 3.75e7 3.79e7 3.83e7 3.87e7
#> # ℹ 256 more rows
#> # ℹ 13 more variables: `2005` <dbl>, `2006` <dbl>, `2007` <dbl>, `2008` <dbl>,
#> #   `2009` <dbl>, `2010` <dbl>, `2011` <dbl>, `2012` <dbl>, `2013` <dbl>,
#> #   `2014` <dbl>, `2015` <dbl>, `2016` <dbl>, `2017` <dbl>
```

Since the other backbone of `lay()` is
[**{vctrs}**](https://vctrs.r-lib.org), the splicing happens
automatically (unless the output of the call is used to create a named
column). This is why, in the last chunk of code, three different columns
(*min*, *mean* and *max*) where directly created.

**Important:** when using `lay()` the function you want to use for the
rowwise job must output a scalar (vector of length 1), or a tibble or
data frame with a single row.

We can apply a function that returns a vector of length \> 1 by turning
such vector into a tibble using `as_tibble_row()` from
[**{tibble}**](https://tibble.tidyverse.org/):

``` r
world_bank_pop |>
  filter(indicator == "SP.POP.TOTL") |>
  mutate(lay(pick(matches("\\d")),
             ~ as_tibble_row(quantile(.x, na.rm = TRUE))), .after = indicator)
#> # A tibble: 266 × 25
#>    country indicator       `0%`  `25%`  `50%`  `75%` `100%` `2000` `2001` `2002`
#>    <chr>   <chr>          <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#>  1 ABW     SP.POP.TOTL   8.91e4 9.38e4 9.86e4 1.03e5 1.05e5 8.91e4 9.07e4 9.18e4
#>  2 AFE     SP.POP.TOTL   4.02e8 4.48e8 5.03e8 5.64e8 6.33e8 4.02e8 4.12e8 4.23e8
#>  3 AFG     SP.POP.TOTL   1.95e7 2.38e7 2.69e7 3.13e7 3.56e7 1.95e7 1.97e7 2.10e7
#>  4 AFW     SP.POP.TOTL   2.70e8 3.03e8 3.42e8 3.85e8 4.31e8 2.70e8 2.77e8 2.85e8
#>  5 AGO     SP.POP.TOTL   1.64e7 1.89e7 2.21e7 2.59e7 3.02e7 1.64e7 1.69e7 1.75e7
#>  6 ALB     SP.POP.TOTL   2.87e6 2.90e6 2.94e6 3.02e6 3.09e6 3.09e6 3.06e6 3.05e6
#>  7 AND     SP.POP.TOTL   6.61e4 7.11e4 7.21e4 7.55e4 8.02e4 6.61e4 6.78e4 7.08e4
#>  8 ARB     SP.POP.TOTL   2.87e8 3.15e8 3.51e8 3.87e8 4.24e8 2.87e8 2.94e8 3.00e8
#>  9 ARE     SP.POP.TOTL   3.28e6 4.07e6 7.49e6 8.73e6 9.07e6 3.28e6 3.45e6 3.63e6
#> 10 ARG     SP.POP.TOTL   3.71e7 3.88e7 4.05e7 4.21e7 4.40e7 3.71e7 3.75e7 3.79e7
#> # ℹ 256 more rows
#> # ℹ 15 more variables: `2003` <dbl>, `2004` <dbl>, `2005` <dbl>, `2006` <dbl>,
#> #   `2007` <dbl>, `2008` <dbl>, `2009` <dbl>, `2010` <dbl>, `2011` <dbl>,
#> #   `2012` <dbl>, `2013` <dbl>, `2014` <dbl>, `2015` <dbl>, `2016` <dbl>,
#> #   `2017` <dbl>
```

### Alternatives to `lay()`

Of course, there are many alternatives to perform rowwise jobs.

Let’s now consider, in turns, these alternatives – sticking to our
example about drugs usage.

#### Alternative 1: vectorized solution

One solution is to simply do the following:

``` r
drugs_full |>
  mutate(everused = codeine | hydrocd | methdon | morphin | oxycodp | tramadl | vicolor)
#> # A tibble: 55,271 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 55,261 more rows
```

It is certainly very efficient from a computational point of view, but
coding this way presents two main limitations:

- you need to name all columns explicitly, which can be problematic when
  dealing with many columns
- you are stuck with expressing your task with logical and arithmetic
  operators, which is not always sufficient

#### Alternative 2: 100% [**{dplyr}**](https://dplyr.tidyverse.org/)

``` r
drugs |>
  rowwise() |>
  mutate(everused = any(c_across(-caseid))) |>
  ungroup()
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

It is easy to use as `c_across()` turns its input into a vector and
`rowwise()` implies that the vector only represents one row at a time.
Yet, for now it remains quite slow on large datasets (see **Efficiency**
below).

#### Alternative 3: [**{tidyr}**](https://tidyr.tidyverse.org/)

``` r
library(tidyr)  ## requires to have installed {tidyr}

drugs |>
  pivot_longer(-caseid) |>
  group_by(caseid) |>
  mutate(everused = any(value)) |>
  ungroup() |>
  pivot_wider() |>
  relocate(everused, .after = last_col())
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

Here the trick is to turn the rowwise problem into a column problem by
pivoting the values and then pivoting the results back. Many find that
this involves a little too much intellectual gymnastic. It is also not
particularly efficient on large dataset both in terms of computation
time and memory required to pivot the tables.

#### Alternative 4: [**{purrr}**](https://purrr.tidyverse.org/)

``` r
library(purrr)  ## requires to have installed {purrr}

drugs |>
  mutate(everused = pmap_lgl(pick(-caseid), ~ any(...)))
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

This is a perfectly fine solution and actually part of what one
implementation of `lay()` relies on (if `.method = "tidy"`), but from a
user perspective it is a little too geeky-scary.

#### Alternative 5: [**{slider}**](https://slider.r-lib.org/)

``` r
library(slider)   ## requires to have installed {slider}

drugs |>
  mutate(everused = slide_vec(pick(-caseid), any))
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

The package [**{slider}**](https://slider.r-lib.org/) is a powerful
package which provides several *sliding window* functions. It can be
used to perform rowwise operations and is quite similar to **{lay}** in
terms syntax. It is however not as efficient as **{lay}** and I am not
sure it supports the automatic splicing demonstrated above.

#### Alternative 6: [**{data.table}**](https://rdatatable.gitlab.io/data.table/)

``` r
library(data.table)  ## requires to have installed {data.table}

drugs_dt <- data.table(drugs)

drugs_dt[, ..I := .I]
drugs_dt[, everused := any(.SD), by = ..I, .SDcols = -"caseid"]
drugs_dt[, ..I := NULL]
as_tibble(drugs_dt)
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

This is a solution for those using
[**{data.table}**](https://rdatatable.gitlab.io/data.table/). It is not
particularly efficient, nor particularly easy to remember for those who
do not program frequently using
[**{data.table}**](https://rdatatable.gitlab.io/data.table/).

#### Alternative 7: `apply()`

``` r
drugs |>
  mutate(everused = apply(pick(-caseid), 1L, any))
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

This is the base R solution. Very efficient and actually part of the
default method used in `lay()`. Our implementation of `lay()` strips the
need of defining the margin (the `1L` above) and benefits from the
automatic splicing and the lambda syntax as shown above.

#### Alternative 8: `for (i in ...) {...}`

``` r
drugs$everused <- NA

columns_in <- !colnames(drugs) %in% c("caseid", "everused")

for (i in seq_len(nrow(drugs))) {
  drugs$everused[i] <- any(drugs[i, columns_in])
}

drugs
#> # A tibble: 100 × 9
#>    caseid hydrocd oxycodp codeine tramadl morphin methdon vicolor everused
#>    <chr>    <int>   <int>   <int>   <int>   <int>   <int>   <int> <lgl>   
#>  1 1            0       0       0       0       0       0       0 FALSE   
#>  2 2            0       0       0       0       0       0       0 FALSE   
#>  3 3            0       0       0       0       0       0       0 FALSE   
#>  4 4            0       0       0       0       0       0       0 FALSE   
#>  5 5            0       0       0       0       0       0       0 FALSE   
#>  6 6            0       0       0       0       0       0       0 FALSE   
#>  7 7            0       0       0       0       0       0       0 FALSE   
#>  8 8            0       0       0       0       0       0       0 FALSE   
#>  9 9            0       0       0       0       0       0       1 TRUE    
#> 10 10           0       0       0       0       0       0       0 FALSE   
#> # ℹ 90 more rows
```

This is another base R solution, which does not involve any external
package. It is not very pretty, nor particularly efficient.

#### Other alternatives?

There are probably other ways. If you think of a nice one, please leave
an issue and we will add it here!

### Efficiency

Here are the results of a benchmark comparing alternative
implementations for our simple rowwise job on a larger dataset with 8
columns and 55271 rows (see
[benchmark](https://courtiol.github.io/lay/articles/benchmark.html) for
details and more tests):

<img src="man/figures/bench_run1-1.png" width="70%" style="display: block; margin: auto;" />

Note that the x-axis of the plot is on a logarithmic scale.

As you can see, `lay()` is not just simple and powerful, it is also
quite efficient!

### History

<img src="https://github.com/courtiol/lay/raw/main/.github/pics/lay_history.png" alt="lay_history" align="right" width="400">

The first draft of this package has been created by **@romainfrancois**
as a reply to a tweet I posted under **@rdataberlin** in February 2020.
At the time I was exploring different ways to perform rowwise jobs in R
and I was experimenting with various ideas on how to exploit the fact
that the newly introduced function `across()` from
[**{dplyr}**](https://dplyr.tidyverse.org/) creates tibbles on which on
can easily apply a function. Romain came up with `lay()` as the better
solution making good use of [**{rlang}**](https://rlang.r-lib.org/) &
[**{vctrs}**](https://vctrs.r-lib.org/).

The verb `lay()` never made it to be integrated within
[**{dplyr}**](https://dplyr.tidyverse.org/) and, so far, I still find
`lay()` superior than most alternatives, which is why I decided to
maintain this package.

In short, I deserve little credit and instead you should feel free to
buy Romain a coffee [here](https://ko-fi.com/romain) or to sponsor his
[github profile](https://github.com/romainfrancois).
