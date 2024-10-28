* Liz Bageant
* September 19, 2024

* Compile PEP age and sex files


* These files contain a number of different age breakdowns. 
* Generating separate files for each type of age breakdown.


* Vintage 2023
import delimited "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/Census PEP county population by characteristics/Vintage 2023/cc-est2023-agesex-16.csv", clear 

	* Recode "year" variable

	tostring year, replace
	replace year = "2020b" if year == "1" // This represents the April 1 base 
	replace year = "2020" if year == "2" // This and subsequebt years represent July 1 estimate
	replace year = "2021" if year == "3"
	replace year = "2022" if year == "4"
	replace year = "2023" if year == "5"


save "$temp/agesex2023", replace


* Vintage 2019
import delimited "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/Census PEP county population by characteristics/Vintage 2019/cc-est2019-agesex-16.csv", clear 

	* Recode "year" variable

	tostring year, replace
	replace year = "2010c" if year == "1" // This represents the Census count
	replace year = "2010b" if year == "2" // This represents the April 1 base. They are very slightly different from Census count.
	replace year = "2010" if year == "3"  // This and subsequent years represent July 1 estimate
	replace year = "2011" if year == "4"
	replace year = "2012" if year == "5"
	replace year = "2013" if year == "6"
	replace year = "2014" if year == "7"
	replace year = "2015" if year == "8"
	replace year = "2016" if year == "9"
	replace year = "2017" if year == "10"
	replace year = "2018" if year == "11"
	replace year = "2019" if year == "12"

save "$temp/agesex2019", replace




* First set of bin options: 7 different bins

* Vintage 2023
	use "$temp/agesex2023", clear

	keep state county stname ctyname year popestimate popest_male popest_fem under5_tot-age1824_fem age2544_tot-age4564_fem age65plus_tot age65plus_male age65plus_fem median_age_tot median_age_male median_age_fem

	egen test = rowtotal(under5_tot age513_tot age1417_tot age1824_tot age2544_tot age4564_tot age65plus_tot)
	assert test == popestimate
	drop test

	save "$temp/v2023", replace

* Vintage 2019
	use "$temp/agesex2019", clear

	keep state county stname ctyname year popestimate popest_male popest_fem under5_tot-age1824_fem age2544_tot-age4564_fem age65plus_tot age65plus_male age65plus_fem median_age_tot median_age_male median_age_fem

	egen test = rowtotal(under5_tot age513_tot age1417_tot age1824_tot age2544_tot age4564_tot age65plus_tot)
	assert test == popestimate
	drop test

* Combine
	append using "$temp/v2023"
	save "$analysis_files/age_and_sex/age_7bins_county", replace
	export delimited using "$analysis_files/age_and_sex/age_7bins_county.csv", replace



* All of the bins that include everyone above a given age ("plus") or below a given age ("under")

* Vintage 2023
	use "$temp/agesex2023", clear

	keep state county stname ctyname year popestimate popest_male popest_fem under5_tot under5_male under5_fem age16plus_tot age16plus_male age16plus_fem age18plus_tot age18plus_male age18plus_fem age65plus_tot age65plus_male age65plus_fem age85plus_tot age85plus_male age85plus_fem median_age_tot median_age_male median_age_fem

	save "$temp/v2023", replace
	
* Vintage 2019
	use "$temp/agesex2019", clear

	keep state county stname ctyname year popestimate popest_male popest_fem under5_tot under5_male under5_fem age16plus_tot age16plus_male age16plus_fem age18plus_tot age18plus_male age18plus_fem age65plus_tot age65plus_male age65plus_fem age85plus_tot age85plus_male age85plus_fem median_age_tot median_age_male median_age_fem

* combine
	append using "$temp/v2023"
	save "$analysis_files/age_and_sex/age_plusbins_county", replace
	export delimited using "$analysis_files/age_and_sex/age_plusbins_county.csv", replace

	
	
	
* Five-year age bins

* Vintage 2023
	use "$temp/agesex2023", clear
	keep state county stname ctyname year popestimate popest_male popest_fem age04_tot-median_age_fem

	egen test = rowtotal(age04_tot age59_tot age1014_tot age1519_tot age2024_tot age2529_tot age3034_tot age3539_tot age4044_tot age4549_tot age5054_tot age5559_tot age6064_tot age6569_tot age7074_tot age7579_tot age8084_tot age85plus_tot)

	assert test == popestimate
	drop test
	
	save "$temp/v2023", replace

* Vintage 2019
	use "$temp/agesex2019", clear
	keep state county stname ctyname year popestimate popest_male popest_fem age04_tot-median_age_fem

	egen test = rowtotal(age04_tot age59_tot age1014_tot age1519_tot age2024_tot age2529_tot age3034_tot age3539_tot age4044_tot age4549_tot age5054_tot age5559_tot age6064_tot age6569_tot age7074_tot age7579_tot age8084_tot age85plus_tot)

	assert test == popestimate
	drop test

* combine
	append using "$temp/v2023"
	save "$analysis_files/age_and_sex/age_5yearbins_county", replace
	export delimited using "$analysis_files/age_and_sex/age_5yearbins_county.csv", replace



