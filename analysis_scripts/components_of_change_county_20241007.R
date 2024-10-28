## Liz Bageant
## October 7, 2024

## Components of change over time--county level.

# bring in file from stata (components_of_change_county.do)
comp <- read.csv(paste(datapath,"components_of_change_county_2010-2023.csv", sep = ""))

# pivot to long with components of change as a categorical variable
data <- comp %>% 
  select(year, county, cfips, popestimate, naturalchg, netmig, residual, base, components_unknown) %>% 
  pivot_longer(c(naturalchg, netmig, residual, base, components_unknown), names_to = "component", values_to = "pop") 

data$component <- factor(data$component, levels = c("residual", "netmig", "naturalchg", "components_unknown", "base"))

longdata <- data ## This is used later for line graphs and components of change bar charts

countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")



# Percent change in population by county from 2014-2023
popchg <- comp %>% 
  select(county, year, popestimate) %>% 
  filter(year %in% c(2014, 2023)) %>% 
  pivot_wider(names_from = year, values_from = popestimate) %>% 
  mutate(Change = round(((`2023` - `2014`)/`2014`)*100))

# Bring in county map and select only Idaho counties
data <- us_map("counties") %>% 
  filter(abbr == "ID") %>% 
  mutate(centroid = st_centroid(geom)) %>% 
  left_join(popchg, join_by(county))


# Map
data %>% 
  mutate(Change = cut(Change, breaks = c(-10, 0, 10, 20, 30, 40, 70), include.lowest = TRUE), 
         county = str_remove(county, " County")) %>% 
  ggplot() +
  geom_sf(color = "white", aes(fill = Change)) +  
  geom_sf_text(aes(label = county, geometry = centroid), color = "#003333", size = 2) +
  coord_sf(crs = 4269) +
  scale_fill_manual(values = c("#DE8A5AFF", "#EDBB8AFF", "#F6EDBDFF", "#B4C8A8FF", "#70A494FF", "#008080FF"), # inspired by rcartocolor::Geyser
                    labels=c("0% to 10% decline", "1%-10% increase", "11%-20% increase", "21%-30% increase", "31%-40% increase")) + 
  theme_void() +
  theme(legend.position = c(.77, .65)) +
  guides(fill = guide_legend(reverse=TRUE)) +
  ggtitle("Percent change in population between 2014 and 2023") +
  labs(caption = "Data source: U.S. Census Population Estimates Program")

ggsave(paste(outputpath, "components_of_change/", "county_pop_change_2014-2023.png", sep = ""), width = 5, height = 8)



# county population line charts
for (i in countynames) {
  longdata %>% 
    filter(county == i) %>% 
    ggplot(aes(x = year, y = popestimate)) +
    geom_line(size = 2) +
    geom_point(size = 4) +
    scale_color_paletteer_d("PrettyCols::Bright") +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0)) +
    scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    scale_y_continuous(labels = label_comma()) +
    ggtitle(paste(i, "population 2011-2023")) +
    labs(caption = "
       Data source: Census Population Estimates program") 
  
  ggsave(paste(outputpath, "components_of_change/line/", i, ".png", sep = ""), width = 8, height = 5)
}

# normalized county population line charts

longdata %>% 
  select(county, year, popestimate) %>% 
  group_by(county) %>% 
  mutate(scaled = (popestimate - mean(popestimate))/sd(popestimate)) %>% 
  ggplot(aes(x = year, y = scaled, color = county)) +
  geom_line() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0), 
        legend.position = "none") +
  scale_x_continuous(limits = c(2010, 2023), breaks = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  ggtitle("Idaho population change by county: 2010-2023 
(standardized to within-county means)") +
  labs(caption = "
       Data source: Census Population Estimates program") 

ggsave(paste(outputpath, "components_of_change/line/", "_all_counties_scaled.png", sep = ""), width = 8, height = 5)


# components of change stacked bar chart
for (i in countynames) {
  longdata %>% 
    filter(year > 2010) %>% 
    filter(county == i) %>% 
    ggplot(aes(x = year, y = pop, fill = component)) +
    geom_bar(position = "stack", stat = "identity") +
    scale_fill_paletteer_d("PrettyCols::Bright", direction = -1) +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0)) +
    scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    scale_y_continuous(labels = label_comma()) +
    ggtitle(paste(i, "population 2011-2022
components of change")) +
    labs(caption = "
       Data source: Census Population Estimates program") 
  
  ggsave(paste(outputpath, "components_of_change/bar/", i, ".png", sep = ""), width = 8, height = 5)
  
}

