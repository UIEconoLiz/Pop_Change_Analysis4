** Liz Bageant
** August 1, 2024

clear all
set more off
version 18

global data "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data"
global temp "/Users/elizabethbageant/Desktop/temp"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"


** Exploratory analysis of demographic projections for Idaho

/*
1. Import Idaho Department of Labor population projections for 2024 and 2019
2. Import Census population estimates for 2019-2023
	- If you want to do regional analysis, aggregate up to IDOL regions. 
3. Make graphs comparing the predicted to actual and/or two predictions, depending on the year.
*/


*** Import IDOL pop projections

** 2019

import excel "$data/IDOL projections/2019/State-Forecast_for_import.xlsx", sheet("age_by_region") firstrow clear

ren *,l
ren b y2019
ren c y2020
ren d y2021
ren e y2022
ren f y2023
ren g y2024
ren h y2025
ren i y2026
ren j y2027
ren k y2028
ren l y2029

reshape long y, i(age idol_region) j(year)

ren y  pop_proj_2019

sort year

save "$temp/age_region_2019", replace

* collapse to region (drop age)
collapse (sum) pop_proj, by(idol_region year)

save "$temp/idol_region_2019", replace

** 2024

import excel "$data/IDOL projections/2024/Idaho Statewide_for_import.xlsx", sheet("age_by_region") firstrow clear

ren *,l

ren	b	y2022
ren	c	y2023
ren	d	y2024
ren	e	y2025
ren	f	y2026
ren	g	y2027
ren	h	y2028
ren	i	y2029
ren	j	y2030
ren	k	y2031
ren	l	y2032

reshape long y, i(age idol_region) j(year)

ren y  pop_proj_2024

save "$temp/age_region_2024", replace

* collapse to region (drop age)
collapse (sum) pop_proj, by(idol_region year)

save "$temp/idol_region_2024", replace




*** Import Census population estimates 2019-2023

import delimited "$data/Census Pop Est by County Vintage 2023/co-est2023-alldata.csv", clear 

keep if stname == "Idaho"

keep state county stname ctyname estimatesbase2020 popestimate2020 popestimate2021 popestimate2022 popestimate2023

ren state state_fips
ren county county_fips

save "$analysis_files/census_vintage2023", replace

* bring in county-level file to aggregate up to IDOL regions

import excel "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/State administrative regions.xlsx", sheet("Sheet1") firstrow clear
ren FIPS county_fips

replace idol_region = "East" if idol_region == "EASTERN"
replace idol_region = "North" if idol_region == "NORTHERN"
replace idol_region = "North Central" if idol_region == "NORTH_CENTRAL"
replace idol_region = "Southeast" if idol_region == "SOUTHEASTERN"
replace idol_region = "Southwest" if idol_region == "SOUTHWESTERN"
replace idol_region = "South Central" if idol_region == "SOUTH_CENTRAL"
tab idol_region, miss
drop if idol_region == ""

save "$analysis_files/administrative_regions", replace

* merge census data with IDOL region data

use "$analysis_files/census_vintage2023", clear
merge 1:1 county_fips using "$data/administrative_regions"

** collapse population estimates by IDOL region

collapse (sum) estimatesbase popest*, by(idol_region)

drop if idol_region == ""

drop estimatesbase //this is 4/1/2020 population. We will use 7/1/2020 estimate.

reshape long popestimate, i(idol_region) j(year)

ren popestimate census_estimate

save "$temp/census_region_vintage2023", replace


**** Merge Census and IDOL data

cd $temp
use census_region_vintage2023, clear

* idol 2024
merge 1:1 idol_region year using idol_region_2024

list if _mer == 2 & year == 2022
list if _mer == 2 & year == 2023
drop if idol_region == "Idaho" 

drop _mer

* idol 2019

merge 1:1 idol_region year using idol_region_2019

drop if idol_region == "Idaho"
drop _mer

save "$temp/regions_all", replace

tab year // there should be 6 obs per year. 

collapse (sum) census pop_proj*, by(year)

foreach var of varlist census pop_proj* {
	replace `var' = . if `var' == 0
}

la var census_estimate "Census (Vin. 2023)"
la var pop_proj_2019 "IDOL 2019 proj"
la var pop_proj_2024 "IDOL 2024 proj"


line census pop_pro* year if year <=2026, cmissing(n) title("Comparison of Idaho's population projection data")





