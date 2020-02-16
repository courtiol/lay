
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lay

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/lay)](https://CRAN.R-project.org/package=lay)
[![R build
status](https://github.com/romainfrancois/lay/workflows/R-CMD-check/badge.svg)](https://github.com/romainfrancois/lay)
<!-- badges: end -->

## Installation

You can install a development version of `lay` with:

``` r
# install.packages("remotes")
remotes::install_github("romainfrancois/lay")
```

## Example

``` r
library(lay)
library(dplyr, warn.conflicts = FALSE)

iris <- as_tibble(iris)

# apply mean to each "row"
iris %>% 
  mutate(sepal = lay(across(starts_with("Sepal")), mean))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species sepal
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa   4.3 
#>  2          4.9         3            1.4         0.2 setosa   3.95
#>  3          4.7         3.2          1.3         0.2 setosa   3.95
#>  4          4.6         3.1          1.5         0.2 setosa   3.85
#>  5          5           3.6          1.4         0.2 setosa   4.3 
#>  6          5.4         3.9          1.7         0.4 setosa   4.65
#>  7          4.6         3.4          1.4         0.3 setosa   4   
#>  8          5           3.4          1.5         0.2 setosa   4.2 
#>  9          4.4         2.9          1.4         0.2 setosa   3.65
#> 10          4.9         3.1          1.5         0.1 setosa   4   
#> # … with 140 more rows

# this is not really needed as we have base::rowMeans
iris %>% 
  mutate(sepal = rowMeans(across(starts_with("Sepal"))))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species sepal
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa   4.3 
#>  2          4.9         3            1.4         0.2 setosa   3.95
#>  3          4.7         3.2          1.3         0.2 setosa   3.95
#>  4          4.6         3.1          1.5         0.2 setosa   3.85
#>  5          5           3.6          1.4         0.2 setosa   4.3 
#>  6          5.4         3.9          1.7         0.4 setosa   4.65
#>  7          4.6         3.4          1.4         0.3 setosa   4   
#>  8          5           3.4          1.5         0.2 setosa   4.2 
#>  9          4.4         2.9          1.4         0.2 setosa   3.65
#> 10          4.9         3.1          1.5         0.1 setosa   4   
#> # … with 140 more rows

# but then you can lay(median)
iris %>% 
  mutate(sepal = lay(across(starts_with("Sepal")), median))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species sepal
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa   4.3 
#>  2          4.9         3            1.4         0.2 setosa   3.95
#>  3          4.7         3.2          1.3         0.2 setosa   3.95
#>  4          4.6         3.1          1.5         0.2 setosa   3.85
#>  5          5           3.6          1.4         0.2 setosa   4.3 
#>  6          5.4         3.9          1.7         0.4 setosa   4.65
#>  7          4.6         3.4          1.4         0.3 setosa   4   
#>  8          5           3.4          1.5         0.2 setosa   4.2 
#>  9          4.4         2.9          1.4         0.2 setosa   3.65
#> 10          4.9         3.1          1.5         0.1 setosa   4   
#> # … with 140 more rows

# or lay into a tibble if you want multiple results
iris %>% 
  mutate(sepal = lay(
    across(starts_with("Sepal")), 
    ~tibble(min = min(.), mean = mean(.), max = max(.))
  ))
#> # A tibble: 150 x 6
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species sepal$min
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>       <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa        3.5
#>  2          4.9         3            1.4         0.2 setosa        3  
#>  3          4.7         3.2          1.3         0.2 setosa        3.2
#>  4          4.6         3.1          1.5         0.2 setosa        3.1
#>  5          5           3.6          1.4         0.2 setosa        3.6
#>  6          5.4         3.9          1.7         0.4 setosa        3.9
#>  7          4.6         3.4          1.4         0.3 setosa        3.4
#>  8          5           3.4          1.5         0.2 setosa        3.4
#>  9          4.4         2.9          1.4         0.2 setosa        2.9
#> 10          4.9         3.1          1.5         0.1 setosa        3.1
#> # … with 140 more rows, and 2 more variables: $mean <dbl>, $max <dbl>

# and if you skip `sepal =` things get auto spliced for you
iris %>% 
  mutate(lay(
    across(starts_with("Sepal")), 
    ~tibble(min = min(.), mean = mean(.), max = max(.))
  ))
#> # A tibble: 150 x 8
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   min  mean
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl> <dbl>
#>  1          5.1         3.5          1.4         0.2 setosa    3.5  4.3 
#>  2          4.9         3            1.4         0.2 setosa    3    3.95
#>  3          4.7         3.2          1.3         0.2 setosa    3.2  3.95
#>  4          4.6         3.1          1.5         0.2 setosa    3.1  3.85
#>  5          5           3.6          1.4         0.2 setosa    3.6  4.3 
#>  6          5.4         3.9          1.7         0.4 setosa    3.9  4.65
#>  7          4.6         3.4          1.4         0.3 setosa    3.4  4   
#>  8          5           3.4          1.5         0.2 setosa    3.4  4.2 
#>  9          4.4         2.9          1.4         0.2 setosa    2.9  3.65
#> 10          4.9         3.1          1.5         0.1 setosa    3.1  4   
#> # … with 140 more rows, and 1 more variable: max <dbl>
```
