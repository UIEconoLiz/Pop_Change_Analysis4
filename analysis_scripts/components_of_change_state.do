** Liz Bageant
** August 27, 2024


** Compiling population and components of change times series at the state level



/*--- THINGS TO THINK ABOUT --------------------------------------------------*/

* We don't need to adhere to the same population controls as Census.
* We might want to adhere to state level population control (so counties total to states) 
* We could drop the residual
* We could sub in our own births/deaths information if it is more accurate
* If we do these things I should talk to a professional. 


/*-------------- Vintage 2023 (2020-2023) ------------------------------------*/

import delimited "$pep/PEP county population and components of change/Vintage 2023/co-est2023-alldata.csv", clear


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
import delimited "$pep/PEP county population and components of change/Vintage 2019/co-est2019-alldata.csv", clear

keep if state == 16 & sumlev == 40

assert popestimate2010 + births2011 - deaths2011 + netmig2011 + residual2011 == popestimate2011 // yes

* reshape file

keep popestimate*  births* deaths* netmig* naturalinc* internat* domestic* netmig* residual* npopchg*
gen vintage = 2019

reshape long popestimate births deaths naturalinc internationalmig domesticmig netmig residual npopchg_, i(vintage) j(year)

ren npopchg_ npopchg
ren naturalinc naturalchg

save "$temp/temp2", replace


/*-------------- Vintage 2009 (2000-2009) ------------------------------------*/

import delimited "$pep/PEP county population and components of change/Vintage 2009/CO-EST2009-alldata.csv", clear

keep if state == 16 & sumlev == 40

assert popestimate2000 + births2001 - deaths2001 + netmig2001 + residual2001 == popestimate2001 

* reshape file

keep popestimate*  births* deaths* netmig* naturalinc* internat* domestic* netmig* residual* npopchg*
gen vintage = 2009

reshape long popestimate births deaths naturalinc internationalmig domesticmig netmig residual npopchg_, i(vintage) j(year)

ren npopchg_ npopchg
ren naturalinc naturalchg

save "$temp/temp3"


/*-------------- Combine files -----------------------------------------------*/

cd "$temp"
use temp, clear
append using "$temp/temp2"
append using "$temp/temp3"

* generate a "base" estimate that is the starting point for the components of change equation.
* this is a lag. 
* this may be slightly different from what census calls the "base" 
* base_y2 = popest_y1, base_y3 = popest_y2, etc

sort year
gen base = popestimate[_n-1]


* components of change for 2020 include only 4/1/2020-7/1/2020. 
* popestimate2020 is the population estimate on 7/1/2020: 1,849,339
* to address this, I am adding a different category called "components_unknown" and removing the 4/1-7/1 data.
* there may be a better way to do this, but this will make the figure transparent for now.
gen components_unknown = 0 

* 2020
replace components_unknown = 1849339-1787065 if year == 2020

* for 2010 and 2000, the intercensals should complete this information but I am excluding it for now.
replace components_unknown = 1570746 - 1545801 if year == 2010

replace netmig = 0 if year == 2020 | year == 2010  | year == 2000
replace naturalchg = 0 if year == 2020 | year == 2010 | year == 2000
replace residual = 0 if year == 2020 | year == 2010 | year == 2000


export delimited using "$analysis_data/components_of_change_2000-2023.csv", replace














