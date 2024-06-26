cd "C:\Users\1026o\Desktop\eur_america\"
ssc install _gwtmean // https://stackoverflow.com/questions/66250560/computing-a-weighted-average-per-observation-stata

*** ==================================================
*** Variables and inconsistency between two datasets
*** ==================================================
*** var                    | TIMSS 1995  | TIMSS 1999
*** ------------------------------------------------
*** student id             | idstud      | IDSTUD
*** country                | idcntry     | IDCNTRY
*** gender                 | itsex       | ITSEX
*** age                    | bsdage      | BSDAGE
*** books at home          | bsbgbook    | BSBGBOOK
*** lives with parents     | BSBGADU1    | BSBGADU1 // mother
***                        | BSBGADU2    | BSBGADU2 // father
***                        | BSBGADU5    | BSBGADU5 // stepmother
***                        | BSBGADU6    | BSBGADU6 // stepfather
*** is born in the country | BSBGBRN1    | BSBGBRN1
***                        | bsbgbrnm    | BSBGBRNM
***                        | bsbgbrnf    | BSBGBRNF
*** math score             | BSMPV01~05  | BSMMAT01~05
*** science score          | BSSPV01~05  | BSSSCI01~05
*** weight                 | totwgt      | TOTWGT


*** ==================================================
*** Clean TIMSS 1995
*** ==================================================
use "timss_1995\TIMSS_1995_Global.dta", clear
gen is_1995 = 1

*** Rename variables
rename idstud IDSTUD
rename idcntry IDCNTRY
rename itsex ITSEX_1995
rename bsdage BSDAGE_1995
rename bsbgbook BSBGBOOK_1995
rename BSBGBRN1 BSBGBRN1_1995
rename bsbgbrnm BSBGBRNM_1995
rename bsbgbrnf BSBGBRNF_1995
rename totwgt TOTWGT_1995

*** Generate the "lives_with_parents" variable
gen lives_with_mother = 0
replace lives_with_mother = 1 if BSBGADU1 == 1 | BSBGADU5 == 1

gen lives_with_father = 0
replace lives_with_father = 1 if BSBGADU2 == 1 | BSBGADU6 == 1

gen lives_with_parents_1995 = 0
replace lives_with_parents_1995 = 1 if lives_with_mother == 1 & lives_with_father == 1
replace lives_with_parents_1995 = . if BSBGADU1 == . & BSBGADU5 == . & BSBGADU2 == . & BSBGADU6 == .

*** Keep only 8th graders
keep if idgrade == 8

*** Drop missing values
drop if ITSEX_1995 == .
drop if BSDAGE_1995 == . | BSDAGE_1995 == 98 | BSDAGE_1995 == 99
drop if lives_with_parents_1995 == .
drop if BSBGBOOK_1995 == . | BSBGBOOK_1995 == 7
drop if BSBGBRN1_1995 != 1 & BSBGBRN1_1995 != 2
drop if BSBGBRNM_1995 != 1 & BSBGBRNM_1995 != 2
drop if BSBGBRNF_1995 != 1 & BSBGBRNF_1995 != 2
drop if BSMPV01 == . | BSMPV02 == . | BSMPV03 == . | BSMPV04 == . | BSMPV05 == .
drop if BSSPV01 == . | BSSPV02 == . | BSSPV03 == . | BSSPV04 == . | BSSPV05 == .
drop if TOTWGT_1995 == .

*** Calculate the "performance" variable
bysort IDCNTRY: egen BSMPV01_mean = wtmean(BSMPV01), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSMPV02_mean = wtmean(BSMPV02), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSMPV03_mean = wtmean(BSMPV03), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSMPV04_mean = wtmean(BSMPV04), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSMPV05_mean = wtmean(BSMPV05), weight(TOTWGT_1995)
gen math_1995_mean = (BSMPV01_mean + BSMPV02_mean + BSMPV03_mean + BSMPV04_mean + BSMPV05_mean) / 5

bysort IDCNTRY: egen BSSPV01_mean = wtmean(BSSPV01), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSSPV02_mean = wtmean(BSSPV02), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSSPV03_mean = wtmean(BSSPV03), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSSPV04_mean = wtmean(BSSPV04), weight(TOTWGT_1995)
bysort IDCNTRY: egen BSSPV05_mean = wtmean(BSSPV05), weight(TOTWGT_1995)
gen scie_1995_mean = (BSSPV01_mean + BSSPV02_mean + BSSPV03_mean + BSSPV04_mean + BSSPV05_mean) / 5

gen performance_1995 = (math_1995_mean + scie_1995_mean) / 2

*** Save dataset
save "timss_1995\TIMSS_1995_Global_tmp.dta", replace


*** ==================================================
*** Clean TIMSS 1999
*** ==================================================
use "timss_1999\timss_1999.dta", clear
gen is_1999 = 1

*** Rename variables
rename ITSEX ITSEX_1999
rename BSDAGE BSDAGE_1999
rename BSBGBOOK BSBGBOOK_1999
rename BSBGBRN1 BSBGBRN1_1999
rename BSBGBRNM BSBGBRNM_1999
rename BSBGBRNF BSBGBRNF_1999
rename TOTWGT TOTWGT_1999

*** Generate the "lives_with_parents" variable
gen lives_with_mother = 0
replace lives_with_mother = 1 if BSBGADU1 == 1 | BSBGADU5 == 1

gen lives_with_father = 0
replace lives_with_father = 1 if BSBGADU2 == 1 | BSBGADU6 == 1

gen lives_with_parents_1999 = 0
replace lives_with_parents_1999 = 1 if lives_with_mother == 1 & lives_with_father == 1
replace lives_with_parents_1999 = . if BSBGADU1 == . & BSBGADU5 == . & BSBGADU2 == . & BSBGADU6 == .

*** All responses from Chinese Taipei is duplicated (IDCNTRY=158)
duplicates drop IDSTUD IDCNTRY, force

*** Drop missing values
drop if ITSEX_1999 == .
drop if BSDAGE_1999 == . | BSDAGE_1999 == 98 | BSDAGE_1999 == 99
drop if lives_with_parents_1999 == .
drop if BSBGBOOK_1999 == . | BSBGBOOK_1999 == 8
drop if BSBGBRN1_1999 != 1 & BSBGBRN1_1999 != 2
drop if BSBGBRNM_1999 != 1 & BSBGBRNM_1999 != 2
drop if BSBGBRNF_1999 != 1 & BSBGBRNF_1999 != 2
drop if BSMMAT01 == . | BSMMAT02 == . | BSMMAT03 == . | BSMMAT04 == . | BSMMAT05 == .
drop if BSSSCI01 == . | BSSSCI02 == . | BSSSCI03 == . | BSSSCI04 == . | BSSSCI05 == .
drop if TOTWGT_1999 == .

*** Calculate the "performance" variable
bysort IDCNTRY: egen BSMMAT01_mean = wtmean(BSMMAT01), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSMMAT02_mean = wtmean(BSMMAT02), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSMMAT03_mean = wtmean(BSMMAT03), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSMMAT04_mean = wtmean(BSMMAT04), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSMMAT05_mean = wtmean(BSMMAT05), weight(TOTWGT_1999)
gen math_1999_mean = (BSMMAT01_mean + BSMMAT02_mean + BSMMAT03_mean + BSMMAT04_mean + BSMMAT05_mean) / 5

bysort IDCNTRY: egen BSSSCI01_mean = wtmean(BSSSCI01), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSSSCI02_mean = wtmean(BSSSCI02), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSSSCI03_mean = wtmean(BSSSCI03), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSSSCI04_mean = wtmean(BSSSCI04), weight(TOTWGT_1999)
bysort IDCNTRY: egen BSSSCI05_mean = wtmean(BSSSCI05), weight(TOTWGT_1999)
gen scie_1999_mean = (BSSSCI01_mean + BSSSCI02_mean + BSSSCI03_mean + BSSSCI04_mean + BSSSCI05_mean) / 5

gen performance_1999 = (math_1999_mean + scie_1999_mean) / 2

*** Save dataset
save "timss_1999\timss_1999_tmp.dta", replace


*** ==================================================
*** Merge two datasets
*** ==================================================
use "timss_1995\TIMSS_1995_Global_tmp.dta", clear
merge 1:1 IDSTUD IDCNTRY using "timss_1999\timss_1999_tmp.dta"
sort IDCNTRY
save "timss_1999\timss_1995_1999_merge.dta", replace


*** ==================================================
*** Table 1
*** ==================================================
use "timss_1999\timss_1995_1999_merge.dta", clear

*** performances
gen performance = .
replace performance = performance_1995 if performance_1995 != .
replace performance = performance_1999 if performance_1999 != .
replace performance = (performance_1995 + performance_1999)/2 if performance_1995 != . & performance_1999 != .
tab IDCNTRY, sum(performance)























