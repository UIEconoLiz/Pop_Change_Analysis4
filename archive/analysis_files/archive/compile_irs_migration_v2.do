** Liz Bageant
** August 29, 2024

clear all
set more off
version 18


** Compiling IRS Statistics of Income state migration files


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

global data "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data"
global temp "/Users/elizabethbageant/Desktop/temp"
global do "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"
global irs "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/IRS Statistics of Income/"




/*------------------------------------------------------------------------------
--------- OUTFLOWS -------------------------------------------------------------
------------------------------------------------------------------------------*/



/*------- 2022 ---------------------------------------------------------------*/

import excel "$irs/2011-2022/2122id.xlsx", sheet("County Outflow") cellrange(A7:I857) clear

* dropping notes at bottom of file (last 4 obs)
drop in L
drop in L
drop in L
drop in L

* name variables
ren *,l
ren a origin_sfips
ren b origin_cfips
ren c dest_sfips
ren d dest_cfips
ren e dest_sname
ren f dest_cname
ren g no_returns
ren h no_indiv
ren i agi

gen year = 2022
gen direction = "outflow"

* destring
desc
destring origin_sfips, replace

* replacing suppressed values with missing and destring
foreach var of varlist no_returns no_indiv agi {
	count if `var' == "" 
	assert r(N) == 0 // confirming that there are not other missing values
	replace `var' = "" if `var' == "d"
	destring `var', replace
}

* addressing "Other Flows" (see note at top)
drop if dest_cname == "Other flows - Northeast"
drop if dest_cname == "Other flows - Midwest"
drop if dest_cname == "Other flows - South"
drop if dest_cname == "Other flows - West"

* dropping header rows (see note at top)
drop if strpos(dest_cname, "Total")>0
drop if strpos(dest_cname, "Non-migrants")>0

save "$temp/irs2022out", replace



/*------------------------------------------------------------------------------
--------- INFLOWS --------------------------------------------------------------
------------------------------------------------------------------------------*/


/*------- 2022 ---------------------------------------------------------------*/

import excel "$irs/2011-2022/2122id.xlsx", sheet("County Inflow") cellrange(A7:I946) clear

* dropping notes at bottom of file (last 4 obs)
drop in L
drop in L
drop in L
drop in L

* name variables
ren *,l
ren a dest_sfips
ren b dest_cfips
ren c origin_sfips
ren d origin_cfips
ren e origin_sname
ren f origin_cname
ren g no_returns
ren h no_indiv
ren i agi

gen year = 2022
gen direction = "inflow"

* destring
desc
destring dest_sfips, replace

* replacing suppressed values with missing and destring
foreach var of varlist no_returns no_indiv agi {
	count if `var' == "" 
	assert r(N) == 0 // confirming that there are not other missing values
	replace `var' = "" if `var' == "d"
	destring `var', replace
}


* addressing "Other Flows" (see note at top)
drop if origin_cname == "Other flows - Northeast"
drop if origin_cname == "Other flows - Midwest"
drop if origin_cname == "Other flows - South"
drop if origin_cname == "Other flows - West"

* dropping header rows (see note at top)
drop if strpos(origin_cname, "Total")>0
drop if strpos(origin_cname, "Non-migrants")>0


save "$temp/irs2022in", replace





/*------------------------------------------------------------------------------
--------- SUMMARIZE ------------------------------------------------------------
------------------------------------------------------------------------------*/

** INFLOWS

use "$temp/irs2022in", clear

collapse (sum) no_returns no_indiv agi, by(dest_cfips year)

gen cfips = dest_cfips

merge 1:1 cfips using "$data/FIPS codes/State administrative regions.dta", keepusing(cfips county_name)
drop _mer cfips

ren county_name dest_cname


** OUTFLOWS

use "$temp/irs2022out",clear

collapse (sum) no_returns no_indiv agi, by (origin_cfips year)

gen cfips = origin_cfips

merge 1:1 cfips using "$data/FIPS codes/State administrative regions.dta", keepusing(cfips county_name)
drop _mer cfips

ren county_name origin_cname





