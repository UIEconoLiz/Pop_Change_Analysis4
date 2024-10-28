## Liz Bageant
## October 9, 2024

# Visualizing IRS migration data at the state level


# BRING IN DATA

state_data <- read.csv(paste(datapath, "migration_irs_state_2012-2022.csv", sep = "")) %>% 
  # calculate turnover, outflow and inflow ratios
  mutate(turnover = (indiv_in + indiv_out)/indiv_stay) %>% 
  mutate(outflow = indiv_out/indiv_stay) %>% 
  mutate(inflow = indiv_in/indiv_stay) %>% 
  mutate(net_mig_abs = indiv_in - indiv_out) %>% 
  mutate(net_mig_ratio = (indiv_in - indiv_out)/indiv_stay) %>% 
  filter(!(year %in% c(2015, 2017))) # dropping 2015 and 2017 due to data quality issues
  


#---- In-, out- and net-migration over time ----#

state_data %>% 
  select(year, indiv_in, indiv_out, net_mig_abs) %>% 
  pivot_longer(cols = c(indiv_in, indiv_out, net_mig_abs), names_to = "group", values_to = "number") %>% 
  ggplot(aes(x = year, y = number, color = group)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  scale_color_manual(values = c("#009392FF", "#9CCB86FF", "#EEB479FF"), 
                     labels = c("In-migration", "Out-migration", "Net Migration"), 
                     name = "") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2012, 2022), breaks = c(2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  ggtitle("Idaho in-migration, out-migration and net-migration") +
  labs(caption = "Data source: IRS Statistics of Income. Years 2015 and 2017 are excluded for data quality reasons. \nNet migration is the difference between in-migration and out-migration.") + 
  ylab("Number of people") +
  xlab("")
       
ggsave(path = outputpath, "migration/state_irs_in_out_net.png", dpi = 320,width = 7, height = 5) 



#---- In-flow, out-flow and turnover ratios over time ----#

state_data %>% 
  select(year, turnover, outflow, inflow) %>% 
  pivot_longer(cols = turnover:inflow, names_to = "group", values_to = "ratio") %>% 
  ggplot(aes(x = year, y = ratio, color = group)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  scale_color_manual(values = c("#009392FF", "#9CCB86FF", "#EEB479FF"), 
                     labels = c("Inflow", "Outflow", "Turnover"), 
                     name = "Ratio") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2012, 2022), breaks = c(2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  #scale_y_continuous(limits=c(0,0.31)) + ## This is the scale used in county figures for comparison
  scale_y_continuous(limits = c(0, 0.12)) + ## this is the scale that better fits the data
  ggtitle("Idaho inflow, outflow and turnover ratios") +
  labs(caption = "Data source: IRS Statistics of Income. Years 2015 and 2017 are excluded for data quality reasons. \nInflow, outflow and turnover ratios are defined relative to the population that does not move. \nInflow = in-migrants/non-movers. Outflow = out-migrants/non-movers. \nTurnover = (inflow + outflow)/non-movers.")

ggsave(path = outputpath, "migration/state_irs_turnover.png", dpi = 320) 


