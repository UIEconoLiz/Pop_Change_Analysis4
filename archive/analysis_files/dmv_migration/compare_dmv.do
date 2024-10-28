** Liz Bageant
** August 1, 2024

clear all
set more off
version 18

global data "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data"
global temp "/Users/elizabethbageant/Desktop/temp"
global do "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"


/*

1. To what extent are the Idaho DMV license surrender and the Census state-to-state 
migration data consistent?


2. To what extent are the Idaho DMV licenses in force data consistent with other 
demographic information available at the county level?

CONCLUSION: They are an underestimate. They represent between 47 and 91% of residents
	depending on the county. 

*/

** Import DMV licenses in force data

import excel "/$data/DMV/DLInForce_County_for_import.xlsx", sheet("WEB.DriversLicenseInForceByCoun") firstrow case(lower) clear

ren a county
ren b y2018
drop c
ren d y2019
ren e y2020
ren f y2021
ren g y2022
ren h y2023

reshape long y, i(county) j(year)

ren y lic_in_force
ren county county_name

do "$do/county_cleaner.do"

drop if county_name == "Total"

save "$temp/lic_in_force", replace



** merge in county-level census estimates

use "$analysis_files/census_vintage2023", clear
drop estimatesbas state_fips stname

rename ctyname county_name

reshape long popestimate, i(county_name county_fips) j(year)

save "$analysis_files/census_vintage2023_long", replace

** combine with licenses in force

merge 1:1 county_name year using "$temp/lic_in_force"
drop if county_fips == 0
drop if county_name == "UNKNOWN" // Look at this more closely if relevant
drop if year ==2018 | year == 2019

tab _mer year
drop _mer

gen share_with_dl = (lic_in_force/popestimate)*100

summarize share, d

bys year: summarize share, d 
bys year: summarize share

/*
----------------------------------------------------------------------------------
-> year = 2020

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
share_with~l |         44     75.3995    13.08308   44.54164   138.8999  <------------------------***** lowest min, highest max

----------------------------------------------------------------------------------
-> year = 2021

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
share_with~l |         44    74.93514    8.524176   47.31938   94.20878

----------------------------------------------------------------------------------
-> year = 2022

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
share_with~l |         44    75.11942    8.317026   47.78012    93.0024

----------------------------------------------------------------------------------
-> year = 2023

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
share_with~l |         44     74.8568     7.78595   48.92295   91.15886
*/











