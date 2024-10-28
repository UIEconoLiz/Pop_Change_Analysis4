** Liz Bageant
** August 27, 2024

global temp "/Users/elizabethbageant/Desktop/temp"
global popest "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/Census Pop Est by County"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"


** Examining population and components of change data

/*--- THINGS TO THINK ABOUT --------------------------------------------------*/

* We don't need to adhere to the same population controls as Census.
* We might want to adhere to state level population control (so counties total to states) 
* We could drop the residual
* We could sub in our own births/deaths information if it is more accurate
* If we do these things I should talk to a professional. 


/*-------------- Vintage 2023 (2020-2023) ------------------------------------*/

import delimited "$popest/Vintage 2023/co-est2023-alldata.csv", clear


* keep only Idaho
keep if state == 16

* first, confirming that I understand how the components of change fit together

keep if sumlev == 40 // keeping only state-level data for the moment

/* Note that "residual" is everything not accounted for by births, deaths and net migration. 
	In practice, I think this is what needs to be added/subtracted to sum to control totals. 
	We don't necessarily need to use the residual, though maybe we start with it. 
	I think Tim Kuhn's projections/estimates don't use the residual.
	We could also sub in our births/deaths from IDHW data. */
	
	list residual*, clean noobs
		/*

		res~2020   res~2021   res~2022   res~2023  
			-488      -1733        614         38  
		*/


* 2021 population estimate for Idaho: 1,904,537

assert popestimate2020 + births2021 - deaths2021 + netmig2021 + residual2021 == popestimate2021 // yes


* reshape file

keep popestimate*  births* deaths* netmig* natural* internat* domestic* netmig* residual* npopchg*
gen vintage = 2023

reshape long popestimate births deaths naturalchg internationalmig domesticmig netmig residual npopchg, i(vintage) j(year)


save "$temp/temp", replace


/*-------------- Vintage 2019 (2010-2019) ------------------------------------*/
import delimited "$popest/Vintage 2019/co-est2019-alldata.csv", clear

keep if state == 16 & sumlev == 40

assert popestimate2010 + births2011 - deaths2011 + netmig2011 + residual2011 == popestimate2011 // yes

* reshape file

keep popestimate*  births* deaths* netmig* naturalinc* internat* domestic* netmig* residual* npopchg*
gen vintage = 2019

reshape long popestimate births deaths naturalinc internationalmig domesticmig netmig residual npopchg_, i(vintage) j(year)

ren npopchg_ npopchg
ren naturalinc naturalchg


/*-------------- Combine files -----------------------------------------------*/

append using "$temp/temp"

* generate a "base" estimate that is the starting point for the components of change equation.
* this is a lag. 
* this may be slightly different from what census calls the "base" 
* base_y2 = popest_y1, base_y3 = popest_y2, etc

gen base = popestimate[_n-1]

export delimited using "$analysis_files/components_of_change_2019-2023.csv", replace

