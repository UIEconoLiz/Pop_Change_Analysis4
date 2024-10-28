** Liz Bageant
** September 12, 2024

** Looking at state inflows and outflows in 2017 (and surrounding years) to see
** if the spike in migration in Idaho is present in other states, or unique
** to Idaho. 


/*--------------- INFLOWS ----------------------------------------------------*/


foreach x in 1314 1415 1516 1617 1718 1819 1920 2021 2122 {

	import delimited "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/IRS Statistics of Income/state inflows and outflows/stateinflow`x'.csv", clear 

	keep if y1_statefips == 96

	ren n1 returns_in
	ren n2 indiv_in
	ren agi agi_in

	ren y2_statefips sfips
	drop y1*

	gen year = `x'

	save "$temp/`x'_in", replace

		
}

** APPEND

use "$temp/1314_in", clear

foreach x in 1415 1516 1617 1718 1819 1920 2021 2122 {
	append using "$temp/`x'_in"
}

recode year (1314 = 2014) (1415 = 2015) (1516 = 2016) (1617 = 2017) (1718 = 2018) (1819 = 2019) (1920 = 2020) (2021 = 2021) (2122 = 2022)

export excel using "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/state_inflows_outflows.xls", replace
export delimited using "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files/irs_migration/state_inflows_outflows.csv", replace


/*--------------- OUTFLOWS ---------------------------------------------------*/
