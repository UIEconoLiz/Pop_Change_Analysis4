** Liz Bageant
** November 1, 2024

** Compiling and examining ACS migration data for Idaho


* bring in data file
import delimited "$data/IPUMS ACS/IPUMS_Idaho_migration_usa_00007.csv", clear 

* Ideally we would use the 2022 5 year sample--it is not in this extract yet.
 tab sample 

* Will try with 2021 2-year sample
keep if sample == 202201


* keep if moved between states
keep if migrate1 == 3

* keep if origin or destination was idaho
keep if statefip == 16 | migplac1 == 16

* generate indicator variables for in-migrants and out-migrants
gen inmig = (statefip == 16)
gen outmig = (migplac == 16)

save "$temp/temp", replace

** Calculating share of in-migrants of different ages
use "$temp/temp", clear
keep if inmig == 1

collapse (sum) hhwt, by(age)

* calculate share of population in age categories
gen agecat = "" 
replace agecat = "kids" if age<=14
replace agecat = "early workforce" if age>=15 & age<=24
replace agecat = "prime" if age>=25 & age<=54
replace agecat = "near retirement" if age>=55 & age<=64
replace agecat = "retired" if age>=65

collapse (sum) hhwt, by(agecat)

* I have pasted this data into excel to calculate shares alongside other calculations using IRS data
* ~Growth in Idaho 2024/Pop_Change_Analysis4/analysis_excel/IRS_ACS_IPUMS_migration_age_shares.xlsx

** Calculating share of out-migrants of different ages
use "$temp/temp", clear
keep if outmig == 1

collapse (sum) hhwt, by(age)

* calculate share of population in age categories
gen agecat = "" 
replace agecat = "kids" if age<=14
replace agecat = "early workforce" if age>=15 & age<=24
replace agecat = "prime" if age>=25 & age<=54
replace agecat = "near retirement" if age>=55 & age<=64
replace agecat = "retired" if age>=65

collapse (sum) hhwt, by(agecat)

* I have pasted this data into excel to calculate shares alongside other calculations using IRS data
* ~Growth in Idaho 2024/Pop_Change_Analysis4/analysis_excel/IRS_ACS_IPUMS_migration_age_shares.xlsx
