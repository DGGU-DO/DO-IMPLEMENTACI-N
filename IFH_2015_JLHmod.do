

clear
cd "/Users/pseudohacker/Desktop/informes_finales"

/*
insheet using "zvar_coef.csv",delimiter(";")

recode idmodelo (112=1)(113=2)(122=3)(123=4)(216=5)(217=6)(222=7)(223=8)(312=9)(313=10)(326=11)(415=12)(414=13)(425=14)(516=15)(518=16)(523=17)(612=18)(613=19)(624=20)(712=21)(713=22)(721=23) (815=24	)(814=25),gen(mod)
recode geo_domarea  (11=1)  (12=2)(21=3)  (22=4)(31=5)  (32=6)  (41=7)  (42=8) (51=9)  (52=10)  (61=11) (62=12) (71=13) (72=14)(81=15), gen (GEO_DominioArea)
drop v15

save "bases\zvar_coef.dta", replace

foreach a of numlist 1 (1) 25 {
use "bases\zvar_coef.dta" if mod==`a', clear
gen 	varnem_cod=0					
replace	varnem_cod=1	if	varname=="b_bien_per"
replace	varnem_cod=2	if	varname=="b_bien"
replace	varnem_cod=3	if	varname=="b_biendur"
replace	varnem_cod=4	if	varname=="b_bienel"
replace	varnem_cod=5	if	varname=="b_bientelec"
replace	varnem_cod=6	if	varname=="b4"
replace	varnem_cod=7	if	varname=="b5"
replace	varnem_cod=8	if	varname=="b6"
replace	varnem_cod=9	if	varname=="b8"
replace	varnem_cod=10	if	varname=="c_indig_jh"
replace	varnem_cod=11	if	varname=="c_jh_sec_incom"
replace	varnem_cod=12	if	varname=="d_jh_anoedu"
replace	varnem_cod=13	if	varname=="d_jh_seguro"
replace	varnem_cod=14	if	varname=="d_max_anoedu"
replace	varnem_cod=15	if	varname=="s_3serv"
replace	varnem_cod=16	if	varname=="s_agu_redd"
replace	varnem_cod=17	if	varname=="s_alum1"
replace	varnem_cod=18	if	varname=="s_dsg_redd"
replace	varnem_cod=19	if	varname=="s_ning"
replace	varnem_cod=20	if	varname=="v_hacina"
replace	varnem_cod=21	if	varname=="v_malpiso"
replace	varnem_cod=22	if	varname=="v_maltecho"
replace	varnem_cod=23	if	varname=="v_usa_comb_solido"
replace	varnem_cod=24	if	varname=="v_usa_gas"

drop id varname nommodelo conglome_geo
drop vargeomin vargeomax vargeomean vargeostdev obsnum
drop if idmodelo==.

reshape wide varcoef vargeom_st vargeoinvstdev, i(idmodelo) j(varnem_cod)
*/

drop id vargeomin vargeomax vargeomean vargeostdev

save "/Users/pseudohacker/Desktop/alg_2015/zvar_coef_wide.dta"

**Prepara tablas de vivienda y hogar

*paso de CSV a DTA
insheet using "muestra2\HOGAR.csv"
*926
save "muestra2\HOGAR", replace
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
/*
gen uno=(c05_08==1)
bys departamen provincia distrito id_cedula data: egen jh_dup= total(uno) 

gen dos=(c05_08==2)
bys departamen provincia distrito id_cedula data: egen cony_dup= total(dos) 

drop uno dos jh_dup cony_dup
*/
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





merge m:m GEO_DominioArea using "muestra2\MUESTRA2_indicadores"
keep if _m==3
drop _m

save "bases\MUESTRA2_zvar_coef_`a'.dta", replace
}

use "bases\MUESTRA2_zvar_coef_1.dta", replace
foreach a of numlist 2(1)25 {
append using "bases\MUESTRA2_zvar_coef_`a'.dta"
}

save "bases\MUESTRA2_TOT.dta", replace


use "bases\MUESTRA2_TOT.dta", clear

duplicates drop departamen provincia distrito id_cedula data idmodelo, force

*HALLAMOS ZVAR Y PUNTAJES

gen	b_bien_per_z_punt	          =	b_bien_per	    *	vargeoinvstdev1	    *	varcoef1	-	vargeom_st1	    *	varcoef1   if !missing(b_bien_per)
gen	b_bien_z_punt	              =	b_bien	        *	vargeoinvstdev2	    *	varcoef2	-	vargeom_st2	    *	varcoef2   if !missing(b_bien)
gen	b_biendur_z_punt	          =	b_biendur	    *	vargeoinvstdev3	    *	varcoef3	-	vargeom_st3     *	varcoef3   if !missing(b_biendur)
gen	b_bienel_z_punt               =	b_bienel	    *	vargeoinvstdev4	    *	varcoef4	-	vargeom_st4	    *	varcoef4   if !missing(b_bienel)
gen	b_bientelec_z_punt            =	b_bientelec	    *	vargeoinvstdev5	    *	varcoef5	-	vargeom_st5     *	varcoef5   if !missing(b_bientelec)
gen	b4_z_punt	                  =	b4	            *	vargeoinvstdev6	    *	varcoef6	-	vargeom_st6	    *	varcoef6   if !missing(b4)
gen	b5_z_punt	                  =	b5	            *	vargeoinvstdev7	    *	varcoef7	-	vargeom_st7	    *	varcoef7   if !missing(b5)
gen	b6_z_punt	                  =	b6       	    *	vargeoinvstdev8	    *	varcoef8	-	vargeom_st8	    *	varcoef8   if !missing(b6)
gen	b8_z_punt	                  =	b8	            *	vargeoinvstdev9	    *	varcoef9	-	vargeom_st9	    *	varcoef9   if !missing(b8)
gen	c_indig_jh_z_punt             =	c_indig_jh	    *	vargeoinvstdev10    *	varcoef10	-	vargeom_st10	*	varcoef10  if !missing(c_indig_jh)
gen	c_jh_sec_incom_z_punt	      =	c_jh_sec_incom	*	vargeoinvstdev11    *	varcoef11	-	vargeom_st11	*	varcoef11  if !missing(c_jh_sec_incom)
gen	d_jh_anoedu_z_punt	          =	d_jh_anoedu	    *	vargeoinvstdev12    *	varcoef12	-	vargeom_st12	*	varcoef12  if !missing(d_jh_anoedu)
gen	d_jh_seguro_z_punt	          =	d_jh_seguro	    *	vargeoinvstdev13	*	varcoef13	-	vargeom_st13	*	varcoef13  if !missing(d_jh_seguro)
gen	d_max_anoedu_z_punt           =	d_max_anoedu	*	vargeoinvstdev14	*	varcoef14	-	vargeom_st14	*	varcoef14  if !missing(d_max_anoedu)
gen	s_3serv_z_punt	              =	s_3serv	        *	vargeoinvstdev15	*	varcoef15	-	vargeom_st15	*	varcoef15  if !missing(s_3serv)
gen	s_alum1_z_punt	              =	s_alum1	        *	vargeoinvstdev17	*	varcoef17	-	vargeom_st17	*	varcoef17  if !missing(s_alum1)
gen	s_dsg_redd_z_punt	          =	s_dsg_redd	    *	vargeoinvstdev18	*	varcoef18	-	vargeom_st18	*	varcoef18  if !missing(s_dsg_redd)
gen	s_ning_z_punt	              =	s_ning	        *	vargeoinvstdev19	*	varcoef19	-	vargeom_st19	*	varcoef19  if !missing(s_ning)
gen	v_hacina_z_punt	              =	v_hacina	    *	vargeoinvstdev20	*	varcoef20	-	vargeom_st20	*	varcoef20  if !missing(v_hacina)
gen	v_malpiso_z_punt	          =	v_malpiso	    *	vargeoinvstdev21	*	varcoef21	-	vargeom_st21	*	varcoef21  if !missing(v_malpiso)
gen	v_maltecho_z_punt	          =	v_maltecho	    *	vargeoinvstdev22	*	varcoef22	-	vargeom_st22	*	varcoef22  if !missing(v_maltecho)
gen	v_usa_comb_solido_z_punt	  =	v_usa_comb_solido*	vargeoinvstdev23    *	varcoef23	-	vargeom_st23	*	varcoef23  if !missing(v_usa_comb_solido)
gen	v_usa_gas_z_punt	          =	v_usa_gas	    *	vargeoinvstdev24	*	varcoef24	-	vargeom_st24	*	varcoef24  if !missing(v_usa_gas)


*GEO_DominioArea
*idmodelo 

egen total_puntuado=rowtotal(b_bien_per_z_punt	b_bien_z_punt	b_biendur_z_punt	b_bienel_z_punt	b_bientelec_z_punt	b4_z_punt	b5_z_punt	b6_z_punt	b8_z_punt	c_indig_jh_z_punt	c_jh_sec_incom_z_punt	d_jh_anoedu_z_punt	d_jh_seguro_z_punt	d_max_anoedu_z_punt	s_3serv_z_punt	s_alum1_z_punt	s_dsg_redd_z_punt	s_ning_z_punt	v_hacina_z_punt	v_malpiso_z_punt	v_maltecho_z_punt	v_usa_comb_solido_z_punt	v_usa_gas_z_punt), miss

save "bases\MUESTRA2_TOT_puntuado.dta", replace

clear
use "bases\umbrales_150512_a.dta", clear

gen    umbral2=round(umbral, 0.001)
drop   umbral
rename umbral2 umbral

gen    umbralextrema2=round(umbralextrema, 0.001)
drop   umbralextrema
rename umbralextrema2 umbralextrema


gen and_or=2
replace and_or=1 if geo_dominioarea==32
replace and_or=1 if geo_dominioarea==42 
replace and_or=1 if geo_dominioarea==52 
replace and_or=1 if geo_dominioarea==62 
replace and_or=1 if geo_dominioarea==72 

gen and_or_ext=1

merge 1:m idmodelo using "bases\MUESTRA2_TOT_puntuado.dta"
drop _m

*condición de pobreza
 
gen pobre_umbral1=(total_puntuado>=umbral) if !missing(umbral) &  !missing(total_puntuado) 
bys departamen provincia distrito id_cedula data geo_dominioarea: egen pobre_umbral2= total(pobre_umbral1), miss
/*
gen     pobre_ =0
replace pobre_ =1 if pobre_umbral2==1 & and_or==1 & geo_dominioarea==32
replace pobre_ =1 if pobre_umbral2==1 & and_or==1 & geo_dominioarea==42
replace pobre_ =1 if pobre_umbral2==1 & and_or==1 & geo_dominioarea==52
replace pobre_ =1 if pobre_umbral2==1 & and_or==1 & geo_dominioarea==62
replace pobre_ =1 if pobre_umbral2==1 & and_or==1 & geo_dominioarea==72
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==11
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==12
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==21
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==22
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==31
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==41
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==51
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==61
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==71
replace pobre_ =1 if pobre_umbral2==2 & and_or==2 & geo_dominioarea==81
*/
gen     pobre_ =.
replace pobre_ = (pobre_umbral2>=1) if geo_dominioarea==32 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=1) if geo_dominioarea==42 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=1) if geo_dominioarea==52 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=1) if geo_dominioarea==62 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=1) if geo_dominioarea==72 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==11 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==12 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==21 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==22 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==31 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==41 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==51 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==61 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==71 &  !missing(pobre_umbral2)
replace pobre_ = (pobre_umbral2>=2) if geo_dominioarea==81 &  !missing(pobre_umbral2)

*condición de pobreza extrema

gen pobre_umbralext1=(total_puntuado>=umbralextrema) if pobre_==1 & !missing(umbralextrema) & !missing(total_puntuado)
bys departamen provincia distrito id_cedula data geo_dominioarea: egen pobre_umbralext2= total(pobre_umbralext1), miss

gen      pobrext_ =0 if !missing(pobre_umbralext2) & !missing(pobre_)& pobre_==1
replace  pobrext_ =1 if pobre_umbralext2>=1 & pobre_==1 & !missing(pobre_umbralext2) & !missing(pobre_)

recode pobre_ (0=3) (1=2) (else=.), gen (pobrezamidis)
 
replace pobrezamidis=1 if pobrext_==1


label define pob 1 "Pobre ext" 2 "pobreno ext" 3 "no pobre"
label values pobrezamidis pob


label define geo	1 "11Costa Norte-urbano"   2 "12Costa Norte-rural" ///
                    3 "21Costa Centro-urbano"  4 "22Costa Centro-rural" ///
					5 "31Costa Sur-urbano"     6 "32Costa Sur-rural" ///
					7 "41Sierra Norte-urbano"  8 "42Sierra Norte-rural" ///
					9 "51Sierra Centro-urbano" 10 "52Sierra Centro-rural" ///
					11 "61Sierra Sur-urbano"   12 "62Sierra Sur-rural" ///
					13 "71Selva-urbano"        14 "72Selva-rural" ///
					15 "81Lima Metropolitana-urbano", modify
label values GEO_DominioArea geo
*drop if idmodelo==113 | idmodelo==815


duplicates drop departamen provincia distrito id_cedula data,force 

tab pobrezamidis
tab  GEO_DominioArea pobrezamidis
