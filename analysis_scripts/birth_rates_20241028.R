# Liz Bageant
# October 28, 2024

#------ STATE LEVEL fertility rate (per 1k women 15-44) -----------------------#

fert_id <- read.csv(paste(datapath, "natality_idaho.csv", sep = "")) %>% 
  select(year, fertility_rate) %>% 
  mutate(geo = "Idaho")
fert_us <- read.csv(paste(datapath, "natality_national.csv", sep = "")) %>% 
  select(year, fertility_rate) %>% 
  mutate(geo = "US")

fert <- fert_id %>% 
  rbind(fert_us)

fert %>% 
  filter(year >= 2000) %>% 
  ggplot(aes(x = year, y = fertility_rate, group = geo, color = geo)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme_liz() +
  scale_color_manual(values = c("#d7003f", "#261882"), 
                     labels = c("Idaho", "U.S."), 
                     name = "General fertility rate") +
  #scale_y_continuous(limits = c(7, 10.5)) +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  ggtitle("Births per 1000 women age 15-44: Idaho and U.S.") +
  labs(caption = "Data source: CDC WONDER, NCHS") +
  xlab("") +
  ylab("Births per 1000 women age 15-44")


ggsave(path = outputpath, "births/gen_fert_US_ID_CDC.png", dpi = 320, height = 7, width = 13) 


#------ STATE LEVEL--crude birth rate -----------------------------------------#

# bring in state level data
births <- read.csv(paste(datapath, "birth_rates_state.csv", sep = ""))

# bring in national level data for comparison (WorldBank data via FRED--crude birth rate)
births_national <- read.csv(paste(datapath, "births_SPDYNCBRTINUSA.csv", sep = "")) 
births_national$DATE <- ymd(births_national$DATE)
births_national <- births_national %>% 
  mutate(year = year(DATE),
         br_crude = SPDYNCBRTINUSA) %>% 
  select(year, br_crude) %>% 
  mutate(group = "USA")


# Plot Idaho birth rates (per 1000 women age 15-44) over time--line graph
births %>% 
  ggplot(aes(x = year, y = br)) +
  geom_line(size = 2, color = "#d7003f") + 
  geom_point(size = 4, color = "#d7003f") +  
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

ggsave(path = outputpath, "births/state_birth_rates.png", dpi = 320) 

# Plot crude birth rate (per 1000 people) over time--line graph
births %>% 
  ggplot(aes(x = year, y = br_crude)) +
  geom_line(size = 2, color = "#d7003f") + 
  geom_point(size = 4, color = "#d7003f") +  
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

ggsave(path = outputpath, "births/state_birth_rates_crude.png", dpi = 320) 


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

ggsave(path = outputpath, "births/Idaho_USA_birth_rate_crude.png", dpi = 320, height = 5, width = 8) 



#------ COUNTY LEVEL ----------------------------------------------------------#

# Mapping birth rates

# Bring in county map and select only Idaho counties
d <- us_map("counties") %>% 
  filter(abbr == "ID")

# bring in Idaho birth rates (calculated using IDHW and PEP data)
births_county <- read.csv(paste(datapath, "birth_rates_county.csv", sep = ""))

# combine data files
data <- left_join(d, births_county, by = "county") %>% 
  mutate(centroid = st_centroid(geom),
         br = round(br, digits = 0))


# Map birth rates by county and year # THESE MAPS ARE NOT COMPARABLE (BINS AND COLORS ARE NOT CONSISTENT ACROSS ALL YEARS)
loop_values <- c(2014, 2023) # adjust bin color scheme if doing all years. 2014 and 2023 are consistent.

for (i in loop_values) {
  data %>% 
    mutate(bins = cut(br, breaks = c(min(br), 40, 80, 100, max(br))),
           county = str_remove(county, " County")) %>% 
    filter(year == i) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = bins)) +
    geom_sf_text(aes(label = county, geometry = centroid), colour = "#003333", size = 2) +
    coord_sf(crs = 4269) +
    scale_fill_manual(values = c("#09979BFF", "#75D8D5FF", "#FFC0CBFF", "#FE7F9DFF"), # inspired by vapoRwave::macPlus
                      labels=c("20-40", "41-80", "81-100", "100-120"),
                      name = "Birth rate \n(per 1000 women\n age 15-44)") +
    theme_void() +
    theme(legend.position = c(.77, .65)) +
    ggtitle(paste("Birth rate by county:", i)) +
    labs(caption = "Data source: Idaho Department of Health and Welfare")

    ggsave(path = outputpath, paste("births/maps/fertility_map_",i,".png", sep = ""), dpi = 320, width = 5, height = 8) 
}


# Map birth rate CHANGE between 2014 and 2023 by county
data %>% 
  filter(year == c(2014, 2023)) %>% 
  select(county, br, year, geom, centroid) %>% 
  pivot_wider(names_from = year, values_from = br) %>% 
  mutate(Change = round(((`2023`-`2014`)/`2014`)*100),
         bins = cut(Change, breaks = c(min(Change), -25, 0, 25, max(Change)), include.lowest = TRUE),
         county = str_remove(county, " County")) %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = bins))+
  geom_sf_text(aes(label = county, geometry = centroid), colour = "#003333", size = 2) +
  coord_sf(crs = 4269) +
  #scale_fill_paletteer_c("grDevices::Tropic", name = "Percent change \nin births per 1000 \nwomen age 15-44", limits=c(-100, 100)) +
  scale_fill_manual(values = c("#EDBB8AFF", "#F6EDBDFF", "#B4C8A8FF", "#70A494FF", "#008080FF"), # inspired by rcartocolor::Geyser
                    labels=c("25% decline and below", "0%-25% decline", "1%-25% increase", "26% increase or more"),
                    name = "Percent change") + 
  guides(fill = guide_legend(reverse=TRUE)) +
  theme_void() +
  theme(legend.position = c(.77, .65)) +
  ggtitle("Percent change in birth rates from 2014-2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = outputpath, "births/maps/change_in_birth_rate_2014-2023.png", dpi = 320, width = 5, height = 8)
  
  


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
  
  ggsave(path = outputpath, paste("births/line/births ",i,".png", sep = ""), dpi = 320, width = 7, height = 5) 
  }

