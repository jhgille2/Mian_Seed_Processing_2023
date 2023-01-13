#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param cleaned_lead_sheets
clean_data_to_collect <- function(cleaned_lead_sheets) {

  # Get the "data to collect table
  data_to_collect <- cleaned_lead_sheets %>% 
    pluck("Merged tables", "Data to collect")
  
  # First, correct the protein/oil parts of the table so that there
  # are different groups for protein and oil
  just_po <- data_to_collect %>% 
    dplyr::filter(trait == "protein/oil")
  
  new_po <- tibble(trait           = rep(c("protein_dry_basis", "oil_dry_basis"), nrow(just_po)), 
                   reps_to_measure = rep(just_po$reps_to_measure, each = 2), 
                   test_name       = rep(just_po$test_name, each = 2))
  
  no_po <- data_to_collect %>% 
    dplyr::filter(trait != "protein/oil")
  
  back_together <- bind_rows(no_po, new_po) %>% 
    arrange(test_name, trait) %>% 
    mutate(trait = recode(trait, lodging = "lod", height = "ht", maturity = "md", "seed quality" = "sq"))
  
  # Add a test weight column
  twt_tbl <- tibble(trait = rep(c("twt_weight", "twt_kg_hl", "twt_13_pct"), length(unique(back_together$test_name))), 
                    reps_to_measure = 3, 
                    test_name = rep(unique(back_together$test_name), 3))
  
  and_it_feels_so_good <- bind_rows(back_together, twt_tbl) %>% 
    mutate(test_name = str_remove(test_name, "2022 "), 
           test_name = recode(test_name, "LU 5 Early" = "LU 5E"))
  
  return(and_it_feels_so_good)
}
