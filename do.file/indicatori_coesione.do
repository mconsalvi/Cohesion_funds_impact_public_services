/* ============================================================================
*** IMPATTO DELLE POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
=============================================================================*/
// Author: Matteo Consalvi
// Project: Impact evaluation of cohesion policies on public services quality
// do-file: public services indicators cleaning and preparation
// Created: 07/01/2026
// Last Modified: 27/01/2026


// Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
* log using "log.txt", text replace  

/* ============================================================================
*** IMPORTA DATASET QUALITÀ DEI SERVIZI E MERGE
=============================================================================*/

import excel using "indicatori_qualita.xlsx", ///
    firstrow ///
    clear ///
    allstring

* ============================================================================
* RENAME ALL VARIABLES FROM ITALIAN LABELS TO BES CODES
* ============================================================================

rename Provincia den_provincia
rename Anno anno

* Health (SAL) - 4 indicators
rename Mortalitàinfantile sal_mort_infantile
rename Mortalitàevit~i sal_mort_evitabile
* NOTE: 01SAL001 (Life expectancy) and 01SAL005 (Road mortality) missing from export
* Add them manually if available in ISTAT, or note as "not exported"

* Education (IST) - 7 indicators
rename Partecipazion~s ist_partecipazione_scolastica
rename Bambinichehan~i ist_bambini_sistemi_infanz
rename Personeconalm~2 ist_diplomati
rename Partecipazion~c ist_formazione_cont
rename Laureatiealtr~i ist_laureati
rename Giovanichenon~s ist_neet
rename Competenzanum~a ist_numerica_inad
rename Competenzaalf~a ist_alfabetismo_inad

* Labor (LAV) - 4 indicators
rename Giornateretri~l lav_giorni_lav
rename Tassodioccupa~i lav_occupazione
rename Tassodioccupa~e lav_occupazione_giovanile
rename Tassodimancat~e lav_partecipazione_giovanile

* Economic (BEC) - 1 indicator
rename Retribuzionem~v bec_retribuzione

* Politics & Institutions (POL) - 2 indicators
rename Comunicapacit~e pol_com_riscossione
rename Amministrazio~p pol_prov_riscossione

* Innovation (RIC) - 1 indicator
rename Comuniconserv~l ric_servizi_digitali

* Quality of Services (SER) - 5 indicators
rename Irregolaritàd~r ser_irregolarita_elettrica
rename Postikmoffert~l ser_tpl_km
rename Emigrazioneos~a ser_emigrazione_osp
rename Serviziodirac~a ser_raccolta_rifiuti
rename Medicispecial~i ser_medici_specializzati
rename Postilettoper~l ser_posti_letto_ass_elev
rename Coperturadell~c ser_internet
rename SER003PN25 ser_posti_letto_osped
label variable ser_posti_letto_osped "Numero di posti letto ospedalieri per 100,000 abitanti"

// Last check

describe

// CONVERT ALL VARIABLES FROM STRING TO NUMERIC

* Identify all variables except provincia
ds den_provincia, not
local numvars `r(varlist)'

* Convert each variable from string to numeric
foreach var in `numvars' {
    destring `var', replace force
}

// Last check
describe
summarize

replace den_provincia = lower(den_provincia)

replace den_provincia = "bolzano" if regexm(den_provincia, "bozen")
replace den_provincia = "aosta" if regexm(den_provincia, "valle")
replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")

replace den_provincia = trim(den_provincia)
recast str30 den_provincia


save "indicatori.dta", replace

///  ==========================================================================

import delimited "occupati", clear

drop freq frequenza ref_area sex sesso age età obs_status statodellosservazione

gen occupati = osservazione * 1000
drop osservazione

rename time_period anno

gen den_provincia = lower(territorio)
drop territorio

save occupati.dta, replace

import delimited "occupati_storico", clear

drop 嚜澹req et v15 v22 v29 v36 frequenza v16 v23 v30 v37 ref_area v13 v20 v27 v34 ///
v17 v24 v31 v38 obs_status v18 v25 v32 v39 sex statodello~r v19 v26 v33 v40 ///
sesso age v14 v21 v28 v35

gen occupati = osservazione * 1000
drop osservazione

rename time_period anno

gen den_provincia = lower(territorio)
drop territorio

append using occupati.dta

sort den_provincia anno

replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")
replace den_provincia = "aosta" if regexm(den_provincia, "valle")

replace anno = 2013 if regexm(den_provincia,"2013")
replace anno = 2014 if regexm(den_provincia,"2014")
replace anno = 2015 if regexm(den_provincia,"2015")
replace anno = 2016 if regexm(den_provincia,"2016")
replace anno = 2017 if regexm(den_provincia,"2017")
replace anno = 2018 if regexm(den_provincia,"2018")
replace anno = 2019 if regexm(den_provincia,"2019")
replace anno = 2020 if regexm(den_provincia,"2020")
replace anno = 2021 if regexm(den_provincia,"2021")
replace anno = 2022 if regexm(den_provincia,"2022")
replace anno = 2023 if regexm(den_provincia,"2023")
replace anno = 2024 if regexm(den_provincia,"2024")

replace occupati = 112120 if regexm(den_provincia,"112.12")
replace occupati = 107128 if regexm(den_provincia,"107.128")
replace occupati = 108379 if regexm(den_provincia,"108.379")
replace occupati = 114134 if regexm(den_provincia,"114.134")
replace occupati = 113096 if regexm(den_provincia,"113.096")
replace occupati = 112995 if regexm(den_provincia,"112.995")
replace occupati = 112265 if regexm(den_provincia,"112.265")
replace occupati = 108951 if regexm(den_provincia,"108.951")
replace occupati = 108764 if regexm(den_provincia,"108.764")
replace occupati = 107103 if regexm(den_provincia,"107.103")
replace occupati = 109029 if regexm(den_provincia,"109.029")
replace occupati = 116177 if regexm(den_provincia,"116.177")

replace den_provincia = "l'aquila" if regexm(den_provincia,"aquila")

replace occupati = 232978 if regexm(den_provincia,"232.978")
replace occupati = 230628 if regexm(den_provincia,"230.628")
replace occupati = 232781 if regexm(den_provincia,"232.781")
replace occupati = 238021 if regexm(den_provincia,"238.021")
replace occupati = 237539 if regexm(den_provincia,"237.539")
replace occupati = 238575 if regexm(den_provincia,"238.575")
replace occupati = 245295 if regexm(den_provincia,"245.295")
replace occupati = 236227 if regexm(den_provincia,"236.227")
replace occupati = 238876 if regexm(den_provincia,"238.876")
replace occupati = 235414 if regexm(den_provincia,"235.414")
replace occupati = 242757 if regexm(den_provincia,"242.757")
replace occupati = 240315 if regexm(den_provincia,"240.315")


replace den_provincia = "reggio nell'emilia" if regexm(den_provincia,"emilia")

replace den_provincia = "sassari" if regexm(den_provincia,"olbia")
replace den_provincia = "nuoro" if regexm(den_provincia,"ogliastra")
replace den_provincia = "sud sardegna" if regexm(den_provincia,"medio") | ///
regexm(den_provincia,"carbonia")

collapse (sum) occupati, by(anno den_provincia)

order den_provincia, last

order anno den_provincia

sort anno den_provincia

save occupati.dta, replace

merge 1:1 anno den_provincia using indicatori.dta

bys anno: tab _merge

drop lav_occupazione

rename occupati lav_occupazione

drop _merge

drop if anno == 2013

save "indicatori.dta", replace

///  ==========================================================================

import delimited "diplomati", clear

drop freq frequenza ref_area data_type indicatore school_level ordinescolastico ///
type_school_management gestionedellascuola type_school tipodiscuolasuperiore ///
obs_status statodellosservazione

gen den_provincia = lower(territorio)
drop territorio

replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")
replace den_provincia = "aosta" if regexm(den_provincia, "valle")

rename time_period anno

replace anno = 2015 if regexm(den_provincia,"2015")
replace anno = 2016 if regexm(den_provincia,"2016")
replace anno = 2017 if regexm(den_provincia,"2017")
replace anno = 2018 if regexm(den_provincia,"2018")
replace anno = 2019 if regexm(den_provincia,"2019")
replace anno = 2020 if regexm(den_provincia,"2020")
replace anno = 2021 if regexm(den_provincia,"2021")
replace anno = 2022 if regexm(den_provincia,"2022")
replace anno = 2023 if regexm(den_provincia,"2023")


replace osservazione = 3178 if regexm(den_provincia,"3178")
replace osservazione = 3245 if regexm(den_provincia,"3245")
replace osservazione = 3352 if regexm(den_provincia,"3352")
replace osservazione = 3432 if regexm(den_provincia,"3432")
replace osservazione = 3470 if regexm(den_provincia,"3470")
replace osservazione = 3639 if regexm(den_provincia,"3639")
replace osservazione = 3754 if regexm(den_provincia,"3754")
replace osservazione = 3696 if regexm(den_provincia,"3696")
replace osservazione = 3655 if regexm(den_provincia,"3655")

replace den_provincia = "reggio nell'emilia" if regexm(den_provincia,"emilia")


replace osservazione = 2315 if regexm(den_provincia,"2315")
replace osservazione = 2352 if regexm(den_provincia,"2352")
replace osservazione = 2118 if regexm(den_provincia,"2118")
replace osservazione = 2210 if regexm(den_provincia,"2210")
replace osservazione = 2277 if regexm(den_provincia,"2277")
replace osservazione = 2272 if regexm(den_provincia,"2272")
replace osservazione = 2154 if regexm(den_provincia,"2154")
replace osservazione = 2155 if regexm(den_provincia,"2155")
replace osservazione = 2162 if regexm(den_provincia,"2162")

replace den_provincia = "l'aquila" if regexm(den_provincia,"aquila")

replace den_provincia = "sassari" if regexm(den_provincia,"olbia")
replace den_provincia = "nuoro" if regexm(den_provincia,"ogliastra")
replace den_provincia = "sud sardegna" if regexm(den_provincia,"medio") | ///
regexm(den_provincia,"carbonia")

collapse (sum) osservazione, by(anno den_provincia)

merge 1:1 anno den_provincia using indicatori.dta

bys anno: tab _merge

drop ist_diplomati

rename osservazione ist_diplomati

drop _merge

drop ist_neet

sort den_provincia anno

save "indicatori.dta", replace

///  ==========================================================================


