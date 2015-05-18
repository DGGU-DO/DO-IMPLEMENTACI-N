
clear
cd "D:\MIDIS 2015\METODOLOGÍA MIDIS 2015\2. Implementación\"

*
*insheet using "bases\zvar_coef.csv",delimiter(";")
*recode idmodelo (112=1)(113=2)(122=3)(123=4)(216=5)(217=6)(222=7)(223=8)(312=9)(313=10)(326=11)(415=12)(414=13)(425=14)(516=15)(518=16)(523=17)(612=18)(613=19)(624=20)(712=21)(713=22)(721=23) (815=24	)(814=25),gen(mod)
*recode geo_domarea  (11=1)  (12=2)(21=3)  (22=4)(31=5)  (32=6)  (41=7)  (42=8) (51=9)  (52=10)  (61=11) (62=12) (71=13) (72=14)(81=15), gen (GEO_DominioArea)
*drop v15

*
*use "enaho\base_unificada", clear
use "enaho\ENAHO_TOTA1L_Puntaje.dta", clear

keep if p203==1


rename geo_domarea GEO_DominioArea

recode GEO_DominioArea (11=1)  (12=2)(21=3)  (22=4)(31=5)  (32=6)  (41=7)  (42=8) (51=9)  (52=10)  (61=11) (62=12) (71=13) (72=14)(81=15)

keep if nanio==2014

save "enaho\base_unificada_2014", replace

use "bases\zvar_coef.dta", clear

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
*save "bases\zvar_coef_`a'.dta", replace

merge m:m GEO_DominioArea using "enaho\base_unificada_2014"
keep if _m==3
drop _m

save "bases\enaho_zvar_coef_`a'.dta", replace

}

use "bases\enaho_zvar_coef_1.dta", replace
foreach a of numlist 2(1)25 {
append using "bases\enaho_zvar_coef_`a'.dta"
}
save "enaho\enaho_TOT.dta", replace
*30848 hh
use "enaho\enaho_TOT.dta", clear

*HALLAMOS ZVAR Y PUNTAJES

gen	b_bien_per_z_punt	          =	b_bien_per	    *	vargeoinvstdev1	    *	varcoef1	-	vargeom_st1	    *	varcoef1
gen	b_bien_z_punt	              =	b_bien	        *	vargeoinvstdev2	    *	varcoef2	-	vargeom_st2	    *	varcoef2
gen	b_biendur_z_punt	          =	b_biendur	    *	vargeoinvstdev3	    *	varcoef3	-	vargeom_st3     *	varcoef3
gen	b_bienel_z_punt               =	b_bienel	    *	vargeoinvstdev4	    *	varcoef4	-	vargeom_st4	    *	varcoef4
gen	b_bientelec_z_punt            =	b_bientelec	    *	vargeoinvstdev5	    *	varcoef5	-	vargeom_st5     *	varcoef5
gen	b4_z_punt	                  =	b4	            *	vargeoinvstdev6	    *	varcoef6	-	vargeom_st6	    *	varcoef6
gen	b5_z_punt	                  =	b5	            *	vargeoinvstdev7	    *	varcoef7	-	vargeom_st7	    *	varcoef7
gen	b6_z_punt	                  =	b6       	    *	vargeoinvstdev8	    *	varcoef8	-	vargeom_st8	    *	varcoef8
gen	b8_z_punt	                  =	b8	            *	vargeoinvstdev9	    *	varcoef9	-	vargeom_st9	    *	varcoef9
gen	c_indig_jh_z_punt             =	c_indig_jh	    *	vargeoinvstdev10    *	varcoef10	-	vargeom_st10	*	varcoef10
gen	c_jh_sec_incom_z_punt	      =	c_jh_sec_incom	*	vargeoinvstdev11    *	varcoef11	-	vargeom_st11	*	varcoef11
gen	d_jh_anoedu_z_punt	          =	d_jh_anoedu	    *	vargeoinvstdev12    *	varcoef12	-	vargeom_st12	*	varcoef12
gen	d_jh_seguro_z_punt	          =	d_jh_seguro	    *	vargeoinvstdev13	*	varcoef13	-	vargeom_st13	*	varcoef13
gen	d_max_anoedu_z_punt           =	d_max_anoedu	*	vargeoinvstdev14	*	varcoef14	-	vargeom_st14	*	varcoef14
gen	s_3serv_z_punt	              =	s_3serv	        *	vargeoinvstdev15	*	varcoef15	-	vargeom_st15	*	varcoef15
gen	s_alum1_z_punt	              =	s_alum1	        *	vargeoinvstdev17	*	varcoef17	-	vargeom_st17	*	varcoef17
gen	s_dsg_redd_z_punt	          =	s_dsg_redd	    *	vargeoinvstdev18	*	varcoef18	-	vargeom_st18	*	varcoef18
gen	s_ning_z_punt	              =	s_ning	        *	vargeoinvstdev19	*	varcoef19	-	vargeom_st19	*	varcoef19
gen	v_hacina_z_punt	              =	v_hacina	    *	vargeoinvstdev20	*	varcoef20	-	vargeom_st20	*	varcoef20
gen	v_malpiso_z_punt	          =	v_malpiso	    *	vargeoinvstdev21	*	varcoef21	-	vargeom_st21	*	varcoef21
gen	v_maltecho_z_punt	          =	v_maltecho	    *	vargeoinvstdev22	*	varcoef22	-	vargeom_st22	*	varcoef22
gen	v_usa_comb_solido_z_punt	  =	v_usa_comb_solido*	vargeoinvstdev23    *	varcoef23	-	vargeom_st23	*	varcoef23
gen	v_usa_gas_z_punt	          =	v_usa_gas	    *	vargeoinvstdev24	*	varcoef24	-	vargeom_st24	*	varcoef24


*GEO_DominioArea
*idmodelo 

egen total_puntuado=rowtotal(b_bien_per_z_punt	b_bien_z_punt	b_biendur_z_punt	b_bienel_z_punt	b_bientelec_z_punt	b4_z_punt	b5_z_punt	b6_z_punt	b8_z_punt	c_indig_jh_z_punt	c_jh_sec_incom_z_punt	d_jh_anoedu_z_punt	d_jh_seguro_z_punt	d_max_anoedu_z_punt	s_3serv_z_punt	s_alum1_z_punt	s_dsg_redd_z_punt	s_ning_z_punt	v_hacina_z_punt	v_malpiso_z_punt	v_maltecho_z_punt	v_usa_comb_solido_z_punt	v_usa_gas_z_punt)

save "enaho\enaho_TOT_puntuado.dta", replace

clear

use "bases\umbrales_150515_d.dta", clear



merge 1:m idmodelo using "enaho\enaho_TOT_puntuado.dta"
drop _m

*condición de pobreza

gen pobre_umbral1=(total_puntuado>=umbral)
bys conglome vivienda hogar : egen pobre_umbral2= total(pobre_umbral1)

gen     pobre_ =.
replace pobre_ = pobre_umbral2==1 if geo_dominioarea==32 
replace pobre_ = pobre_umbral2==1 if geo_dominioarea==42
replace pobre_ = pobre_umbral2==1 if geo_dominioarea==52 
replace pobre_ = pobre_umbral2==1 if geo_dominioarea==62 
replace pobre_ = pobre_umbral2==1 if geo_dominioarea==72 

replace pobre_ = pobre_umbral2==2 if geo_dominioarea==11 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==12
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==21 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==22 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==31 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==41 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==51 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==61 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==71 
replace pobre_ = pobre_umbral2==2 if geo_dominioarea==81 

*POBREZA EXTREMA

*cuando todos los modelos tienen un umbral extremo
 drop if umbralextrema==.
 gen pobre_umbralext1=(total_puntuado>=umbralextrema) if pobre_==1  //& !missing(umbralextrema) & !missing(total_puntuado) & umbralextrema!=.
 gen pobrext_ =pobre_umbralext1==1 


/*cuando hay modelos con dos umbral extremo
gen pobre_umbralext1=(total_puntuado>=umbralextrema_2y) if pobre_==1  //& !missing(umbralextrema) & !missing(total_puntuado) & umbralextrema!=.
bys conglome vivienda hogar : egen pobre_umbralext2= total(pobre_umbralext1)
drop if numfactor==2 
gen pobrext_ =pobre_umbralext2>=1 
*/

recode pobre_ (0=3) (1=2) (else=.), gen (pobrezamidis)

 
replace pobrezamidis=pobrext_ if pobrext_==1

tab pobrezamidis [aw=factor07]
tab pobre_ [aw=factor07]
tab pobrext_ [aw=factor07]

tab pobrezamidis pobreza [aw=factor07]

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

gen factorpob=factor07*mieperho

tab GEO_DominioArea pobrezamidis [aw=factorpob], row nofreq  
tab GEO_DominioArea pobreza  [aw=factorpob], row nofreq   
