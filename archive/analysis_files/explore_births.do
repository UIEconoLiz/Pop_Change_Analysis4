** Liz Bageant
** August 13, 2024


clear all
set more off
version 18

global data "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data"
global temp "/Users/elizabethbageant/Desktop/temp"
global do "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"


** Exploring natality information for Idaho

/* Exploring the county-level data that are availble. 
We have finalized county-level data from 2007-2022. 
There is no county-level provisional data for 2023-2024 in CDC WONDER. 
	Provisional recent data may be available by request from IDHW? 8/13 called them to ask.
County-level data are only available for counties >100k in population. 
In Idaho this includes Ada, Bonneville (since 2014), Canyon and Kootenai.

*/

import delimited "$data/NCHS/Natality/Natality by county 2007-2022.txt", clear 
drop notes
drop if statecode == . 

* clean up missing data

foreach var of varlist birthrate fertilityrate {
	replace `var' = "" if `var' == "Not Available" | `var' == "Missing County"
	destring `var', replace
	}

* Birthrate: Births per 1000 population.
line birthrate year if countycode == 16999 // all unidentified counties only
line birthrate year, by(countycode) // big 4 counties + the rest

* Fertility rate: Births per 1000 women age 15-44
line fertilityrate year if countycode == 16999 // all unidentified counties only
line fertilityrate year, by(countycode) // big 4 counties + the rest

line census pop_pro* year if year <=2026, cmissing(n) title("Comparison of Idaho's population projection data")

