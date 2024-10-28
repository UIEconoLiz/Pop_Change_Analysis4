## Liz Bageant
## September 3, 2024

## Looking at DMV migration information

data <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/dmv_migration/dmv_migration.csv") %>% 
  mutate(migrants_in = indiv_in,
         migrants_out = indiv_out, 
         net_migrants = net)
  


head(data)  

chartdata <- data %>% 
  pivot_longer(cols = -year, names_to = "group", values_to = "people") 

chartdata$group <- factor(chartdata$group, levels = c("migrants_in", "migrants_out", "net_migrants")) 

chartdata %>% 
  ggplot(aes(x = year, y = people, color = group)) +
  geom_line(size = 2) +
  scale_color_paletteer_d("vangogh::CafeTerrace") +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)) +
  scale_y_continuous(limits = c(0, 92000)) +
  ggtitle("Idaho in-migrants, out-migrants and net migration: DMV data")

ggsave(path = "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/dmv_migration/", ("Idaho_dmv_in_out_net.png"), dpi = 320) 









chartdata2 <- state_data %>% 
  select(year, indiv_in, indiv_out, net_mig_abs) %>% 
  pivot_longer(cols = -year, names_to = "group", values_to = "people") 


chartdata2 %>% 
  ggplot(aes(x = year, y = people, fill = group, color= group)) +
  geom_line() +
  scale_color_viridis(discrete = T, direction = -1) +
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(limits = c(2011, 2023), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) +
  ggtitle("Infow, outflow, net migration: State level")

