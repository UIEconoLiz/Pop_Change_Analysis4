** Liz Bageant
** September 10, 2024

** Organizing mortality data

clear all
set more off
version 18

global data "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data"
global temp "/Users/elizabethbageant/Desktop/temp"
global do "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"


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
	save "$analysis_files/mortality//idaho_deaths_2014-2023", replace
	export delimited using "$analysis_files/mortality//idaho_deaths_2014-2023.csv", replace

	restore

	drop if county_name == "IDAHO"

	* clean up county names
	do "$do/analysis_files/county_cleaner"
	ren county_name county


	save "$analysis_files/mortality/death_by_county_2014-2023", replace
	export delimited using "$analysis_files/death_by_county_2014-2023.csv", replace
	
	
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
		
	export delimited using "$analysis_files/death_by_county_and_sex_2014-2023.csv", replace
		
	

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

save "$analysis_files/mortality/cdc_idaho_deaths_1999-2024", replace
export delimited using "$analysis_files/mortality/cdc_idaho_deaths_1999-2024.csv", replace



