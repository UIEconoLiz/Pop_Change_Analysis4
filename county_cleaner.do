** Liz Bageant
** August 1, 2024


** This file is designed to clean county names for Idaho and include FIPS codes

/*

This porrtion of the file creates the administrative_regions.dta file, but does not need to be run

import excel "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data/State administrative regions.xlsx", sheet("Sheet1") firstrow clear
ren FIPS county_fips

replace idol_region = "East" if idol_region == "EASTERN"
replace idol_region = "North" if idol_region == "NORTHERN"
replace idol_region = "North Central" if idol_region == "NORTH_CENTRAL"
replace idol_region = "Southeast" if idol_region == "SOUTHEASTERN"
replace idol_region = "Southwest" if idol_region == "SOUTHWESTERN"
replace idol_region = "South Central" if idol_region == "SOUTH_CENTRAL"
tab idol_region, miss
drop if idol_region == ""

save "$data/administrative_regions", replace
*/

replace county_name = "Ada County" if county_name == "ADA" | county_name == "Ada"
replace county_name = "Adams County" if county_name == "ADAMS" | county_name == "Adams"
replace county_name = "Bannock County" if county_name == "BANNOCK" | county_name == "Bannock"
replace county_name = "Bear Lake County" if county_name == "BEAR LAKE" | county_name == "Bear Lake"
replace county_name = "Benewah County" if county_name == "BENEWAH" | county_name == "Benewah"
replace county_name = "Bingham County" if county_name == "BINGHAM" | county_name == "Bingham"
replace county_name = "Blaine County" if county_name == "BLAINE" | county_name == "Blaine"
replace county_name = "Boise County" if county_name == "BOISE" | county_name == "Boise"
replace county_name = "Bonner County" if county_name == "BONNER" | county_name == "Bonner"
replace county_name = "Bonneville County" if county_name == "BONNEVILLE" | county_name == "Bonneville"
replace county_name = "Boundary County" if county_name == "BOUNDARY" | county_name == "Boundary"
replace county_name = "Butte County" if county_name == "BUTTE" | county_name == "Butte"
replace county_name = "Camas County" if county_name == "CAMAS" | county_name == "Camas"
replace county_name = "Canyon County" if county_name == "CANYON" | county_name == "Canyon"
replace county_name = "Caribou County" if county_name == "CARIBOU" | county_name == "Caribou"
replace county_name = "Cassia County" if county_name == "CASSIA" | county_name == "Cassia"
replace county_name = "Clark County" if county_name == "CLARK" | county_name == "Clark"
replace county_name = "Clearwater County" if county_name == "CLEARWATER" | county_name == "Clearwater"
replace county_name = "Custer County" if county_name == "CUSTER" | county_name == "Custer"
replace county_name = "Elmore County" if county_name == "ELMORE" | county_name == "Elmore"
replace county_name = "Franklin County" if county_name == "FRANKLIN" | county_name == "Franklin"
replace county_name = "Fremont County" if county_name == "FREMONT" | county_name == "Fremont"
replace county_name = "Gem County" if county_name == "GEM" | county_name == "Gem"
replace county_name = "Gooding County" if county_name == "GOODING" | county_name == "Gooding"
replace county_name = "Idaho County" if county_name == "IDAHO" | county_name == "Idaho"
replace county_name = "Jefferson County" if county_name == "JEFFERSON" | county_name == "Jefferson"
replace county_name = "Jerome County" if county_name == "JEROME" | county_name == "Jerome"
replace county_name = "Kootenai County" if county_name == "KOOTENAI" | county_name == "Kootenai"
replace county_name = "Latah County" if county_name == "LATAH" | county_name == "Latah"
replace county_name = "Lemhi County" if county_name == "LEMHI" | county_name == "Lemhi"
replace county_name = "Lewis County" if county_name == "LEWIS" | county_name == "Lewis"
replace county_name = "Lincoln County" if county_name == "LINCOLN" | county_name == "Lincoln"
replace county_name = "Madison County" if county_name == "MADISON" | county_name == "Madison"
replace county_name = "Minidoka County" if county_name == "MINIDOKA" | county_name == "Minidoka"
replace county_name = "Nez Perce County" if county_name == "NEZ PERCE" | county_name == "Nez Perce"
replace county_name = "Oneida County" if county_name == "ONEIDA" | county_name == "Oneida"
replace county_name = "Owyhee County" if county_name == "OWYHEE" | county_name == "Owyhee"
replace county_name = "Payette County" if county_name == "PAYETTE" | county_name == "Payette"
replace county_name = "Power County" if county_name == "POWER" | county_name == "Power"
replace county_name = "Shoshone County" if county_name == "SHOSHONE" | county_name == "Shoshone"
replace county_name = "Teton County" if county_name == "TETON" | county_name == "Teton"
replace county_name = "Twin Falls County" if county_name == "TWIN FALLS" | county_name == "Twin Falls"
replace county_name = "Valley County" if county_name == "VALLEY" | county_name == "Valley"
replace county_name = "Washington County" if county_name == "WASHINGTON" | county_name == "Washington"
