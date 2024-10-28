## Liz Bageant
## October 9, 2024


# Plotting ACS in-, out- and net migration 

# Bring in data

acs <- read.csv(paste(datapath, "migration_acs_2010-2022.csv", sep = ""))


# Plot 
acs %>% 
  select(-pop, -non_migrants) %>% 
  pivot_longer(cols = c(migrants_in, migrants_out, net_migration), names_to = "group", values_to = "number") %>% 
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
  labs(caption = "Data source: American Community Survey. \nNet migration is the difference between in-migration and out-migration.") + 
  ylab("Number of people") +
  xlab("")

ggsave(path = outputpath, "migration/state_acs_in_out_net.png", dpi = 320, height = 5, width = 7) 


