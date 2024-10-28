## Liz Bageant
## October 8, 2024

## Looking at the inflow/outflow patterns over time by state
## Interested in whether there is a spike in 2017 for all states


data <- read.csv(paste(datapath, "migration_irs_all_states.csv", sep = "")) %>% 
  mutate(sfips = as.factor(sfips))  


# Inflows
data %>% 
  group_by(sfips) %>% 
  mutate(scaled = (indiv_in - mean(indiv_in))/sd(indiv_in)) %>% 
  ggplot(aes(x = year, y = scaled, group = sfips, color = sfips)) +
  geom_line() +
  scale_color_viridis_d() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0), 
        legend.position = "none") +
  ggtitle("Migration inflows: 2014-2022 (standardized)")



data %>% 
  ggplot(aes(x = year, y = indiv_in, group = sfips, color = sfips)) +
  geom_line() +
  scale_color_viridis_d() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0), 
        legend.position = "none") +
  ggtitle("Migration inflows: 2014-2022 (raw)")


# Outflows
data %>% 
  group_by(sfips) %>% 
  mutate(scaled = (indiv_out - mean(indiv_out))/sd(indiv_out)) %>% 
  ggplot(aes(x = year, y = scaled, group = sfips, color = sfips)) +
  geom_line() +
  scale_color_viridis_d() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0), 
        legend.position = "none") +
  ggtitle("Migration outflows: 2014-2022 (standardized)")



data %>% 
  ggplot(aes(x = year, y = indiv_out, group = sfips, color = sfips)) +
  geom_line() +
  scale_color_viridis_d() +
  theme_liz() +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0), 
        legend.position = "none") +
  ggtitle("Migration outflows: 2014-2022 (raw)")
