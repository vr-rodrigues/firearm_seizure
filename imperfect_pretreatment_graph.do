clear all
di c(pwd)
local diretorio = substr("`c(pwd)'", 1, 2)
cd `diretorio'


* ---------------------
* TOTAL DE OCORRENCIAS
* ---------------------

clear all
import delimited "data/ocorrencia_3mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Crime Occurrences") xtitle("Time") ///
legend(size(small))

graph export "graficos/Crime_Occurrences_3MA_pretreat.eps", replace
graph export "graficos/Crime_Occurrences_3MA_pretreat.pdf", replace


clear all
import delimited "data/ocorrencia_6mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Crime Occurrences") xtitle("Time") ///
legend(size(small))

graph export "graficos/Crime_Occurrences_6MA_pretreat.eps", replace
graph export "graficos/Crime_Occurrences_6MA_pretreat.pdf", replace








* ------------------------------------------------------
* VITIMAS
* ------------------------------------------------------
clear all
import delimited "data/vitima_3mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Total Victims") xtitle("Time") ///
legend(size(small))

graph export "graficos/Total_Victims_3MA_pretreat.eps", replace
graph export "graficos/Total_Victims_3MA_pretreat.pdf", replace


clear all
import delimited "data/vitima_6mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Total Victims") xtitle("Time") ///
legend(size(small))

graph export "graficos/Total_Victims_6MA_pretreat.eps", replace
graph export "graficos/Total_Victims_6MA_pretreat.pdf", replace





* ------------------------------------------------------
* ARMAS
* ------------------------------------------------------
clear all
import delimited "data/qtd_arma_3mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Firearm Seizure") xtitle("") ///
legend(size(small))

graph export "graficos/Firearm_Seizure_3MA_pretreat.eps", replace
graph export "graficos/Firearm_Seizure_3MA_pretreat.pdf", replace


clear all
import delimited "data/qtd_arma_6mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Firearm Seizure") xtitle("") ///
legend(size(small))

graph export "graficos/Firearm_Seizure_6MA_pretreat.eps", replace
graph export "graficos/Firearm_Seizure_6MA_pretreat.pdf", replace





* ------------------
* HOMICIDIOS
* ------------------
clear all
import delimited "data/homicidio_vitima_3mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Murder") xtitle("Time") ///
legend(size(small))

graph export "graficos/Murder_3MA_pretreat.eps", replace
graph export "graficos/Murder_3MA_pretreat.pdf", replace


clear all
import delimited "data/homicidio_vitima_6mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Murder") xtitle("Time") ///
legend(size(small))

graph export "graficos/Murder_6MA_pretreat.eps", replace
graph export "graficos/Murder_6MA_pretreat.pdf", replace






* ------------------------
* TENTATIVA DE HOMICIDIOS
* ------------------------
clear all
import delimited "data/tentat_homicidio_3mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Attempted Murder") xtitle("") ///
legend(size(small))

graph export "graficos/Attempted_Murder_3MA_pretreat.eps", replace
graph export "graficos/Attempted_Murder_3MA_pretreat.pdf", replace


clear all
import delimited "data/tentat_homicidio_6mm.csv"
format time %tm

* Grafico SCM
label var treated "Pernambuco"
label var counter "SC (all lags)"
label var demean "Demeaned SC (all lags)"
label var vanilla "SC (Abadie et al. 2003)"
label var did "Diff-in-Diff"

twoway line treated counter demean vanilla did time, ///
lpattern(solid dash dot dash_dot longdash_dot) lwidth(medthick) ///
lcolor(black gs4 gs7 gs10 gs13) ///
xline(693, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
graphregion(color(white)) bgcolor(white) ylabel(, nogrid labsize(small)) ///
xlabel(660(16.5)710, labsize(small)) ytitle("Attempted Murder") xtitle("") ///
legend(size(small))

graph export "graficos/Attempted_Murder_6MA_pretreat.eps", replace
graph export "graficos/Attempted_Murder_6MA_pretreat.pdf", replace
