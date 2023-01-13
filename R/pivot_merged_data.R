#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param merged_data
pivot_merged_data <- function(merged_data) {
  
  # Phenotype variables
  pheno_vars <- c("ht", 
                  "lod", 
                  "md", 
                  "sq", 
                  "yield", 
                  "sdwt", 
                  "oil_dry_basis", 
                  "protein_dry_basis", 
                  "twt_weight", 
                  "twt_kg_hl", 
                  "twt_13_pct")
  
  # Identification variables
  id_cols <- c("test", 
               "year",
               "loc", 
               "code", 
               "rep", 
               "plot",
               "genotype",
               "nir_no")

  # Pivot the merged data to a long + nested format for easier error checking
  nested_data <- merged_data %>% 
    select(all_of(c(pheno_vars, id_cols))) %>% 
    pivot_longer(cols = all_of(pheno_vars), names_to = "pheno", values_to = "value") %>%
    group_by(test, loc, pheno) %>% 
    nest()
  
  return(nested_data)
}
