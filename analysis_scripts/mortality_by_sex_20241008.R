## Liz Bageant
## October 8, 2024


## Mortality rates by sex



#------ STATE LEVEL -----------------------------------------------------------#

# Bring in state level deaths by sex
mstate <- read.csv(paste(datapath, "deaths_idaho_by_sex_2014-2023.csv", sep = ""))

# Bring in Pop Estimates Program population by sex over time and collapse to state level
pep <- read.csv(paste(datapath, "sex_county.csv", sep = "")) %>% 
  group_by(year) %>% 
  summarize(
    fpop = sum(popest_fem),
    mpop = sum(popest_male))

# Plot state level deaths for men and women over time
mstate %>% 
  left_join(pep) %>% 
  mutate(Male = (m_num/mpop)*1000,
         Female = (f_num/fpop)*1000) %>% 
  pivot_longer(cols = contains("ale"),
               names_to = "sex", 
               values_to = "rate") %>% 
  ggplot(aes(x = year, y = rate, group = sex, color = sex)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  scale_color_paletteer_d("PrettyCols::Bright") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2014, 2023), 
                     breaks = c(2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(7, 11)) +
  ggtitle("Idaho death rate by sex: 2014-2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare") +
  xlab("") +
  ylab("Deaths per 1000 people")

ggsave(path = outputpath, "deaths/deaths_by_sex_line.png", dpi = 320) 


#------ COUNTY LEVEL ----------------------------------------------------------#

# Bring in county map and select only Idaho counties
map <- us_map("counties") %>% 
  filter(abbr == "ID")

# bring in IDHW death data by sex
mcounty <- read.csv(paste(datapath, "death_by_county_and_sex_2014-2023.csv", sep = ""))

# Bring in Pop Estimates Program population by sex over time
pep_county <- read.csv(paste(datapath, "sex_county.csv", sep = ""))


# combine all data files and calculate sex-specific death rates
data <- left_join(map, pep_county, by = join_by(county)) %>% 
  left_join(mcounty, by = join_by(county, year)) %>% 
  filter(year >=2014) %>% 
  mutate(centroid = st_centroid(geom),
         frate = round((f_num/popest_fem)*1000),
         mrate = round((m_num/popest_male)*1000))


# Map MALE mortality by year

loop_values <- 2014:2023

for (i in loop_values) {
  data %>% 
    mutate(bins = cut(mrate, breaks = c(min(mrate), 5, 10, 15, 20, max(mrate)), include.lowest = TRUE),
           county = str_remove(county, " County")) %>% 
    filter(year == i) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = bins)) +
    geom_sf_text(aes(label = county, geometry = centroid), color = "#003333", size = 2) +
    coord_sf(crs = 4269) +
    scale_fill_manual(values = c("#70A494FF", "#B4C8A8FF", "#F6EDBDFF", "#EDBB8AFF", "#DE8A5AFF"), # inspired by rcartocolor::Geyser
                      labels=c("3-6", "7-9", "10-12", "13-15", "16-18"),
                      name = "Male deaths \n(per 1000 men)") + 
    guides(fill = guide_legend(reverse=TRUE)) +
    theme_void() +
    theme(legend.position = c(.77, .65)) +
    ggtitle(paste("Male death rate by county:", i)) +
    labs(caption = "Data source: Idaho Department of Health and Welfare")
  
  ggsave(path = outputpath, paste("deaths/sex/male_mortality ", i, ".png", sep = ""), dpi = 320, width = 5, height = 8) 
  
}


# Map FEMALE mortality by year

loop_values <- 2014:2023

for (i in loop_values) {
  data %>% 
    mutate(bins = cut(frate, breaks = c(min(frate), 5, 10, 15, 20, max(frate)), include.lowest = TRUE),
           county = str_remove(county, " County")) %>% 
    filter(year == i) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = bins)) +
    geom_sf_text(aes(label = county, geometry = centroid), color = "#003333", size = 2) +
    coord_sf(crs = 4269) +
    scale_fill_manual(values = c("#70A494FF", "#B4C8A8FF", "#F6EDBDFF", "#EDBB8AFF", "#DE8A5AFF"), # inspired by rcartocolor::Geyser
                      labels=c("3-6", "7-9", "10-12", "13-15", "16-18"),
                      name = "Female deaths \n(per 1000 women)") + 
    guides(fill = guide_legend(reverse=TRUE)) +
    theme_void() +
    theme(legend.position = c(.77, .65)) +
    ggtitle(paste("Female death rate by county:", i)) +
    labs(caption = "Data source: Idaho Department of Health and Welfare")
  
  ggsave(path = outputpath, paste("deaths/sex/female_mortality ", i, ".png", sep = ""), dpi = 320, width = 5, height = 8) 
  
}


# Map change in MALE mortality from 2014-2023
data %>% 
  filter(year == c(2014, 2023)) %>% 
  select(county, mrate, year, geom, centroid) %>% 
  pivot_wider(names_from = year, values_from = mrate) %>% 
  mutate(Change = round(((`2023`-`2014`)/`2014`)*100), 
         bins = cut(Change, breaks = c(min(Change), -25, 0, 25, 50, max(Change)), include.lowest = TRUE),
         county = str_remove(county, " County")) %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = bins))+
  geom_sf_text(aes(label = county, geometry = centroid), colour = "#003333", size = 2) +
  coord_sf(crs = 4269) +
  scale_fill_manual(values = c("#B4C8A8FF", "#F6EDBDFF", "#EDBB8AFF", "#DE8A5AFF", "#CA562CFF"), # inspired by rcartocolor::Geyser
                    labels=c("25%-50% decrease", "0%-25% decrease", "1%-25% increase", "26%-50% increase", "51% increase or more"),
                    name = "Percent change") + 
  guides(fill = guide_legend(reverse=TRUE)) +
  theme_void() +
  theme(legend.position = c(.77, .65)) +
  ggtitle("Percent change in male death rates from 2014 to 2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = outputpath, "deaths/male_deaths_change_2014-2023.png", dpi = 320, width = 5, height = 8)



# Map change in FEMALE mortality from 2014-2023
data %>% 
  filter(year == c(2014, 2023)) %>% 
  select(county, frate, year, geom, centroid) %>% 
  pivot_wider(names_from = year, values_from = frate) %>% 
  mutate(Change = round(((`2023`-`2014`)/`2014`)*100), 
         bins = cut(Change, breaks = c(min(Change), -50, -25, 0, 25, 50, max(Change)), include.lowest = TRUE),
         county = str_remove(county, " County")) %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = bins))+
  geom_sf_text(aes(label = county, geometry = centroid), colour = "#003333", size = 2) +
  coord_sf(crs = 4269) +
  scale_fill_manual(values = c("#70A494FF","#B4C8A8FF", "#F6EDBDFF", "#EDBB8AFF", "#DE8A5AFF", "#CA562CFF"), # inspired by rcartocolor::Geyser
                    labels=c("50% decrease or more","25%-49% decrease", "0%-24% decrease", "1%-25% increase", "26%-50% increase", "51% increase or more"),
                    name = "Percent change") + 
  guides(fill = guide_legend(reverse=TRUE)) +
  theme_void() +
  theme(legend.position = c(.77, .65)) +
  ggtitle("Percent change in female death rates from 2014 to 2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = outputpath, "deaths/female_deaths_change_2014-2023.png", dpi = 320, width = 5, height = 8)

