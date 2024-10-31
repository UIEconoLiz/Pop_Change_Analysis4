## Liz Bageant
## August 15, 2024

## Creating population pyramids for Idaho. 
# Currently not plotting at county level due to likely lack of precision. This can be revisited if there is interest.




#---------- PEP 2010-2023 -------------#

pep_county <- read.csv(paste(datapath, "age_5yearbins_county.csv", sep = "")) %>% 
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


# Plot state level
loop_years = 2010:2023
ylabels <- c("Under 5", "5 to 9", "10 to 14", "15 to 19 ", "20 to 24", "25 to 29", "30 to 34", "35 to 39", "40 to 44", "45 to 49", "50 to 54", "55 to 59", "60 to 64", "65 to 69", "70 to 74", "75 to 79", "80 to 84", "85+")

for (i in loop_years) {
  pep_state %>% 
    filter(year == i) %>% 
    ggplot(aes(x = agecat, 
               fill = sex, 
               y = ifelse(
                 test = sex == "mpop", 
                 yes = -pop, 
                 no = pop))) +
    geom_bar(stat = "identity") +
    scale_y_continuous(labels = abs, 
                       limits = c(-80000, 80000),
                       breaks = c(-75000, -50000, -25000, 0, 25000, 50000, 75000)) +
    scale_x_discrete(labels = ylabels) +
    scale_fill_manual(values = c("#f1b300", "#261882"), 
                      labels = c("Female", "Male"), 
                      name = "Sex") +
    coord_flip() +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0)) +
    labs(x = "Age group",
         y = "Estimated population",
         title = paste("Idaho population structure:", i), 
         caption = "Data source: U.S. Census Population Estimates Program Vintage 2019, Vintage 2023")
  
  ggsave(path = outputpath, paste("age/state_",i,".png", sep = ""), dpi = 320, width = 7, height = 7) 
  
 }



#---------- 2000 PEP Estimate -------------#

pep2000 <- read.csv(paste(datapath, "age_sex_pop_pep_2000.csv", sep = ""))

# factor the age categories
pep2000$cats <-  factor(pep2000$age_group, order = TRUE, levels = c("Under 5", "5 to 9", "10 to 14", "15 to 19 ", "20 to 24", "25 to 29", "30 to 34", "35 to 39", "40 to 44", "45 to 49", "50 to 54", "55 to 59", "60 to 64", "65 to 69", "70 to 74", "75 to 79", "80 to 84", "85+"))
levels(pep2000$cats) 

# plot
pep2000 %>% 
  ggplot(aes(x = cats, 
             fill = gender, 
             y = ifelse(
               test = gender == "mpop", 
               yes = -popest_2000, 
               no = popest_2000))) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = abs, 
                     limits = c(-80000, 80000),
                     breaks = c(-75000, -50000, -25000, 0, 25000, 50000, 75000)) +
  scale_x_discrete(labels = ylabels) +
  scale_fill_manual(values = c("#f1b300", "#261882"), 
                    labels = c("Female", "Male"), 
                    name = "Sex") +
  coord_flip() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  labs(x = "Age group",
       y = "Estimated population",
       title = "Idaho population structure: 2000", 
       caption = "Data source: U.S. Census Population Estimates Program")

ggsave(path = outputpath, "age/state_2000.png", dpi = 320, width = 7, height = 7) 

             

#---------- 1990 Decennial Census -------------#

# Using Decennial Census because it is handy, but we can re-do this with PEP estimates for consistency if needed.

census1990 <- read.csv(paste(datapath, "age_sex_pop_pep_1990.csv", sep = ""))

# factor the age categories
census1990$cats <-  factor(census1990$age_group, order = TRUE, levels = c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years"))
levels(census1990$cats) 


# plot
census1990 %>% 
  ggplot(aes(x = cats, 
             fill = gender, 
             y = ifelse(
               test = gender == "mpop", 
               yes = -censuspop_1990, 
               no = censuspop_1990))) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = abs, 
                     limits = c(-80000, 80000),
                     breaks = c(-75000, -50000, -25000, 0, 25000, 50000, 75000)) +
  scale_x_discrete(labels = ylabels) +
  scale_fill_manual(values = c("#f1b300", "#261882"), 
                    labels = c("Female", "Male"), 
                    name = "Sex") +
  coord_flip() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  labs(x = "Age group",
       y = "Estimated population",
       title = "Idaho population structure: 1990", 
       caption = "Data source: U.S. Census Decennial Census")

ggsave(path = outputpath, "age/state_1990.png", dpi = 320, width = 7, height = 7) 


#---------- 1980 Decennial Census -------------#

# Using Decennial Census because it is handy, but we can re-do this with PEP estimates for consistency if needed.

census1980 <- read.csv(paste(datapath, "age_sex_pop_pep_1980.csv", sep = ""))

# factor the age categories
census1980$cats <-  factor(census1980$age_group, order = TRUE, levels = c("Under 5 years", "5 to 9 years", "10 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 29 years", "30 to 34 years", "35 to 39 years", "40 to 44 years", "45 to 49 years", "50 to 54 years", "55 to 59 years", "60 to 64 years", "65 to 69 years", "70 to 74 years", "75 to 79 years", "80 to 84 years", "85 years"))
levels(census1980$cats) 


# plot
census1980 %>% 
  ggplot(aes(x = cats, 
             fill = gender, 
             y = ifelse(
               test = gender == "mpop", 
               yes = -censuspop_1980, 
               no = censuspop_1980))) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = abs, 
                     limits = c(-80000, 80000),
                     breaks = c(-75000, -50000, -25000, 0, 25000, 50000, 75000)) +
  scale_x_discrete(labels = ylabels) +
  scale_fill_manual(values = c("#FCEDCB", "#E5E3F1"), 
                    labels = c("Female", "Male"), 
                    name = "Sex") +
  coord_flip() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  labs(x = "Age group",
       y = "Estimated population",
       title = "Idaho population structure: 1980", 
       caption = "Data source: U.S. Census Decennial Census")

ggsave(path = outputpath, "age/state_1980.png", dpi = 320, width = 7, height = 7) 



examine <- pep_state %>% 
  filter(year == 2023)

