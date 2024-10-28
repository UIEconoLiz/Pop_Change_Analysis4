## Mortality data comparison

# Bring in census components of change data--as of 9/19 this data needs updating once we hear from Brian at Census
comp <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/components_of_change_2019-2023.csv")

# Bring in IDHW data
idhw_mortality <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/idaho_deaths_2014-2023.csv") %>% 
  mutate(idhw_deaths = death_num, 
         idhw_rate = death_rate)

# Bring in CDC WONDER data
cdc_mortality <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/cdc_idaho_deaths_1999-2024.csv") %>% 
  mutate(cdc_deaths = deaths) %>% 
  select(year, cdc_deaths)
  
# Combine       
data <- comp %>% 
  left_join(idhw_mortality) %>% 
  left_join(cdc_mortality)

# Plot all three data sources
data %>% 
  select(year, deaths, idhw_deaths, cdc_deaths) %>% 
  mutate(IDHW = idhw_deaths, 
         Census = deaths, 
         CDC_WONDER = cdc_deaths) %>% 
  pivot_longer(cols = c(IDHW, Census, CDC_WONDER), names_to = "source", values_to = "number") %>% 
  ggplot(aes(x = year, y = number, color = source)) +
  geom_line(size = 2) +
  theme_liz() +
  scale_color_paletteer_d("PrettyCols::Bright") +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(0, 20000)) +
  ggtitle("Idaho deaths by data source") 

#ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/", "deaths_comparison.png", dpi = 320) 


# Plot only IDHW and Census because CDC and IDHW are the same (see above)
data %>% 
  select(year, deaths, idhw_deaths) %>% 
  mutate(IDHW = idhw_deaths, 
         Census = deaths) %>% 
  pivot_longer(cols = c(IDHW, Census), names_to = "source", values_to = "number") %>% 
  ggplot(aes(x = year, y = number, color = source)) +
  geom_line(size = 2) +
  theme_liz() +
  scale_color_paletteer_d("PrettyCols::Bright") +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(0, 20000)) +
  ggtitle("Idaho deaths by data source") +
  labs(caption = "
      Note: CDC WONDER mortality data excluded from graph because they are identical to IDHW
      Data sources: Idaho Department of Health and Welfare; U.S. Census Bureau Annual Resident Population Estimates,
      Estimated Components of Resident Population Change, and Rates of the Components of Resident Population
      Change for States and Counties, Vintage 2019 and Vintage 2023")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/mortality/", "deaths_comparison.png", dpi = 320) 



  
