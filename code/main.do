/****************************************************************************
* File name: 2021
* Author(s): DH
* Date: November 2021
* Description: optiques in IDF
* * * *
* Inputs: CEREMA 
*
* Outputs:  
* comments: 
* latest modification : 04/10/2021
***************************************************************************/

clear
global inputs1 ""/Volumes/DiscoDH/research projects/project hermes/data/project_data/excel""
global inputs2 ""/Users/danielherrera 1/Google Drive/Assistant professor/research/project optiques/excel""
global temporary ""/Users/danielherrera 1/Google Drive/Assistant professor/research/project optiques/stata/temporary""


***************************************************************************/
** Opening dataset - sirene that contains Paris optiques
***************************************************************************/

	
cd $inputs2 
import delimited "adresses-14.csv", encoding(UTF-8) clear
	keep nom_afnor numero x y lon lat
	bys nom_afnor numero: g tmp = 1 if _n ==_N
	drop if tmp == .
	drop tmp
	tempfile address14
	save `address14', replace
	
cd $inputs2
import delimited "optiques_sirene_historique_2021.csv", clear 
	g idcom = codecommuneetablissement
	destring idcom, replace force 
	keep if idcom > 14010 & idcom < 15000
	keep if etatadministratifetablissement == "A"
	egen nom_afnor = concat( typevoieetablissement libellevoieetablissement ), punct(" ")
	g numero = numerovoieetablissement
	destring numero, replace force 	
	
	*** need to correct to be able to merge with the dataset on address in Paris ***
	replace nom_afnor = subinstr(nom_afnor,"AV ","AVENUE ",.)
	replace nom_afnor = subinstr(nom_afnor,"FBG","FAUBOURG",.)
	replace nom_afnor = subinstr(nom_afnor,"FG","FAUBOURG",.)
	replace nom_afnor = subinstr(nom_afnor,"PL ","PLACE ",.)
	replace nom_afnor = subinstr(nom_afnor,"BD ","BOULEVARD ",.)
	replace nom_afnor = subinstr(nom_afnor," ST "," SAINT ",.)
	replace nom_afnor = subinstr(nom_afnor," STE "," SAINT ",.)
	replace nom_afnor = subinstr(nom_afnor,"PTE ","PORTE ",.)
	replace nom_afnor = subinstr(nom_afnor,"'"," ",.)
	replace nom_afnor = subinstr(nom_afnor,"IMP ","IMPASSE ",.)
	replace nom_afnor = subinstr(nom_afnor,"CRS ","COURS ",.)
	replace nom_afnor = subinstr(nom_afnor,"QU ","QUAI ",.)
	replace nom_afnor = subinstr(nom_afnor,"SQ ","SQUARE ",.)
	replace nom_afnor = subinstr(nom_afnor," CDT "," COMMANDANT ",.)
	replace nom_afnor = subinstr(nom_afnor,"1ER","IER",.)
	replace nom_afnor = subinstr(nom_afnor,"RTE","ROUTE",.)	
	
	replace numero = 2 if numero == .
	
	merge m:1 numero nom_afnor using `address14'
	
	g opti = cond(etatadministratifetablissement == "A",1,0)
	g cconlc = "CB"
	g idsec_opti = _n
	tostring idsec_opti , replace 
	
	rename lat st_y
	rename lon st_x	
	keep if _merge == 3
	
	bys st_x st_y: g tmp = 1 if _n == 1
	drop if tmp == . & opti == 0
	drop tmp 
	
	g full_opti = 1
	
	cd $temporary
	keep idcom st_* cconlc opti idsec_opti full_opti 
	save opti_14_2021.dta, replace
	
	

cd $inputs2 
import delimited "adresses-75.csv", encoding(UTF-8) clear
	keep nom_afnor numero x y lon lat
	bys nom_afnor numero: g tmp = 1 if _n ==_N
	drop if tmp == .
	drop tmp
	tempfile address75
	save `address75', replace 
		
	
cd $inputs2
import delimited "optiques_sirene_historique_2021.csv", clear 
	g idcom = codecommuneetablissement
	destring idcom, replace force 
	keep if idcom > 75100 & idcom < 75121
	keep if etatadministratifetablissement == "A"
	egen nom_afnor = concat( typevoieetablissement libellevoieetablissement ), punct(" ")
	g numero = numerovoieetablissement
	destring numero, replace force 
	
	*** need to correct to be able to merge with the dataset on address in Paris ***
	replace nom_afnor = subinstr(nom_afnor,"AV ","AVENUE ",.)
	replace nom_afnor = subinstr(nom_afnor,"FBG","FAUBOURG",.)
	replace nom_afnor = subinstr(nom_afnor,"FG","FAUBOURG",.)
	
	replace nom_afnor = subinstr(nom_afnor,"PL ","PLACE ",.)
	replace nom_afnor = subinstr(nom_afnor,"BD ","BOULEVARD ",.)
	replace nom_afnor = subinstr(nom_afnor," ST "," SAINT ",.)
	replace nom_afnor = subinstr(nom_afnor," STE "," SAINT ",.)
	
	replace nom_afnor = subinstr(nom_afnor,"PTE ","PORTE ",.)
	replace nom_afnor = subinstr(nom_afnor,"'"," ",.)
	replace nom_afnor = subinstr(nom_afnor,"IMP ","IMPASSE ",.)
	replace nom_afnor = subinstr(nom_afnor,"CRS ","COURS ",.)
	replace nom_afnor = subinstr(nom_afnor,"QU ","QUAI ",.)
	replace nom_afnor = subinstr(nom_afnor,"SQ ","SQUARE ",.)
	replace nom_afnor = subinstr(nom_afnor," CDT "," COMMANDANT ",.)

	replace nom_afnor = subinstr(nom_afnor,"1ER","IER",.)
	
	replace nom_afnor = subinstr(nom_afnor,"COURS DE ROME","COUR DE ROME",.) 	
	replace nom_afnor = subinstr(nom_afnor,"RUE SQUARE CARPEAUX","RUE DU SQUARE CARPEAUX",.) 
	replace nom_afnor = subinstr(nom_afnor,"RUE SAINT CROIX BRETONNERIE","RUE STE CROIX DE LA BRETONNERIE",.) 
	replace nom_afnor = subinstr(nom_afnor,"RUE LAVANDIERES SAINT OPPORTUNEE","RUE LAVANDIERES SAINTE OPPORTUNE",.) 
	replace nom_afnor = subinstr(nom_afnor,"PAS FLOURENS","PASSAGE FLOURENS",.) 
	replace nom_afnor = subinstr(nom_afnor,"PAS MESLAY","PASSAGE MESLAY",.)
	replace nom_afnor = subinstr(nom_afnor,"PAS THIERE","PASSAGE THIERE",.)	
	replace nom_afnor = subinstr(nom_afnor,"PAS PIVER","PASSAGE PIVER",.)	
	replace nom_afnor = subinstr(nom_afnor,"PAS DU GRAND CERF","PASSAGE DU GRAND CERF",.)	
	replace nom_afnor = subinstr(nom_afnor,"PAS MONTBRUN","PASSAGE MONTBRUN",.)	
	replace nom_afnor = subinstr(nom_afnor,"VLA CURIAL","VILLA CURIAL",.)	
	replace nom_afnor = subinstr(nom_afnor,"VLA MOZART","VILLA MOZART",.)	
	replace nom_afnor = subinstr(nom_afnor,"RUE M ELEONORE DE BELLEFOND","RUE DE BELLEFOND",.)	
	replace nom_afnor = subinstr(nom_afnor,"RUE CHARLES-V","RUE CHARLES V",.)	
	replace nom_afnor = subinstr(nom_afnor,"BOULEVARD DE ROCHECHOUART","BD MARGUERITE DE ROCHECHOUART",.)	
	replace nom_afnor = subinstr(nom_afnor,"AVENUE PORTE DE MONTMARTRE","AVENUE DE LA PORTE DE MONTMARTRE",.)	
	replace nom_afnor = subinstr(nom_afnor,"RUE DE CHATEAU LANDON","RUE DU CHATEAU LANDON",.)	
	replace nom_afnor = subinstr(nom_afnor,"RUE LA GRANGE AUX BELLES","RUE DE LA GRANGE AUX BELLES",.)	
	replace numero = 1 if nom_afnor == "AVENUE GAMBETTA" & numero == 2

	merge m:1 numero nom_afnor using`address75'
	
	g opti = cond(etatadministratifetablissement == "A",1,0)
	g cconlc = "CB"
	g idsec_opti = _n
	tostring idsec_opti , replace 
	
	rename lat st_y
	rename lon st_x	
	keep if _merge == 3
	
	bys st_x st_y: g tmp = 1 if _n == 1
	drop if tmp == . & opti == 0
	drop tmp 
	
	g full_opti = 1
	
	cd $temporary
	keep idcom st_* cconlc opti idsec_opti full_opti 
	save opti_75_2021.dta, replace


cd $inputs2 
import delimited "adresses-27.csv", encoding(UTF-8) clear
	keep nom_afnor numero x y lon lat
	bys nom_afnor numero: g tmp = 1 if _n ==_N
	drop if tmp == .
	drop tmp
	tempfile address27
	save `address27', replace 	
	
	
cd $inputs2
import delimited "optiques_sirene_historique_2021.csv", clear 
	g idcom = codecommuneetablissement
	destring idcom, replace force 
	keep if idcom > 27010 & idcom < 28000
	keep if etatadministratifetablissement == "A"
	egen nom_afnor = concat( typevoieetablissement libellevoieetablissement ), punct(" ")
	g numero = numerovoieetablissement
	destring numero, replace force 
	
	*** need to correct to be able to merge with the dataset on address in Paris ***
	replace nom_afnor = subinstr(nom_afnor,"AV ","AVENUE ",.)
	replace nom_afnor = subinstr(nom_afnor,"FBG","FAUBOURG",.)
	replace nom_afnor = subinstr(nom_afnor,"FG","FAUBOURG",.)
	replace nom_afnor = subinstr(nom_afnor,"PL ","PLACE ",.)
	replace nom_afnor = subinstr(nom_afnor,"BD ","BOULEVARD ",.)
	replace nom_afnor = subinstr(nom_afnor," ST "," SAINT ",.)
	replace nom_afnor = subinstr(nom_afnor," STE "," SAINT ",.)
	replace nom_afnor = subinstr(nom_afnor,"PTE ","PORTE ",.)
	replace nom_afnor = subinstr(nom_afnor,"'"," ",.)
	replace nom_afnor = subinstr(nom_afnor,"IMP ","IMPASSE ",.)
	replace nom_afnor = subinstr(nom_afnor,"CRS ","COURS ",.)
	replace nom_afnor = subinstr(nom_afnor,"QU ","QUAI ",.)
	replace nom_afnor = subinstr(nom_afnor,"SQ ","SQUARE ",.)
	replace nom_afnor = subinstr(nom_afnor," CDT "," COMMANDANT ",.)
	replace nom_afnor = subinstr(nom_afnor,"1ER","IER",.)
	replace nom_afnor = subinstr(nom_afnor,"RTE","ROUTE",.)
	
	
	replace nom_afnor = subinstr(nom_afnor,"RUE DU GAL DE GAULLE","RUE DU GENERAL DE GAULLE",.)	
	replace nom_afnor = subinstr(nom_afnor,"RUE GENERAL DE GAULLE","RUE DU GENERAL DE GAULLE",.)	
	replace nom_afnor = subinstr(nom_afnor,"PLACE D4ARMES","PLACE D ARMES",.)		
	replace nom_afnor = subinstr(nom_afnor,"PLACE DES QUATRE SAISONS","PLACE DES 4 SAISONS",.)		
	replace nom_afnor = subinstr(nom_afnor,"CHE DU VIROLET","CHEMIN DU VIROLET",.)		
	replace nom_afnor = subinstr(nom_afnor,"GALERIE DES MOUSQUTAIRES","COUR DES MOUSQUETAIRES",.)		
	replace nom_afnor = subinstr(nom_afnor,"RUE CARAVELLE LOT. LA GARENNE 1 EXT","RUE CARAVELLE",.)		
	replace nom_afnor = subinstr(nom_afnor,"RUE DU 18 JUIN 1940","AVENUE DU 18 JUIN 1940",.)		
	replace nom_afnor = subinstr(nom_afnor,"SAINT ULFRAN","RUE SAINT ULFRANT",.)	
	replace nom_afnor = subinstr(nom_afnor,"RUE SAINT ULFRANTT","RUE SAINT ULFRANT",.)		
	
	replace nom_afnor = subinstr(nom_afnor,"RUE DU SOLEIL D OR","RUE DU SOLEIL",.)		
	replace nom_afnor = subinstr(nom_afnor,"RUE DES TROIS MAILLETS","RUE DES 3 MAILLETS",.)		
	replace nom_afnor = subinstr(nom_afnor,"AVENUE MARECHAL LECLERC","AVENUE DU MARECHAL LECLERC",.)		

	replace numero = 6 if nom_afnor == "BOULEVARD DE NORMANDIE" & numero == .	
	replace numero = 5 if nom_afnor == "BOULEVARD DU 14 JUILLET" & numero == .	
	replace nom_afnor = subinstr(nom_afnor,"BOULEVARD DU 14 JUILLET","IMPASSE DU 14 JUILLET",.)		
	replace numero = 6 if nom_afnor == "BOULEVARD JEAN JAURES" & numero == .	
	replace numero = 20 if nom_afnor == "CHEMIN DU VIROLET" & numero == .	
	replace numero = 31 if nom_afnor == "ROUTE DE BERNAY" & numero == .	
	replace numero = 1 if nom_afnor == "RN 13" & numero == .	
	replace numero = 1 if nom_afnor == "ROUTE DE FOURGES" & numero == .	
	replace numero = 8 if nom_afnor == "ROUTE DE ROUEN" & numero == .	
	replace numero = 2 if nom_afnor == "ROUTE DU NEUBOURG" & numero == .	
	replace numero = 1 if nom_afnor == "RUE CARAVELLE" & numero == .	
	replace numero = 9 if nom_afnor == "RUE DE L INDUSTRIE" & numero == .	
	replace numero = 1 if nom_afnor == "RUE DU BOULOIR" & numero == .	
	replace numero = 2 if nom_afnor == "AVENUE DU 18 JUIN 1940" & numero == .	
	replace numero = 3 if nom_afnor == "RUE HENRI DE CAMPION" & numero == .	
	replace numero = 2 if nom_afnor == "RUE SAINT ULFRANT" & numero == .		
	replace numero = 6 if nom_afnor == "RUE COURTINE" & numero == 4		
	replace numero = 1 if nom_afnor == "AVENUE DU MARECHAL LECLERC" & numero == .				

	replace numero = 14 if nom_afnor == "ROUTE DE LYONS" & numero == 24		
	replace numero = 2 if nom_afnor == "RUE ISAMBARD" & numero == 74		
	replace numero = 1 if nom_afnor == "ROUTE DE PARIS" & numero == 9001		
	replace numero = 1 if nom_afnor == "AVENUE DES PEUPLIERS" & numero == 9001		
	replace numero = 1 if nom_afnor == "RUE DE LA FORET" & numero == 9008		
	
	merge m:1 numero nom_afnor using`address27'
	
	g opti = cond(etatadministratifetablissement == "A",1,0)
	g cconlc = "CB"
	g idsec_opti = _n
	tostring idsec_opti , replace 
	
	rename lat st_y
	rename lon st_x	
	keep if _merge == 3
	
	bys st_x st_y: g tmp = 1 if _n == 1
	drop if tmp == . & opti == 0
	drop tmp 
	
	g full_opti = 1
	
	cd $temporary
	keep idcom st_* cconlc opti idsec_opti full_opti 
	save opti_27_2021.dta, replace	
	
	
	
	
***************************************************************************/
** Opening dataset
***************************************************************************/
foreach dd in  14 {
cd $inputs1
import delimited lonlat_`dd'.csv, clear 
		
	if `dd' < 75 {
		drop st_x st_y
		rename st_x2 st_x
		rename st_y2 st_y
	}
	
	tempfile lonlat 
	save `lonlat', replace 
	
	
clear 
cd $inputs1
import delimited pb0010_`dd'.csv, clear 
	
	* merging datasets 
	merge 1:1 idpar idlocal using `lonlat'
	drop if _merge==2 
	drop _merge 
	
	* creating variables of interest 
	g opti = cconac == "4778A"
	g hh = logh == "t"
	g oth_busi = (opti == 0) * (hh == 0)
	g oth_sprincp = oth_busi * sprincp

	cd $temporary
	
	*** accounting for repeated optical firms ***
	replace opti = 0 if opti == 1
	
	*** appending with sirenne data ***
	destring st_x st_y, replace force
	drop if st_x == .		
	foreach var in st_x st_y {
		bys idsec : egen tmp = mean(`var')
		replace `var' = tmp
		drop tmp		
	}
	// keeping the same idsec as in fichier foncier
	preserve 
	
		keep idsec st_x st_y
		rename st_x st_x2
		rename st_y st_y2
		bys idsec: g tmp = 1 if _n == 1
		drop if tmp != 1
		drop tmp 
		cross using opti_`dd'_2021
		geodist st_y st_x st_y2 st_x2, gen(dist_min)		
		so st_y2 st_x2 dist_min
		bys  idsec_opti st_y st_x (dist_min): g tmp = 1 if _n == 1
		keep if tmp == 1
		keep idsec st_x2 st_y2 opti idcom cconlc 
		rename st_x2 st_x
		rename st_y2 st_y
		tempfile opti_temp 
		save `opti_temp'
	
	restore 
	append using `opti_temp'
	***********************************
		
	// generating markets and selection
 	g mkt = 1
	egen mkt_bis = group(idcom)

//  	egen mkt = group(idcom)
// 	egen mkt_bis = group(idcom)
	
//  	keep if inlist(idcom,75101,75102,75103,75104,75105,75106,75107,75108,75109,75110,75111,75112,75113,75114,75115,75119)
// //  	keep if inlist(idcom,75110,75111,75112,75113,75114,75115,75116,75119)

	egen idsecfe = group(idsec)	
	bys idsec: egen opti1 = sum(opti)
	drop opti
	rename opti1 opti
	
	foreach var in hh oth_busi stoth sprincp slocal oth_sprincp {
		bys idsec : egen tmp = sum(`var')
		replace `var' = tmp
		drop tmp		
	}	

	foreach var in st_x st_y {
		bys idsec : egen tmp = mean(`var')
		replace `var' = tmp
		drop tmp		
	}
	
	* leaving in only markets where an optic entered
	bys mkt_bis : egen opti_sum = sum(opti)
	drop if opti_sum == 0

	* generating markets and selection
	drop mkt*
	egen mkt = group(idcom)
	egen mkt_bis = group(idcom)
	
	
//  drop if cconlc != "CB"
	
	** keeping only sections 
	egen tmp = tag(idsec)
	keep if tmp == 1
	drop tmp
	
	*the ordering here is extremely important
	so mkt idsec
	
	* saving tempfile per department
	tempfile tmp_dep_`dd' 
	save `tmp_dep_`dd'', replace
}

	*** Appending datasets ***
	use `tmp_dep_14', clear 
	g dep = 14
 	foreach dd in  27  {
 		append using `tmp_dep_`dd''
		replace dep = `dd' if dep == .
 	}	
	
	egen mkt2 = group(mkt dep)
	drop mkt 
	rename mkt2 mkt
	
	
***************************************************************************/
	sum mkt 
	global mktsize =`r(max)'
	forvalues kk = 1/$mktsize {
	*** Computing distances between optiques ***
 	preserve
	quiet {
		keep if mkt == `kk'
		keep idsec mkt st_x st_y
		destring *, replace
		g tmp = _N
		
		*rename codepostal codepostal2
		rename mkt mkt2			
		rename idsec idsec2		
		rename st_y st_y2  // latitude
		rename st_x st_x2  // longitude
		egen i2 = group(idsec2)
		
		tempfile latlon
		save `latlon',replace

		rename mkt2 mkt1					
		rename idsec2 idsec1						
		rename st_y st_y1
		rename st_x st_x1
		rename i2 i1  // longitude		
		
		cross using `latlon'
		
		geodist st_y1 st_x1 st_y2 st_x2, gen(dist)		
		keep idsec* dist mkt* i* tmp
			
		*make sure the data in distance has the same sorting that the main data
		so mkt1 idsec1 mkt2 idsec2 
		tempfile dist_mkt_`kk'
		save `dist_mkt_`kk'', replace 	
	}
	restore	 
	
	}


	tab mkt_bis, gen(mkt_)
	keep opti* hh* oth_busi stoth sprincp slocal oth_sprincp mkt
	export delimited using "/Users/danielherrera 1/Google Drive/Assistant professor/research/project optiques/matlab/opti_N.csv", replace
		
	***** Creating distances *****
	
	use `dist_mkt_1', clear
	forvalues kk = 2/$mktsize {
		append using `dist_mkt_`kk''
		di `kk'
	}
	
	
	* Sparse matrix -- adjusting for the gaps 
	
	bys mkt1 (i1 mkt2 i2): g tmp11 = 1 if _n == _N
	bys mkt1 (i1 mkt2 i2): g tmp12 = 1 if _n == 1
	
	g tmp2 = sum(tmp11 * tmp)
	replace tmp2 = tmp2 + tmp12 * (tmp > 1)
	bys mkt1 (i1 mkt2 i2): egen tmp3 = mean(tmp2)
	
	g tmp4 = i1 + tmp3 - 1
	g tmp5 = i2 + tmp3 - 1
	
	drop i1 i2
	g i1 = tmp4
	g i2 = tmp5
	keep i1 i2 dist
	export delimited using "/Users/danielherrera 1/Google Drive/Assistant professor/research/project optiques/matlab/opti_dist.csv", replace
		
	************************************
	
			
	
