** Liz Bageant
** September 13, 2024

** Census Population Estimates Program Housing Unit Estimates



import excel "$data/Census PEP Housing Units/import/CO-EST2019-ANNHU-16.xlsx", sheet("CO-EST2019-ANNHU-16") firstrow clear

save "$temp/2019units", replace

import excel "$data/Census PEP Housing Units/import/CO-EST2023-HU-16.xlsx", sheet("CO-EST2023-HU-16") firstrow clear
save "$temp/2023units", replace


/*----------- STATE LEVEL ----------------------------------------------------*/

use "$temp/2019units", clear
keep if location == "IDAHO"
keep location units_*
reshape long units_, i(location) j(year)
save "$temp/id2019", replace

use "$temp/2023units", clear
keep if location == "IDAHO"
keep location units_*
reshape long units_, i(location) j(year)

append using "$temp/id2019"

ren units_ units

export delimited using "$analysis_data/housing_units_state_2010-2023", replace



/*----------- COUNTY LEVEL ---------------------------------------------------*/


use "$temp/2019units", clear
drop if location == "IDAHO"

* clean county strings
replace location = substr(location, 2, .)
replace location = subinstr(location, ", Idaho", "", .)
replace location = strtrim(location)

ren location county
keep county units*

reshape long units_, i(county) j(year)

ren units_ units

save "$temp/c2019", replace


use "$temp/2023units", clear
drop if location == "IDAHO"

* clean county strings
replace location = substr(location, 2, .)
replace location = subinstr(location, ", Idaho", "", .)
replace location = strtrim(location)

ren location county
keep county units*

reshape long units_, i(county) j(year)

ren units_ units

append using "$temp/c2019"

export delimited using "$analysis_data/housing_units_county_2010-2023", replace




