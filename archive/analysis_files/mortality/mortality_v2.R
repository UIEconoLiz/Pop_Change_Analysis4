## Liz Bageant
## September 20, 2024

## Visualize mortality data


# import data

idahomort <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/idaho_deaths_2014-2023.csv")
mort <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/death_by_county_2014-2023.csv")

countymap <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/county_map_data.csv")

#------ STATE LEVEL -----------------------------------------------------------#

idahomort %>% 
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
# combine
mapdata <- mort %>% 
  left_join(countymap, join_by(county), relationship = "many-to-many")

# map: all years
ggplot(mapdata, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = death_rate), color = "white") +
  scale_fill_viridis(name = "Death rate \n(per 1000 people)",  limits=c(2, 19)) +
  theme_void() + 
  theme(legend.position = c(0.8, 0.7),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank()) +
  coord_map("mercator")  +
  ggtitle("Death rate by county: 2014-2023")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/maps/", "IDAHO.png", dpi = 320) 


# map: loop over years

loop_values <- 2014:2023

for (i in loop_values) {
mapdata %>% 
    filter(year == i) %>%
    ggplot(aes(x = long, y = lat, group = group)) +
    geom_polygon(aes(fill = death_rate), color = "white") +
    scale_fill_viridis(name = "Death rate \n(per 1000 people)",  limits=c(2, 19)) +
    theme_void() + 
    theme(legend.position = c(0.8, 0.7),
          axis.text.x = element_blank(), 
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          rect = element_blank()) +
    coord_map("mercator")  +
    ggtitle(paste("Death rate by county:", i))
    
  ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/maps", paste("mortality_map_",i,".png", sep = ""), dpi = 320) 
}


# plot county-level mortality rates over time

mort %>% 
  ggplot(aes(x = year, y = death_rate, color = county)) +
  geom_line() +
  theme_liz() +
  #scale_color_viridis() +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) 
  # not very effective
  
# counties with the highest death rates by year
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




# county and number of years (out of 10) in top 5 death rates
# 1 Benewah County        6
# 2 Butte County          2
# 3 Clearwater County     6
# 4 Gem County            4
# 5 Idaho County          1
# 6 Lemhi County          8
# 7 Lewis County          6
# 8 Nez Perce County      3
# 9 Shoshone County      10
# 10 Washington County    4



# counties with the lowest death rates by year

top5_2014 <- mort %>% 
  filter(year == 2014) %>% 
  slice_min(death_rate, n = 5) 
top5_2015 <- mort %>% 
  filter(year == 2015) %>% 
  slice_min(death_rate, n = 5) 
top5_2016 <- mort %>% 
  filter(year == 2016) %>% 
  slice_min(death_rate, n = 5) 
top5_2017 <- mort %>% 
  filter(year == 2017) %>% 
  slice_min(death_rate, n = 5) 
top5_2018 <- mort %>% 
  filter(year == 2018) %>% 
  slice_min(death_rate, n = 5) 
top5_2019 <- mort %>% 
  filter(year == 2019) %>% 
  slice_min(death_rate, n = 5) 
top5_2020 <- mort %>% 
  filter(year == 2020) %>% 
  slice_min(death_rate, n = 5) 
top5_2020 <- mort %>% 
  filter(year == 2020) %>% 
  slice_min(death_rate, n = 5) 
top5_2021 <- mort %>% 
  filter(year == 2021) %>% 
  slice_min(death_rate, n = 5) 
top5_2022 <- mort %>% 
  filter(year == 2022) %>% 
  slice_min(death_rate, n = 5) 
top5_2023 <- mort %>% 
  filter(year == 2023) %>% 
  slice_min(death_rate, n = 5) 
bottom5 <- top5_2014 %>% 
  rbind(top5_2015,
        top5_2016,
        top5_2017,
        top5_2018,
        top5_2019,
        top5_2020,
        top5_2021,
        top5_2022,
        top5_2023) 

bottom5 %>% 
  group_by(county) %>% 
  summarise(n())

# county and number of years (out of 10) in bottom 5
# 1 Blaine County        8
# 2 Camas County         5
# 3 Clark County         3
# 4 Jefferson County     3
# 5 Latah County         7
# 6 Lincoln County       4
# 7 Madison County      10
# 8 Teton County        10
  
