## Liz Bageant
## September 13, 2024

## Population Estimates Program housing units estimates

# state level
id <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/housing_units/state_housing_units_2010-2023.csv")

id %>% 
  ggplot(aes(x = year, y = units)) +
  geom_line() +
  geom_point()


# county level
county <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/housing_units/county_housing_units_2010-2023.csv") %>% 
  arrange(county, year)

countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")

# looking at drops between 2019 and 2020, by county
change <- county %>% 
  filter(year == 2019 | year == 2020) %>% 
  pivot_wider(names_from = year, values_from = units) %>% 
  mutate(diff = `2020`-`2019`) %>% 
  mutate(pctchg = diff/`2019`) %>% 
  arrange(pctchg)



## all counties on one graph--not scaled
county %>% 
  group_by(county) %>% 
  mutate(scaled = (units - mean(units))/sd(units)) %>% 
  ggplot(aes(x = year, y = units, color = county)) +
  geom_line() +
  geom_line() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0), 
        legend.position = "none") +
  scale_x_continuous(limits = c(2010, 2023), breaks = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  ggtitle("Idaho housing unit change by county: 2010-2023) +
  labs(caption = "
       Data source: Census Population Estimates program Housing Units Estimates") 

ggsave("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/housing_units/county/all_counties_housing_scaled.png")


## all counties on one graph--scaled
county %>% 
  group_by(county) %>% 
  mutate(scaled = (units - mean(units))/sd(units)) %>% 
  ggplot(aes(x = year, y = scaled, color = county)) +
  geom_line() +
  geom_line() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0), 
        legend.position = "none") +
  scale_x_continuous(limits = c(2010, 2023), breaks = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  ggtitle("Idaho housing unit change by county: 2010-2023 
(standardized to within-county means)") +
  labs(caption = "
       Data source: Census Population Estimates program Housing Units Estimates") 

ggsave("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/housing_units/county/all_counties_housing_scaled.png")


# individual county graphs

for (i in countynames) {
  county %>% 
    filter(county == i) %>% 
    ggplot(aes(x = year, y = units)) +
    geom_line() +
    geom_line() +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0), 
          legend.position = "none") +
    scale_x_continuous(limits = c(2010, 2023), breaks = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    ggtitle(paste(i, "housing unit change: 2010-2023")) +
    labs(caption = "
       Data source: Census Population Estimates program Housing Units Estimates") 
  
  ggsave(paste("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/housing_units/county/", i, ".png", sep = ""))

  }

  