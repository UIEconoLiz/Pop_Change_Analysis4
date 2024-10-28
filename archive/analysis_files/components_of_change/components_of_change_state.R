## Liz Bageant
## September 20, 2024

## Graphing components of change over time--state level

# bring in file from stata (components_of_change_state.do)
comp <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/components_of_change_2010-2023.csv")

# pivot to long with components of change as a categorical variable
data <- comp %>% 
  select(year, popestimate, naturalchg, netmig, residual, base, components_unknown) %>% 
  pivot_longer(c(naturalchg, netmig, residual, base, components_unknown), names_to = "component", values_to = "pop") 

data$component <- factor(data$component, levels = c("residual", "netmig", "naturalchg", "components_unknown", "base"))

# population estimate line chart

data %>% 
  ggplot(aes(x = year, y = popestimate)) +
  geom_line(size = 2, color = "#462255FF") + 
  geom_point(size = 4, color = "#462255FF") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2010, 2023), 
                     breaks = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(1500000, 2000000),
                     labels = label_comma()) +
  ggtitle("Idaho's population 2010-2023") +
  labs(caption = "Data source: U.S. Census Bureau Annual Resident Population Estimates Vintage 2019, Vintage 2023") +
  xlab("") +
  ylab("Population")
ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "state_population_line.png", dpi = 320) 


  

# components of change stacked bar chart

data %>% 
  filter(year > 2010) %>% 
  ggplot(aes(x = year, y = pop, fill = component)) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_paletteer_d("PrettyCols::Bright", direction = -1) +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  ggtitle("Idaho population with components of change
2011-2022")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "components_of_change_bar.png", dpi = 320) 


data %>% 
  filter(year > 2010) %>% 
  ggplot(aes(x = year, y = pop, fill = component)) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_paletteer_d("PrettyCols::Bright", direction = -1) +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  coord_cartesian(ylim=c(1500000, 1950000)) +  
  ggtitle("Idaho population with components of change
2011-2022 (detail)")


ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "components_of_change_bar_zoomed.png", dpi = 320) 


# plot net migration and natural increase


data %>% 
  filter(year > 2010) %>% 
  filter(year != 2020) %>% 
  filter(component != "residual") %>% 
  filter(component != "base", 
         component != "components_unknown") %>% 
  ggplot(aes(x = year, y = pop, color = component)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  scale_color_paletteer_d("vangogh::CafeTerrace") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  ggtitle("Population growth in Idaho: Components of change") +
  labs(caption = "Data source: U.S. Census Bureau Annual Resident Population Estimates, Estimated Components of Resident \nPopulation Change, and Rates of the Components of Resident Population Change for States and Counties \nVintage 2019, 2023")


ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "components_of_change_line.png", dpi = 320) 


# plot net migration only
data %>% 
  filter(year > 2010) %>% 
  filter(year != 2020) %>% 
  filter(component == "netmig") %>% 
  ggplot(aes(x = year, y = pop)) +
  geom_line(size = 2, color = "#024873FF") +
  geom_point(size = 4, color = "#024873FF") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2011, 2023), 
                     breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(0, 55000), 
                     breaks = c(10000, 20000, 30000, 40000, 50000),
                     labels = label_comma()) +
  ggtitle("Idaho net migration: 2011-2023") +
  labs(caption = "Data source: U.S. Census Bureau Annual Resident Population Estimates, Estimated Components of Resident \nPopulation Change, and Rates of the Components of Resident Population Change for States and Counties \nVintage 2019, 2023") +
  xlab("") +
  ylab("Population (net)")



ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "net_migration.png", dpi = 320) 



