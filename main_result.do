clear all
di c(pwd)
local diretorio = substr("`c(pwd)'", 1, 2)
cd `diretorio'

use dados/base_seguranca, clear 
 
* Variaveis
gen seg_publica_pc = (seg_publica/pop)
gen assis_social_pc = (assis_social/pop)
gen saude_pc = (saude/pop)
gen trabalho_pc = (trabalho/pop)
gen educ_pc = (educ/pop)
gen cultura_pc = (cultura/pop)
gen direito_cidadania_pc = (direito_cidadania/pop)
gen habitacao_pc = (habitacao/pop)
gen ciencia_tec_pc = (ciencia_tec/pop)
gen agragaria_pc = (agragaria/pop)
gen esporte_lazer_pc = (esporte_lazer/pop)
gen ln_pop = ln(pop)
gen total_veiculo = furto_veic + roubo_veic

gen vitima = homicidio_vitima + lesao_corp_vitima + latrocinio_vitima
gen ocorrencia = estupro + total_veiculo + roubo_fin + roubo_carga + tentat_homicidio

gen time=ym(ano,mes_num)
format time %tm
egen id=group(uf)
tsset id time

foreach var of varlist homicidio_vitima lesao_corp_vitima latrocinio_vitima estupro ///
roubo_fin roubo_carga total_veiculo tentat_homicidio vitima ocorrencia qtd_arma {
	gen `var'2 = (l1.`var' + `var')/2
	replace `var'2 = `var' if `var'2 == .
	gen `var'3 = (l2.`var' + l1.`var' + `var')/3
	replace `var'3 = `var'2 if `var'3 == .
	gen `var'4 = (l3.`var' + l2.`var' + l1.`var' + `var')/4
	replace `var'4 = `var'3 if `var'4 == .
	gen `var'5 = (l4.`var' + l3.`var' + l2.`var' + l1.`var' + `var')/5
	replace `var'5 = `var'4 if `var'5 == .
	gen `var'6 = (l5.`var' + l4.`var' + l3.`var' + l2.`var' + l1.`var' + `var')/6
	replace `var'6 = `var'5 if `var'6 == .
}

foreach var of varlist homicidio_vitima lesao_corp_vitima latrocinio_vitima estupro ///
roubo_fin roubo_carga total_veiculo tentat_homicidio vitima ocorrencia qtd_arma {
	
	bysort uf: egen me_`var'3 = mean(`var'3)
	replace `var'3 = me_`var'3 if `var'3 ==.

	bysort uf: egen me_`var'6 = mean(`var'6)
	replace `var'6 = me_`var'6 if `var'6 ==.

	drop `var'2 `var'4 `var'5 me_`var'6 me_`var'3
}

drop id 

gen controles = (uf=="São Paulo"|uf=="Amapá"|uf=="Rio Grande do Norte"|uf=="Sergipe"| ///
uf=="Tocantins"|uf=="Rio de Janeiro"|uf=="Mato Grosso do Sul"|uf=="Rio Grande do Sul"| ///
uf=="Santa Catarina"|uf=="Minas Gerais"|uf=="Paraná"|uf=="Distrito Federal") 

keep if uf=="Pernambuco" | controles==1
egen id=group(uf)
tab uf id
tsset id time

foreach var of varlist homicidio_vitima lesao_corp_vitima latrocinio_vitima estupro ///
roubo_fin roubo_carga total_veiculo tentat_homicidio vitima ocorrencia qtd_arma {
	gen l`var'3 = l.`var'3
	gen l`var'6 = l.`var'6
}

* 10/26/2017
keep if ano>=2015
encode uf, gen(unidade)

save dados/base_final, replace









* ------------------------------------------------------
* ARMAS
* ------------------------------------------------------

* Media Movel 3 Meses
clear all 
use dados/base_final, clear

synth qtd_arma3 lqtd_arma3 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc sal_efetivo_real ///
idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) media_estudo(693), ///
trunit(6) trperiod(693) keep(dados/qtd_arma_3mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth qtd_arma3 lqtd_arma3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ///
	ocup(693) homem(693) media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'
	
	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/qtd_arma_3mm_rmspe, replace

matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/qtd_arma_3mm_inf, replace
use dados/qtd_arma_3mm, clear
merge 1:1 _time using dados/qtd_arma_3mm_inf
drop _merge
save dados/Firearm_Seizure_3MA, replace
rm dados/qtd_arma_3mm_inf.dta
rm dados/qtd_arma_3mm.dta



* Media Movel 6 Meses
clear all 
use dados/base_final, clear

synth qtd_arma6 lqtd_arma6 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc sal_efetivo_real ///
idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) media_estudo(693), ///
trunit(6) trperiod(693) keep(dados/qtd_arma_6mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth qtd_arma6 lqtd_arma6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ///
	ocup(693) homem(693) media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'


	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/qtd_arma_6mm_rmspe, replace

matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/qtd_arma_6mm_inf, replace
use dados/qtd_arma_6mm, clear
merge 1:1 _time using dados/qtd_arma_6mm_inf
drop _merge
save dados/Firearm_Seizure_6MA.dta, replace
rm dados/qtd_arma_6mm_inf.dta
rm dados/qtd_arma_6mm.dta










* ------------------------------------------------------
* VITIMAS
* ------------------------------------------------------

* Media Movel 3 Meses
clear all
use dados/base_final

synth vitima3 lvitima3 qtd_arma3 lqtd_arma3 total_veiculo3 estupro3 tentat_homicidio3 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/vitima_3mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth vitima3 lvitima3 qtd_arma3 lqtd_arma3 total_veiculo3 estupro3 tentat_homicidio3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'
	

	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/vitima_3mm_rmspe, replace

matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/vitima_3mm_inf, replace
use dados/vitima_3mm, clear
merge 1:1 _time using dados/vitima_3mm_inf
drop _merge
save dados/Total_Victims_3MA, replace
rm dados/vitima_3mm_inf.dta
rm dados/vitima_3mm.dta



* Media Movel 6 Meses
clear all
use dados/base_final

synth vitima6 lvitima6 qtd_arma6 lqtd_arma6 total_veiculo6 estupro6 tentat_homicidio6 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/vitima_6mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth vitima6 lvitima6 qtd_arma6 lqtd_arma6 total_veiculo6 estupro6 tentat_homicidio6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'

	
	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/vitima_6mm_rmspe, replace

matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/vitima_6mm_inf, replace
use dados/vitima_6mm, clear
merge 1:1 _time using dados/vitima_6mm_inf
drop _merge
save dados/Total_Victims_6MA, replace
rm dados/vitima_6mm_inf.dta
rm dados/vitima_6mm.dta








* ---------------------
* TOTAL DE OCORRENCIAS
* ---------------------

* M.A. 3 Meses
clear all
use dados/base_final

synth ocorrencia3 locorrencia3 qtd_arma3 lqtd_arma3 homicidio_vitima3 lhomicidio_vitima3 ///
lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/ocorrencia_3mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth ocorrencia3 locorrencia3 qtd_arma3 lqtd_arma3 homicidio_vitima3 lhomicidio_vitima3 ///
	lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'

	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/ocorrencia_3mm_rmspe, replace

matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/ocorrencia_3mm_inf, replace
use dados/ocorrencia_3mm, clear
merge 1:1 _time using dados/ocorrencia_3mm_inf
drop _merge
save dados/Crime_Occurrences_3MA, replace
rm dados/ocorrencia_3mm_inf.dta
rm dados/ocorrencia_3mm.dta



* M.A. 6 Meses
clear all
use dados/base_final

synth ocorrencia6 locorrencia6 qtd_arma6 lqtd_arma6 homicidio_vitima6 lhomicidio_vitima6 ///
lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/ocorrencia_6mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth ocorrencia6 locorrencia6 qtd_arma6 lqtd_arma6 homicidio_vitima6 lhomicidio_vitima6 ///
	lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'

	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/ocorrencia_6mm_rmspe, replace

matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/ocorrencia_6mm_inf, replace
use dados/ocorrencia_6mm, clear
merge 1:1 _time using dados/ocorrencia_6mm_inf
drop _merge
save dados/Crime_Occurrences_6MA, replace
rm dados/ocorrencia_6mm_inf.dta
rm dados/ocorrencia_6mm.dta






* ------------------
* HOMICIDIOS
* ------------------
* M.A. 3 Meses
clear all
use dados/base_final

synth homicidio_vitima3 lhomicidio_vitima3 qtd_arma3 lqtd_arma3 ///
lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/homicidio_vitima_3mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth homicidio_vitima3 lhomicidio_vitima3 qtd_arma3 lqtd_arma3 ///
	lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'

	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/homicidio_vitima_3mm_rmspe, replace

matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/homicidio_vitima_3mm_inf, replace
use dados/homicidio_vitima_3mm, clear
merge 1:1 _time using dados/homicidio_vitima_3mm_inf
drop _merge
save dados/Murder_3MA, replace
rm dados/homicidio_vitima_3mm_inf.dta
rm dados/homicidio_vitima_3mm.dta



* M.A. 6 Meses
clear all
use dados/base_final

synth homicidio_vitima6 lhomicidio_vitima6 qtd_arma6 lqtd_arma6 ///
lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/homicidio_vitima_6mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth homicidio_vitima6 lhomicidio_vitima6 qtd_arma6 lqtd_arma6  ///
	lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'

	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/homicidio_vitima_6mm_rmspe, replace


matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/homicidio_vitima_6mm_inf, replace
use dados/homicidio_vitima_6mm, clear
merge 1:1 _time using dados/homicidio_vitima_6mm_inf
drop _merge
save dados/Murder_6MA, replace
rm dados/homicidio_vitima_6mm_inf.dta
rm dados/homicidio_vitima_6mm.dta










* ------------------------
* TENTATIVA DE HOMICIDIOS
* ------------------------

* M.A. 3 Meses
clear all
use dados/base_final

synth tentat_homicidio3 ltentat_homicidio3 qtd_arma3 lqtd_arma3 ///
lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/tentat_homicidio_3mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth homicidio_vitima3 lhomicidio_vitima3 qtd_arma3 lqtd_arma3 ///
	lesao_corp_vitima3 llesao_corp_vitima3 latrocinio_vitima3 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'

	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/tentat_homicidio_3mm_rmspe, replace


matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/tentat_homicidio_3mm_inf, replace
use dados/tentat_homicidio_3mm, clear
merge 1:1 _time using dados/tentat_homicidio_3mm_inf
drop _merge
save dados/Attempted_Murder_3MA, replace
rm dados/tentat_homicidio_3mm_inf.dta
rm dados/tentat_homicidio_3mm.dta



* M.A. 6 Meses
clear all
use dados/base_final

synth tentat_homicidio6 ltentat_homicidio6 qtd_arma6 lqtd_arma6 ///
lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
media_estudo(693), trunit(6) trperiod(693) keep(dados/tentat_homicidio_6mm) replace

gen rmspe_original = e(RMSPE)[1,1]
gen rmspe = .
* Estimando intervalos de confianca
forvalues i = 1/13 {
	synth tentat_homicidio6 ltentat_homicidio6 qtd_arma6 lqtd_arma6 ///
	lesao_corp_vitima6 llesao_corp_vitima6 latrocinio_vitima6 ///
	seg_publica_pc educ_pc saude_pc habitacao_pc cultura_pc ciencia_tec_pc ///
	sal_efetivo_real idade_23_35(693) idade_36_60(693) idade_61mais(693) ocup(693) homem(693) ///
	media_estudo(693), trunit(`i') trperiod(693)
	replace rmspe = e(RMSPE)[1,1] if unidade == `i'

	matrix temp1 = e(Y_treated)
	matrix Ymat = (nullmat(Ymat), temp1)
	matrix temp1 = e(W_weights)
	matrix temp2 = temp1[1...,2]
	matrix weightsmat = (nullmat(weightsmat), temp2)
}

gen rmspe_vezes = rmspe/rmspe_original
keep unidade-rmspe_vezes
duplicates drop unidade, force
save dados/tentat_homicidio_6mm_rmspe, replace


matrix v = J(1, colsof(Ymat), 0)
do "function_SCM-CS_v07_stata.do"
SCMCS Ymat weightsmat 6 34 0 v 30 "linear" 1/13

* Salvando resultados de IC
svmat results
keep results1 results2
rename results1 upper
rename results2 lower
drop if missing(lower)
gen _time = 659 + _n
save dados/tentat_homicidio_6mm_inf, replace
use dados/tentat_homicidio_6mm, clear
merge 1:1 _time using dados/tentat_homicidio_6mm_inf
drop _merge
save dados/Attempted_Murder_6MA, replace
rm dados/tentat_homicidio_6mm_inf.dta
rm dados/tentat_homicidio_6mm.dta







* ------------------
* GRAFICOS
* ------------------

foreach i in ///
Crime_Occurrences_3MA Crime_Occurrences_6MA {

	clear all
	use dados/`i'
	gen dif = _Y_treated - _Y_synthetic
	format _time %tm
	gen yline = 0

	* Grafico SCM
	twoway line _Y_treated _Y_synthetic _time, ///
	lpattern(solid dash) lwidth(thick medthick) lcolor(black black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Crime Occurrences") xtitle("Time") ///
	legend(size(small) lab(1 "Pernambuco") lab(2 "Synt. Pernambuco"))
	graph export "graficos/`i'_scm.eps", replace
	graph export "graficos/`i'_scm.pdf", replace

	* Grafico - Diferenca e IC
	twoway rarea upper lower _time, fcolor(gs15) lcolor(gs14) || ///
	line yline _time, lpattern(dash) lwidth(thin) lcolor(gs12) || ///
	line dif _time, lwidth(thick) lcolor(black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Gap in Crime Occurrences") xtitle("Time") ///
	legend(size(small) order(1 "C.I." 3 "Gap"))
	graph export "graficos/`i'_inf.eps", replace
	graph export "graficos/`i'_inf.pdf", replace
}



foreach i in ///
Firearm_Seizure_6MA Firearm_Seizure_3MA {

	clear all
	use dados/`i'
	gen dif = _Y_treated - _Y_synthetic
	format _time %tm
	gen yline = 0

	* Grafico SCM
	twoway line _Y_treated _Y_synthetic _time, ///
	lpattern(solid dash) lwidth(thick medthick) lcolor(black black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Firearm Seizure") xtitle("Time") ///
	legend(size(small) lab(1 "Pernambuco") lab(2 "Synt. Pernambuco"))
	graph export "graficos/`i'_scm.eps", replace
	graph export "graficos/`i'_scm.pdf", replace

	* Grafico - Diferenca e IC
	twoway rarea upper lower _time, fcolor(gs15) lcolor(gs14) || ///
	line yline _time, lpattern(dash) lwidth(thin) lcolor(gs12) || ///
	line dif _time, lwidth(thick) lcolor(black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Gap in Firearm Seizure") xtitle("Time") ///
	legend(size(small) order(1 "C.I." 3 "Gap"))
	graph export "graficos/`i'_inf.eps", replace
	graph export "graficos/`i'_inf.pdf", replace
}



foreach i in ///
Total_Victims_3MA Total_Victims_6MA {

	clear all
	use dados/`i'
	gen dif = _Y_treated - _Y_synthetic
	format _time %tm
	gen yline = 0

	* Grafico SCM
	twoway line _Y_treated _Y_synthetic _time, ///
	lpattern(solid dash) lwidth(thick medthick) lcolor(black black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Total Victims") xtitle("Time") ///
	legend(size(small) lab(1 "Pernambuco") lab(2 "Synt. Pernambuco"))
	graph export "graficos/`i'_scm.eps", replace
	graph export "graficos/`i'_scm.pdf", replace

	* Grafico - Diferenca e IC
	twoway rarea upper lower _time, fcolor(gs15) lcolor(gs14) || ///
	line yline _time, lpattern(dash) lwidth(thin) lcolor(gs12) || ///
	line dif _time, lwidth(thick) lcolor(black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Gap in Total Victims") xtitle("Time") ///
	legend(size(small) order(1 "C.I." 3 "Gap"))
	graph export "graficos/`i'_inf.eps", replace
	graph export "graficos/`i'_inf.pdf", replace
}


foreach i in Attempted_Murder_6MA Attempted_Murder_3MA {

	clear all
	use dados/`i'
	gen dif = _Y_treated - _Y_synthetic
	format _time %tm
	gen yline = 0

	* Grafico SCM
	twoway line _Y_treated _Y_synthetic _time, ///
	lpattern(solid dash) lwidth(thick medthick) lcolor(black black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Attempted Murder") xtitle("Time") ///
	legend(size(small) lab(1 "Pernambuco") lab(2 "Synt. Pernambuco"))
	graph export "graficos/`i'_scm.eps", replace
	graph export "graficos/`i'_scm.pdf", replace

	* Grafico - Diferenca e IC
	twoway rarea upper lower _time, fcolor(gs15) lcolor(gs14) || ///
	line yline _time, lpattern(dash) lwidth(thin) lcolor(gs12) || ///
	line dif _time, lwidth(thick) lcolor(black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Gap in Attempted Murder") xtitle("Time") ///
	legend(size(small) order(1 "C.I." 3 "Gap"))
	graph export "graficos/`i'_inf.eps", replace
	graph export "graficos/`i'_inf.pdf", replace
}



foreach i in Murder_3MA Murder_6MA {

	clear all
	use dados/`i'
	gen dif = _Y_treated - _Y_synthetic
	format _time %tm
	gen yline = 0

	* Grafico SCM
	twoway line _Y_treated _Y_synthetic _time, ///
	lpattern(solid dash) lwidth(thick medthick) lcolor(black black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Murder") xtitle("Time") ///
	legend(size(small) lab(1 "Pernambuco") lab(2 "Synt. Pernambuco"))
	graph export "graficos/`i'_scm.eps", replace
	graph export "graficos/`i'_scm.pdf", replace

	* Grafico - Diferenca e IC
	twoway rarea upper lower _time, fcolor(gs15) lcolor(gs14) || ///
	line yline _time, lpattern(dash) lwidth(thin) lcolor(gs12) || ///
	line dif _time, lwidth(thick) lcolor(black) ///
	xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
	xlabel(660(16.5)710, labsize(small)) ytitle("Gap in Murder") xtitle("Time") ///
	legend(size(small) order(1 "C.I." 3 "Gap"))
	graph export "graficos/`i'_inf.eps", replace
	graph export "graficos/`i'_inf.pdf", replace
}









* ------------------------
* TESTES T
* ------------------------

ssc install asdoc


foreach i in ocorrencia_3mm_graph ocorrencia_6mm_graph qtd_arma_3mm_graph ///
qtd_arma_6mm_graph vitima_3mm_graph vitima_6mm_graph homicidio_vitima_3mm_graph ///
homicidio_vitima_6mm_graph tentat_homicidio_3mm_graph tentat_homicidio_6mm_graph {

	clear all
	use dados/`i'

	asdoc ttest _Y_treated == _Y_synthetic if _time <= 693, save(ttest.doc)
	asdoc ttest _Y_treated == _Y_synthetic if _time > 693, rowappend 
	
}


