## Liz Bageant
## October 10, 2024

## Population Estimates Program housing units estimates

# BRING IN DATA
# state level
id <- read.csv(paste(datapath, "housing_units_state_2010-2023.csv", sep = ""))

# county level
county <- read.csv(paste(datapath, "housing_units_county_2010-2023.csv", sep = "")) 

countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")


# PLOT

# State level
id %>% 
  filter(year != 2020) %>% # excluding this until we have intercensals.
  ggplot(aes(x = year, y = units)) +
  geom_line(size = 2, color = "#2D3184FF") +
  geom_point(size = 4, color = "#2D3184FF") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2010, 2023), 
                     breaks = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(#limits = c(1500000, 2000000),
                     labels = label_comma()) +
  ggtitle("Housing units in Idaho: 2010-2023") +
  labs(caption = "Data source: U.S. Census Bureau Population and Housing Estimates Vintage 2019, Vintage 2023. \nData from 2020 are excluded until intercensal estimates finalized.") +
  xlab("") +
  ylab("Housing units")

ggsave(path = outputpath, "housing/housing_units_state.png", dpi = 320, height = 5, width = 7) 


# County level--these seem very unrealiable for smaller counties. Probably shouldn't use.
for (i in countynames) {
  county %>% 
    filter(county == i, 
           year != 2020) %>% 
    ggplot(aes(x = year, y = units)) +
    geom_line(size = 2, color = "#2D3184FF") +
    geom_point(size = 4, color = "#2D3184FF") +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0), 
          legend.position = "none") +
    scale_x_continuous(limits = c(2010, 2023), breaks = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    ggtitle(paste(i, "housing unit change: 2010-2023")) +
    labs(caption = "
       Data source: U.S. Census Bureau Population and Housing Estimates Vintage 2019, Vintage 2023. \nNeeds updating when intercensals are released.") 
  
  ggsave(paste(outputpath, "housing/county/", i, ".png", sep = ""), dpi = 320, height = 5, width = 7)

  }


  