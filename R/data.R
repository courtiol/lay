#' Pain relievers misuse in the US
#'
#' A dataset containing information about the use of pain relievers for non medical purpose.
#'
#' This dataset is a small subset from the "National Survey on Drug Use and Health, 2014".
#' All variables related to drug use have been recoded into vectors of integers talking value 0 for
#' "No/Unknown" and value 1 for "Yes". The original variable names were the same as those defined
#' here but in upper case and ending with the number 2.
#'
#' @format A tibble with 55271 rows and 9 variables:
#' \describe{
#'   \item{caseid}{The identifier code of the respondent}
#'   \item{hydrocd}{Ever use hydrocodone nonmedically?}
#'   \item{oxycodp}{Ever use ever percocet, percodan, tylox, oxycontin... nonmedically?}
#'   \item{codeine}{Ever used codeine nonmedically?}
#'   \item{tramadl}{Ever used tramadol nonmedically?}
#'   \item{morphin}{Ever used morphine nonmedically?}
#'   \item{methdon}{Ever used methadone nonmedically?}
#'   \item{demerol}{Ever used demerol nonmedically?}
#'   \item{vicolor}{Ever used vicodin, lortab or lorcert nonmedically?}
#' }
#' @source \url{https://www.icpsr.umich.edu/web/NAHDAP/studies/36361}
#' @references United States Department of Health and Human Services.
#'     Substance Abuse and Mental Health Services Administration.
#'     Center for Behavioral Health Statistics and Quality.
#'     National Survey on Drug Use and Health, 2014.
#'     Ann Arbor, MI: Inter-university Consortium for Political and Social Research (distributor), 2016-03-22.
#'     \url{https://doi.org/10.3886/ICPSR36361.v1}
#' @examples
#' drugs
"drugs"