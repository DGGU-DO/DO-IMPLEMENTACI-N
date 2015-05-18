
clear

*cd "D:\MIDIS 2015\METODOLOGÍA MIDIS 2015\2. Implementación\"

cd "G:\bases ifh 2015\"

*paso de CSV a DTA
insheet using "muestra2\HOGAR.csv"
*926
saveold "muestra2\HOGAR", replace
clear

insheet using "muestra2\LOCALIZACION.csv"
*926
recode       cod_ccpp (0=.)
gen          ccpp=codccpp  if cod_ccpp==. 
destring     ccpp, replace
recode ccpp  (0=.)
replace      cod_ccpp=ccpp if cod_ccpp==. 
saveold "muestra2\LOCALIZACION", replace
clear

insheet using "muestra2\POBLACION.csv"

saveold "muestra2\POBLACION", replace
clear

insheet using "muestra2\VIVIENDA.csv"
saveold "muestra2\VIVIENDA", replace

 * base ccpp
use "bases\conglomerados_geo_ccpp.dta", clear

rename DPTO_IMPUTADO     departamen 
rename PROV_IMPUTADO     provincia 
rename DIST_IMPUTADO     distrito 
rename COD_CCPP_IMPUTADO cod_ccpp

keep GEO_area GEO_DominioArea departamen provincia distrito cod_ccpp

save "bases\dominio_midis", replace

merge 1:m departamen provincia distrito cod_ccpp using "muestra2\LOCALIZACION"
keep if _m==3
drop _m
saveold "muestra2\LOCALIZACION_ccpp", replace

 *Junto bases
 *=============

use "muestra2\VIVIENDA", clear
merge 1:1 departamen provincia distrito id_cedula data using "muestra2\HOGAR"
drop _m

merge 1:m departamen provincia distrito id_cedula data using "muestra2\POBLACION"
drop _m

merge m:1 departamen provincia distrito id_cedula data using "muestra2\LOCALIZACION_ccpp"

keep if _m==3
drop _m

save "muestra2\BASE_MUESTRA2", replace
