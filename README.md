
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lay

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/lay)](https://CRAN.R-project.org/package=lay)
[![R build
status](https://github.com/courtiol/lay/workflows/R-CMD-check/badge.svg)](https://github.com/courtiol/lay)
<!-- badges: end -->

## Why laying down?

To come.

## Installation

You can install a development version of `lay` with:

``` r
# install.packages("remotes")
remotes::install_github("courtiol/lay")
```

## Examples

``` r
library(lay)
library(dplyr, warn.conflicts = FALSE)

iris <- as_tibble(iris)

# apply mean for each row
iris %>%
  mutate(Sepal.Mean = lay(across(starts_with("Sepal")), mean))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Mean
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>        <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa        4.3 
#>  2          4.9         3            1.4         0.2 setosa        3.95
#>  3          4.7         3.2          1.3         0.2 setosa        3.95
#>  4          4.6         3.1          1.5         0.2 setosa        3.85
#>  5          5           3.6          1.4         0.2 setosa        4.3 
#>  6          5.4         3.9          1.7         0.4 setosa        4.65
#>  7          4.6         3.4          1.4         0.3 setosa        4   
#>  8          5           3.4          1.5         0.2 setosa        4.2 
#>  9          4.4         2.9          1.4         0.2 setosa        3.65
#> 10          4.9         3.1          1.5         0.1 setosa        4   
#> # … with 140 more rows

# not that useful because there is `rowMeans` already
iris %>%
  mutate(Sepal.Mean = rowMeans(across(starts_with("Sepal"))))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Mean
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>        <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa        4.3 
#>  2          4.9         3            1.4         0.2 setosa        3.95
#>  3          4.7         3.2          1.3         0.2 setosa        3.95
#>  4          4.6         3.1          1.5         0.2 setosa        3.85
#>  5          5           3.6          1.4         0.2 setosa        4.3 
#>  6          5.4         3.9          1.7         0.4 setosa        4.65
#>  7          4.6         3.4          1.4         0.3 setosa        4   
#>  8          5           3.4          1.5         0.2 setosa        4.2 
#>  9          4.4         2.9          1.4         0.2 setosa        3.65
#> 10          4.9         3.1          1.5         0.1 setosa        4   
#> # … with 140 more rows

# but then we can lay other functions, e.g. median
iris %>%
  mutate(Sepal.Median = lay(across(starts_with("Sepal")), median))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Median
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>          <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa          4.3 
#>  2          4.9         3            1.4         0.2 setosa          3.95
#>  3          4.7         3.2          1.3         0.2 setosa          3.95
#>  4          4.6         3.1          1.5         0.2 setosa          3.85
#>  5          5           3.6          1.4         0.2 setosa          4.3 
#>  6          5.4         3.9          1.7         0.4 setosa          4.65
#>  7          4.6         3.4          1.4         0.3 setosa          4   
#>  8          5           3.4          1.5         0.2 setosa          4.2 
#>  9          4.4         2.9          1.4         0.2 setosa          3.65
#> 10          4.9         3.1          1.5         0.1 setosa          4   
#> # … with 140 more rows

# you can pass arguments to the function
iris_with_NA <- iris
iris_with_NA[1, 1] <- NA
iris_with_NA %>%
  mutate(Sepal.Mean = lay(across(starts_with("Sepal")), mean))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Mean
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>        <dbl>
#>  1         NA           3.5          1.4         0.2 setosa       NA   
#>  2          4.9         3            1.4         0.2 setosa        3.95
#>  3          4.7         3.2          1.3         0.2 setosa        3.95
#>  4          4.6         3.1          1.5         0.2 setosa        3.85
#>  5          5           3.6          1.4         0.2 setosa        4.3 
#>  6          5.4         3.9          1.7         0.4 setosa        4.65
#>  7          4.6         3.4          1.4         0.3 setosa        4   
#>  8          5           3.4          1.5         0.2 setosa        4.2 
#>  9          4.4         2.9          1.4         0.2 setosa        3.65
#> 10          4.9         3.1          1.5         0.1 setosa        4   
#> # … with 140 more rows
iris_with_NA %>%
  mutate(Sepal.Mean = lay(across(starts_with("Sepal")), mean, na.rm = TRUE))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Mean
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>        <dbl>
#>  1         NA           3.5          1.4         0.2 setosa        3.5 
#>  2          4.9         3            1.4         0.2 setosa        3.95
#>  3          4.7         3.2          1.3         0.2 setosa        3.95
#>  4          4.6         3.1          1.5         0.2 setosa        3.85
#>  5          5           3.6          1.4         0.2 setosa        4.3 
#>  6          5.4         3.9          1.7         0.4 setosa        4.65
#>  7          4.6         3.4          1.4         0.3 setosa        4   
#>  8          5           3.4          1.5         0.2 setosa        4.2 
#>  9          4.4         2.9          1.4         0.2 setosa        3.65
#> 10          4.9         3.1          1.5         0.1 setosa        4   
#> # … with 140 more rows

# you can also lay into a tibble if you want multiple results
iris %>%
  mutate(Sepal.Mean = lay(
    across(starts_with("Sepal")),
    ~ tibble(min = min(.x), mean = mean(.x), max = max(.x))
  ))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Mean$min
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>            <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa             3.5
#>  2          4.9         3            1.4         0.2 setosa             3  
#>  3          4.7         3.2          1.3         0.2 setosa             3.2
#>  4          4.6         3.1          1.5         0.2 setosa             3.1
#>  5          5           3.6          1.4         0.2 setosa             3.6
#>  6          5.4         3.9          1.7         0.4 setosa             3.9
#>  7          4.6         3.4          1.4         0.3 setosa             3.4
#>  8          5           3.4          1.5         0.2 setosa             3.4
#>  9          4.4         2.9          1.4         0.2 setosa             2.9
#> 10          4.9         3.1          1.5         0.1 setosa             3.1
#> # … with 140 more rows, and 2 more variables: $mean <dbl>, $max <dbl>

# the previous example creates a df-column called `Sepal.Mean`,
# which you could unpack with `tidyr::unpack()`, but
# if you skip `Sepal.Mean =` things get auto spliced for you!
iris %>%
  mutate(lay(
    across(starts_with("Sepal")),
    ~ tibble(min = min(.x), mean = mean(.x), max = max(.x))
  ))
#> # A tibble: 150 x 8
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   min  mean   max
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl> <dbl> <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa    3.5  4.3    5.1
#>  2          4.9         3            1.4         0.2 setosa    3    3.95   4.9
#>  3          4.7         3.2          1.3         0.2 setosa    3.2  3.95   4.7
#>  4          4.6         3.1          1.5         0.2 setosa    3.1  3.85   4.6
#>  5          5           3.6          1.4         0.2 setosa    3.6  4.3    5  
#>  6          5.4         3.9          1.7         0.4 setosa    3.9  4.65   5.4
#>  7          4.6         3.4          1.4         0.3 setosa    3.4  4      4.6
#>  8          5           3.4          1.5         0.2 setosa    3.4  4.2    5  
#>  9          4.4         2.9          1.4         0.2 setosa    2.9  3.65   4.4
#> 10          4.9         3.1          1.5         0.1 setosa    3.1  4      4.9
#> # … with 140 more rows

# if your function returns a vector and not a scalar,
# just wrap it up in list (note also the use of the lambda syntax ~ fn(.x) here)
iris %>%
  mutate(Sepal.Quantiles = lay(across(starts_with("Sepal")), ~ list(quantile(.x))))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Quantiles
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <list>         
#>  1          5.1         3.5          1.4         0.2 setosa  <dbl [5]>      
#>  2          4.9         3            1.4         0.2 setosa  <dbl [5]>      
#>  3          4.7         3.2          1.3         0.2 setosa  <dbl [5]>      
#>  4          4.6         3.1          1.5         0.2 setosa  <dbl [5]>      
#>  5          5           3.6          1.4         0.2 setosa  <dbl [5]>      
#>  6          5.4         3.9          1.7         0.4 setosa  <dbl [5]>      
#>  7          4.6         3.4          1.4         0.3 setosa  <dbl [5]>      
#>  8          5           3.4          1.5         0.2 setosa  <dbl [5]>      
#>  9          4.4         2.9          1.4         0.2 setosa  <dbl [5]>      
#> 10          4.9         3.1          1.5         0.1 setosa  <dbl [5]>      
#> # … with 140 more rows

# the previous example creates a list-column called `Sepal.Quantiles`,
# which you could unnest with `tidyr::unnest_wider()`, but
# you can once again rely on a tibble and skip the column name to get the output
# auto spliced for you!
iris %>%
  mutate(lay(across(starts_with("Sepal")), ~ as_tibble_row(quantile(.x))))
#> # A tibble: 150 x 10
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species  `0%` `25%` `50%`
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl> <dbl> <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa    3.5  3.9   4.3 
#>  2          4.9         3            1.4         0.2 setosa    3    3.48  3.95
#>  3          4.7         3.2          1.3         0.2 setosa    3.2  3.58  3.95
#>  4          4.6         3.1          1.5         0.2 setosa    3.1  3.48  3.85
#>  5          5           3.6          1.4         0.2 setosa    3.6  3.95  4.3 
#>  6          5.4         3.9          1.7         0.4 setosa    3.9  4.28  4.65
#>  7          4.6         3.4          1.4         0.3 setosa    3.4  3.7   4   
#>  8          5           3.4          1.5         0.2 setosa    3.4  3.8   4.2 
#>  9          4.4         2.9          1.4         0.2 setosa    2.9  3.28  3.65
#> 10          4.9         3.1          1.5         0.1 setosa    3.1  3.55  4   
#> # … with 140 more rows, and 2 more variables: `75%` <dbl>, `100%` <dbl>
```

## History

<img src="https://github.com/courtiol/lay/raw/master/.github/pics/lay_history.png" alt="lay_history" align="right" width="400">

This package has been created by **@romainfrancois** as a reply to one
of my tweet in February 2020. At the time I was exploring different ways
to perform rowwise jobs in data.frames and I was experimenting with
various ideas on how to exploit the fact that the newly developed
`dplyr::across()` creates tibbles on which on can easily apply a
function. Romain came up with `lay()` as the better solution.

The verb `lay()` never made it to be integrated within {dplyr}. Yet, it
remains to date an efficient solution to the old “rowwise job problem”.
This is why I decided to revive this package and to improve `lay()` a
little further with Romain’s help.

In short, I deserve no credit and instead you should feel free to buy
Romain a coffee [here](https://ko-fi.com/romain) or to sponsor his
[github profile](https://github.com/romainfrancois) as I do.
