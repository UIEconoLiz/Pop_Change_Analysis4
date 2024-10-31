** Liz Bageant
** October 31, 2024


NEVERMIND. AGE CATEGORIES DON'T WORK FOR THE 65+ RANGE. :( 
** Compiling BLS labor force participation rates by age (national)

import excel "$data/BLS/labor_force_participation_by_age_sex_race.xlsx", sheet("Table 3.3") cellrange(A3:K76) clear

egen sno = seq()

ren *, l

keep sno a b c d e

ren a group
ren b lfpr_2003
ren c lfpr_2013
ren d lfpr_2023
ren e lfpr_2033

sort sno

* keeping only needed data

drop if group ==""
drop in 13/74





