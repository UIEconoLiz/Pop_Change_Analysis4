** Liz Bageant
** September 4, 2024

clear all
set more off
version 18


** Extracting ACS state-to-state migration files

global temp "/Users/elizabethbageant/Desktop/temp"
global popest "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/Census Pop Est by County"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"
global acs_migration "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/ACS state-to-state migration data/State-to-State Migration Flows"


* set up a blank file to append processed sub-files to
import excel "$acs_migration/ACS_migration_template.xlsx", sheet("template") firstrow allstring clear
save "$temp/finalfile", replace

* process each year from 2010-2022
local files : dir "$acs_migration/import" files "*.xls"
foreach file in `files' {
	di "`file'"
	import excel "$acs_migration/import/`file'", sheet("Table") firstrow allstring clear
	ren *, l
	drop l w ah as bd bo bz ck cv dg dr 
	cap drop ea
	cap drop eb
	drop if current_residence == ""
	drop if current_residence == "Current residence in"
	drop if current_residence == "Current residence in --"
	drop if current_residence == "Current residence"
	count
	assert r(N) == 53
	* generating a year variable by pulling the last 4 digits from the filenames
	gen origin_file = "`file'"
	gen year = substr(origin_file, -8, 4)
	append using "$temp/finalfile"
	save "$temp/finalfile", replace
}

* final tidy
use "$temp/finalfile", clear
drop L-DR
order year, first
save "$acs_migration/processed/acs_state_to_state_2010-2022", replace

