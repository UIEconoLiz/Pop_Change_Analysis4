## Liz Bageant
## August 28, 2024

library(viridis)
library(gfonts)
library(hrbrthemes)
library(tidyverse)

## Graphing components of change over time

# bring in file from stata (components_of_change.do)
comp <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change_2019-2023.csv")

# for a stacked area chart, the data need to be long with components of change as a categorical variable
data <- comp %>% 
  select(year, popestimate, naturalchg, netmig, residual, base) %>% 
  pivot_longer(c(popestimate, naturalchg, netmig, residual, base), names_to = "component", values_to = "pop") 


data <- comp %>% 
  select(year, naturalchg, netmig, residual, base) %>% 
  pivot_longer(c(naturalchg, netmig, residual, base), names_to = "component", values_to = "pop") 

  
data$component <- factor(data$component, levels = c("residual", "netmig", "naturalchg", "base"))

# plot

components_of_change <- data %>% 
  filter(year > 2010) %>% 
  filter(component != "residual") %>% 
  ggplot(aes(x = year, y = pop, fill = component)) +
  geom_area(alpha = 0.8) +
  scale_fill_viridis(discrete = T) +
  theme_ipsum() +
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  ggtitle("Population growth in Idaho: Components of change")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "components_of_change.png", dpi = 320) 

  
components_of_change

# "zoomed in" plot

components_of_change_zoomed <- data %>% 
  filter(year > 2010) %>% 
  filter(component != "residual") %>% 
  mutate(pop = if_else(component == "base", pop/50, pop)) %>% ## scaling the base population down by 100,00 
  ggplot(aes(x = year, y = pop, fill = component)) +
  geom_area(alpha = 0.8) +
  scale_fill_viridis(discrete = T) +
  theme_ipsum() +
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  ggtitle("Population growth in Idaho: Natural change and net migration")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "components_of_change_zoomed.png", dpi = 320) 


components_of_change_zoomed
