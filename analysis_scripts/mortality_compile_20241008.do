** Liz Bageant
** October 8, 2024

** Organizing mortality data

clear all
set more off
version 18

/*-------- IDAHO DEPT. OF HEALTH AND WELFARE ---------------------------------*/

* import IDHW mortality data
	import excel "$data/IDHW/import/2014-2023 Idaho Resident Deaths and Births_Aug 2024.xlsx", sheet("Total Deaths") firstrow clear
	drop V-AM

	* reshape long
	reshape long num rate, i(county) j(year)

	* clean up variable names
	ren num death_num
	ren rate death_rate
	replace county = strtrim(county)
	ren county county_name

	* remove state-level data
	preserve 
	keep if county_name == "IDAHO"
	*save "$analysis_data/mortality//idaho_deaths_2014-2023", replace
	export delimited using "$analysis_data/deaths_crude_idaho_2014-2023.csv", replace

	restore

	drop if county_name == "IDAHO"

	* clean up county names
	do "$project/Pop_Change_Analysis/county_cleaner.do"
	ren county_name county


	*save "$analysis_data/death_by_county_2014-2023", replace
	export delimited using "$analysis_data/deaths_crude_by_county_2014-2023.csv", replace
	
	
* Import IDHW mortality-by-sex data
	import excel "$data/IDHW/import/2014-2023 Idaho Resident Deaths and Births_Aug 2024.xlsx", sheet("Deaths by Sex") firstrow clear
	drop if county == ""
	destring f2014 m2014, replace
	ren *, l
	
	* manual reshape and merge
	
		* female deaths
		preserve 
		keep county f*
		reshape long f, i(county) j(year)
		rename f f_num
		save "$temp/fnum", replace
		restore
		
		* male deaths
		keep county m*
		reshape long m, i(county) j(year)
		rename m m_num
		
		* merge
		merge 1:1 county year using "$temp/fnum"
		drop _mer
		
		
	* remove state-level data
	preserve 
	keep if county == "IDAHO"
	export delimited using "$analysis_data/deaths_crude_idaho_by_sex_2014-2023.csv", replace
	restore

	drop if county == "IDAHO"

	* clean up county names
	ren county county_name
	do "$project/Pop_Change_Analysis/county_cleaner.do"
	ren county_name county
		
	export delimited using "$analysis_data/deaths_crude_by_county_and_sex_2014-2023.csv", replace
		
	
/*-------- IDHW by age -------------------------------------------------------*/

* Calculating age-specific mortality rates
* Calculating age-adjusted mortality rates


* import reference population
import excel "$data/US Standard Population 2000/Standard Population NCHS.xlsx", sheet("pre-2001") clear
drop in 14/18
ren *, l
ren a age_group
ren b ref_pop
ren c proportion
ren d standard_million
drop in 1
drop if age_group == "Total"

save "$data/US Standard Population 2000/standard_population_2000", replace	
	
	

/*-------- CDC WONDER --------------------------------------------------------*/

* import 1999-2020 data file
import excel "$data/CDC WONDER/import/deaths_import.xlsx", sheet("1999-2020") firstrow case(lower) clear
drop notes state statecode yearcode
drop if year == . 
save "$temp/deaths1999-2020", replace

* import 2018-2022 data file
import excel "$data/CDC WONDER/import/deaths_import.xlsx", sheet("2018-2022") firstrow case(lower) clear
drop notes state statecode yearcode
drop if year == . 
save "$temp/deaths2018-2022", replace

* import 2018-2024 provisional data file. 2023 and 2024 data are provisional. 
import excel "$data/CDC WONDER/import/deaths_import.xlsx", sheet("2018-2024p") firstrow case(lower) clear
drop notes residen* year
ren yearcode year
drop if year == . 

append using "$temp/deaths1999-2020"
append using "$temp/deaths2018-2022"

* examine to see whether there are any duplicate years with different values. 
sort year
duplicates drop // dropping duplicate years with identical values
tab year, miss  // each year appears only once. 

*save "$analysis_data/cdc_idaho_deaths_1999-2024", replace
export delimited using "$analysis_data/deaths_crude_idaho_cdc_1999-2024.csv", replace


/*-------- CDC WONDER by age -------------------------------------------------*/


* Calculating age-specific mortality rates
* Calculating age-adjusted mortality rates


/* THIS NEEDS A LOOK WITH FRESH EYES
In order to calculate age-adjusted mortality rates, I first calculate
age-specific mortality rates, which are then weighted by the reference 
population weights and summed to create the age-adjusted weight. 
The age-specific mortality rates require a number of deaths and a population
figure for the age-group for idaho. CDC provides this for all age gropus except
85+. 
Why don't they provide it? 
Documentation says "it's not available" which seems odd because PEP produces this information.
They also offer downloads of the age-adjusted mortality rate so they must be using this
information from somewhere. 
PUZZLING. */

/*

* import 1999-2020 mortality by age data file
import delimited "$data/CDC WONDER/mortality by age/Multiple Cause of Death, 1999-2020.txt", clear 
drop notes cruderate
ren population id_pop
destring id_pop, replace

egen rowmiss = rowmiss(*)
tab rowmiss, miss
drop if rowmiss == 5
drop rowmiss

	* convert five year age groups to 10-year to align with standard population
	gen age_group = ""
	replace age_group = "Under 1" if fiveyearagegroupscode == "1"
	replace age_group = fiveyearagegroupscode if fiveyearagegroupscode == "1-4"
	replace age_group = "5-14" if fiveyearagegroupscode == "5-9" | fiveyearagegroupscode == "10-14"
	replace age_group = "15-24" if fiveyearagegroupscode == "15-19" | fiveyearagegroupscode == "20-24"
	replace age_group = "25-34" if fiveyearagegroupscode == "25-29" | fiveyearagegroupscode == "30-34"
	replace age_group = "35-44" if fiveyearagegroupscode == "35-39" | fiveyearagegroupscode == "40-44"
	replace age_group = "45-54" if fiveyearagegroupscode == "45-49" | fiveyearagegroupscode == "50-54"
	replace age_group = "55-64" if fiveyearagegroupscode == "55-59" | fiveyearagegroupscode == "60-64"
	replace age_group = "65-74" if fiveyearagegroupscode == "65-69" | fiveyearagegroupscode == "70-74"
	replace age_group = "75-84" if fiveyearagegroupscode == "75-79" | fiveyearagegroupscode == "80-84"
	replace age_group = "85 and over" if fiveyearagegroupscode == "85-89" | fiveyearagegroupscode == "90-94" | fiveyearagegroupscode == "95-99" | fiveyearagegroupscode == "100+"

	tab age_group, miss
	
	tab year, miss
	* 2015 5-9 category is suppressed and therefore not shown. IDHW reports 7 deaths in this category in 2015.
	* As of 10/17, proceeding using only CDC WONDER data. Can patch in IDHW deaths later if needed. 

	collapse (sum) deaths id_pop, by(age_group year)



save "$temp/mort1999-2020", replace


* import 2018-last week provisional data
import delimited "$data/CDC WONDER/mortality by age/Provisional Mortality Statistics 2018 through Last Week.txt", clear 
drop in 175/231

drop if notes == "Total"
drop notes year population cruderate

	* convert five year age groups to 10-year to align with standard population
	gen age_group = ""
	replace age_group = "Under 1" if fiveyearagegroupscode == "1"
	replace age_group = fiveyearagegroupscode if fiveyearagegroupscode == "1-4"
	replace age_group = "5-14" if fiveyearagegroupscode == "5-9" | fiveyearagegroupscode == "10-14"
	replace age_group = "15-24" if fiveyearagegroupscode == "15-19" | fiveyearagegroupscode == "20-24"
	replace age_group = "25-34" if fiveyearagegroupscode == "25-29" | fiveyearagegroupscode == "30-34"
	replace age_group = "35-44" if fiveyearagegroupscode == "35-39" | fiveyearagegroupscode == "40-44"
	replace age_group = "45-54" if fiveyearagegroupscode == "45-49" | fiveyearagegroupscode == "50-54"
	replace age_group = "55-64" if fiveyearagegroupscode == "55-59" | fiveyearagegroupscode == "60-64"
	replace age_group = "65-74" if fiveyearagegroupscode == "65-69" | fiveyearagegroupscode == "70-74"
	replace age_group = "75-84" if fiveyearagegroupscode == "75-79" | fiveyearagegroupscode == "80-84"
	replace age_group = "85 and over" if fiveyearagegroupscode == "85-89" | fiveyearagegroupscode == "90-94" | fiveyearagegroupscode == "95-99" | fiveyearagegroupscode == "100+"

	tab age_group, miss

* drop years that overlap with previous data series
drop if year == 2018 | year == 2019 | year == 2020

* dropping 2024 because it includes only partial data
drop if year == 2024

ren yearcode year
tab year, miss

* 2021 5-9 category is suppressed and therefore not shown. IDHW reports 9 deaths in this category in 2021.
* As of 10/17, proceeding using only CDC WONDER data. Can patch in IDHW deaths later if needed. 

collapse (sum) deaths, by(age_group year)

save "$temp/recent", replace


* Combining mortality data files
use "$temp/mort1999-2020", clear
append using "$temp/recent"

* merge with standard 2000 population
merge m:1 age_group using "$data/US Standard Population 2000/standard_population_2000"
destring population proportion standard_million, replace
drop _mer

* Calculate age-specific death rates
gen age_rate = (population/274634000)*(deaths/population)
collapse (sum) age_rate, by(year)
replace age_rate = age_rate*1000


save "$temp/mort1999-2020", replace

*/


/*-------- CDC WONDER pre-calculated age-adjusted rates ----------------------*/

** Idaho level

import excel "$data/CDC WONDER/mortality by age/Age adjusted death rates for import.xlsx", sheet("1999-2020") firstrow case(lower) clear
drop if notes == "Total"
drop notes
destring *, replace
drop yearcode

save "$temp/1999-2020", replace


import excel "$data/CDC WONDER/mortality by age/Age adjusted death rates for import.xlsx", sheet("2018-last week") firstrow case(lower) clear
drop if notes == "Total"
drop notes
drop if yearcode == "2024"
drop year
ren yearcode year
destring *, replace

*keeping only 2021-2023 (years not covered in prior data file)
keep if year >= 2021
append using "$temp/1999-2020"

tab year, miss

export delimited using "$analysis_data/deaths_age_adjusted_idaho_cdc_1999-2023.csv", replace

** US level

import excel "$data/CDC WONDER/mortality by age/Age adjusted death rates for import.xlsx", sheet("US 1999-2020") firstrow case(lower) clear
drop if notes == "Total"
drop notes
destring *, replace
save "$temp/t", replace

import excel "$data/CDC WONDER/mortality by age/Age adjusted death rates for import.xlsx", sheet("US 2018-last week") firstrow case(lower) clear
drop if notes == "Total"
drop notes
destring *, replace
drop year
ren yearcode year

*keeping only 2021-2023 (years not covered in prior data file)
keep if year >= 2021
drop if year == 2024 //partial year

tab year, miss

append using "$temp/t"
drop yearcode

export delimited using "$analysis_data/deaths_age_adjusted_us_cdc_1999-2023.csv", replace











