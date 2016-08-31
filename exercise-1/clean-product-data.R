library(dplyr)
library(tidyr)

products <- read.csv("refine_original.csv", header = TRUE)
products_tbl <- tbl_df(products)

# Clean up brand names
products_tbl <- products_tbl %>%
  mutate(company = tolower(company)) %>%
  mutate(company = gsub("^[pf].*", "philips", company)) %>%
  mutate(company = gsub("^a.*", "akzo", company)) %>%
  mutate(company = gsub("^v.*", "van houten", company)) %>%
  mutate(company = gsub("^u.*", "unilever", company))

# Separate product code & number
products_tbl <- products_tbl %>%
  separate(`Product.code...number`, c("product_code", "product_number"), "-")

# Add product categories
products_tbl <- products_tbl %>%
  mutate(category = product_code) %>%
  mutate(category = gsub("p", "Smartphone", category)) %>%
  mutate(category = gsub("v", "TV", category)) %>%
  mutate(category = gsub("x", "Laptop", category)) %>%
  mutate(category = gsub("q", "Tablet", category))

# Add full address
products_tbl <- products_tbl %>% unite(full_address, address:country, sep = ", ")

# Add company binary variables
products_tbl <- products_tbl %>%
  mutate(company_philips = ifelse(company == "philips", 1, 0),
         company_akzo = ifelse(company == "akzo", 1, 0),
         company_van_houten = ifelse(company == "van houten", 1, 0),
         company_unilever = ifelse(company == "unilever", 1, 0))

# Add product binary variables
products_tbl <- products_tbl %>%
  mutate(product_smartphone = ifelse(category == "Smartphone", 1, 0),
         product_tv = ifelse(category == "TV", 1, 0),
         product_laptop = ifelse(category == "Laptop", 1, 0),
         product_tablet = ifelse(category == "Tablet", 1, 0))

# Write data to a new csv
write.table(products_tbl, "refine_clean.csv", sep = ", ", col.names = TRUE)
