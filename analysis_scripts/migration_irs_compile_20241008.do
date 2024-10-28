** Liz Bageant
** August 29, 2024

clear all
set more off
version 18


** Compiling IRS Statistics of Income state migration files from 2012-2022


/* Notes from documentation

AGI is in thousands of dollars

Number of individuals: "Beginning in 2018, personal exemption deductions were suspended 
for the primary, secondary, and dependent taxpayers. However, the 
data used to create the "Number of individuals"—filing status, dependent 
status indicator, and identifying dependent information—are still available 
on the Form 1040. This field is based on these data."

Counties with less than 20 returns are aggregated into various "Other
Flows" categories. The Other Flows categories are Same State, Different State, Foreign, as well
as by region (Northeast, Midwest, South, and West).

Data will be removed from the State files only if the counts are below a threshold of 10 returns.
Records may be removed at the county level that are not removed at the State level. As such,
the county totals may not add to the State totals

"Other flows" categories contain data that are not captured elsehwere, but are 
not mutually exclusive. "Other flows - Different State" ist he total of the regional
categories, so both "Different State" and regional should not be counted simultaneously.

There are six header rows for each county that will be dropped in these files (but
may be useful elsewhere) as they are totals of other data in this file.

*/



/*------------------------------------------------------------------------------
--------- OUTFLOWS -------------------------------------------------------------
------------------------------------------------------------------------------*/



/*----- COUNTY LEVEL ---------------------------------------------------------*/
	
	* Import, tidy and standardize 2012-2022 county outflow files
		/* Note: Import files had headers and footers removed manually in 
		   excel to facilitate this step. */

		cd "$irs_import"

		forv i = 2012/2022 {
			import excel id`i', firstrow sheet("County Outflow") clear
			
			* drop any extra rows
			egen rowmiss = rowmiss(*)
			drop if rowmiss == 9
			drop rowmiss
			
			* create year variable
			gen year = `i'
			
			* replacing suppressed values with missing and destring
			foreach var of varlist returns indiv agi {
				di "`var'"
				count if `var' == "" 
				assert r(N) == 0 // confirming that there are no other missing values
				replace `var' = "" if `var' == "d"
				destring `var', replace
			}
			
			* addressing "Other Flows" (see note at top)
			drop if dest_cname == "Other flows - Northeast"
			drop if dest_cname == "Other flows - Midwest"
			drop if dest_cname == "Other flows - South"
			drop if dest_cname == "Other flows - West"
			
			* pulling out non-migrants and saving separately
				preserve

				keep if strpos(dest_cname, "Non-migrants")>0
				rename returns_out returns_stay
				rename indiv_out indiv_stay
				rename agi_out agi_stay

				gen cfips = dest_cfips
				keep cfips year returns_stay indiv_stay agi_stay
				save "$temp/nonmig`i'", replace

				restore
			
			* pulling out state-level totals and saving separately
				preserve
				keep if strpos(dest_cname, "Total Migration-US and Foreign")>0
				collapse (sum) returns indiv_out agi_out, by(year)
				save "$temp/state`i'_out", replace
				restore
			
			* dropping header rows (see note at top)
			drop if strpos(dest_cname, "Total")>0
			drop if strpos(dest_cname, "Non-migrants")>0
			
			* 2014 file contains duplicate observations
			if `i' == 2014 {
				duplicates drop
				}

			* check identifiers
			isid origin_cfips dest_cfips dest_sfips

			save "$temp/irs`i'_out", replace

		}

	* Append county outflows
		use "$temp/irs2012_out", clear

		forv i = 2013/2022 {
			append using "$temp/irs`i'_out"
		}
		
		gen cfips = origin_cfips

*		save "$irs/processed/county_outflows_2012-2022", replace
save "$temp/county_outflows_2012-2022", replace

		
	* Append county non-migrants
		use "$temp/nonmig2012", clear
		
		forv i = 2013/2022 {
			append using "$temp/nonmig`i'"
		}

*		save "$irs/processed/county_nonmigrants_2012-2022", replace
save "$temp/county_nonmigrants_2012-2022", replace



/*------------------------------------------------------------------------------
--------- INFLOWS --------------------------------------------------------------
------------------------------------------------------------------------------*/

/*----- STATE LEVEL ----------------------------------------------------------*/



/*----- COUNTY LEVEL ---------------------------------------------------------*/

	* Import, tidy and standardize 2012-2022 county inflow files
		/* Note: Import files had headers and footers removed manually in 
		   excel to facilitate this step. */

	cd "$irs_import"

	forv i = 2012/2022 {
		import excel id`i', firstrow sheet("County Inflow") clear
		
		* drop any extra rows
		egen rowmiss = rowmiss(*)
		tab rowmiss
		drop if rowmiss == 9
		drop rowmiss
		
		* create year variable
		gen year = `i'
		
		* replacing suppressed values with missing and destring
		foreach var of varlist returns indiv agi {
			di "`var'"
			count if `var' == "" 
			assert r(N) == 0 // confirming that there are no other missing values
			replace `var' = "" if `var' == "d"
			destring `var', replace
		}

		* addressing "Other Flows" (see note at top)
		drop if origin_cname == "Other flows - Northeast"
		drop if origin_cname == "Other flows - Midwest"
		drop if origin_cname == "Other flows - South"
		drop if origin_cname == "Other flows - West"

		* pulling out state-level totals and saving separately
		preserve
		keep if strpos(origin_cname, "Total Migration-US and Foreign")>0
		collapse (sum) returns indiv agi, by(year)
		save "$temp/state`i'_in", replace
		restore
		
		* dropping header rows (see note at top)
		drop if strpos(origin_cname, "Total")>0
		drop if strpos(origin_cname, "Non-migrants")>0
		
		* 2014 file contains duplicate observations
		if `i' == 2014 {
			duplicates drop
			}


		* check identifiers
		isid dest_cfips origin_cfips origin_sfips

		save "$temp/irs`i'_in", replace

	}

	* Append inflows
		use "$temp/irs2012_in", clear

		forv i = 2013/2022 {
			append using "$temp/irs`i'_in"
		}
		
		gen cfips = dest_cfips
		
*		save "$irs/processed/county_inflows_2012-2022", replace
save "$temp/county_inflows_2012-2022", replace


/*------------------------------------------------------------------------------
--------- COMBINE ------------------------------------------------------------
------------------------------------------------------------------------------*/

*cd "$irs/processed"
cd "$temp"

* collapsing data to county level and combining
	use county_inflows_2012-2022.dta, clear
	collapse (sum) returns indiv agi, by(cfips year)
	save "$temp/in", replace

	use county_outflows_2012-2022.dta, clear
	collapse (sum) indiv agi, by(cfips year)
	save "$temp/out", replace

* merge
	use "$temp/in", clear
	merge 1:1 cfips year using "$temp/out"
	drop _mer
	* bring in non-migrants
*	merge 1:1 cfips year using "$irs/processed/county_nonmigrants_2012-2022"
merge 1:1 cfips year using "$temp/county_nonmigrants_2012-2022"
	drop _mer
	* bring in county names
	merge m:1 cfips using "$data/FIPS codes/State administrative regions.dta", keepusing(cfips county_name)
	drop _mer

* Identifying and addressing suppressed values
	gen tag = . 
	foreach var of varlist return* indiv* agi* {
		replace tag = 1 if `var' == 0
		}
	tab tag

	* Clark County (33) has many suppressed values. These end up being 0s in the data. 
	* Changing them to missing. 

	foreach var of varlist return* indiv* agi* {
		replace `var' = . if `var' == 0 & cfips == 33
		}

	* Fairfield County (25) has two suppressed values that end up being 0s in the data. 
	* Changing them to missing. 
	foreach var of varlist return* indiv* agi* {
		replace `var' = . if `var' == 0 & cfips == 25
		}

	* checking
	list return* indiv* agi* if tag == 1, clean noobs
	drop tag
	

*save "$analysis_files/irs_migration/county_in_out_stay_2012-2022", replace
*export delimited using "$analysis_data/irs_migration/county_in_out_stay_2012-2022.csv", replace
export delimited using "$analysis_data/migration_irs_county_2012-2022.csv", replace


/*----------------------------------------------------------------------------*/
/*----- STATE LEVEL ----------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

* Note: State level file processing structure is different from county process
* above because files and processing are simpler,

cd "$irs_import"

* Outflows and non-migrants

forv i = 2012/2022 {

	import excel id`i', firstrow sheet("State Outflow") clear
		
	* create year variables
	gen year = `i'

	* keeping only total migrants 
		preserve
		
		keep if strpos(sname, "US and Foreign")
		
		* destring
		foreach var of varlist returns indiv agi {
			destring `var', replace
		}

		keep returns indiv agi year

		save "$temp/outmig`i'", replace
		restore

	* keeping only non-migrants
	keep if strpos(sname, "Non-migrants")
	rename returns_out returns_stay
	rename indiv_out indiv_stay
	rename agi_out agi_stay
	
	* destring
		foreach var of varlist returns indiv agi {
			destring `var', replace
		}

	keep returns indiv agi year
	
	save "$temp/nomig`i'", replace
}

* Inflows 

forv i = 2012/2022 {
	import excel id`i', firstrow sheet("State Inflow") clear

	* drop any extra rows
		egen rowmiss = rowmiss(*)
		drop if rowmiss == 7
		drop rowmiss

	* create year variables
	gen year = `i'

	* keeping only total migrants 
	keep if strpos(sname, "US and Foreign")
	
	* destring
		foreach var of varlist returns indiv agi {
			destring `var', replace
		}

	keep returns indiv agi year

	save "$temp/inmig`i'", replace
}

* append

cd "$temp"

* append outflows

	use outmig2012, clear

	forv i = 2013/2022 {
		append using outmig`i'
		}
		
	save outmig, replace

* append inflows
	use inmig2012, clear

	forv i = 2013/2022 {
		append using inmig`i'
	}

	save inmig, replace

* append non-migrants
	use nomig2012, clear
	
	forv i = 2013/2022 {
		append using nomig`i'
	}

	save nomig, replace

* merge all

use outmig, clear
merge 1:1 year using inmig
drop _mer
merge 1:1 year using nomig
drop _mer

*save "$analysis_files/irs_migration/state_migration_flows_2012-2022", replace
*save "$irs/processed/state_migration_flows_2012-2022", replace
*export delimited using "$analysis_files/irs_migration/state_migration_flows_2012-2022.csv", replace
export delimited using "$analysis_data/migration_irs_state_2012-2022.csv", replace

