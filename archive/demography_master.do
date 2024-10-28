** LIz Bageant
** September 11, 2024

** Master file for initial demography and growth explorations


clear all
set more off
version 18

global data "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data"
global temp "/Users/elizabethbageant/Desktop/temp"
global do "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"

global popest "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/Census Pop Est by County"

global irs "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/IRS Statistics of Income/2011-2022"
global irs_import "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/IRS Statistics of Income/2011-2022/import"



/*------------ IMPORT AND COMPILE --------------------------------------------*/


/*---- Census PEP ----*/



/*---- Migration ----*/


* DMV

do "$do/dmv_migration/compile_dmv_migration" // compiles raw data
do "$do/dmv_migration/dmv_migration" // generates files used in R--MAY NEED CHECKING AND UPDATING to run fully?
do "$do/dmv_migration/compare_dmv" 	 // looks at relationship between DMV files and population

	** Data visualization in R: dmv_migration.R

	
* ACS


* PEP
do "$do/components_of_change/components_of_change_state.do" // compiles components of change at the state level
	** Data visualization in R: components_of_change_state.R
	* Does not include components of change for 2020. 
	



* IRS
do "$do/irs_migration/compile_irs_migration.do" // generates files used in R
	
	** Data visualization in R: irs_migration_v3.R
	
do "$do/irs_migration/irs_migration_all_states.do" // compiles inflows to look at trends in other states
	** Data vizualization in R: state_inflow_outflow.R


/*---- Mortality ----*/

* IDHW

* CDC WONDER


/*---- Natality ----*/

* IDHW

* CDC WONDER





* generally .do are run before .R files
