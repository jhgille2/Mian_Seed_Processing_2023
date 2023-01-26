#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pivoted_phenotype_data
#' @param data_to_collect
check_errors <- function(pivoted_phenotype_data, data_to_collect) {

  # A function to filter the data column based on how many reps are expected
  filter_to_expected_reps <- function(data, reps_to_measure){
    dplyr::filter(data, as.numeric(rep) <= reps_to_measure)
  }
  
  expected_reps <- left_join(pivoted_phenotype_data, data_to_collect, by = c("test" = "test_name", 
                                                                             "pheno" = "trait")) %>% 
    mutate(data                 = map2(data, reps_to_measure, filter_to_expected_reps), 
           missing_pct          = map_dbl(data, function(x) sum(is.na(x$value))/nrow(x)), 
           missing_count        = map_dbl(data, function(x) sum(is.na(x$value))),
           missing_observations = map(data, function(x) dplyr::filter(x, is.na(value))))
  
  return(expected_reps)

}
