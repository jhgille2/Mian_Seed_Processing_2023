#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param sas_prepped
#' @param outdir
export_sas_data <- function(sas_prepped, outdir = here("exports", "sas-ready")) {

  # A function to export the data for a test
  export_sas_ready <- function(test_name, test_data){
    
    # The path to save the file to
    test_file_name <- paste0(test_name, "_SAS_ready.xlsx")
    test_file_path <- here(outdir, test_file_name)
    
    # Make the workbook object
    wb <- createWorkbook()
    
    # Add a named sheet to the table
    addWorksheet(wb, test_name)
    
    # Write the data to the workbook
    writeData(wb, test_name, test_data)
    
    # Save the workbook
    saveWorkbook(wb, test_file_path, overwrite = TRUE)
    
    return(test_file_path)
  }
  
  # Apply this function to each test in the sas_prepped list
  outpaths <- map2_chr(names(sas_prepped), sas_prepped, export_sas_ready)

  # Return the paths to the new files
  return(outpaths)
}
