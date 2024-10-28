## Liz Bageant
## September 12, 2024

## Looking at the inflow/outflow patterns over time by state
## Interested in whether there is a spike in 2017 for all states

data <- read.csv("/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/state_inflows_outflows.csv") %>% 
  mutate(sfips = as.factor(sfips)) 
  

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






data %>% 
  ggplot(aes(x = year, y = indiv_in_standardized, group = sfips, color = sfips)) +
  geom_line() +
  scale_color_viridis_d()

