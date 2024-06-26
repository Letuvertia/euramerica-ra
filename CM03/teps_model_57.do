cd "C:\Users\1026o\Desktop\eur_america\teps_r\"

log using "C:\Users\1026o\Desktop\eur_america\code\teps_model_57.log", replace

***================================
*** Merge datasets
***================================

***Use 2001 grade 7 student data
use "w1j\w1_j_s_lv6.0.dta", clear

***Merge 2001 grade 7 parent data.
merge 1:1 stud_id using "w1j\w1_j_p_lv6.0.dta"
drop _merge

***Merge 2003 grade 9 student data.
merge 1:1 stud_id using "w2j\w2_j_s_lv6.0.dta"
drop _merge

***Merge 2005 grade 11 core panel student data.
merge 1:1 stud_id using "w3s\w3_sf_s_cp_lv6.0.dta"

***Keep only core panel student
keep if _merge == 3

***================================
*** Create vairables
***================================

***Create four math score groups
***Keep only the lowest quantile (group 0)
egen ms_group = cut(w1m3p), group(4)
ta ms_group
keep if ms_group == 0

***Create high school
***1 = 普通高中 (2-普通學程)
***0 = 職業高中 (3-綜合學程, 4-高職, 5-五專)
recode w3pgrm (2=1)(3 4 5=0), gen(high_school)
ta high_school

***Create science
***1 = 自然組 (21-普通學程自然組)
***0 = 社會組 (22-普通學程非自然組)
recode w3clspgm (21=1)(22=0)(*=.), gen(science)
ta science

***Create math score
gen mathG7 = w1m3p
gen mathG9 = w2m3p

***Create parental education
***1 = Less than HS (1-國中或以下)
***2 = HS only (2-高中、高職)
***3 = College and beyond (3-專科(二、三、五專)、技術學院或科技大學, 4-一般大學, 5-研究所)
gen paedu=.
replace paedu=1 if w1faedu==1 & w1moedu==1
replace paedu=2 if w1faedu==2 | w1moedu==2
replace paedu=3 if (w1faedu==3 | w1faedu==4 | w1faedu==5) | (w1moedu==3 | w1moedu==4 | w1moedu==5)
ta paedu

recode paedu (3=1)(*=0), gen(college)
ta college

***Create interaction between math score and parental education
gen mathG7_college = mathG7 * college
gen mathG9_college = mathG9 * college

***Create sex
recode w1s502 (2=1)(1=0), gen(girl)
ta girl

***================================
*** Multiple linear regression
***================================
*** pwcorr = check multicollinearity between independent vars
*** pcorr = check partial correlation between high_school and each independent var

***Model 5.a (with mathG7)
pwcorr mathG7 college girl mathG7_college, obs sig star(.05)
pcorr high_school mathG7 college girl mathG7_college
regress high_school mathG7 college girl mathG7_college

***Model 5.b (with mathG9)
pwcorr mathG9 college girl mathG9_college, obs sig star(.05)
pcorr high_school mathG9 college girl mathG9_college
regress high_school mathG9 college girl mathG9_college

***Model 7.a (with mathG7)
pwcorr mathG7 college girl mathG7_college, obs sig star(.05)
pcorr science mathG7 college girl mathG7_college
regress science mathG7 college girl mathG7_college

***Model 7.b (with mathG9)
pwcorr mathG9 college girl mathG9_college, obs sig star(.05)
pcorr science mathG9 college girl mathG9_college
regress science mathG9 college girl mathG9_college

log close
