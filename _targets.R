## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(

  # Get paths to all the leadsheets, yield/field notes, nir,
  # and test weight files
  tar_target(lead_sheet_files,
             list.files(here("data", "leadsheets"), full.names = TRUE),
             format = "file"),
  
  tar_target(yield_files,
             list.files(here("data", "yield"), full.names = TRUE),
             format = "file"),
  
  tar_target(nir_files,
             list.files(here("data", "nir"), full.names = TRUE),
             format = "file"),
  
  tar_target(test_weight_files,
             list.files(here("data", "test_weight"), full.names = TRUE),
             format = "file"),
  
  tar_target(nir_masterfile, 
             here("data", "NIR_masterfile_2022.xlsx"), 
             format = "file"), 
  
  tar_target(twt_name_conversion_file, 
             here("data", "test_weight_test_name_conversion.xlsx"), 
             format = "file"),
  
  # Clean up the leadsheets, yield, nir, and test weight files
  tar_target(yield_nir_masterfile, 
             read_excel(nir_masterfile, sheet = 2) %>% 
               janitor::clean_names()),
  
  tar_target(twt_name_conversion, 
             read_excel(twt_name_conversion_file)),
  
  tar_target(cleaned_lead_sheets,
             clean_lead_sheets(lead_sheet_files)),
  
  tar_target(cleaned_yield_files,
             clean_yield_files(yield_files) %>% 
               dplyr::filter(!is.na(test))),
  
  tar_target(cleaned_nir_files,
             clean_nir_files(files = nir_files, nir_masterfile = yield_nir_masterfile) %>% 
               mutate(oil_13_pct = oil_dry_basis*0.87, 
                      protein_13_pct = protein_dry_basis*0.87)),
  
  tar_target(cleaned_test_weight,
             clean_test_weight(test_weight_files) %>% 
               convert_from_table("test", twt_name_conversion)),
  
  # Modify the "data to collect" part of the leadsheet table so that it can be joined with 
  # the pivoted phenotype data later for error checking
  tar_target(data_to_collect, 
             clean_data_to_collect(cleaned_lead_sheets)),
  
  ## Section: Error checking
  ###########################################################################
  
  # Merge yield, nir, and test weight data
  tar_target(merged_data, 
             merge_all_data(yield = cleaned_yield_files,
                            nir = cleaned_nir_files,
                            twt = cleaned_test_weight)),
  
  # Pivot into a long, nested format
  tar_target(pivoted_phenotype_data, 
             pivot_merged_data(merged_data)),
  
  # Error check
  tar_target(errors_checked, 
             check_errors(pivoted_phenotype_data, data_to_collect)),
  
  # Fit models and extract various summary components from the models
  tar_target(model_data, 
             fit_models(errors_checked))
  
  
  
  
  
  

)
