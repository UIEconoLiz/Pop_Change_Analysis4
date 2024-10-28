## Liz Bageant
## September 20, 2024

## Visualize mortality data


# import data

idahomort <- read.csv(paste(datapath, "deaths_idaho_2014-2023.csv", sep = ""))
mort <- read.csv(paste(datapath, "death_by_county_2014-2023.csv", sep = ""))

#countymap <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/county_map_data.csv")

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

ggsave(path = outputpath, "deaths/deaths_state_line.png", dpi = 320) 




#------ COUNTY LEVEL ----------------------------------------------------------#


# MAPS

# Bring in county map and select only Idaho counties
d <- us_map("counties") %>% 
  filter(abbr == "ID")

# combine with mortality data files
data <- left_join(d, mort, by = "county") %>% 
  mutate(centroid = st_centroid(geom),
         death_rate = round(death_rate, digits = 0))

# map: all years
data %>% 
  mutate(bins = cut(death_rate, breaks = c(min(death_rate), 6, 9, 12, 15, max(death_rate)), include.lowest = TRUE),
         county = str_remove(county, " County")) %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = bins)) +
  geom_sf_text(aes(label = county, geometry = centroid), color = "#003333", size = 2) +
  coord_sf(crs = 4269) +
  scale_fill_manual(values = c("#70A494FF", "#B4C8A8FF", "#F6EDBDFF", "#EDBB8AFF", "#DE8A5AFF"), # inspired by rcartocolor::Geyser
                    labels=c("3-6", "7-9", "10-12", "13-15", "16-18"),
                    name = "Deaths per 1000 people") + 
  guides(fill = guide_legend(reverse=TRUE)) +
  theme_void() +
  theme(legend.position = c(.77, .65)) +
  ggtitle("Death rate by county: 2014-2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = outputpath, "deaths/death_rate_idaho_2014-2023.png", dpi = 320, width = 5, height = 8) 


# Map year-by-year

loop_values <- 2014:2023

for (i in loop_values) {
  data %>% 
    mutate(bins = cut(death_rate, breaks = c(min(death_rate), 6, 9, 12, 15, max(death_rate)), include.lowest = TRUE),
           county = str_remove(county, " County")) %>% 
    filter(year == i) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = bins)) +
    geom_sf_text(aes(label = county, geometry = centroid), color = "#003333", size = 2) +
    coord_sf(crs = 4269) +
    scale_fill_manual(values = c("#70A494FF", "#B4C8A8FF", "#F6EDBDFF", "#EDBB8AFF", "#DE8A5AFF"), # inspired by rcartocolor::Geyser
                      labels=c("3-6", "7-9", "10-12", "13-15", "16-18"),
                      name = "Deaths per 1000 people") + 
    guides(fill = guide_legend(reverse=TRUE)) +
    theme_void() +
    theme(legend.position = c(.77, .65)) +
    ggtitle(paste("Death rate by county:", i)) +
    labs(caption = "Data source: Idaho Department of Health and Welfare")
  
  ggsave(path = outputpath, paste("deaths/maps/death_rate_", i, ".png", sep = ""), dpi = 320, width = 5, height = 8) 
  
  }

# Map death rate CHANGE between 2014 and 2023
data %>% 
  filter(year == c(2014, 2023)) %>% 
  select(county, death_rate, year, geom, centroid) %>% 
  pivot_wider(names_from = year, values_from = death_rate) %>% 
  mutate(Change = round(((`2023`-`2014`)/`2014`)*100), 
         bins = cut(Change, breaks = c(min(Change), 0, 20, 40, 60, 80, max(Change)), include.lowest = TRUE),
         county = str_remove(county, " County")) %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = bins))+
  geom_sf_text(aes(label = county, geometry = centroid), colour = "#003333", size = 2) +
  coord_sf(crs = 4269) +
  #scale_fill_paletteer_c("grDevices::Tropic", name = "Percent change \nin births per 1000 \nwomen age 15-44", limits=c(-100, 100)) +
  scale_fill_manual(values = c("#B4C8A8FF","#FFFFE0", "#F6EDBDFF", "#EDBB8AFF", "#DE8A5AFF", "#CA562CFF"), # inspired by rcartocolor::Geyser
                    labels=c("0%-20% decrease", "1%-20% increase", "21%-40% increase", "41%-60% increase", "61%-80% increase", "80% increase or more"),
                    name = "Percent change") + 
  guides(fill = guide_legend(reverse=TRUE)) +
  theme_void() +
  theme(legend.position = c(.77, .65)) +
  ggtitle("Percent change in death rates from 2014 to 2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = outputpath, "deaths/death_rate_change_2014-2023.png", dpi = 320, width = 5, height = 8)




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


countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")
for (i in countynames) {
  mort %>% 
    filter(county == i) %>% 
    ggplot(aes(x = year, y = death_rate, color = county)) +
    geom_line(size = 2, color = "#006666") + 
    geom_point(size = 4, color = "#006666") +  
    theme_liz() +
    scale_x_continuous(limits = c(2014, 2023), breaks = c(2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    theme(axis.text.x = element_text(angle = 45), 
          plot.caption=element_text(hjust = 0),
          legend.position="bottom", 
          legend.justification.bottom = "left", 
          legend.title = element_blank(), 
          legend.text = element_text(size = 12)) +
    ylim(0, 20) +
    ylab("Deaths per 1000 people") +
    ggtitle(paste("Death rate per 1000 people:", i))
  
  ggsave(path = outputpath, paste("deaths/line/deaths ",i,".png", sep = ""), dpi = 320, width = 7, height = 5) 
}



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

#write.csv(top5, "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/top5.csv")
#write.csv(last10yearstop, "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/last10years.csv")
write.csv(top5, paste(outputpath, "deaths/top5.csv", sep = ""))
write.csv(last10years, paste(outputpath, "deaths/last10yearstop.csv", sep = ""))


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

write.csv(bottom5, paste(outputpath, "deaths/bottom5.csv", sep = ""))
write.csv(last10yearsbottom, paste(outputpath, "deaths/last10yearsbottom.csv", sep = ""))

