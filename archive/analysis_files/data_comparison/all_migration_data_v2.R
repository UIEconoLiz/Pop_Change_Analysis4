## Liz Bageant
## September 4, 2024

## Putting together migration data into a single file: DMV, IRS, Census Popest, Census ACS

## Note: the ratios are included here but at the moment it's not clear how to 
## calculate them for DMV and popest data, so they are not plotted at this time.


#------------------------------------------------------------------------------#
#   Bring in data files
#------------------------------------------------------------------------------#

# IRS migration data

irs <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/state_in_out_stay_2012-2022.csv") %>% 
  # calculate turnover, outflow and inflow ratios
  mutate(turnover = (indiv_in + indiv_out)/indiv_stay,
         migrants_out_ratio = indiv_out/indiv_stay,
         migrants_in_ratio = indiv_in/indiv_stay,
         net_migration_ratio = (indiv_in - indiv_out)/indiv_stay,
         migrants_in = indiv_in, 
         migrants_out = indiv_out,
         net_migration = indiv_in - indiv_out,
         Source = "IRS Statistics of Income") %>% 
  select(year, contains("migrants_"), Source, contains("net_migration"))

head(irs)

# DMV migration data

dmv <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/dmv_migration/dmv_migration.csv") %>% 
mutate(migrants_in = indiv_in,
       migrants_out = indiv_out,
       net_migration = net,
       Source = "DMV Driver's License Surrenders") %>% 
  select(year, Source, migrants_in, migrants_out, net_migration)
head(dmv)


# Census PopEst migration data

popest <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/components_of_change/components_of_change_2019-2023.csv") %>% 
  mutate(net_migration = netmig,
         Source = "Census Population Estimates Program") %>% 
  select(year, net_migration, Source)

head(popest)


# ACS migration data

acs <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/acs_migration/acs_state_migration_flows_2010-2022.csv") %>% 
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


#------------------------------------------------------------------------------#
#   Plot
#------------------------------------------------------------------------------#

# in-migration

people %>%
  select(year, Source, statistic, people) %>% 
  filter(statistic == "migrants_in" & Source != "popest") %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
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
  scale_y_continuous(limits=c(20000, 110000)) + # For in-migration and out-migration comparison
  ggtitle("Idaho in-migration by data source") 
  #labs(caption = "
  #    Data sources: IRS Statistics of Income, DMV License Surrenders, American Community Survey")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/data_comparison/", ("in_migration.png"), dpi = 320) 

  
# out-migration
people %>%
  select(year, Source, statistic, people) %>% 
  filter(statistic == "migrants_out" & Source != "popest") %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
  geom_line(size = 2) +
  theme_liz() +
  scale_x_continuous(labels = label_comma()) +
  scale_color_paletteer_d("PrettyCols::Bright") +
  theme(axis.text.x = element_text(angle = 45), 
        plot.caption=element_text(hjust = 0),
        legend.position="bottom", 
        legend.justification.bottom = "left", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 12)) +
  guides(color = guide_legend(ncol = 2)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits=c(20000, 110000)) + # For in-migration and out-migration comparison
  ggtitle("Idaho out-migration by data source") 
  #labs(caption = "
  #      Data sources: IRS Statistics of Income, DMV License Surrenders, American Community Survey")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/data_comparison/", ("out_migration.png"), dpi = 320) 


# net migration
people %>%
  select(year, Source, statistic, people) %>% 
  filter(statistic == "net_migration") %>% 
  filter(people != 8872) %>% # <------------------------------------TEMPORARY DELETION!
  filter(Source != "DMV Driver's License Surrenders") %>% # <-------TEMPORARY DELETION!
  #mutate(people = replace(people, Source == "Census Population Estimates Program" & year == 2020, 0)) %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
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
  scale_y_continuous(labels = label_comma()) +
  ggtitle("Idaho net migration: 2011-2023") +
  labs(caption = "
       Note: 2020 net migration data unavailable from ACS and Population Estimates Program. PEP expected release November 2024.") 

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/data_comparison/", ("net_migration.png"), dpi = 320) 

# net migration-- PopEst and IRS only
people %>%
  select(year, Source, statistic, people) %>% 
  filter(statistic == "net_migration") %>% 
  mutate(people = if_else(Source == "Census American Community Survey", 0, people), 
         people = if_else(Source == "DMV Driver's License Surrenders", 0, people)) %>% 
  ggplot(aes(x = year, y = people, color = Source)) +
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
  scale_y_continuous(limits = c(1, 53000)) +
  ggtitle("Idaho net migration by data source") 
#labs(caption = "
#     Data sources: IRS Statistics of Income, DMV License Surrenders, Census Population Estimates program, American Community Survey") +

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/data_comparison/", ("net_migration_ACS_PopEst.png"), dpi = 320) 


