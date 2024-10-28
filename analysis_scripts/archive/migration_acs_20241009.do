** Liz Bageant
** October 9, 2024

clear all
set more off
version 18

** Organizing ACS state-to-state files to focus on Idaho --CODE BELOW HAS BEEN INCORPORATED INTO migration_acs_compile_20241009

/*
Notes based on investigations below: 
	pop = same_house + same_state + diff_state + from_abroad
	from-abroad = from_pr + from_usisland + from_foreign
	
Out-migration only includes people who moved to one of the 49 other states + PR and DC. 
Does not include people who moved to another country. 

*/

* General cleaning and investigations

* current_residence = Idaho
use "$acs_migration/processed/acs_state_to_state_2010-2022", clear

* destring 
foreach var of varlist * {
	replace `var' = "" if `var' == "N/A"
	replace `var' = "" if `var' == "N/A1"
	replace `var' = "" if `var' == "N/A2"
	replace `var' = "" if `var' == "N/A3"
	destring `var', replace
}

drop if current_residence == "" // 3 obs dropped, all values missing

* What is the relationship between variables? 
	order *_moe, last

	* What is the relationship between diff_state and other variables?
	* totalling all origin locations and comparing to "diff_state" variable
	egen rowtotal = rowtotal(from_al-from_foreign)
	count if diff_state != rowtotal // browsing, you can see that rowtotal is consistently higher
	count if diff_state >= rowtotal // all rowtotals are > diff_state
	* totaling states only
	egen rowtotal2 = rowtotal(from_al-from_wy)
	count if rowtotal2 != diff_state // they are all equal.
	drop rowtotal*	
		* Conclusion: diff_state does not include migrants from non-US states (e.g. PR, Islands, "abroad" and "foreign"), but does include DC.

	* What is the relationship between from_abroad and from_foreign?
	egen rowtotal = rowtotal(from_pr from_usisland from_foreign)
	count if from_abroad != rowtotal // they are all equal
		* Conclusion: from-abroad = from_pr + from_usisland + from_foreign

	* What is the relationship between population, same_house, same_state, diff_state and from_abroad?
	count if pop == (same_house + same_state + diff_state + from_abroad) // 636 obs--great.
		* Conclusion: pop = same_house + same_state + diff_state + from_abroad

save "$analysis_files/acs_migration/acs_migration_matrix_2010-2022", replace



* Calculate in-migration
use "$analysis_files/acs_migration/acs_migration_matrix_2010-2022", clear

keep year current_residence pop pop_moe same_hous* same_stat* diff_stat* from_abroa*
gen migrants_in = diff_state + from_abroad
gen non_migrants = same_house + same_state
keep if current_residence == "Idaho"
keep year pop migrants_in non_migrants
save "$temp/idaho_in_stay", replace


* Calculate out-migration
use "$analysis_files/acs_migration/acs_migration_matrix_2010-2022", clear
drop if current_residence == "United States1" | current_residence == "United States2"

collapse (sum) from_id, by(year)
ren from_id migrants_out
save "$temp/idaho_out", replace

** Merge and calculate net migration
use "$temp/idaho_in_stay", clear
merge 1:1 year using "$temp/idaho_out"
drop _mer
* net migration
gen net_migration = migrants_in - migrants_out

save "$analysis_files/acs_migration/acs_state_migration_flows", replace	









keep if current_residence == "Idaho"
keep year pop pop_moe same_hous* same_stat* diff_stat*

** Out-migration


** Net migration
