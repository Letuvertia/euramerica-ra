cd "C:\Users\m_bib\Google Drive\data\teps"

log using "2020-01-01-disadvantage_SES.log", replace

***Use 2001 grade 7 student data
use "w1j\w1_j_s_lv6.0.dta", clear

***Merge 2001 grade 7 parent data
merge 1:1 stud_id using "w1j\w1_j_p_lv6.0.dta"

***Create four math score groups
***Group 0 is the lowest quantile
egen ms_group = cut(w1m3p), group(4)

ta ms_group

***Create four all score groups
***Group 0 is the first quartile
egen all_group = cut(w1all3p), group(4)

ta all_group

***Create four cf score groups
***Group 0 is the first quartile
egen cf_group = cut(w1cf3p), group(4)

ta cf_group

***Create parental education
***1 = Less than HS
***2 = HS only
***3 = College and beyond
gen paedu=.
replace paedu=1 if w1faedu==1 & w1moedu==1
replace paedu=2 if w1faedu==2 | w1moedu==2
replace paedu=3 if (w1faedu==3 | w1faedu==4 | w1faedu==5) | (w1moedu==3 | w1moedu==4 | w1moedu==5)

ta paedu

drop _merge

***Merge 2003 grade 9 student data
merge 1:1 stud_id using "w2j\w2_j_s_lv6.0.dta"

ta _merge

***********************************************************
***Below the first quartile in math
***********************************************************

***Parental education = Less than HS
***2001 grade 7
sum w1m3p [aw=w1stwt1] if ms_group==0 & paedu==1 & _merge==3

***2003 grade 9
sum w2m3p [aw=w2stwt2] if ms_group==0 & paedu==1 & _merge==3

***Parental education = HS
***2001 grade 7
sum w1m3p [aw=w1stwt1] if ms_group==0 & paedu==2 & _merge==3

***2003 grade 9
sum w2m3p [aw=w2stwt2] if ms_group==0 & paedu==2 & _merge==3

***Parental education = College and beyound
***2001 grade 7
sum w1m3p [aw=w1stwt1] if ms_group==0 & paedu==3 & _merge==3

***2003 grade 9
sum w2m3p [aw=w2stwt2] if ms_group==0 & paedu==3 & _merge==3

***********************************************************
***Above the third quartile in math
***********************************************************

***Parental education = Less than HS
***2001 grade 7
sum w1m3p [aw=w1stwt1] if ms_group==3 & paedu==1 & _merge==3

***2003 grade 9
sum w2m3p [aw=w2stwt2] if ms_group==3 & paedu==1 & _merge==3

***Parental education = HS
***2001 grade 7
sum w1m3p [aw=w1stwt1] if ms_group==3 & paedu==2 & _merge==3

***2003 grade 9
sum w2m3p [aw=w2stwt2] if ms_group==3 & paedu==2 & _merge==3

***Parental education = College and beyound
***2001 grade 7
sum w1m3p [aw=w1stwt1] if ms_group==3 & paedu==3 & _merge==3

***2003 grade 9
sum w2m3p [aw=w2stwt2] if ms_group==3 & paedu==3 & _merge==3

***********************************************************
***Below the first quartile in all3p
***********************************************************

***Parental education = Less than HS
***2001 grade 7
sum w1all3p [aw=w1stwt1] if all_group==0 & paedu==1 & _merge==3

***2003 grade 9
sum w2all3p [aw=w2stwt2] if all_group==0 & paedu==1 & _merge==3

***Parental education = HS
***2001 grade 7
sum w1all3p [aw=w1stwt1] if all_group==0 & paedu==2 & _merge==3

***2003 grade 9
sum w2all3p [aw=w2stwt2] if all_group==0 & paedu==2 & _merge==3

***Parental education = College and beyound
***2001 grade 7
sum w1all3p [aw=w1stwt1] if all_group==0 & paedu==3 & _merge==3

***2003 grade 9
sum w2all3p [aw=w2stwt2] if all_group==0 & paedu==3 & _merge==3

***********************************************************
***Above the third quartile in all3p
***********************************************************
***Parental education = Less than HS
***2001 grade 7
sum w1all3p [aw=w1stwt1] if all_group==3 & paedu==1 & _merge==3

***2003 grade 9
sum w2all3p [aw=w2stwt2] if all_group==3 & paedu==1 & _merge==3

***Parental education = HS
***2001 grade 7
sum w1all3p [aw=w1stwt1] if all_group==3 & paedu==2 & _merge==3

***2003 grade 9
sum w2all3p [aw=w2stwt2] if all_group==3 & paedu==2 & _merge==3

***Parental education = College and beyound
***2001 grade 7
sum w1all3p [aw=w1stwt1] if all_group==3 & paedu==3 & _merge==3

***2003 grade 9
sum w2all3p [aw=w2stwt2] if all_group==3 & paedu==3 & _merge==3

***********************************************************
***Below the first quartile in cf3p
***********************************************************

***Parental education = Less than HS
***2001 grade 7
sum w1cf3p [aw=w1stwt1] if cf_group==0 & paedu==1 & _merge==3

***2003 grade 9
sum w2cf3p [aw=w2stwt2] if cf_group==0 & paedu==1 & _merge==3

***Parental education = HS
***2001 grade 7
sum w1cf3p [aw=w1stwt1] if cf_group==0 & paedu==2 & _merge==3

***2003 grade 9
sum w2cf3p [aw=w2stwt2] if cf_group==0 & paedu==2 & _merge==3

***Parental education = College and beyound
***2001 grade 7
sum w1cf3p [aw=w1stwt1] if cf_group==0 & paedu==3 & _merge==3

***2003 grade 9
sum w2cf3p [aw=w2stwt2] if cf_group==0 & paedu==3 & _merge==3

***********************************************************
***Above the third quartile in cf3p
***********************************************************
***Parental education = Less than HS
***2001 grade 7
sum w1cf3p [aw=w1stwt1] if cf_group==3 & paedu==1 & _merge==3

***2003 grade 9
sum w2cf3p [aw=w2stwt2] if cf_group==3 & paedu==1 & _merge==3

***Parental education = HS
***2001 grade 7
sum w1cf3p [aw=w1stwt1] if cf_group==3 & paedu==2 & _merge==3

***2003 grade 9
sum w2cf3p [aw=w2stwt2] if cf_group==3 & paedu==2 & _merge==3

***Parental education = College and beyound
***2001 grade 7
sum w1cf3p [aw=w1stwt1] if cf_group==3 & paedu==3 & _merge==3

***2003 grade 9
sum w2cf3p [aw=w2stwt2] if cf_group==3 & paedu==3 & _merge==3

log close
