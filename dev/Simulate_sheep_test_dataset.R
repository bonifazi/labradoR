# 0. Install and load libs ------------------------------------------------
# install latest version
# install.packages("C:/Users/bonif002/Downloads/MoBPS_1.11.81.tar.gz", repos = NULL, type = "source")
library(MoBPS)


# 1. Simulate sheep data ----------------------------------------------
# From https://www.mobps.de/home, download the JSON of "Simple Sheep Advanced".
population <- json.simulation(file = "C:/Users/bonif002/OneDrive/labradoR_simulation/Simple Sheep Advanced.json")

# 1. extract pedigree and info -----------------------------------------------
pedigree <- unique(get.pedigree(population, gen = 1:get.ngen(population), id = TRUE))
pedigree_info <- unique(get.pedigree(population, gen = 1:get.ngen(population), raw = TRUE))

# get info on time point in simulation
time <- numeric(nrow(pedigree))
for (index in 1:nrow(pedigree)) {
  print(index)
  time[index] <- get.time.point(population, database = get.database(population, id = pedigree[index, 1]))
}

# 2. Wrangle data ---------------------------------------------------------
sheep_merged <- cbind(pedigree, time) %>%
  as.data.frame() %>%
  mutate(
    YOB = paste0(2004 + time, "-01-01") # assign a birth date based on the time point
  ) %>%
  left_join(pedigree_info %>% as.data.frame() %>%
    select(
      offspring = offspring.nr,
      sex = offspring.sex
    )) %>%
  mutate(sex = if_else(sex == 1, "M", "F")) %>%
  rename(ID = offspring, sire = father, dam = mother, sex = sex, birthdate = YOB) %>%
  # exclude early time points
  filter(time > 0)

dim(sheep_merged)
head(sheep_merged)
sheep_merged %>% count(birthdate, time, sex)

# assign sex
sheep_merged <- sheep_merged %>%
  distinct() %>%
  rowwise() %>%
  mutate(sex = case_when(
    !is.na(sex) ~ sex, # keep assigned sex if existent
    ID %in% sheep_merged$sire ~ "M",
    ID %in% sheep_merged$dam  ~ "F",
    TRUE ~ sample(c("M", "F"), size = 1, replace = TRUE) # Randomly assign M or F only if still NA
    )
  ) %>%
  ungroup()

sheep_merged %>% count(birthdate, time, sex)

# 3. Save output to disk --------------------------------------------------
write.table(sheep_merged,
  "C:/Users/bonif002/OneDrive/labradoR_simulation/Retriever/www/upload/sheep_ped.txt",
  sep = ";",
  quote = F,
  row.names = F
)

# 4. Run Retriever .exe --------------------------------------------------
# 4.1 move in Retriever.exe dir
setwd("C:/Users/bonif002/OneDrive/labradoR_simulation/Retriever/www/")

# run once in Dutch to create a test file, copy the output and then
# run again as English

# 4.2 Create the .ini file
# Create the content for the inbreedingmonitor.ini file
inbreedingmonitor_content <- c(
  "Sheep simple JSON",   # name of run
  "upload/sheep_ped.txt", # name of pedigree file
  ";",                   # delimiter
  "n",
  "yyyy-mm-dd",          # date of birth format
  "rund",
  "M",                   # sex code for males
  "nl",                  # output language
  "y",
  "0",
  "0"
)

for (lang in c("nl", "en")) {
  # Update the language in the content
  inbreedingmonitor_content[8] <- lang

  # 4.3 write to disk
  writeLines(inbreedingmonitor_content, "inbreedingmonitor.ini")

  # 4.4 call .exe
  # system("inteeltmonitor007.exe")
  system("inteeltmonitor.exe")
  # take copy of nl one
  if(lang == "nl") {
    file.copy(from = "upload/sheep_ped.out", to = "upload/sheep_ped_nl.out", overwrite = TRUE)
  }
  rm(lang)
}
list.files("upload")

# copy files for testing in /tests
file.copy(from = "upload/sheep_ped_nl.out", to = "C:/Rpkgs/packages_development/labradoR/tests/", overwrite = TRUE)
file.copy(from = "upload/sheep_ped.out",    to = "C:/Rpkgs/packages_development/labradoR/tests/", overwrite = TRUE)

# 5. Collect output and create the report check --------------------------------
# move to the documentation directory
setwd("C:/Rpkgs/packages_development/labradoR/doc")
library(rmarkdown)

# Create the report folder if it doesn't exist
# if (!dir.exists("report")) {
#   dir.create("report")
# }

# 6. Render the R Markdown report into the 'report' folder
rmarkdown::render(
  "Create_report_sheep_example.Rmd",
  output_file = "Create_report_sheep_example",
  params = list(
    input_file = "C:/Users/bonif002/OneDrive/labradoR_simulation/Retriever/www/upload/sheep_ped.out",
    language = "ENG"
    )
)

#### END -----------------------------------------------------------------------
