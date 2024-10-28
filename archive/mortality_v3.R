# Liz Bageant
# September 30, 2024

# Updating mortality maps with new method



#------ STATE LEVEL -----------------------------------------------------------#

mstate <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/idaho_deaths_by_sex_2014-2023.csv")


mstate %>% 
  ggplot(aes(x = year, y = death_rate)) +
  geom_line(size = 2, color = "#462255FF") + 
  geom_point(size = 4, color = "#462255FF") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2014, 2023), 
                     breaks = c(2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(7, 10)) +
  ggtitle("Idaho death rate: 2014-2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare") +
  xlab("") +
  ylab("Deaths per 1000 people")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality", "state_deaths_line.png", dpi = 320) 



#------ COUNTY LEVEL ----------------------------------------------------------#


# Bring in county map and select only Idaho counties
map <- us_map("counties") %>% 
  filter(abbr == "ID")

# bring in Idaho death rates (from IDHW)
mcounty <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/death_by_county_2014-2023.csv")

# combine data files
data <- left_join(map, mcounty, by = "county") %>% 
  mutate(centroid = st_centroid(geom),
         dr = round(death_rate, digits = 0))


# Map death rates by county and year
loop_values <- 2014:2023

for (i in loop_values) {
  data %>% 
    st_transform('EPSG:3082') %>% 
    filter(year == i) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = dr)) +
    geom_sf_text(aes(label = dr, geometry = centroid), colour = "#003333", size = 3) +
    #scale_fill_paletteer_c("harrypotter::lunalovegood", name = "Deaths \nper 1000 people", limits=c(3, 21)) +
    scale_fill_paletteer_c("grDevices::Lajolla", name = "Deaths \nper 1000 people", limits=c(3, 21)) +
    #scale_fill_paletteer_c("ggthemes::Blue-Green Sequential") +
    theme_void() +
    ggtitle(paste("Death rate by county:", i)) +
    labs(caption = "Data source: Idaho Department of Health and Welfare")
  
  ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/maps", paste("mortality_map_",i,".png", sep = ""), dpi = 320) 
}


# Counties with the highest death rates by year
top5_2014 <- mort %>% 
  filter(year == 2014) %>% 
  slice_max(death_rate, n = 5) 

top5_2015 <- mort %>% 
  filter(year == 2015) %>% 
  slice_max(death_rate, n = 5) 

top5_2016 <- mort %>% 
  filter(year == 2016) %>% 
  slice_max(death_rate, n = 5) 

top5_2017 <- mort %>% 
  filter(year == 2017) %>% 
  slice_max(death_rate, n = 5) 

top5_2018 <- mort %>% 
  filter(year == 2018) %>% 
  slice_max(death_rate, n = 5) 

top5_2019 <- mort %>% 
  filter(year == 2019) %>% 
  slice_max(death_rate, n = 5) 

top5_2020 <- mort %>% 
  filter(year == 2020) %>% 
  slice_max(death_rate, n = 5) 

top5_2020 <- mort %>% 
  filter(year == 2020) %>% 
  slice_max(death_rate, n = 5) 

top5_2021 <- mort %>% 
  filter(year == 2021) %>% 
  slice_max(death_rate, n = 5) 

top5_2022 <- mort %>% 
  filter(year == 2022) %>% 
  slice_max(death_rate, n = 5) 

top5_2023 <- mort %>% 
  filter(year == 2023) %>% 
  slice_max(death_rate, n = 5) 

top5 <- top5_2014 %>% 
  rbind(top5_2015,
        top5_2016,
        top5_2017,
        top5_2018,
        top5_2019,
        top5_2020,
        top5_2021,
        top5_2022,
        top5_2023) 

last10years <- top5 %>% 
  group_by(county) %>% 
  summarise(n())

write.csv(top5, "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/top5.csv")
write.csv(last10yearstop, "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/last10years.csv")


# Counties with the lowest death rates by year
bottom5_2014 <- mort %>% 
  filter(year == 2014) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2015 <- mort %>% 
  filter(year == 2015) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2016 <- mort %>% 
  filter(year == 2016) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2017 <- mort %>% 
  filter(year == 2017) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2018 <- mort %>% 
  filter(year == 2018) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2019 <- mort %>% 
  filter(year == 2019) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2020 <- mort %>% 
  filter(year == 2020) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2020 <- mort %>% 
  filter(year == 2020) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2021 <- mort %>% 
  filter(year == 2021) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2022 <- mort %>% 
  filter(year == 2022) %>% 
  slice_min(death_rate, n = 5) 

bottom5_2023 <- mort %>% 
  filter(year == 2023) %>% 
  slice_min(death_rate, n = 5) 

bottom5 <- bottom5_2014 %>% 
  rbind(bottom5_2015,
        bottom5_2016,
        bottom5_2017,
        bottom5_2018,
        bottom5_2019,
        bottom5_2020,
        bottom5_2021,
        bottom5_2022,
        bottom5_2023) 

last10yearsbottom <- bottom5 %>% 
  group_by(county) %>% 
  summarise(n())

write.csv(bottom5, "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/bottom5.csv")
write.csv(last10yearsbottom, "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/last10yearsbottom.csv")







