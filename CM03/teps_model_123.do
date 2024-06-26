cd "C:\Users\1026o\Desktop\eur_america\teps_r\"

log using "C:\Users\1026o\Desktop\eur_america\code\teps_model_123.log", replace

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

***================================
*** Create vairables
***================================

***Create four math score groups
***Keep only the lowest quantile (group 0)
egen ms_group = cut(w1m3p), group(4)
ta ms_group
keep if ms_group == 0

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

***Create sex
recode w1s502 (2=1)(1=0), gen(girl)
ta girl

***Create tutor
recode w1s108a (1=0)(2 3 4 5=1)(*=.), gen(tutor)
ta tutor

***================================
*** Multiple linear regression
***================================
*** pwcorr = check multicollinearity between independent vars
*** pcorr = check partial correlation between math9 and each independent var

***Model 1
pwcorr mathG7 college girl, obs sig star(.05)
pcorr mathG9 mathG7 college girl
regress mathG9 mathG7 college girl

***Model 2
pwcorr mathG7 college girl mathG7_college, obs sig star(.05)
pcorr mathG9 mathG7 college girl mathG7_college
regress mathG9 mathG7 college girl mathG7_college

***Model 3
pwcorr mathG7 college girl mathG7_college tutor, obs sig star(.05)
pcorr mathG9 mathG7 college girl mathG7_college tutor
regress mathG9 mathG7 college girl mathG7_college tutor

log close
