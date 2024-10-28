# Liz Bageant
# September 30, 2024




#------ STATE LEVEL -----------------------------------------------------------#

# bring in state level data
births <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/state_birth_rates.csv")

# bring in national level data for comparison
births_national <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/SPDYNCBRTINUSA.csv") 
births_national$DATE <- ymd(births_national$DATE)
births_national <- births_national %>% 
  mutate(year = year(DATE),
         br_crude = SPDYNCBRTINUSA) %>% 
  select(year, br_crude) %>% 
  mutate(group = "USA")


# Plot Idaho birth rates (per 1000 women age 15-44) over time--line graph
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

# Plot crude birth rate (per 1000 people) over time--line graph
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


# Put national and state crude rate on same graph
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

# Mapping birth rates

# Bring in county map and select only Idaho counties
d <- us_map("counties") %>% 
  filter(abbr == "ID")

# bring in Idaho birth rates (calculated using IDHW and PEP data)
births_county <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/county_birth_rates.csv")

# combine data files
data <- left_join(d, births_county, by = "county") %>% 
  mutate(centroid = st_centroid(geom),
         br = round(br, digits = 0))


# Map birth rates by county and year
loop_values <- 2014:2023

for (i in loop_values) {
  data %>% 
    st_transform('EPSG:3082') %>% 
    filter(year == i) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = br)) +
    geom_sf_text(aes(label = br, geometry = centroid), colour = "#003333", size = 3) +
    #scale_fill_viridis(name = "Birth rate \n(per 1000 people)") +
    scale_fill_paletteer_c("grDevices::Tropic", name = "Births \nper 1000 women\nage 15-44", limits=c(30, 115)) +
    #scale_fill_paletteer_c("ggthemes::Blue-Green Sequential") +
    theme_void() +
    ggtitle(paste("Birth rate by county:", i)) +
    labs(caption = "Data source: Idaho Department of Health and Welfare")
    
    ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/maps", paste("fertility_map_",i,".png", sep = ""), dpi = 320) 
}


# Map birth rate CHANGE between 2014 and 2023 by county
data %>% 
  filter(year == c(2014, 2023)) %>% 
  select(county, br, year, geom, centroid) %>% 
  pivot_wider(names_from = year, values_from = br) %>% 
  mutate(Change = round(((`2023`-`2014`)/`2014`)*100)) %>% 
  st_transform('EPSG:3082') %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = Change)) +
  geom_sf_text(aes(label = Change, geometry = centroid), colour = "#003333", size = 3) +
  scale_fill_paletteer_c("grDevices::Tropic", name = "Percent change \nin births per 1000 \nwomen age 15-44", limits=c(-100, 100)) +
  theme_void() +
  ggtitle("Percent change in birth rates from 2014-2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/maps", "change_in_birth_rate_2014-2023.png",dpi = 320)
  
  


# Line graphs of individual counties over time
countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")
for (i in countynames) {
  births_county %>% 
    filter(county == i) %>% 
    ggplot(aes(x = year, y = br, color = county)) +
    geom_line(size = 2, color = "#006666") + 
    geom_point(size = 4, color = "#006666") +  
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

