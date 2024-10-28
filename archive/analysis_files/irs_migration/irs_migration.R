## Liz Bageant
## August 29, 2024


## Visualize turnover data for 2022

library(viridis)
library(gfonts)
library(hrbrthemes)
library(tidyverse)
library(forcats)
library(gt)

# BRING IN DATA
data <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs2022.csv") %>% 
  mutate(county_name = as.factor(county_name)) %>% 
  # calculate turnover, outflow and inflow ratios
  mutate(turnover = (no_indiv_in + no_indiv_out)/no_indiv_stay) %>% 
  mutate(outflow = no_indiv_out/no_indiv_stay) %>% 
  mutate(inflow = no_indiv_in/no_indiv_stay) 


# BAR GRAPHS TO EXAMINE DATA 
# looking at turnover 
data %>% 
  mutate(county_name = fct_reorder(county_name, desc(turnover))) %>% 
  ggplot(aes(x = county_name, y = turnover)) +
  geom_bar(stat = "identity") +
  coord_flip()

# looking at inflows
data %>% 
  mutate(county_name = fct_reorder(county_name, desc(inflow))) %>% 
  ggplot(aes(x = county_name, y = inflow)) +
  geom_bar(stat = "identity") +
  coord_flip()

# looking at outflows
data %>% 
  mutate(county_name = fct_reorder(county_name, desc(outflow))) %>% 
  ggplot(aes(x = county_name, y = outflow)) +
  geom_bar(stat = "identity") +
  coord_flip()


# looking at outflows, organized by inflows
data %>% 
  mutate(county_name = fct_reorder(county_name, desc(inflow))) %>% 
  ggplot(aes(x = county_name, y = outflow)) +
  geom_bar(stat = "identity") +
  coord_flip()

# looking at turnover, organized by outflows
data %>% 
  mutate(county_name = fct_reorder(county_name, desc(outflow))) %>% 
  ggplot(aes(x = county_name, y = turnover)) +
  geom_bar(stat = "identity") +
  coord_flip()

# looking at turnover, organized by inflows
data %>% 
  mutate(county_name = fct_reorder(county_name, desc(inflow))) %>% 
  ggplot(aes(x = county_name, y = turnover)) +
  geom_bar(stat = "identity") +
  coord_flip()


## MAPPING TURNOVER, INFLOWS AND OUTFLOWS BY COUNTY
data <- data %>% 
  mutate(county = county_name) 

mapdata <- left_join(mapdata, data, by = "county")

# turnover map
ggplot(mapdata, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = turnover), color = "black") +
  scale_fill_viridis(option = "viridis", name = "Turnover Ratio \n(Movers/Non-movers)", limits=c(0,0.36)) +
  theme_void() + 
  theme(legend.position = c(0.8, 0.7),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank()) +
  coord_map("mercator")  +
  ggtitle("Population turnover by county")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "turnover_map.png", dpi = 320) 

      
# inflow ratio map
ggplot(mapdata, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = inflow), color = "black") +
  scale_fill_viridis(option = "viridis", name = "Inflow Ratio \n(Arrivals/Non-movers)", limits=c(0,0.21)) +
  theme_void() + 
  theme(legend.position = c(0.8, 0.7),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank()) +
  coord_map("mercator")  +
  ggtitle("In-migration by county")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "inflow_map.png", dpi = 320) 

# outflow ratio map
ggplot(mapdata, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = outflow), color = "black") +
  scale_fill_viridis(option = "viridis", name = "Outflow Ratio \n(Departures/Non-movers)", limits=c(0,0.21)) +
  theme_void() + 
  theme(legend.position = c(0.8, 0.7),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank()) +
  coord_map("mercator") +
  ggtitle("Out-migration by county")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change", "outflow_map.png", dpi = 320) 



