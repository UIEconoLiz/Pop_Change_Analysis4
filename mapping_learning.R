
# Built of of this info: https://stackoverflow.com/questions/63004172/putting-values-on-a-county-map-in-r


d <- us_map("counties") %>% 
  filter(abbr == "ID")

births_county <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/county_birth_rates.csv")

data <- left_join(d, births_county, by = "county") %>% 
  mutate(centroid = st_centroid(geom),
         br = round(br, digits = 0))

# 2023 birth rates by county
data %>% 
  st_transform('EPSG:3082') %>% 
  filter(year == 2023) %>% 
  ggplot() +
  geom_sf(aes(fill = br)) +
  geom_sf_text(aes(label = br, geometry = centroid), colour = "#003333", size = 3) +
  #scale_fill_viridis(name = "Birth rate \n(per 1000 people)") +
  scale_fill_paletteer_c("grDevices::Tropic", name = "Births \nper 1000 women\nage 15-44", limits=c(30, 115)) +
  #scale_fill_paletteer_c("ggthemes::Blue-Green Sequential") +
  theme_void() +
  ggtitle("Birth rate by county: 2023") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/", "fertility_map_2023.png", dpi = 320)

# 2014 birth rates by county
  
data %>% 
  st_transform('EPSG:3082') %>% 
  filter(year == 2014) %>% 
  ggplot() +
  geom_sf(aes(fill = br)) +
  geom_sf_text(aes(label = br, geometry = centroid), colour = "#003333", size = 3) +
  #scale_fill_viridis(name = "Birth rate \n(per 1000 people)") +
  scale_fill_paletteer_c("grDevices::Tropic", name = "Births \nper 1000 women\nage 15-44", limits=c(30, 115)) +
  #scale_fill_paletteer_c("ggthemes::Blue-Green Sequential") +
  theme_void() +
  ggtitle("Birth rate by county: 2014") +
  labs(caption = "Data source: Idaho Department of Health and Welfare")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/births/", "fertility_map_2014.png", dpi = 320)


# PUTTING NAMES ON COUNTY MAP:
data %>% 
  mutate(Change = cut(Change, breaks = c(-10, 0, 10, 20, 30, 40, 70), include.lowest = TRUE),
         county = str_remove(county, " County")) %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = Change)) +
  geom_sf_text(aes(label = county, geometry = centroid), color = "#003333", size = 3)
  coord_sf(crs = 4269) +
  theme_void() 



# scratch

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




SCRATCH
%>% 
  st_as_sfc() %>% 
  mutate(centroid = st_centroid(geometry))

sfdata$centroids <- st_centroid(data$geometry)

sfdata <- st_as_sfc(data)

d

sf <- st_as_sfc(d)



d   <- us_map("counties")
d   <- d[d$abbr == "GA",]
GAc <- lapply(split(d, d$county), function(x) st_polygon(list(cbind(x$x, x$y))))
