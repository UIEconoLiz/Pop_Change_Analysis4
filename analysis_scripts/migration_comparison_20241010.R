## Liz Bageant
## October 10, 2024

## Putting together migration data into a single file: DMV, IRS, Census Popest, Census ACS

## Note: the ratios are included here but at the moment it's not clear how to 
## calculate them for DMV and popest data, so they are not plotted at this time.


#------------------------------------------------------------------------------#
#   Bring in data files
#------------------------------------------------------------------------------#

# IRS migration data

irs <- read.csv(paste(datapath, "migration_irs_state_2012-2022.csv", sep = "")) %>% 
  # calculate turnover, outflow and inflow ratios
  mutate(turnover = (indiv_in + indiv_out)/indiv_stay,
         migrants_out_ratio = indiv_out/indiv_stay,
         migrants_in_ratio = indiv_in/indiv_stay,
         net_migration_ratio = (indiv_in - indiv_out)/indiv_stay,
         migrants_in = indiv_in, 
         migrants_out = indiv_out,
         net_migration = indiv_in - indiv_out,
         Source = "IRS Statistics of Income") %>% 
  select(year, contains("migrants_"), Source, contains("net_migration")) %>% 
  filter(!(year %in% c(2015, 2017))) # dropping 2015 and 2017 due to data quality issues

head(irs)

# DMV migration data

dmv <- read.csv(paste(datapath, "migration_dmv_2014-2023.csv", sep = "")) %>% 
mutate(migrants_in = indiv_in,
       migrants_out = indiv_out,
       net_migration = net,
       Source = "DMV Driver's License Surrenders") %>% 
  select(year, Source, migrants_in, migrants_out, net_migration)
head(dmv)


# Census PopEst migration data

popest <- read.csv(paste(datapath, "components_of_change_2010-2023.csv", sep = "")) %>% 
  mutate(net_migration = netmig,
         Source = "Census Population Estimates Program") %>% 
  select(year, net_migration, Source) %>% 
  filter(year != 2020) # Dropping 2020 until we receive updated intercensals

head(popest)


# ACS migration data

acs <- read.csv(paste(datapath, "migration_acs_2010-2022.csv", sep = "")) %>% 
  mutate(Source = "Census American Community Survey",
         migrants_in_ratio = migrants_in/non_migrants, 
         migrants_out_ratio = migrants_out/non_migrants, 
         net_migration_ratio = (migrants_in - migrants_out)/non_migrants) 


#------------------------------------------------------------------------------#
#   Append and Reshape
#------------------------------------------------------------------------------#

migration <- irs %>% 
  bind_rows(dmv) %>% 
  bind_rows(popest) %>% 
  bind_rows(acs)

# separating the ratios from the population
ratios <- migration %>% 
  select(year, Source, contains("ratio")) %>% 
  pivot_longer(c(net_migration_ratio, migrants_in_ratio, migrants_out_ratio), names_to = "statistic", values_to = "ratio")

people <- migration %>% 
  select(year, Source, net_migration, migrants_in, migrants_out) %>% 
  pivot_longer(c(net_migration, migrants_in, migrants_out), names_to = "statistic", values_to = "people")
people$Source <- factor(people$Source, order = TRUE, levels = c("Census American Community Survey", "DMV Driver's License Surrenders", "IRS Statistics of Income", "Census Population Estimates Program"))
levels(people$Source)


#------------------------------------------------------------------------------#
#   Plot
#------------------------------------------------------------------------------#

# in-migration

people %>%
  select(year, Source, statistic, people) %>% 
  #filter(statistic == "migrants_in" & Source != "Census Population Estimates Program" & Source != "DMV Driver's License Surrenders") %>% 
  filter(statistic == "migrants_in" & Source != "Census Population Estimates Program") %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme_liz() +
  #scale_color_paletteer_d("PrettyCols::Bright", direction = -1) +
  scale_color_manual(values = c("#003D5BFF", "#00798CFF", "#EDAE49FF", "#D1495BFF"), # inspiried by PrettyCols::Lively
                     labels = c("American Community Survey", "Driver's License Surrenders", "IRS Statistics of Income", "Population Estimates Program")) +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2011, 2023), 
                     breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits=c(20000, 110000), # For in-migration and out-migration comparison
                     labels = label_comma()) + 
  ggtitle("Idaho estimated in-migration: 2011-2022") +
  labs(caption = "
Data sources: IRS Statistics of Income, Idaho Transportation Department DMV Driver's License \nSurrenders, U.S. Census Bureau American Community Survey")

ggsave(path = outputpath, ("migration/comparison_in-migration.png"), dpi = 320, width = 7, height = 5) 

  


# out-migration
people %>%
  select(year, Source, statistic, people) %>% 
  #filter(statistic == "migrants_out" & Source != "Census Population Estimates Program" & Source != "DMV Driver's License Surrenders") %>% 
  filter(statistic == "migrants_out" & Source != "Census Population Estimates Program") %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme_liz() +
  scale_x_continuous(labels = label_comma()) +
  #scale_color_paletteer_d("PrettyCols::Bright", direction = -1) +
  scale_color_manual(values = c("#003D5BFF", "#00798CFF", "#EDAE49FF", "#D1495BFF"), # inspiried by PrettyCols::Lively
                     labels = c("American Community Survey", "Driver's License Surrenders", "IRS Statistics of Income", "Population Estimates Program")) +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits=c(20000, 110000), # For in-migration and out-migration comparison
                     labels = label_comma()) + 
  ggtitle("Idaho estimated out-migration: 2011-2022") +
labs(caption = "
Data sources: IRS Statistics of Income, Idaho Transportation Department DMV Driver's License \nSurrenders, U.S. Census Bureau American Community Survey")

  ggsave(path = outputpath, ("migration/comparison_out-migration.png"), dpi = 320, width = 7, height = 5) 
  

# net migration
people %>%
  select(year, Source, statistic, people) %>% 
  filter(statistic == "net_migration") %>% 
  #filter(people != 8872) %>% # <------------------------------------TEMPORARY DELETION!
  #filter(Source != "DMV Driver's License Surrenders") %>% # <-------TEMPORARY DELETION!
  #mutate(people = replace(people, Source == "Census Population Estimates Program" & year == 2020, 0)) %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme_liz() +
  #scale_color_paletteer_d("PrettyCols::Bright", direction = -1) +
  scale_color_manual(values = c("#003D5BFF", "#00798CFF", "#EDAE49FF", "#D1495BFF"), # inspiried by PrettyCols::Lively
                     labels = c("American Community Survey", "Driver's License Surrenders", "IRS Statistics of Income", "Population Estimates Program")) +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(labels = label_comma()) +
  ggtitle("Idaho estimated net migration: 2011-2022") +
  labs(caption = "
Data sources: IRS Statistics of Income, Idaho Transportation Department DMV Driver's License \nSurrenders, U.S. Census Bureau American Community Survey, U.S. Census Bureau Population \n Estimates Program\n
Note: 2020 net migration data unavailable from ACS and Population Estimates Program. \nPEP expected release November 2024. IRS 2015 and 2017 data not available.") 

ggsave(path = outputpath, ("migration/comparison_net-migration.png"), dpi = 320, width = 7, height = 5) 

# net migration-- PopEst and IRS only
people %>%
  select(year, Source, statistic, people) %>% 
  filter(statistic == "net_migration", 
         (Source %in% c("IRS Statistics of Income", "Census Population Estimates Program"))) %>% 
  #mutate(people = if_else(Source == "Census American Community Survey", 0, people), 
  #       people = if_else(Source == "DMV Driver's License Surrenders", 0, people)) %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme_liz() +
  scale_color_manual(values = c("#EDAE49FF", "#D1495BFF"), # inspiried by PrettyCols::Lively
                     labels = c("IRS Statistics of Income", "Population Estimates Program")) +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(0, 53000),
                     labels = label_comma()) +
  ggtitle("Idaho net migration by data source") 
#labs(caption = "
#     Data sources: IRS Statistics of Income, DMV License Surrenders, Census Population Estimates program, American Community Survey") +

#ggsave(path = outputpath, ("migration/comparison_net-migration_irs_pep.png"), dpi = 320, width = 7, height = 5) 


