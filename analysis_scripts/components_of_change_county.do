** Liz Bageant
** September 13, 2024


** Compiling population and components of change times series at the county level


/*-------------- Vintage 2023 (2020-2023) ------------------------------------*/

import delimited "$pep/PEP county population and components of change/Vintage 2023/co-est2023-alldata.csv", clear

* keep only Idaho
keep if state == 16
* keeping only counties
keep if sumlev == 50

assert popestimate2020 + births2021 - deaths2021 + netmig2021 + residual2021 == popestimate2021 

* reshape file

keep ctyname county popestimate*  births* deaths* netmig* natural* internat* domestic* netmig* residual* npopchg*
gen vintage = 2023

reshape long popestimate births deaths naturalchg internationalmig domesticmig netmig residual npopchg, i(ctyname county) j(year)

rename county cfips
ren ctyname county

save "$temp/temp", replace


/*-------------- Vintage 2019 (2010-2019) ------------------------------------*/

import delimited "$pep/PEP county population and components of change/Vintage 2019/co-est2019-alldata.csv", clear

keep if state == 16 & sumlev == 50

assert popestimate2010 + births2011 - deaths2011 + netmig2011 + residual2011 == popestimate2011 // yes

* reshape file

keep ctyname county popestimate*  births* deaths* netmig* natural* internat* domestic* netmig* residual* npopchg*
gen vintage = 2019

reshape long popestimate births deaths naturalinc internationalmig domesticmig netmig residual npopchg_, i(ctyname county) j(year)

ren county cfips
ren ctyname county
ren npopchg_ npopchg
ren naturalinc naturalchg




/*-------------- Combine files -----------------------------------------------*/

append using "$temp/temp"
save "$temp/temp1", replace

use "$temp/temp1", clear

* generate a "base" estimate that is the starting point for the components of change equation.
* this is a lag. 
* this may be slightly different from what census calls the "base" 
* base_y2 = popest_y1, base_y3 = popest_y2, etc

bys county (year): gen base = popestimate[_n-1]

* components of change for 2020 include only 4/1/2020-7/1/2020. 
* popestimate2020 is the population estimate on 7/1/2020 for each county.
* to address this, I am adding a different category called "components_unknown" and removing the 4/1-7/1 data.
* there may be a better way to do this, but this will make the figure transparent for now.

* look at relationship between popestimate and base. Difference should = npopchg.
gen check = popestimate - base
gen flag = 1 if check != npopchg

tab year flag , miss // only 2010 and 2020. 
* In 2010 it's because base = . for that year.
* In 2020 it's because npopchg contains data from 4/1/20-7/1/20. 
drop check flag

* remove 4/1/2020-7/1/2020 components of change data 
foreach var of varlist births deaths naturalchg netmig residual {
	replace `var' = 0 if year == 2020
	replace `var' = 0 if year == 2010 // removing this too for completeness, though it doesn't enter into our analysis at the moment
}


* 2020 is where components are unknown
gen components_unknown = 0

* total components of change is the difference between the base and the new estimate for that year. 
* replacing for 2020 only because we have components of change data for other years.
replace components_unknown = popestimate - base if year == 2020

tab year if components_unknown != 0 // Only 2020. Correct. 


export delimited using "$analysis_data/components_of_change_county_2010-2023.csv", replace

