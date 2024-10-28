** Liz Bageant
** August 6, 2024

** Explore DMV migration files. 

global data "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Data"
global temp "/Users/elizabethbageant/Desktop/temp"
global do "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis"
global analysis_files "/Users/elizabethbageant/Dropbox/_MCCLURE/Demography--Growth in Idaho/Analysis/analysis_files"



/* Looking at net in-migrants and net out-migrants. */


use "$analysis_files/dmv_migration/dmv_migration_by_age.dta", clear

destring number, replace

collapse (sum) number, by(year direction)

reshape wide number, i(year) j(direction) string

ren number_of_peoplein ppl_in
ren number_of_peopleout ppl_out

gen net_in = ppl_in - ppl_out



line ppl_in ppl_out net_in year , cmissing(n) title("Migration in/out using DMV records")

summarize net_in ppl_out ppl_in
/*
    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
      net_in |         10     15123.3    7133.672       4604      25347
     ppl_out |         10     36832.2    11814.42      23673      57233
      ppl_in |         10     51955.5    7513.128      41664      64029
*/

** 15k on average annual growth
** A lot of people are leaving

ren net_in net

* save and export for R

	* aligning names with IRS files
	ren net_in net
	ren ppl_in indiv_in
	ren ppl_out indiv_out

save "$analysis_files/dmv_migration/dmv_migration", replace
export delimited using "$analysis_files/dmv_migration/dmv_migration.csv", replace




collapse (sum) net_in ppl_out ppl_in

list net_in ppl_out ppl_in, clean noobs

/*
    net_in   ppl_out   ppl_in  
    151233    368322   519555  
*/

** 151k growth
/* 151k people ended up in Idaho, 
	but many more than that came (519k) 
	and many more left (368k). 
	This is "churn".
	*/

	
	
/*
How do we get from DMV records to in/out migration numbers? 
How representative  are DMV records of the population as a whole? 
Look at ACS
	- who can drive? who has DL? Multiply DMV numbers by that factor. 
	- how many kids come with each DL-holding adult, on average? Add them in dataset.
	
Look at DL in force data:
	- Request county level data by year and age group











