## Liz Bageant
## August 15, 2024

## Creating population pyramids for Idaho

############ PEP annual estimates ##############################################

pep_county <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/age_and_sex/age_5yearbins_county.csv") %>% 
  select(ctyname, year, contains("age"), -contains("median"), -contains("_tot")) %>% 
  filter(year != "2010c" & year != "2010b" & year != "2020b") %>% 
  pivot_longer(cols = starts_with("age"), 
               names_to = c("agecat", "sex"),
               names_sep = "_", 
               values_to = "pop")  

pep_state <- pep_county %>% 
  pivot_wider(names_from = sex, 
  values_from = pop) %>% 
  rename(male, mpop = male) %>% 
  rename(fem, fpop = fem) %>% 
  group_by(agecat, year) %>% 
  summarize(
    mpop = sum(mpop), 
    fpop = sum(fpop)) %>% 
  pivot_longer(cols = c(mpop, fpop), 
               values_to = "pop", 
               names_to = "sex")
  

pep_county$agecat <- factor(pep_county$agecat, order = TRUE, levels = c("age04", "age59", "age1014", "age1519", "age2024", "age2529", "age3034", "age3539", "age4044", "age4549", "age5054", "age5559", "age6064", "age6569", "age7074", "age7579", "age8084", "age85plus"))
pep_state$agecat <- factor(pep_state$agecat, order = TRUE, levels = c("age04", "age59", "age1014", "age1519", "age2024", "age2529", "age3034", "age3539", "age4044", "age4549", "age5054", "age5559", "age6064", "age6569", "age7074", "age7579", "age8084", "age85plus"))

# Select 2023 and pivot data to long form
# data <- pep_state %>% 
#   filter(year == "2023") %>% 
#   select(mpop, fpop, agecat) %>% 
#   pivot_longer(
#     cols = !agecat , 
#     names_to = "sex",
#     values_to = "pop"
#   ) 

# plot
ylabels <- c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years and over")
pep_state %>% 
  filter(year == "2022") %>% 
  ggplot(aes(x = agecat, 
             fill = sex, 
             y = ifelse(
               test = sex == "mpop", 
               yes = -pop, 
               no = pop))) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = abs) +
  scale_x_discrete(labels = ylabels) +
  coord_flip() +
  theme_minimal() +
  labs(x = "Age group",
       y = "Estimated population",
       title = "Idaho population structure 2022 (PEP)") 
 



############ 2010 ACS 5 Year Estimates #########################################

# read in 2010 ACS data for Idaho
acs2010 <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids/idaho_pop_by_agesex_acs5year_2010.csv")

# factor the age categories
acs2010$cats <-  factor(acs2010$age_group, order = TRUE, levels = c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years and over"))
levels(cats) 

# pivot data to long form
data <- acs2010 %>% 
  select(mpop, fpop, cats) %>% 
  pivot_longer(
    cols = !cats, 
    names_to = "gender",
    values_to = "pop"
  ) 

# plot
basic_plot <- ggplot(data, 
                     aes(x = cats,
                         fill = gender,
                         y = ifelse(
                           test = gender == "mpop",
                           yes = -pop,
                           no = pop
                         )
                         )
                    ) +
  geom_bar(stat = "identity")

pyr2010 <- basic_plot +
  scale_y_continuous(
    labels = abs) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age group", 
    y = "Estimated population", 
    title = "Idaho population structure 2010"
  )

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids", "pyr2010.png", dpi = 320) 

  
############ 2022 ACS 5 Year Estimates #########################################

acs2022 <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids/idaho_pop_by_agesex_acs5year_2022.csv")

# factor the age categories
acs2022$cats <-  factor(acs2010$age_group, order = TRUE, levels = c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years and over"))
levels(cats) 

# pivot data to long form
data <- acs2022 %>% 
  select(mpop, fpop, cats) %>% 
  pivot_longer(
    cols = !cats, 
    names_to = "gender",
    values_to = "pop")

# plot
basic_plot <- ggplot(data, 
                     aes(x = cats,
                         fill = gender,
                         y = ifelse(
                           test = gender == "mpop",
                           yes = -pop,
                           no = pop
                         )
                     )
) +
  geom_bar(stat = "identity")

pyr2022 <- basic_plot +
  scale_y_continuous(
    labels = abs) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age group", 
    y = "Estimated population", 
    title = "Idaho population structure 2022 (ACS 5 year)"
  )

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids", "pyr2022.png", dpi = 320) 


############ 2000 Census Counts #########################################

census2000 <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids/idaho_pop_by_agesex_census_2000.csv")

# factor the age categories
census2000$cats <-  factor(census2000$age_group, order = TRUE, levels = c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years and over"))
levels(cats) 

# data are already in long form
# plot
basic_plot <- ggplot(census2000, 
                     aes(x = cats,
                         fill = gender,
                         y = ifelse(
                           test = gender == "mpop",
                           yes = -censuspop_2000,
                           no = censuspop_2000
                         )
                     )
  ) +
  geom_bar(stat = "identity")

pyr2000 <- basic_plot +
  scale_y_continuous(
    labels = abs) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age group", 
    y = "Census population", 
    title = "Idaho population structure 2000"
  )

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids", "pyr2000.png", dpi = 320) 


############ 1990 Census Counts #########################################

census1990 <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids/idaho_pop_by_agesex_census_1990.csv")

# factor the age categories
census1990$cats <-  factor(census1990$age_group, order = TRUE, levels = c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years"))
levels(cats) 


# plot
basic_plot <- ggplot(census1990, 
                     aes(x = cats,
                         fill = gender,
                         y = ifelse(
                           test = gender == "mpop",
                           yes = -censuspop_1990,
                           no = censuspop_1990
                         )
                     )
) +
  geom_bar(stat = "identity")

pyr1990 <- basic_plot +
  scale_y_continuous(
    labels = abs) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age group", 
    y = "Census population", 
    title = "Idaho population structure 1990"
  )

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids", "pyr1990.png", dpi = 320) 


############ 1980 Census Counts #########################################

census1980 <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids/idaho_pop_by_agesex_census_1980.csv")

# factor the age categories
census1980$cats <-  factor(census1980$age_group, order = TRUE, levels = c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years"))
levels(cats) 


# plot
basic_plot <- ggplot(census1980, 
                     aes(x = cats,
                         fill = gender,
                         y = ifelse(
                           test = gender == "mpop",
                           yes = -censuspop_1980,
                           no = censuspop_1980
                         )
                     )
) +
  geom_bar(stat = "identity")

pyr1990 <- basic_plot +
  scale_y_continuous(
    labels = abs) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age group", 
    y = "Census population", 
    title = "Idaho population structure 1980"
  )

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/pop_pyramids", "pyr1980.png", dpi = 320) 


