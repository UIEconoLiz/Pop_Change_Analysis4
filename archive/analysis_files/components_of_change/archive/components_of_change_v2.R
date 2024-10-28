## Liz Bageant
## August 28, 2024

library(viridis)
library(gfonts)
library(hrbrthemes)
library(tidyverse)


## Graphing components of change over time

# bring in file from stata (components_of_change.do)
comp <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/components_of_change_2019-2023.csv")

# pivot to long with components of change as a categorical variable
data <- comp %>% 
  select(year, popestimate, naturalchg, netmig, residual, base) %>% 
  pivot_longer(c(popestimate, naturalchg, netmig, residual, base), names_to = "component", values_to = "pop") 

# plot net migration and natural increase

data$component <- factor(data$component, levels = c("residual", "netmig", "naturalchg", "base"))

components_of_change <- data %>% 
  filter(year > 2010) %>% 
  filter(component != "residual") %>% 
  filter(component != "base") %>% 
  ggplot(aes(x = year, y = pop, color = component)) +
  geom_line(size = 2) +
  scale_color_paletteer_d("vangogh::CafeTerrace") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  ggtitle("Population growth in Idaho: Components of change") +
  labs(caption = "Data source: U.S. Census Bureau Annual Resident Population Estimates, Estimated Components of Resident \nPopulation Change, and Rates of the Components of Resident Population Change for States and Counties \nVintage 2019, 2023")

components_of_change

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "components_of_change.png", dpi = 320) 


# plot net migration only
net_migration <- data %>% 
  filter(year > 2010) %>% 
  filter(component == "netmig") %>% 
  ggplot(aes(x = year, y = pop)) +
  geom_line(size = 2, color = "#024873FF") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(0, 92000)) +
  ggtitle("Idaho net migration: Census") +
  labs(caption = "Data source: U.S. Census Bureau Annual Resident Population Estimates, Estimated Components of Resident \nPopulation Change, and Rates of the Components of Resident Population Change for States and Counties \nVintage 2019, 2023")

net_migration

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "net_migration.png", dpi = 320) 
