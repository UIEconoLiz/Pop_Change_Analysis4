## Liz Bageant
## September 25, 2024

## Graph and map birth rates for Idaho


# import data

births <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/state_birth_rates.csv")
births_county <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/county_birth_rates.csv")
births_national <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/SPDYNCBRTINUSA.csv") 
births_national$DATE <- ymd(births_national$DATE)
births_national <- births_national %>% 
  mutate(year = year(DATE),
         br_crude = SPDYNCBRTINUSA) %>% 
  select(year, br_crude) %>% 
  mutate(group = "USA")
  

countymap <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/county_map_data.csv")

#------ STATE LEVEL -----------------------------------------------------------#

births %>% 
  ggplot(aes(x = year, y = br)) +
  geom_line(size = 2, color = "#D44D5CFF") + 
  geom_point(size = 4, color = "#D44D5CFF") +  
theme_liz() +
  scale_color_paletteer_d("PrettyCols::Bright", direction = -1) +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2014, 2023), breaks = c(2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits=c(10,100),
                     labels = label_comma()) + 
  ylab("Births per 1000 women age 15-44") +
  ggtitle("Idaho births per 1000 women age 15-44: 2014-2023") 

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/", "state_birth_rates.png", dpi = 320) 


births %>% 
  ggplot(aes(x = year, y = br_crude)) +
  geom_line(size = 2, color = "#D44D5CFF") + 
  geom_point(size = 4, color = "#D44D5CFF") +  
  theme_liz() +
  scale_color_paletteer_d("PrettyCols::Bright", direction = -1) +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2014, 2023), breaks = c(2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits=c(10, 25), labels = label_comma()) + 
  ylab("Births per 1000 people") +
  ggtitle("Idaho births per 1000 people: 2014-2023") 

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/", "state_birth_rates_crude.png", dpi = 320) 


# put national and state crude rate on same graph
births %>% 
  select(year, br_crude) %>% 
  mutate(group = "Idaho") %>% 
  rbind(births_national) %>% 
  ggplot(aes(x = year, y = br_crude, group = group, color = group)) +
  geom_line(size = 2) +
  geom_point(size = 3) +  
  scale_color_paletteer_d("PrettyCols::Bright") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(1960, 2023), breaks = c(1960, 1970, 1980, 1990, 2000, 2010, 2020)) +
  scale_y_continuous(limits=c(10, 25), labels = label_comma()) + 
  ylab("Births per 1000 people") +
  ggtitle("Births per 1000 people: 1960-2023") +
  labs(caption = "
       Data sources: Idaho rates calculated from IDHW births and Census population estimates. National rates obtained from World Bank (via FRED databse).")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/", "Idaho_USA_birth_rate_crude.png", dpi = 320) 



#------ COUNTY LEVEL ----------------------------------------------------------#

# combine
mapdata <- births_county %>% 
  left_join(countymap, join_by(county), relationship = "many-to-many")

dim(mapdata)
dim(births_county)
dim(countymap)

# map crude birth rate: all years
ggplot(mapdata, aes(x = long, y = lat, group = county)) +
  geom_polygon(aes(fill = br_crude), color = "white") +
  scale_fill_viridis(name = "Birth rate \n(per 1000 people)") +
  theme_void() + 
  theme(legend.position = c(0.8, 0.7),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank()) +
  coord_map("mercator")  +
  ggtitle("Crude birth rate by county: 2014-2023")


# map birth rate: all years
ggplot(mapdata, aes(x = long, y = lat, group = county)) +
  geom_polygon(aes(fill = br), color = "white") +
  scale_fill_viridis(name = "Birth rate \n(per 1000 women age 15-44)") +
  theme_void() + 
  theme(legend.position = c(0.8, 0.7),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank()) +
  coord_map("mercator")  +
  ggtitle("Birth rate per 1000 women age 15-44 by county: 2014-2023")


# Map counties individually

loop_values <- 2014:2023

for (i in loop_values) {
  mapdata %>% 
  filter(year == i) %>%
  ggplot(aes(x = long, y = lat, group = county)) +
    geom_polygon(aes(fill = br), color = "white") +
    scale_fill_viridis(name = "Birth rate \n(per 1000 women age 15-44)",  limits=c(25, 125)) +
    theme_void() + 
    theme(legend.position = c(0.8, 0.7),
          axis.text.x = element_blank(), 
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          rect = element_blank()) +
    coord_map("mercator")  +
    ggtitle(paste("Birth rate per 1000 women age 15-44 by county: ", i))
  
  ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/maps", paste("fertility_map_",i,".png", sep = ""), dpi = 320) 
  
  }
  
  
# Line graphs of individual counties over time
countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")
for (i in countynames) {
births_county %>% 
    filter(county == i) %>% 
  ggplot(aes(x = year, y = br, color = county)) +
    geom_line(size = 2, color = "#D44D5CFF") + 
    geom_point(size = 4, color = "#D44D5CFF") +  
    theme_liz() +
    scale_x_continuous(limits = c(2014, 2023), breaks = c(2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  #scale_color_viridis() +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
    ylim(25, 125) +
    ylab("Births") +
    ggtitle(paste("Birth rate per 1000 women age 15-44:", i))
  
  ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/line", paste("births ",i,".png", sep = ""), dpi = 320) 
  
}


# Examine county-level birth rates in 2023
a <- births_county %>% 
  filter(year == 2023) 
  

