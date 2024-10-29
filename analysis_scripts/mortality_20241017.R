## Liz Bageant
## October 17, 2024

## Visualize mortality data
# 1. State and national age-adjusted mortality figure
# 2. State and national crude mortality figure



# import data

id <- read.csv(paste(datapath, "deaths_crude_idaho_2014-2023.csv", sep = ""))
us_cdc <- read.csv(paste(datapath, "deaths_age_adjusted_us_cdc_1999-2023.csv", sep = ""))  %>% 
  mutate(geo = "US") # includes both age-adjusted and crude
id_cdc <- read.csv(paste(datapath, "deaths_age_adjusted_idaho_cdc_1999-2023.csv", sep = "")) %>% 
  mutate(geo = "ID")

# combine idaho and US into a single long file

cdc <- id_cdc %>% 
  rbind(us_cdc) %>% 
  select(year, cruderate, ageadjustedrate, geo) %>% 
  pivot_longer(cols = c(cruderate, ageadjustedrate), names_to = "rate_type", values_to = "rate"  )

#---------------- AGE ADJUSTED DEATH RATES ------------------------------------#

cdc %>% 
  filter(rate_type == "ageadjustedrate") %>% 
  ggplot(aes(x = year, y = rate, group = geo, color = geo)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme_liz() +
  scale_color_manual(values = c("#d7003f", "#261882"), 
                     labels = c("Idaho", "U.S."), 
                     name = "Deaths per 1000 people") +
  #scale_y_continuous(limits = c(7, 10.5)) +
  theme(axis.text.x = element_text(angle = 45)) +
  theme(plot.caption=element_text(hjust = 0)) +
  ggtitle("Age adjusted deaths per 1000: Idaho and U.S.") +
  labs(caption = "Data source: CDC WONDER") +
  xlab("") +
  ylab("Deaths per 1000 people")


ggsave(path = outputpath, "deaths/deaths_age_adjusted_US_ID_CDC.png", dpi = 320, height = 7, width = 13) 


#---------------- CRUDE DEATH RATES -------------------------------------------#

cdc %>% 
  filter(rate_type == "cruderate") %>% 
  ggplot(aes(x = year, y = rate, group = geo, color = geo)) +
  geom_line(size = 2) +
  geom_point(size = 4) +
  theme_liz() +
  scale_color_manual(values = c("#FF8C00", "#462255FF"), 
                     labels = c("Idaho", "U.S."), 
                     name = "Deaths per 1000 people") +
  scale_y_continuous(limits = c(7, 10.5)) +
  ggtitle("Crude deaths per 1000: Idaho and U.S.") +
  labs(caption = "Data source: CDC WONDER") +
  xlab("") +
  ylab("Deaths per 1000 people")


ggsave(path = outputpath, "deaths/deaths_crude_US_ID_CDC.png", dpi = 320, height = 7, width = 13) 

