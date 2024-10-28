** Liz Bageant
** August 14, 2024


* UPDATE 9/17/2024: THIS SHOULD PROBABLY BE RE-DONE USING PEP COUNTY ESTIMATES FILES.

clear all
set more off
version 18


** Organizing data to create population pyramids (which will be done in R)


/*------------ 2000 Census Counts --------------------------------------------*/

import excel "$pep/st-est2002-asro-02-16.xls", sheet("import") firstrow clear

* This file is already in good shape. No cleaning needed. 

* save a file for use in R
export delimited using "$analysis_data/age_sex_pop_pep_2000.csv", replace


/*------------ 1980 and 1990 Census Counts -----------------------------------*/

* This text file has a lot of issues. 

import excel "$pep/s5yr8090_idaho_import", sheet("import") firstrow clear 

rename *, l

keep a b m

ren a age_group
ren b censuspop_1980
ren m censuspop_1990

drop in 1/20 //d eleting total population
gen gender = ""
replace gender = "mpop" in 1/18
replace gender = "fpop" in 20/37
drop if gender == ""

* save a file for use in R
export delimited age_group censuspop_1980 gender using "$analysis_data/age_sex_pop_pep_1980.csv", replace
export delimited age_group censuspop_1990 gender using "$analysis_data/age_sex_pop_pep_1990.csv", replace



/* CURRENTLY NOT USING AS OF 10/10/24
/*------------ 2010 ACS Five Year Estimates ----------------------------------*/

import excel "$data/Census population by age and sex/Five year estimates/ACSST5Y2010.S0101-2024-08-14T182828.xlsx", sheet("import") firstrow clear


* add some identifying data
gen state = "Idaho"
gen year = 2010
gen acs_type = "5 year estimate"

* Drop all % characters and destring
foreach var in pct_total pct_mpop pct_fpop {
	replace `var' = subinstr(`var', "%", "", .)
	destring `var', replace
	replace `var' = `var'/100
	}


* rename and destring totalpop
ren totalpop idahopop
replace idahopop = subinstr(idahopop, "," , "", .)
destring idahopop, replace

* destring MOEs
foreach var in moe_totalpop moe_mpop moe_fpop {
	replace `var' = usubstr(`var', 2, 3) // unicode substring
	destring `var', replace
}


* calculate the number of people in each age category, total and by sex
gen totalpop = idahopop*pct_total
gen mpop = totalmpop*pct_mpop
gen fpop = totalfpop*pct_fpop


order age_group totalpop mpop fpop

* Check: do male and female pop estimates align with total pop for each age category?
gen check = mpop + fpop
gen diff = check - totalpop 
sum diff, d // there are some differences
gen pct_diff = diff/totalpop 
sum pct_diff, d // max difference is 3.3%, smallest diff is functionally zero.

* save a file for use in R (As of 10/10/2024 we are not using this)
*export delimited age_group totalpop mpop fpop using "$analysis_data/idaho_pop_by_agesex_acs5year_2010.csv", replace


/*------------ 2022 ACS Five Year Estimates ----------------------------------*/

import excel "$data/Census population by age and sex/Five year estimates/ACSST5Y2022.S0101-2024-08-14T184338.xlsx", sheet("import") firstrow clear

* add some identifying data
gen state = "Idaho"
gen year = 2022
gen acs_type = "5 year estimate"

drop if age_group == ""

* destring fpop
replace fpop = subinstr(fpop, "," , "", .)
destring fpop, replace


* save a file for use in R (As of 10/10/2024 we are not using this)
*export delimited age_group totalpop mpop fpop using "$analysis_data/idaho_pop_by_agesex_acs5year_2022.csv", replace

*/




