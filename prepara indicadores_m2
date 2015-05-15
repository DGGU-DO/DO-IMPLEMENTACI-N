
clear
*cd "D:\MIDIS 2015\METODOLOGÍA MIDIS 2015\2. Implementación\"
cd "G:\bases ifh 2015\"

*use "muestra\PI2_2014_ULE", clear

use "muestra2\BASE_MUESTRA2", clear

gen b_bien=c04_03_1 + c04_03_2 + c04_03_3 + c04_03_4 + c04_03_5 + c04_03_6 + c04_03_7 + c04_03_8 + c04_03_9 + c04_03_10 + c04_03_11 + c04_03_12 + c04_03_13 + c04_03_14n

*2. Número de bienes percápita
*-----------------------------
gen __miembros_hogar = 1 
bys departamen provincia distrito id_cedula data: egen nummiem_hogar= total(__miembros_hogar) //Hacinamiento
drop __miembros_hogar

*gen b_bien_per=b_bien/c04_06a
gen b_bien_per=b_bien/nummiem_hogar

*3. Número de bienes durables
gen b_biendur=c04_03_2 + c04_03_5 + c04_03_6 + c04_03_9 + c04_03_10
 
*4. Número de bienes eléctricos

gen b_bienel = c04_03_4 + c04_03_5 + c04_03_8 + c04_03_11
 
*5. Número de bienes de telecomunicaciones 

gen b_bientelec= c04_03_12 + c04_03_13 + c04_03_14n + c04_03_7

*7. Licuadora

gen b4=c04_03_4

*8. Refrigeradora/congeladora

gen b5=c04_03_5

*9. Cocina a gas
gen b6=c04_03_6       

*10. Plancha eléctrica
gen b8=c04_03_8
 
*11. Idioma nativo del jefe del hogar 
destring c05_13a, replace
gen  indig_jh=((c05_13a == 1 | c05_13a == 2 | c05_13a == 3 | c05_13a==7) & c05_08 == 1)
bys departamen provincia distrito id_cedula data: egen c_indig_jh=max(indig_jh)
drop indig_jh


*12. Jefe de hogar con secundaria incompleta
*----------------------------------------------
*gen c_jh_sec_incom=((c05_15==4  & c05_16<5) & c05_08==1)
*Por: CASE WHEN              (C05_15 = 4 AND C05_16 < 5) AND C05_08 = 1 THEN 1 ELSE 0 END

gen jh_sec_incom=((c05_15<4 |(c05_15==4 & c05_16<5)) & c05_08==1)
bys departamen provincia distrito id_cedula data: egen c_jh_sec_incom=max(jh_sec_incom)
drop jh_sec_incom

*Años de educ

gen anoeduc=.
replace anoeduc=0			    if c05_15==1 | c05_15==2 
replace anoeduc=c05_16	     	if c05_15==3 & c05_16<=6
replace anoeduc=6	     	    if c05_15==3 & c05_16>6
replace anoeduc=6+c05_16	    if c05_15==4 & c05_16<=5
replace anoeduc=6+5      	    if c05_15==4 & c05_16>5  //
replace anoeduc=6+5+c05_16	    if c05_15==5 & c05_16<=3 // sup. no univ
replace anoeduc=6+5+3    	    if c05_15==5 & c05_16>3 // sup. no univ
replace anoeduc=6+5+c05_16	    if c05_15==6 & c05_16<=5  // sup. univ
replace anoeduc=6+5+5    	    if c05_15==6 & c05_16>5  // sup. univ
replace anoeduc=6+5+5+c05_16    if c05_15==7 
        
*13. Años de educación del jefe de hogar
gen d_jh_anoed=anoeduc if c05_08==1
bys departamen provincia distrito id_cedula data: egen d_jh_anoedu=max(d_jh_anoed)
drop d_jh_anoed

*14. Jefe de hogar o conyugue con seguro
destring c05_13_1 c05_13_2 c05_13_3, replace

gen jh_seguro =(c05_13_1==1 | c05_13_2==1 | c05_13_3==1) & (c05_08==1 | c05_08== 2)
bys departamen provincia distrito id_cedula data: egen d_jh_seguro=max(jh_seguro)
drop jh_seguro

*15. Años de educación máximo en el hogar

bys departamen provincia distrito id_cedula data: egen d_max_anoeduc=max(anoeduc)

*16. tres servicios
gen uno=(c03_06==1)
gen dos=(c03_07==1)
gen tre=(c03_08==1)

gen s_3serv= uno + dos + tre
drop uno dos tre

*17. Usa electricidad
gen s_alum1=(c03_06==1) 

*18. Tiene desague dentro de la viv
gen s_dsg_redd=(c03_08==1)

*19. Ningún servicio
gen uno=(c03_06!=1)
gen dos=(c03_07!=1)
gen tre=(c03_08!=1)

gen s_ning=uno + dos + tre
drop uno dos tre
 
*20. Ratio de hacinamiento
*---------------------------
*gen v_hacina=c04_06a/c04_01
gen v_hacina=nummiem_hogar/c04_01
 
*21. Mal piso
gen v_malpiso=(c03_05==6)
 
*22. Mal techo
gen v_maltecho=(c03_04!=1) 

*23. Usa combustible solido
gen v_usa_comb_solido=(c04_02 == 4 | c04_02 == 5 | c04_02 == 6)

*24. Usa gas
gen v_usa_gas=(c04_02==2)

recode GEO_DominioArea  (11=1)  (12=2)(21=3)  (22=4)(31=5)  (32=6)  (41=7)  (42=8) (51=9)  (52=10)  (61=11) (62=12) (71=13) (72=14)(81=15)

*keep if GEO_DominioArea==15
sort departamen provincia distrito id_cedula data

*duplicates drop departamen provincia distrito id_cedula data,force

keep if c05_08==1
  
save "muestra2\MUESTRA2_indicadores", replace
