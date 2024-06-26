cd "C:\Users\1026o\Desktop\eur_america\"
log using "schutz_2008\schutz_2008_table_13.log", replace
ssc install _gwtmean // https://stackoverflow.com/questions/66250560/computing-a-weighted-average-per-observation-stata

*** ==================================================
*** Inconsistency of variable name between two datasets
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
*** Inconsistency of country code between two datasets
*** ==================================================
*** country                | TIMSS 1995  | TIMSS 1999
*** ------------------------------------------------
*** Belgium (Fl)           | 056         | 956
*** Belgium (Fl)           | 057         | 957
*** Czech Republic         | 200         | 203
*** England                | 826         | 926
*** Scotland               | 827         | 927
*** Slovenia               | 890         | 705
*** South Africa           | 717         | 710


*** ==================================================
*** Clean TIMSS 1995
*** ==================================================
use "timss_1995\TIMSS_1995_Global.dta", clear
gen is_1995 = 1

*** Rename variables to fit TIMSS 1999 naming convention
rename idstud IDSTUD
rename idcntry IDCNTRY
rename itsex ITSEX
rename bsdage BSDAGE
rename bsbgbook BSBGBOOK
rename bsbgbrnm BSBGBRNM
rename bsbgbrnf BSBGBRNF
rename totwgt TOTWGT
rename BSMPV01 BSMMAT01
rename BSMPV02 BSMMAT02
rename BSMPV03 BSMMAT03
rename BSMPV04 BSMMAT04
rename BSMPV05 BSMMAT05
rename BSSPV01 BSSSCI01
rename BSSPV02 BSSSCI02
rename BSSPV03 BSSSCI03
rename BSSPV04 BSSSCI04
rename BSSPV05 BSSSCI05

*** Fix IDCNTRY to fix TIMSS 1999 codebook
replace IDCNTRY = 956 if IDCNTRY == 056
replace IDCNTRY = 957 if IDCNTRY == 057
replace IDCNTRY = 203 if IDCNTRY == 200
replace IDCNTRY = 926 if IDCNTRY == 826
replace IDCNTRY = 927 if IDCNTRY == 827
replace IDCNTRY = 705 if IDCNTRY == 890
replace IDCNTRY = 710 if IDCNTRY == 717

*** Keep only 8th graders
keep if idgrade == 8

*** Check the number of countries
*** 35 countries not 40 countries
*** 5 missing: Denmark(208), Ireland(372), Kuwait(414), Philippines(608), Scotland(927)
***   These countries have no 8th graders.
*** 1 unexcepted: an unknown country(201)
***   Singapore(702) is missing
codebook IDCNTRY

*** Check sample size with TIMSS 1995 user guide (p.3-14)
*** Incompatible sample size (paper number/dataset number):
*** - Australia(036): 7253/7392
*** - New Zealand(554): 3683/3184
*** - Sweden(753): 4075/1949
*** - Switzerland(756): 4855/4275
*** - England(826): 1776/1803
tab IDCNTRY

*** Save dataset
d, s
save "timss_1995\TIMSS_1995_Global_tmp.dta", replace


*** ==================================================
*** Clean TIMSS 1999
*** ==================================================
use "timss_1999\timss_1999.dta", clear
gen is_1999 = 1

*** All responses from Chinese Taipei is duplicated (IDCNTRY=158)
duplicates drop IDSTUD IDCNTRY, force

*** Check the number of countries
*** 38 countries
codebook IDCNTRY

*** Save dataset
d, s
save "timss_1999\timss_1999_tmp.dta", replace


*** ==================================================
*** Merge two datasets
*** ==================================================
use "timss_1995\TIMSS_1995_Global_tmp.dta", clear
append using "timss_1999\timss_1999_tmp.dta"
sort IDCNTRY

*** Check all countries
*** 50 countries not 54 countries
*** 4 missing: Denmark(208), Ireland(372), Kuwait(414), Phillppines(608)
***    These countries only participate in TIMSS 1995 and are exluded b/c no 8th graders.
codebook IDCNTRY

*** Check all countries that participated in both studies
*** 23 countries not 24 countries
*** 1 missing: Singapore(702)
***   Singpore is missing from TIMSS 1995
bysort IDCNTRY: egen NCNTRY_1995 = sum(is_1995) // # of response of a country in 1995
bysort IDCNTRY: egen NCNTRY_1999 = sum(is_1999) // # of response of a country in 1999
codebook IDCNTRY if NCNTRY_1995 != 0 & NCNTRY_1999 != 0

*** Save dataset
d, s
save "timss_1999\timss_1995_1999_merge.dta", replace


*** ==================================================
*** Preprocessing
*** ==================================================
use "timss_1999\timss_1995_1999_merge.dta", clear

*** Generate the "lives_with_parents" variable
gen lives_with_mother = 0
replace lives_with_mother = 1 if BSBGADU1 == 1 | BSBGADU5 == 1

gen lives_with_father = 0
replace lives_with_father = 1 if BSBGADU2 == 1 | BSBGADU6 == 1

gen lives_with_parents = 0
replace lives_with_parents = 1 if lives_with_mother == 1 & lives_with_father == 1
replace lives_with_parents = . if BSBGADU1 == . & BSBGADU5 == . & BSBGADU2 == . & BSBGADU6 == .

*** Generate the "study dummy" variable, indicating the countries participating both TIMSS studies
gen part_both_studies = 0
replace part_both_studies = 1 if NCNTRY_1995 != 0 & NCNTRY_1999 != 0

*** Drop missing values
drop if ITSEX == .
drop if BSDAGE == . | BSDAGE == 98 | BSDAGE == 99
drop if lives_with_parents == .
drop if BSBGBOOK == . | BSBGBOOK == 7 | BSBGBOOK == 8
drop if BSBGBRN1 != 1 & BSBGBRN1 != 2
drop if BSBGBRNM != 1 & BSBGBRNM != 2
drop if BSBGBRNF != 1 & BSBGBRNF != 2
drop if BSMMAT01 == . | BSMMAT02 == . | BSMMAT03 == . | BSMMAT04 == . | BSMMAT05 == .
drop if BSSSCI01 == . | BSSSCI02 == . | BSSSCI03 == . | BSSSCI04 == . | BSSSCI05 == .
drop if TOTWGT == .

*** Recode dummmy variables and change labels
label define lives_with_parents 0 "Does not live with parents" 1 "Lives with parents"
label values lives_with_parents lives_with_parents

label define part_both_studies 0 "Participates in one of the studies" 1 "Participates both studies"
label values part_both_studies part_both_studies

recode ITSEX (1=1) (2=0)
label drop ITSEX
label define ITSEX 0 "Boy" 1 "Girl"
label values ITSEX ITSEX

recode BSBGBRN1 (1=1) (2=0)
label drop BSBGBRN1
label define BSBGBRN1 0 "Was not born in the country" 1 "Born in the country (I)"
label values BSBGBRN1 BSBGBRN1

recode BSBGBRNM (1=1) (2=0)
label drop BSBGBRNM
label define BSBGBRNM 0 "Was not born in the country" 1 "Born in the country (Mother)"
label values BSBGBRNM BSBGBRNM

recode BSBGBRNF (1=1) (2=0)
label drop BSBGBRNF
label define BSBGBRNF 0 "Was not born in the country" 1 "Born in the country (Father)"
label values BSBGBRNF BSBGBRNF


*** ==================================================
*** Table 1
*** ==================================================

*** Calculate the "performance" variable
bysort IDCNTRY: egen BSMMAT01_mean = wtmean(BSMMAT01), weight(TOTWGT)
bysort IDCNTRY: egen BSMMAT02_mean = wtmean(BSMMAT02), weight(TOTWGT)
bysort IDCNTRY: egen BSMMAT03_mean = wtmean(BSMMAT03), weight(TOTWGT)
bysort IDCNTRY: egen BSMMAT04_mean = wtmean(BSMMAT04), weight(TOTWGT)
bysort IDCNTRY: egen BSMMAT05_mean = wtmean(BSMMAT05), weight(TOTWGT)
gen math_mean = (BSMMAT01_mean + BSMMAT02_mean + BSMMAT03_mean + BSMMAT04_mean + BSMMAT05_mean) / 5

bysort IDCNTRY: egen BSSSCI01_mean = wtmean(BSSSCI01), weight(TOTWGT)
bysort IDCNTRY: egen BSSSCI02_mean = wtmean(BSSSCI02), weight(TOTWGT)
bysort IDCNTRY: egen BSSSCI03_mean = wtmean(BSSSCI03), weight(TOTWGT)
bysort IDCNTRY: egen BSSSCI04_mean = wtmean(BSSSCI04), weight(TOTWGT)
bysort IDCNTRY: egen BSSSCI05_mean = wtmean(BSSSCI05), weight(TOTWGT)
gen scie_mean = (BSSSCI01_mean + BSSSCI02_mean + BSSSCI03_mean + BSSSCI04_mean + BSSSCI05_mean) / 5

gen performance = (math_mean + scie_mean) / 2

tab IDCNTRY, sum(performance)


*** ==================================================
*** Table 3
*** ==================================================

*** Only taiwan
gen constant=1

regress performance ///
constant ///
BSBGBOOK ///
BSDAGE ///
i.ITSEX ///
i.lives_with_parents ///
i.part_both_studies ///
i.BSBGBRN1 ///
i.BSBGBRNM ///
i.BSBGBRNF ///
i.BSBGBRN1##BSBGBOOK ///
i.BSBGBRNM##BSBGBOOK ///
i.BSBGBRNF##BSBGBOOK ///
[aw=TOTWGT] if IDCNTRY == 158

log close

