** Liz Bageant
** August 5, 2024

** Cleaning and compiling the DMV migration data from 2014-2023



/*----------------- LICENSES "IN" --------------------------------------------*/
qui { 
* 2023 new licenses:

	import excel "$data/DMV/migbyage20.xlsx", sheet("2023") cellrange(A6:N85) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* dropping row and column totals
	drop total 
	drop if origin == "Total"

	* examine unknown age
	tab unknown, miss 
	ren unknown ageunk

	* The top row does not have a value for "origin". I will replace this with "unknown". 
	replace origin = "unknown" if origin == ""

	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop if rowmiss >1
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)

	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2023
	
	save "$temp/in2023", replace



* 2022 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2022") cellrange(A5:N83) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"

	* examine "unknown" age
	tab unknown, miss 
	ren unknown ageunk
	
	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop if rowmiss >1
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)
	
	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2022

	save "$temp/in2022", replace
	
* 2021 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2021") cellrange(A5:m81) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
		
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* no unknown age
	gen ageunk = "0"

	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)
	
	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2021
	
	save "$temp/in2021", replace
	
* 2020 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2020") cellrange(A5:m77) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* no unknown aged people
	gen ageunk = "0"

	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2020
	
	save "$temp/in2020", replace


* 2019 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2019") cellrange(A5:n75) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* examine "unknown" age
	tab unknown, miss 
	ren unknown ageunk
	
	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)
	
	
	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2019
	
	save "$temp/in2019", replace



* 2018 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2018") cellrange(A5:n82) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* examine "unknown" age
	tab unknown, miss 
	ren unknown ageunk

	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)

	
	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2018
	
	save "$temp/in2018", replace


* 2017 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2017") cellrange(A5:n76) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* examine "unknown" age
	tab unknown, miss 
	ren unknown ageunk

	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)

	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2017
	
	save "$temp/in2017", replace
	

* 2016 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2016") cellrange(A5:n78) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* examine "unknown" age
	tab unknown, miss 
	ren unknown ageunk

	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)

	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2016
	
	save "$temp/in2016", replace
	
	
* 2015 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2015") cellrange(A5:n76) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* examine "unknown" age
	tab unknown, miss 
	ren unknown ageunk

	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)

	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2015
	
	save "$temp/in2015", replace
	
	
* 2014 new licenses:
	import excel "$data/DMV/migbyage20.xlsx", sheet("2014") cellrange(A5:n74) firstrow clear

	ren *, l

	ren a origin
	ren andunder age20
	la var age20 "Under 20"
	drop c
	ren d age21_30
	ren e age31_40
	ren f age41_50
	ren g age51_60
	drop h
	ren i age61_70
	ren j age71_80
	ren k age81_90
	ren andover age91
	
	* drop "Total" rows and columns.
	drop total
	drop if origin == "Total"
	
	* examine "unknown" age
	tab unknown, miss  
	ren unknown ageunk

	* look for blank rows
	egen rowmiss = rowmiss(*)
	tab rowmiss // none
	drop rowmiss
	
	* Change case and eliminate leading/trailing spaces
	replace origin = proper(origin)
	replace origin = strtrim(origin)

	* Reshape long
	reshape long age, i(origin) j(age_group) string
	ren age dl_from

	* add year
	gen year = 2014
	
	save "$temp/in2014", replace
	
}
	
	
/*----------------- LICENSES "OUT" --------------------------------------------*/

** 2023 out

import excel "$data/DMV/migbyage20.xlsx", sheet("2023") cellrange(a6:x84) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	ren o age20
	la var age20 "Under 20"
	ren p age21_30
	ren q age31_40
	ren r age41_50
	ren s age51_60
	ren t age61_70
	ren u age71_80
	ren v age81_90
	ren w age91
	ren x total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"
	
	* The top row does not have a value for "destination". I will replace this with "unknown". 
	replace destination = "unknown" if destination == ""

	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop if rowmiss == 1
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2023
	
	save "$temp/out2023", replace

	
** 2022 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2022") cellrange(a5:x82) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	ren o age20
	la var age20 "Under 20"
	ren p age21_30
	ren q age31_40
	ren r age41_50
	ren s age51_60
	ren t age61_70
	ren u age71_80
	ren v age81_90
	ren w age91
	ren x total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"

	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2022
	
	save "$temp/out2022", replace

	
** 2021 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2021") cellrange(a5:w81) firstrow clear

	ren *, l
	drop andunder c-k andover total

	ren a destination
	ren n age20
	la var age20 "Under 20"
	ren o age21_30
	ren p age31_40
	ren q age41_50
	ren r age51_60
	ren s age61_70
	ren t age71_80
	ren u age81_90
	ren v age91
	ren w total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"

	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2021
	
	save "$temp/out2021", replace

	
** 2020 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2020") cellrange(a5:w77) firstrow clear

	ren *, l
	drop andunder c-k andover total

	ren a destination
	ren n age20
	la var age20 "Under 20"
	ren o age21_30
	ren p age31_40
	ren q age41_50
	ren r age51_60
	ren s age61_70
	ren t age71_80
	ren u age81_90
	ren v age91
	ren w total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"

	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2020
	
	save "$temp/out2020", replace
	
	
** 2019 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2019") cellrange(a5:x75) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	ren o age20
	la var age20 "Under 20"
	ren p age21_30
	ren q age31_40
	ren r age41_50
	ren s age51_60
	ren t age61_70
	ren u age71_80
	ren v age81_90
	ren w age91
	ren x total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"
	
	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2019
	
	save "$temp/out2019", replace

	
** 2018 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2018") cellrange(a5:y82) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	ren o age20
	la var age20 "Under 20"
	ren p age21_30
	ren q age31_40
	ren r age41_50
	ren s age51_60
	ren t age61_70
	ren u age71_80
	ren v age81_90
	ren w age91
	ren x unknown
	ren y total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"
	
	* looking at unknown ages
	tab unknown
	ren unknown ageunk
	
	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2018
	
	save "$temp/out2018", replace

** 2017 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2017") cellrange(a5:y76) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	ren o age20
	la var age20 "Under 20"
	ren p age21_30
	ren q age31_40
	ren r age41_50
	ren s age51_60
	ren t age61_70
	ren u age71_80
	ren v age81_90
	ren w age91
	ren x unknown
	ren y total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"
	
	* looking at unknown ages
	tab unknown
	ren unknown ageunk
	
	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2017
	
	save "$temp/out2017", replace
	
	
** 2016 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2016") cellrange(a5:y78) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	ren o age20
	la var age20 "Under 20"
	ren p age21_30
	ren q age31_40
	ren r age41_50
	ren s age51_60
	ren t age61_70
	ren u age71_80
	ren v age81_90
	ren w age91
	ren x unknown
	ren y total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"
	
	* looking at unknown ages
	tab unknown
	ren unknown ageunk
	
	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2016
	
	save "$temp/out2016", replace

	
** 2016 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2015") cellrange(a5:y76) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	ren o age20
	la var age20 "Under 20"
	ren p age21_30
	ren q age31_40
	ren r age41_50
	ren s age51_60
	ren t age61_70
	ren u age71_80
	ren v age81_90
	ren w age91
	ren x unknown
	ren y total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"
	
	* looking at unknown ages
	tab unknown
	ren unknown ageunk
	
	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2015
	
	save "$temp/out2015", replace

	
** 2014 out
import excel "$data/DMV/migbyage20.xlsx", sheet("2014") cellrange(a5:x74) firstrow clear

	ren *, l
	drop andunder c-k andover unknown total

	ren a destination
	** ren o age20 // THERE IS NO UNDER 20 DATA FOR 2014
	ren o age21_30
	ren p age31_40
	ren q age41_50
	ren r age51_60
	ren s age61_70
	ren t age71_80
	ren u age81_90
	ren v age91
	ren w unknown
	ren x total
	
	* dropping row and column totals
	drop total 
	drop if destination == "Total"
	
	* looking at unknown ages
	tab unknown
	ren unknown ageunk
	
	* drop a row of blank data
	egen rowmiss = rowmiss(*)
	tab rowmiss
	drop rowmiss

	* Change case and eliminate leading/trailing spaces
	replace destination = proper(destination)
	replace destination = strtrim(destination)

	* Reshape long
	reshape long age, i(destination) j(age_group) string
	ren age dl_to

	* add year
	gen year = 2014
	
	save "$temp/out2014", replace
	
	
/*----------------- COMBINE FILES --------------------------------------------*/


* Relinquished licenses ("in")

cd "$temp"

use in2023, clear
gen direction = "in"
forv i = 2014/2022 {
	append using in`i'
	replace direction = "in"
}
ren origin origin_destination
ren dl_from number_of_people
save "in", replace

use out2023, clear
gen direction = "out"
forv i = 2014/2022 {
	append using out`i'
	replace direction = "out"
}
ren destination origin_destination
ren dl_to number_of_people

append using in

save "$analysis_files/dmv_migration/dmv_migration_by_age.dta", replace


