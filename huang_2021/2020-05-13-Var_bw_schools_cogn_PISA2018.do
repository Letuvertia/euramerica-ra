// cd "E:\data\pisa\2018"

// log using "2020-05-13-Var_bw_schools_cogn_PISA2018.log", replace

// use CY07_MSU_STU_QQQ, clear

use "C:\Users\1026o\Desktop\eur_america\pisa_2018\CY07_MSU_STU_QQQ_pisa2018.dta", clear

// sort CNTRYID CNTSCHID

// merge m:1 CNTRYID CNTSCHID using "CY07_MSU_SCH_QQQ.dta"

keep if CNT=="TAP"

gen junk=1

sum PV*MATH
sum PV*SCIE
sum PV*READ

// gen private=SCHLTYPE
// recode private 1 2=1 3=0 8 9=.

areg PV1MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
oneway PV1MATH CNTSCHID [aw=W_FSTUWT] if ST001D01T==9
oneway PV1MATH CNTSCHID if ST001D01T==9

// ***Math, Grade 9
// areg PV1MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV2MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV3MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV4MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV5MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV6MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV7MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV8MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV9MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV10MATH junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)

// ***Math, Grade 10
// areg PV1MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV2MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV3MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV4MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV5MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV6MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV7MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV8MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV9MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV10MATH junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
//
// ***Science, Grade 9
// areg PV1SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV2SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV3SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV4SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV5SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV6SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV7SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV8SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV9SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV10SCIE junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
//
// ***Science, Grade 10
// areg PV1SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV2SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV3SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV4SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV5SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV6SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV7SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV8SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV9SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV10SCIE junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
//
// ***Reading, Grade 9
// areg PV1READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV2READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV3READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV4READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV5READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV6READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV7READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV8READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV9READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
// areg PV10READ junk [aw=W_FSTUWT] if ST001D01T==9, absorb (CNTSCHID)
//
// ***Reading, Grade 10
// areg PV1READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV2READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV3READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV4READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV5READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV6READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV7READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV8READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV9READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)
// areg PV10READ junk [aw=W_FSTUWT] if ST001D01T==10, absorb (CNTSCHID)

// log close
