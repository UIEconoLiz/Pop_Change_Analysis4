** Liz Bageant
** September 11, 2024

** Compiling births data by county and by age


import excel "$data/IDHW/import/2014-2023 Idaho Resident Deaths and Births_Aug 2024.xlsx", sheet("Births by Moms Age") firstrow clear


save "$temp/idhw_births", replace

/*-------------- IDAHO TOTALS BY YEAR ----------------------------------------*/

use "$temp/idhw_births", clear

keep if county == "IDAHO"


keep county total*
reshape long total_, i(county) j(year)
ren total_ total_births
ren county state
save "$analysis_data/idhw_births_idaho", replace
*export delimited using "$analysis_data/idhw_births_idaho_2014-2023.csv"

/*-------------- COUNTY TOTALS BY YEAR ---------------------------------------*/

use "$temp/idhw_births", clear

drop if county == "IDAHO"
keep county total*

drop if county == ""
reshape long total_, i(county) j(year)
ren total_ total_births

* clean up counties
ren county county_name
do "$project/Pop_Change_Analysis/county_cleaner.do"
ren county_name county

save "$analysis_data/idhw_births_county", replace
*export delimited using "$analysis_data/idhw_births_county_2014-2023.csv"


/*-------------- IDAHO TOTALS BY YEAR AND AGE OF MOTHER ----------------------*/

use "$temp/idhw_births", clear

keep if county == "IDAHO"
drop total*

reshape long age_1014 age_1519 age_2024 age_2529 age_3034 age_3539 age_4044 age_4549 age_5054 age_5559 age_6064, i(county) j(year)
ren county state

save "$analysis_data/idhw_births_idaho_by_age", replace
*export delimited using "$analysis_data/idhw_births_idaho_by_age_2014-2023.csv"

/*-------------- COUNTY TOTALS BY YEAR AND AGE OF MOTHER ---------------------*/

use "$temp/idhw_births", clear

drop if county == "IDAHO"
drop total*

drop if county == ""
reshape long age_1014 age_1519 age_2024 age_2529 age_3034 age_3539 age_4044 age_4549 age_5054 age_5559 age_6064, i(county) j(year)

* clean up counties
ren county county_name
do "$project/Pop_Change_Analysis/county_cleaner.do"
ren county_name county

save "$analysis_data/idhw_births_county_by_age", replace
*export delimited using "$analysis_data/idhw_births_county_by_age_2014-2023.csv"


/*-------------- BRING IN PEP AGE STRUCTURE DATA ---------------------*/

* State level

	* How many 15-44 year olds are there in Idaho, by year? Using PEP estimates.
	use "$analysis_data/age_5yearbins_county.dta", clear
	keep stname ctyname year popestimate age1519_fem age2024_fem age2529_fem age3034_fem age3539_fem age4044_fem 
	* generate number of females age 15-44
	egen female_1544 = rowtotal(age1519_fem age2024_fem age2529_fem age3034_fem age3539_fem age4044_fem)
	* collapse to state level
	collapse (sum) female_1544 popestimate, by(year)

	* tidy
	drop if year == "2010b" 
	drop if year == "2010c"
	drop if year == "2020b"
	destring year, replace

	* bring in IDHW births data
	merge 1:1 year using "$analysis_data/idhw_births_idaho"

	/*
		Result                      Number of obs
		-----------------------------------------
		Not matched                             4
			from master                         4  (_merge==1) <-- IDHW births only go back to 2014, this is 2010-2014 PEP data
			from using                          0  (_merge==2)

		Matched                                10  (_merge==3)
		-----------------------------------------
	*/

	keep if _mer == 3
	drop _mer

	* Crude birth rate = (births/popest)*1000
	gen br_crude = (total_births/popestimate)*1000

	* Birth rate = (births/women 15-44)*1000
	gen br = (total_births/female_1544)*1000

	export delimited using "$analysis_data/birth_rates_state.csv", replace

	
* County level

	* How many 15-44 year olds are there in Idaho, by county and year? Using PEP estimates.
	use "$analysis_data/age_5yearbins_county.dta", clear
	keep stname ctyname year popestimate age1519_fem age2024_fem age2529_fem age3034_fem age3539_fem age4044_fem 
	* generate number of females age 15-44
	egen female_1544 = rowtotal(age1519_fem age2024_fem age2529_fem age3034_fem age3539_fem age4044_fem)
	* collapse to state level
	collapse (sum) female_1544 popestimate, by(year ctyname)

	* tidy
	drop if year == "2010b" 
	drop if year == "2010c"
	drop if year == "2020b"
	destring year, replace
	rename ctyname county
	
	* bring in IDHW births data
	merge 1:1 year county using "$analysis_data/idhw_births_county"
	
	tab year _mer // all non-merges are prior to 2014 as expected
	keep if _mer == 3
	drop _mer
	
	* Crude birth rate = (births/popest)*1000
	gen br_crude = (total_births/popestimate)*1000

	* Birth rate = (births/women 15-44)*1000
	gen br = (total_births/female_1544)*1000

	export delimited using "$analysis_data/birth_rates_county.csv", replace
	









