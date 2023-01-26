#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pivoted_phenotype_data
clean_for_sas <- function(pivoted_phenotype_data) {

  # To make the data ready for SAS, the test data has to be pivoted back to a 
  # wide format, sorted, and the NA values replaced with "."
  wide_pheno_data <- pivoted_phenotype_data %>% 
    unnest(data) %>% 
    pivot_wider(names_from = pheno, values_from = value) %>% 
    rename(yield_grams = yield) %>% 
    select(-c(twt_weight, twt_13_pct)) %>% 
    arrange(test, loc, code, rep) %>% 
    mutate(across(everything(), as.character))
  
  # Replacing NAs with "."
  wide_pheno_data[is.na(wide_pheno_data)] <- "."
  
  # Split by test
  pheno_by_test <- split(wide_pheno_data, wide_pheno_data$test)
  
  # Return the list of split data
  return(pheno_by_test)
}
