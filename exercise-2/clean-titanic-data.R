library(dplyr)

passengers <- read.csv("titanic_original.csv", header = TRUE,
                       stringsAsFactors=FALSE)
passengers_tbl <- tbl_df(passengers)

# Set NA embarked value as S
passengers_tbl <- passengers_tbl %>%
  mutate(embarked = replace(embarked, is.na(embarked) | embarked == "", "S"))

# Set NA age as the mean age
passengers_tbl <- passengers_tbl %>%
  mutate(age = replace(age, is.na(age) | age == "", mean(age, na.rm=TRUE)))

# Set empty boat column to NA
passengers_tbl <- passengers_tbl %>%
  mutate(boat = replace(boat, boat == "", "NA"))

# Add has_cabin_number
passengers_tbl <- passengers_tbl %>%
  mutate(has_cabin_number = ifelse(cabin != "", 1, 0))

# Write data to a new csv
write.table(passengers_tbl, "titanic_clean.csv", sep = ", ", col.names = TRUE)
