#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param errors_checked
make_missing_report <- function(errors_checked, outdir = here("exports", "missing_data_report.xlsx")) {

  error_summary_table <- errors_checked %>% 
    select(test, loc, pheno, reps_to_measure, missing_pct, missing_count)
  
  missing_data_table <- errors_checked %>%
    select(test, loc, pheno, missing_observations) %>% 
    unnest(missing_observations)
  
  wb <- createWorkbook()
  
  addWorksheet(wb, "Missing data counts")
  addWorksheet(wb, "Missing observations")
  
  writeDataTable(wb, "Missing data counts", error_summary_table)
  writeDataTable(wb, "Missing observations", missing_data_table)
  
  saveWorkbook(wb, file = outdir, overwrite = TRUE)
  
  return(outdir)

}
