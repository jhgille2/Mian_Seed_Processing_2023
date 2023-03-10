##################################################
## Project: 2023 Mian seed processing
## Script purpose: Utility functions
## Date: 2023-01-13
## Author: Jay Gillenwater
##################################################

# A function that takes a conversion table with an "old name" inn the first column
# and the name that it should be recoded to in the second column, and takes
# this table to recode a given variable in some dataframe
convert_from_table <- function(data, var, conversiontable){
  
  all_matches   <- match(unlist(data[, var]), unlist(conversiontable[, 1]))
  match_indices <- which(!is.na(all_matches))
  
  new_var <- as.character(unlist(data[, var]))
  
  new_var[match_indices] <- unlist(conversiontable[, 2])[all_matches[match_indices]]
  
  data[, var] <- new_var
  
  return(data)
}

# Function to handle the particular duplicated test weight values for this year
remove_duplicated_test_weight <- function(cleaned_test_weight){
  
  cleaned_test_weight %>% 
    dplyr::filter(!(test == "LU 5E" & loc == "CAS" & plot == 83 & twt_moisture == 7.5)) %>% 
    group_by(test, loc, plot) %>% 
    sample_n(1) %>% 
    ungroup() %>% 
    mutate(test = ifelse(test == "LU 5L" & loc == "PLY", "LU 5L-2", test)) 
  
}
