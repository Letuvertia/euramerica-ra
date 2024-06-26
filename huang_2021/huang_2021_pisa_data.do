*** Use PISA 2018
cd "C:\Users\1026o\Desktop\eur_america\"
// use "pisa_2018\CY07_MSU_STU_QQQ_pisa2018.dta", clear
use "pisa_2022\CY08MSP_STU_QQQ_pisa2022.dta", clear

*** Var
*** CNTRYID = country
clonevar country = CNTRYID

*** CNTSCHID = international school id
clonevar school = CNTSCHID

*** ST001D01T = international student grade
clonevar grade = ST001D01T
keep if grade == 9 | grade == 10

*** PV1MATH~PV10MATH = plausible values of math
clonevar math1 = PV1MATH
clonevar math2 = PV2MATH
clonevar math3 = PV3MATH
clonevar math4 = PV4MATH
clonevar math5 = PV5MATH
clonevar math6 = PV6MATH
clonevar math7 = PV7MATH
clonevar math8 = PV8MATH
clonevar math9 = PV9MATH
clonevar math10 = PV10MATH

*** PV1READ~PV10READ = plausible values of reading
clonevar read1 = PV1READ
clonevar read2 = PV2READ
clonevar read3 = PV3READ
clonevar read4 = PV4READ
clonevar read5 = PV5READ
clonevar read6 = PV6READ
clonevar read7 = PV7READ
clonevar read8 = PV8READ
clonevar read9 = PV9READ
clonevar read10 = PV10READ

*** PV1SCIE~PV10SCIE = plausible values of science
clonevar scie1 = PV1SCIE
clonevar scie2 = PV2SCIE
clonevar scie3 = PV3SCIE
clonevar scie4 = PV4SCIE
clonevar scie5 = PV5SCIE
clonevar scie6 = PV6SCIE
clonevar scie7 = PV7SCIE
clonevar scie8 = PV8SCIE
clonevar scie9 = PV9SCIE
clonevar scie10 = PV10SCIE

*** ESCS = index of economic, social and cultural status
recode ESCS (99=.), gen(soc)

*** W_FSTUWT = adjusted student weight, aw
clonevar weight = W_FSTUWT

*** Sort
sort country school

*** Check if clonevar succeed ('gen' seems to fail)
codebook CNTSCHID if ST001D01T == 10 & CNTRYID == 410
codebook school if grade == 10 & country == 410

*** Export to xlsx
export excel country school grade soc weight ///
math1 math2 math3 math4 math5 math6 math7 math8 math9 math10 ///
read1 read2 read3 read4 read5 read6 read7 read8 read9 read10 ///
scie1 scie2 scie3 scie4 scie5 scie6 scie7 scie8 scie9 scie10 ///
using "pisa_2022\huang_2021_pisa_2022_data.xlsx", firstrow(variables)
// using "pisa_2018\huang_2021_pisa_2018_data.xlsx", firstrow(variables)
