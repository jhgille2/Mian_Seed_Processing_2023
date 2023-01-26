#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param yield
#' @param nir
#' @param twt
merge_all_data <- function(yield = cleaned_yield_files, nir =
                           cleaned_nir_files, twt = cleaned_test_weight) {
  
  yield %<>%
    mutate(loc = toupper(loc))
  
  # Convert rep to a character in the nir data to match the data type in the yield data
  nir %<>%
    mutate(rep = as.character(rep), 
           loc = toupper(loc))
  
  twt %<>%
    mutate(plot = as.numeric(plot), 
           loc = toupper(loc),
           twt_kg_hl = twt_weight * 1.287, 
           twt_13_pct = 4.955 + (0.2*twt_moisture) + (0.898*twt_kg_hl))

  # Join all the data using shared ID columns
  merged_data <- left_join(yield, nir, by = c("test", "loc", "code", "plot", "rep", "year", "genotype")) %>% 
    left_join(., twt, by = c("test", "plot", "loc", "year")) %>% 
    distinct()
  
  return(merged_data)

}
