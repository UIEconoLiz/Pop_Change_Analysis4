## Liz Bageant

## October 7, 2024

## Demography master file
library(usethis)
library(viridis)
library(gfonts)
library(hrbrthemes)
library(tidyverse)
library(forcats)
library(RColorBrewer)
library(paletteer)
library(scales)
library(naniar)
library(readxl)
library(usmap)  
library(sf)
library(pals)


# File path
datapath <- "/Users/elizabethbageant/Library/CloudStorage/OneDrive-UniversityofIdaho/MAIN/Projects/Growth in Idaho 2024/Pop_Change_Analysis/analysis_data/"
outputpath <- "/Users/elizabethbageant/Library/CloudStorage/OneDrive-UniversityofIdaho/MAIN/Projects/Growth in Idaho 2024/Pop_Change_Analysis/analysis_output/"

# Color paletteer explorer: https://r-graph-gallery.com/color-palette-finder.html
# Colors in scale_color_paletteer_d("vangogh::CafeTerrace") #024873FF, #A2A637FF, #D9AA1EFF, #D98825FF, #BF4F26FF

#PrettyCols::Bright #462255FF, #FF8811FF, #9DD9D2FF, #046E8FFF, #D44D5CFF

# Files in order:

source(theme_liz.R)

# Population change 
source(components_of_change_county_20241007.R)
source(components_of_change_state_20241008.R)
source(pop_pyramids_20241010.R)
source(housing_units_20241010.R)
source(birth_rates_20241007.R)
source(mortality_20241008.R)
source(mortality_by_sex_20241008.R)
source(mortality_comparison.R)
source(migration_irs_all_states_20241009.R)
source(migration_irs_state_20241009.R)
source(migration_irs_county_20241009.R)
source(migration_acs_state_20241009.R)
source(migration_comparison_20241010.R)



