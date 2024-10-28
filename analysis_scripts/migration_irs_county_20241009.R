## Liz Bageant
## October 9, 2024

# Visualizing IRS migration data at the county level


# BRING IN DATA
data <- read.csv(paste(datapath, "migration_irs_county_2012-2022.csv", sep = "")) %>% 
  mutate(county_name = as.factor(county_name)) %>% 
  # calculate turnover, outflow and inflow ratios
  mutate(turnover = (indiv_in + indiv_out)/indiv_stay, 
         outflow = indiv_out/indiv_stay,
         inflow = indiv_in/indiv_stay, 
         net_mig_abs = indiv_in - indiv_out, 
         net_mig_ratio = (indiv_in - indiv_out)/indiv_stay,
         county = county_name) %>% 
  filter(!(year %in% c(2015, 2017))) # dropping 2015 and 2017 due to data quality issues


# Bring in county map and select only Idaho counties
d <- us_map("counties") %>% 
  filter(abbr == "ID")

mapdata <- left_join(d, data, by = "county") %>% 
  mutate(centroid = st_centroid(geom))
class(mapdata)
max(mapdata$turnover)

countynames <- c("Ada County", "Adams County", "Bannock County", "Bear Lake County", "Benewah County", "Bingham County", "Blaine County", "Boise County", "Bonner County", "Bonneville County", "Boundary County", "Butte County", "Camas County", "Canyon County", "Caribou County", "Cassia County", "Clark County", "Clearwater County", "Custer County", "Elmore County", "Franklin County", "Fremont County", "Gem County", "Gooding County", "Idaho County", "Jefferson County", "Idaho County", "Jefferson County", "Jerome County", "Kootenai County", "Latah County", "Lemhi County", "Lewis County", "Lincoln County", "Madison County", "Minidoka County", "Nez Perce County", "Oneida County", "Owyhee County", "Payette County", "Power County", "Shoshone County", "Teton County", "Twin Falls County", "Valley County", "Washington County")
irs_years <- c(2012, 2013, 2014, 2016, 2018, 2019, 2020, 2021, 2022) # note 2015 and 2017 are excluded due to data quality concerns


#---- In-, out- and net-migration over time ----#

# Line graphs by county

for (i in countynames) {
  data %>% 
    select(year, county, indiv_in, indiv_out, net_mig_abs) %>% 
    pivot_longer(cols = c(indiv_in, indiv_out, net_mig_abs), names_to = "group", values_to = "number")  %>% 
    filter(county == i) %>% 
    ggplot(aes(x = year, y = number, color = group)) +
    geom_line(size = 2) +
    geom_point(size = 4) + 
    scale_color_manual(values = c("#009392FF", "#9CCB86FF", "#EEB479FF"), 
                       labels = c("In-migration", "Out-migration", "Net Migration"), 
                       name = "") +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0)) +
    scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    ggtitle(paste("In-migration, out-migration and net-migration:", i)) +
    labs(caption = "Data source: IRS Statistics of Income. Net migration is the difference beween in-migration and out-migration.")

ggsave(path = outputpath, paste("/migration/county_levels/irs_levels_", i, ".png", sep = ""), dpi = 320, width = 7, height = 5) 

}

# Net migration maps
for (i in irs_years) {
  
  mapdata %>% 
    select(county, year, net_mig_abs, centroid) %>% 
    filter(year == i) %>% 
    mutate(county = str_remove(county, " County")) %>% 
    ggplot() +
      geom_sf(color = "white", aes(fill = net_mig_abs)) +
      geom_sf_text(aes(label = county, geometry = centroid), colour = "white", size = 2) +
      coord_sf(crs = 4269) +
      paletteer::scale_fill_paletteer_c("grDevices::Red-Blue", direction = -1, limits= c(-1000, 11000)) +
      theme_void() +
      theme(legend.position = c(.77, .65)) +
      #scale_y_continuous(c(-1000, 11000)) +
    ggtitle(paste("Net migration by county: ", i, sep = "")) +
    labs(caption = "Data source: IRS Statistics of Income")
  
  ggsave(path = outputpath, paste("migration/migration_maps/irs_net_", i, ".png", sep = ""), dpi = 320, width = 5, height = 8) 
  
}

# IN-migration maps
for (i in irs_years) {
  
  mapdata %>% 
    select(county, year, indiv_in, centroid) %>% 
    filter(year == i) %>% 
    mutate(county = str_remove(county, " County")) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = indiv_in)) +
    geom_sf_text(aes(label = county, geometry = centroid), colour = "white", size = 2) +
    coord_sf(crs = 4269) +
    paletteer::scale_fill_paletteer_c("grDevices::Red-Blue", direction = -1, limits= c(0, 35000)) +
    theme_void() +
    theme(legend.position = c(.77, .65)) +
    ggtitle(paste("In-migration by county: ", i, sep = "")) +
    labs(caption = "Data source: IRS Statistics of Income")
  
  ggsave(path = outputpath, paste("migration/migration_maps/irs_in_", i, ".png", sep = ""), dpi = 320, width = 5, height = 8) 
  
}

# OUT-migration maps
for (i in irs_years) {
  
  mapdata %>% 
    select(county, year, indiv_out, centroid) %>% 
    filter(year == i) %>% 
    mutate(county = str_remove(county, " County")) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = indiv_out)) +
    geom_sf_text(aes(label = county, geometry = centroid), colour = "white", size = 2) +
    coord_sf(crs = 4269) +
    paletteer::scale_fill_paletteer_c("grDevices::Red-Blue", direction = -1, limits= c(0, 35000)) +
    theme_void() +
    theme(legend.position = c(.77, .65)) +
    ggtitle(paste("Out-migration by county: ", i, sep = "")) +
    labs(caption = "Data source: IRS Statistics of Income")
  
  ggsave(path = outputpath, paste("migration/migration_maps/irs_out_", i, ".png", sep = ""), dpi = 320, width = 5, height = 8) 
  
}



#---- In-flow, out-flow and turnover ratios over time ----#

# Line graphs by county

for (i in countynames) {

data %>% 
  select(year, county, inflow, outflow, turnover) %>% 
  pivot_longer(cols = c(inflow, outflow, turnover), names_to = "group", values_to = "ratio") %>% 
    filter(county == i) %>% 
    ggplot(aes(x = year, y = ratio, color = group)) +
    geom_line(size = 2) +
    geom_point(size = 4) +
    scale_color_manual(values = c("#009392FF", "#9CCB86FF", "#EEB479FF"), 
                       labels = c("Inflow", "Outflow", "Turnover"), 
                       name = "") +
    theme_liz() +
    theme(axis.text.x = element_text(angle = 45)) +
    theme(plot.caption=element_text(hjust = 0)) +
    scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
    xlab("") +
    ylab("Ratio") +
    ggtitle(paste("Inflow, outflow and turnover ratios: ", i)) +
    labs(caption = "Data source: IRS Statistics of Income. \nInflow, outflow and turnover ratios are defined relative to the population that does not move. \nInflow = in-migrants/non-movers. Outflow = out-migrants/non-movers. \nTurnover = (inflow + outflow)/non-movers.")
  
ggsave(path = outputpath, paste("/migration/county_turnover/irs_turnover_", i, ".png", sep = ""), dpi = 320, width = 7, height = 5) 
  
}


#---- Turnover maps ----#

for (i in irs_years) {
  
  mapdata %>% 
    select(county, year, turnover, centroid) %>% 
    filter(year == i) %>% 
    mutate(bins = cut(turnover, breaks = c(0.1, 0.2, 0.3, 0.4)),
           county = str_remove(county, " County")) %>% 
    ggplot() +
    geom_sf(color = "white", aes(fill = bins)) +
    geom_sf_text(aes(label = county, geometry = centroid), colour = "white", size = 2) +
    coord_sf(crs = 4269) +
    scale_fill_manual(values = c("#81A9ADFF", "#91A1BAFF", "#51628EFF"), 
                      labels=c("0.11-0.2", "0.21-0.3", "0.3-0.4", "Insufficient data"),
                      name = "Turnover ratio") +
    theme_void() +
    theme(legend.position = c(.77, .65)) +
    ggtitle(paste("Turnover ratio by county:", i)) +
    labs(caption = "Data source: IRS Statistics of Income")
  
  ggsave(path = outputpath, paste("migration/turnover_maps/irs_turnover_", i, ".png", sep = ""), dpi = 320, width = 7, height = 5) 

}

  
  
  
