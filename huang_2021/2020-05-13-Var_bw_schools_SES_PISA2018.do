cd "E:\data\pisa\2018"

log using "2020-05-13-Var_bw_schools_SES_PISA2018.log", replace

use CY07_MSU_STU_QQQ, clear

sort CNTRYID CNTSCHID

merge m:1 CNTRYID CNTSCHID using "CY07_MSU_SCH_QQQ.dta"

keep if CNT=="TAP"

gen junk=1

sum PV*MATH
sum PV*SCIE
sum PV*READ

gen private=SCHLTYPE
recode private 1 2=1 3=0 8 9=.

***Family SES, Grade 9
areg ESCS junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)

***Family SES, Grade 10
areg ESCS junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)

log close