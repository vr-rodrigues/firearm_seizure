clear all
di c(pwd)
local diretorio = substr("`c(pwd)'", 1, 2)
cd `diretorio'


* ------------------------------------------------------
* ARMAS
* ------------------------------------------------------

* Media Movel 3 Meses
use dados/base_final, clear

* Estimando placebos
forvalues i = 1/13 {
	synth qtd_arma3 lqtd_arma3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ///
	ocup(693) homem(693) media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_qtd_arma_3mm_`i') replace
}

use dados/placebo_qtd_arma_3mm_1, clear
gen unidade = 1
save dados/placebo_qtd_arma_3mm, replace
rm dados/placebo_qtd_arma_3mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_qtd_arma_3mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_qtd_arma_3mm.dta
	save dados/placebo_qtd_arma_3mm, replace
	rm dados/placebo_qtd_arma_3mm_`i'.dta
	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/qtd_arma_3mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Firearm Seizure") xtitle("Time") legend(off)
	   graph export "graficos/Firearm_Seizure_3MA_placebo.pdf", replace
	   graph export "graficos/Firearm_Seizure_3MA_placebo.eps", replace
  
	   
  

* Media Movel 6 Meses
clear all
use dados/base_final

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth qtd_arma6 lqtd_arma6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ///
	ocup(693) homem(693) media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_qtd_arma_6mm_`i') replace
}

use dados/placebo_qtd_arma_6mm_1, clear
gen unidade = 1
save dados/placebo_qtd_arma_6mm, replace
rm dados/placebo_qtd_arma_6mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_qtd_arma_6mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_qtd_arma_6mm.dta
	save dados/placebo_qtd_arma_6mm, replace
	rm dados/placebo_qtd_arma_6mm_`i'.dta
	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/qtd_arma_6mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Firearm Seizure") xtitle("Time") legend(off)
	   graph export "graficos/Firearm_Seizure_6MA_placebo.pdf", replace
	   graph export "graficos/Firearm_Seizure_6MA_placebo.eps", replace
  






* ------------------------------------------------------
* VITIMAS
* ------------------------------------------------------

* Media Movel 3 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth vitima3 lvitima3 qtd_arma3 lqtd_arma3 total_veiculo3 estupro3 tentat_homicidio3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693),  trunit(`i') trperiod(693) keep(dados/placebo_vitima_3mm_`i') replace
	
}


use dados/placebo_vitima_3mm_1, clear
gen unidade = 1
save dados/placebo_vitima_3mm, replace
rm dados/placebo_vitima_3mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_vitima_3mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_vitima_3mm.dta
	save dados/placebo_vitima_3mm, replace
	rm dados/placebo_vitima_3mm_`i'.dta
	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/vitima_3mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  12, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Total Victims") xtitle("Time") legend(off)
	   graph export "graficos/Total_Victims_3MA_placebo.pdf", replace
	   graph export "graficos/Total_Victims_3MA_placebo.eps", replace



* Media Movel 6 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth vitima6 lvitima6 qtd_arma6 lqtd_arma6 total_veiculo6 estupro6 tentat_homicidio6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693),  trunit(`i') trperiod(693) keep(dados/placebo_vitima_6mm_`i') replace
	
}


use dados/placebo_vitima_6mm_1, clear
gen unidade = 1
save dados/placebo_vitima_6mm, replace
rm dados/placebo_vitima_6mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_vitima_6mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_vitima_6mm.dta
	save dados/placebo_vitima_6mm, replace
	rm dados/placebo_vitima_6mm_`i'.dta
	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/vitima_6mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  12, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Total Victims") xtitle("Time") legend(off)
	   graph export "graficos/Total_Victims_6MA_placebo.pdf", replace
	   graph export "graficos/Total_Victims_6MA_placebo.eps", replace







	   
   
* ------------------------------------------------------
* OCORRENCIAS
* ------------------------------------------------------

* Media Movel 3 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth ocorrencia3 locorrencia3 qtd_arma3 lqtd_arma3 homicidio_vitima3 lhomicidio_vitima3 ///
	lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_ocorrencia_3mm_`i') replace
	
}

use dados/placebo_ocorrencia_3mm_1, clear
gen unidade = 1
save dados/placebo_ocorrencia_3mm, replace
rm dados/placebo_ocorrencia_3mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_ocorrencia_3mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_ocorrencia_3mm.dta
	save dados/placebo_ocorrencia_3mm, replace
	rm dados/placebo_ocorrencia_3mm_`i'.dta	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/ocorrencia_3mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Crime Occurrences") xtitle("Time") legend(off)
	   graph export "graficos/Crime_Occurrences_3MA_placebo.pdf", replace
	   graph export "graficos/Crime_Occurrences_3MA_placebo.eps", replace
 


* Media Movel 6 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth ocorrencia6 locorrencia6 qtd_arma6 lqtd_arma6 homicidio_vitima6 lhomicidio_vitima6 ///
	lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_ocorrencia_6mm_`i') replace
	
}

use dados/placebo_ocorrencia_6mm_1, clear
gen unidade = 1
save dados/placebo_ocorrencia_6mm, replace
rm dados/placebo_ocorrencia_6mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_ocorrencia_6mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_ocorrencia_6mm.dta
	save dados/placebo_ocorrencia_6mm, replace
	rm dados/placebo_ocorrencia_6mm_`i'.dta	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/ocorrencia_6mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Crime Occurrences") xtitle("Time") legend(off)
	   graph export "graficos/Crime_Occurrences_6MA_placebo.pdf", replace
	   graph export "graficos/Crime_Occurrences_6MA_placebo.eps", replace
	   
	   
	   
	   
	   
	   
	   
	   
	   
* ------------------------------------------------------
* HOMICIDIOS
* ------------------------------------------------------

* Media Movel 3 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth homicidio_vitima3 lhomicidio_vitima3 qtd_arma3 lqtd_arma3 ///
	lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_homicidio_vitima_3mm_`i') replace
	
}

use dados/placebo_homicidio_vitima_3mm_1, clear
gen unidade = 1
save dados/placebo_homicidio_vitima_3mm, replace
rm dados/placebo_homicidio_vitima_3mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_homicidio_vitima_3mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_homicidio_vitima_3mm.dta
	save dados/placebo_homicidio_vitima_3mm, replace
	rm dados/placebo_homicidio_vitima_3mm_`i'.dta	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/homicidio_vitima_3mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  12, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Murder") xtitle("Time") legend(off)
	   graph export "graficos/Murder_3MA_placebo.pdf", replace
	   graph export "graficos/Murder_3MA_placebo.eps", replace
 


* Media Movel 6 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth homicidio_vitima6 lhomicidio_vitima6 qtd_arma6 lqtd_arma6 ///
	lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_homicidio_vitima_6mm_`i') replace
	
}

use dados/placebo_homicidio_vitima_6mm_1, clear
gen unidade = 1
save dados/placebo_homicidio_vitima_6mm, replace
rm dados/placebo_homicidio_vitima_6mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_homicidio_vitima_6mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_homicidio_vitima_6mm.dta
	save dados/placebo_homicidio_vitima_6mm, replace
	rm dados/placebo_homicidio_vitima_6mm_`i'.dta	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/homicidio_vitima_6mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  12, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Murder") xtitle("Time") legend(off)
	   graph export "graficos/Murder_6MA_placebo.pdf", replace
	   graph export "graficos/Murder_6MA_placebo.eps", replace
	   
	   
	   
	   
	   
	   
	   
	   
	   

* ------------------------------------------------------
* TENTATIVA DE HOMICIDIOS
* ------------------------------------------------------

* Media Movel 3 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth tentat_homicidio3 ltentat_homicidio3 qtd_arma3 lqtd_arma3 ///
	lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_tentat_homicidio_3mm_`i') replace
	
}

use dados/placebo_tentat_homicidio_3mm_1, clear
gen unidade = 1
save dados/placebo_tentat_homicidio_3mm, replace
rm dados/placebo_tentat_homicidio_3mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_tentat_homicidio_3mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_tentat_homicidio_3mm.dta
	save dados/placebo_tentat_homicidio_3mm, replace
	rm dados/placebo_tentat_homicidio_3mm_`i'.dta	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/tentat_homicidio_3mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  12, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Attempted Murder") xtitle("Time") legend(off)
	   graph export "graficos/Attempted_Murder_3MA_placebo.pdf", replace
	   graph export "graficos/Attempted_Murder_3MA_placebo.eps", replace
 


* Media Movel 6 Meses
use dados/base_final, clear

* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth tentat_homicidio6 ltentat_homicidio6 qtd_arma6 lqtd_arma6 ///
	lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693) keep(dados/placebo_tentat_homicidio_6mm_`i') replace
	
}

use dados/placebo_tentat_homicidio_6mm_1, clear
gen unidade = 1
save dados/placebo_tentat_homicidio_6mm, replace
rm dados/placebo_tentat_homicidio_6mm_1.dta

forvalues i = 2/13 {
	use dados/placebo_tentat_homicidio_6mm_`i', clear
	gen unidade = `i'
	append using dados/placebo_tentat_homicidio_6mm.dta
	save dados/placebo_tentat_homicidio_6mm, replace
	rm dados/placebo_tentat_homicidio_6mm_`i'.dta	
}

format _time %tm
gen dif = _Y_treated - _Y_synthetic
sort unidade _time
merge m:1 unidade using dados/tentat_homicidio_6mm_rmspe
drop _merge
drop if rmspe_vezes > 5
tab unidade

twoway line dif _time if unidade ==  1, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  2, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  3, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  4, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  5, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  6, lwidth(thick) lcolor(black)  || ///
	   line dif _time if unidade ==  7, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  8, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  9, lwidth(thin) lcolor(gs12)  || ///
	   line dif _time if unidade ==  10, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  11, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  12, lwidth(thin) lcolor(gs12) || ///
	   line dif _time if unidade ==  13, lwidth(thin) lcolor(gs12) ///
	   xline(693, lcolor(gs10) lpattern(dash) lwidth(medium)) graphregion(color(white)) ///
	   bgcolor(white) ylabel(, nogrid labsize(small)) xlabel(660(16.5)710, labsize(small)) ///
	   ytitle("Gap in Attempted Murder") xtitle("Time") legend(off)
	   graph export "graficos/Attempted_Murder_6MA_placebo.pdf", replace
	   graph export "graficos/Attempted_Murder_6MA_placebo.eps", replace
