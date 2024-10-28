## Liz Bageant
## September 13, 2024

## Components of change over time--county level.

# bring in file from stata (components_of_change_county.do)
comp <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/components_of_change_county_2010-2023.csv")

# pivot to long with components of change as a categorical variable
data <- comp %>% 
  select(year, county, cfips, popestimate, naturalchg, netmig, residual, base, components_unknown) %>% 
  pivot_longer(c(naturalchg, netmig, residual, base, components_unknown), names_to = "component", values_to = "pop") 

data$component <- factor(data$component, levels = c("residual", "netmig", "naturalchg", "components_unknown", "base"))

countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")


  
# components of change stacked bar chart

for (i in countynames) {
  data %>% 
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
  
  ggsave(paste("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/county/bar/", i, ".png", sep = ""))
}


# components of change line charts
for (i in countynames) {
  data %>% 
    filter(year > 2010) %>% 
    filter(year != 2020) %>% 
    filter(county == i) %>% 
    filter(component == "netmig" | component == "naturalchg") %>% 
    # mutate(pop = na_if(year, 2020)) %>% 
    # replace_with_na_at(.vars = c("pop"),
    #                    condition = ~.year == 2020) %>% 
    #mutate_at(vars(pop), ~replace(., year == 2020, NA)) %>% 
    ggplot(aes(x = year, y = pop, color = component)) +
    geom_line(size = 2) +
    geom_point(size = 4) +
    scale_color_paletteer_d("PrettyCols::Bright") +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0)) +
    scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    scale_y_continuous(labels = label_comma()) +
    ggtitle(paste(i, "population 2011-2022
components of change")) +
    labs(caption = "
       Data source: Census Population Estimates program") 
  
  ggsave(paste("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/county/line/", i, ".png", sep = ""))
}


# county population line charts
for (i in countynames) {
  data %>% 
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
  
  ggsave(paste("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/countypop/", i, ".png", sep = ""))
}

# normalized county population line charts

data %>% 
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
  

ggsave("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/countypop/all_counties_population_scaled.png")



