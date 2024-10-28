## Liz Bageant
## October 9, 2024

# Visualizing IRS migration data 


# BRING IN DATA
data <- read.csv(paste(datapath, "migration_irs_county_2012-2022.csv", sep = "")) %>% 
  mutate(county_name = as.factor(county_name)) %>% 
  # calculate turnover, outflow and inflow ratios
  mutate(turnover = (indiv_in + indiv_out)/indiv_stay) %>% 
  mutate(outflow = indiv_out/indiv_stay) %>% 
  mutate(inflow = indiv_in/indiv_stay) 

state_data <- read.csv(paste(datapath, "migration_irs_state_2012-2022.csv", sep = "")) %>% 
  # calculate turnover, outflow and inflow ratios
  mutate(turnover = (indiv_in + indiv_out)/indiv_stay) %>% 
  mutate(outflow = indiv_out/indiv_stay) %>% 
  mutate(inflow = indiv_in/indiv_stay) %>% 
  mutate(net_mig_abs = indiv_in - indiv_out) %>% 
  mutate(net_mig_ratio = (indiv_in - indiv_out)/indiv_stay)


#countymap <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/county_map_data.csv")




#--------------------------------------------------------------------------------------# 
#   PLOT INFLOWS, OUTFLOWS AND TURNOVER OVER TIME AT STATE LEVEL--updated 9/4
#--------------------------------------------------------------------------------------#

chartdata <- state_data %>% 
  select(year, turnover, outflow, inflow) %>% 
  pivot_longer(cols = turnover:inflow, names_to = "group", values_to = "ratio") 

chartdata %>% 
  #filter(group != "turnover") %>% 
  ggplot(aes(x = year, y = ratio, color = group)) +
  geom_line(size = 2) +
  scale_color_paletteer_d("vangogh::CafeTerrace") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2012, 2022), breaks = c(2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  scale_y_continuous(limits=c(0,0.31)) + ## This is the scale used in county figures for comparison
  ggtitle("Idaho inflow, outflow and turnover: IRS data") +
  labs(caption = "Data source: IRS Statistics of Income \nInflow, outflow and turnover ratios are defined relative to the population that does not move. \nInflow = in-migrants/non-movers. Outflow = out-migrants/non-movers. \nTurnover = (inflow + outflow)/non-movers.")

  ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/in_out_ratios", ("Idaho.png"), dpi = 320) 

#--------------------------------------------------------------------------------------# 
#   PLOT NET MIGRATION OVER TIME AT STATE LEVEL--updated 9/4
#--------------------------------------------------------------------------------------#

# plot inflow, outflow and net migration in terms of population
chartdata2 <- state_data %>% 
  mutate(net_migrants = net_mig_abs,
         migrants_in = indiv_in, 
         migrants_out = indiv_out) %>% 
  select(year, migrants_in, migrants_out, net_migrants) %>% 
  pivot_longer(cols = -year, names_to = "group", values_to = "people") 

chartdata2 %>% 
  ggplot(aes(x = year, y = people, fill = group, color= group)) +
  geom_line(size = 2) +
  scale_color_paletteer_d("vangogh::CafeTerrace") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2012, 2022), breaks = c(2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  scale_y_continuous(limits = c(0, 92000)) +
  ggtitle("Idaho in-migrants, out-migrants and net migrants: IRS data") +
  labs(caption = "Net migration = in-migrants - out-migrants. Data source: IRS Statistics of Income.")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/", ("Idaho_irs_in_out_net.png"), dpi = 320) 



# plot net migration in terms of population
chartdata <- state_data %>% 
  select(year, net_mig_abs, net_mig_ratio) 

plot_abs <- state_data %>% 
  ggplot(aes(x = year, y = net_mig_abs)) +
  geom_line(size = 2) +
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(limits = c(2012, 2022), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) 
plot_abs

# plot net migration as a ratio (relative to those who don't move)
plot_ratio <- state_data %>% 
  ggplot(aes(x = year, y = net_mig_ratio)) +
  geom_line(size = 2) +
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(limits = c(2012, 2022), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) 
plot_ratio





#--------------------------------------------------------------------------------------#
#  MAPPING TURNOVER, INFLOWS AND OUTFLOWS BY COUNTY--not updated as of 9/4
#--------------------------------------------------------------------------------------#

data <- data %>% 
  mutate(county = county_name) 

mapdata <- left_join(countymap, data, by = "county")

# turnover map
ggplot(mapdata, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = turnover), color = "black") +
  scale_fill_viridis(option = "viridis", name = "Turnover Ratio \n(Movers/Non-movers)", limits=c(0,0.5)) +
  theme_void() + 
  theme(legend.position = c(0.8, 0.7),
        axis.text.x = element_blank(), 
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank()) +
  coord_map("mercator")  +
  ggtitle("Population turnover by county: 2012-2022 annual")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/maps", "turnover_map_allyears.png", dpi = 320) 

# Loop map over all years and output figures
  loop_values <- 2012:2022
  
  # turnover
  for (i in loop_values) {
  plot <- mapdata %>% 
    filter(year == i) %>% 
  ggplot(aes(x = long, y = lat, group = group)) +
      geom_polygon(aes(fill = turnover), color = "black") +
      scale_fill_viridis(option = "viridis", name = "Turnover Ratio \n(Movers/Non-movers)", limits=c(0,0.5)) +
      theme_void() + 
      theme(legend.position = c(0.8, 0.7),
            axis.text.x = element_blank(), 
            axis.text.y = element_blank(),
            axis.ticks = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            rect = element_blank()) +
      coord_map("mercator")  +
      ggtitle(paste("Population turnover by county:", i))
  
  ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/maps", paste("turnover_map_",i,".png", sep = ""), dpi = 320) 
  }
  
  # inflow
  for (i in loop_values) {
    plot <- mapdata %>% 
      filter(year == i) %>% 
      ggplot(aes(x = long, y = lat, group = group)) +
      geom_polygon(aes(fill = inflow), color = "black") +
      scale_fill_viridis(option = "viridis", name = "Inflow Ratio \n(Arrivals/Non-movers)", limits=c(0,0.31)) +
      theme_void() + 
      theme(legend.position = c(0.8, 0.7),
            axis.text.x = element_blank(), 
            axis.text.y = element_blank(),
            axis.ticks = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            rect = element_blank()) +
      coord_map("mercator")  +
      ggtitle(paste("Population inflow by county:", i))
    
    ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/maps", paste("inflow_map_", i, ".png", sep = ""), dpi = 320) 
  }
  
  
  # outflow
  for (i in loop_values) {
    plot <- mapdata %>% 
      filter(year == i) %>% 
      ggplot(aes(x = long, y = lat, group = group)) +
      geom_polygon(aes(fill = outflow), color = "black") +
      scale_fill_viridis(option = "viridis", name = "Outflow Ratio \n(Arrivals/Non-movers)", limits=c(0,0.31)) +
      theme_void() + 
      theme(legend.position = c(0.8, 0.7),
            axis.text.x = element_blank(), 
            axis.text.y = element_blank(),
            axis.ticks = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            rect = element_blank()) +
      coord_map("mercator")  +
      ggtitle(paste("Population outflow by county:", i))
    
    ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/maps", paste("outflow_map_", i, ".png", sep = ""), dpi = 320) 
  }
  
#--------------------------------------------------------------------------------------# 
#   PLOT INFLOWS, OUTFLOWS AND TURNOVER OVER TIME BY COUNTY
#--------------------------------------------------------------------------------------#

chartdata <- data %>% 
  select(year, county, cfips, turnover, outflow, inflow) %>% 
  pivot_longer(cols = turnover:inflow, names_to = "group", values_to = "ratio") 

chartdata %>% 
  filter(group != "turnover") %>% 
  filter(county == "Canyon County") %>% 
  ggplot(aes(x = year, y = ratio, fill = group)) +
  geom_area() +
  scale_fill_viridis(discrete = T) +
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  ggtitle("Infow and outflow: Canyon County")


loop_data <- chartdata %>% 
  filter(group != "turnover")

loop_values <- data %>% 
  filter(year == 2012) %>% 
  select(county) %>% 
  pull()

for (i in loop_values) {
plot <- loop_data %>% 
  filter(county == i) %>% 
  ggplot(aes(x = year, y = ratio, fill = group)) +
  geom_area() +
  scale_fill_viridis(discrete = T) +
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  scale_y_continuous(limits=c(0,0.31)) +
  ggtitle(paste("Infow and outflow: ", i))
  
  ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/in_out_ratios", paste(i, ".png", sep = ""), dpi = 320) 
}

