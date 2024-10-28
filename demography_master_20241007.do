** Liz Bageant
** October 7, 2024

** Master file for Population Change in Idaho IaaG and DEQ Growth and Infrastructure projects


clear all
set more off
version 18

* umbrella file
global project "/Users/elizabethbageant/Library/CloudStorage/OneDrive-UniversityofIdaho/MAIN/Projects/Growth in Idaho 2024"

* sub-folders
global temp "/Users/elizabethbageant/Desktop/temp"
global data "$project/Pop_Change_Analysis/raw_data"
global do "$project/Pop_Change_Analysis/analysis_scripts"
global analysis_files "$project/Pop_Change_Analysis/analysis_files"
global analysis_data "$project/Pop_Change_Analysis/analysis_data"

global pep "$data/Census PEP"
global irs_import "$data/IRS Statistics of Income/2011-2022/import"



/*---- Census PEP ----*/

* Compile population and components of change files
do "$do/components_of_change_county.do"
do "$do/components_of_change_state.do"

	* Data visualization done in R:
		* components_of_change_county_20241007.R
		* components_of_change_state_20241008.R

* Age and sex
do "$do/pep_age_sex_20241007.do" // must run before births files
do "$do/pop_pyramid_compile_20241010.do" 

	* Data visualization done in R:
		* pop_pyramids_20241010.R


* Housing units
do "$do/housing_units_compile_20241009.do"

	* Data visualization done in R:
		* housing_units_20241010.R


/*---- Births ----*/

* Compile IDHW births data and calculate birth rates by county and state
do "$do/births_compile_20241007.do"

	* Data visualization done in R:
		* birth_rates_20241007.R
		
	
/*---- Deaths ----*/

do "$do/mortality_compile_20241008.do"

	* Data visualization done in R:
		* mortality_20241008.R
		* mortality_by_sex_20241008.R
		* mortality_comparison.R // compare CDC, IDHW and Census mortality figures. Somewhat outdated but may be useful in the future. 
	
	
/*---- Migration ----*/


* IRS

* Compile migration data
do "$do/migration_irs_compile_20241008.do"
do "$do/migration_irs_all_states_20241008.do"

	* Data visualization done in R:
		* migration_irs_all_states_20241009.R // Looks at trends in all US states to understand 2015 and 2017 data glitches
		* migration_irs_state_20241009.R
		* migration_irs_county_20241009.R


* ACS
do "$do/migration_acs_compile_20241009.do"

	* Data visualization in R:
		* migration_acs_state_20241009.R


* DMV--update with Jaap's data if you get it.
do "$do/migration_dmv_compile_20241010.do"




* USPS COA


* LIGHTCAST



* MIGRATION COMPARISON--in R
* migration_comparison_20241010.R

	
	
