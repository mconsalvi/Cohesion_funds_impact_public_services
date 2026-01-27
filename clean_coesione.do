/// ============================================================================
/// IMPATTO DELLE POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
/// ============================================================================

// Author: Matteo Consalvi
// Project: Impact evaluation of cohesion policies on public services quality
// do-file: cleaning
// Created: 07/07/2025
// Last Modified: 18/11/2025
// Each section title is indicated with "///"
// Comments are indicated with "*" or with "//"

// Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
* log using "log.txt", text replace  

/// ============================================================================
/// STEP 1: IMPORTA DATASET ORIGINALE
/// ============================================================================

// import csv FILE
import delimited "progetti_14-20", clear

// Visualizza info sul dataset
* describe

// Visualizza le prime righe
* list in 1/10

// Sintesi delle variabili
* summarize

// Percorso opzionale: descrizione più dettagliata
* codebook

/// ============================================================================
/// STEP 2: PULIZIA
/// ============================================================================

/// Drop Group 1: Identificativi e description testuali
capture drop descrizione_grande_progetto cod_ateco descrizione_ateco oc_cod_tipo_aiuto
capture drop oc_descr_tipo_aiuto oc_cod_sll oc_denominazione_sll oc_sintesi_progetto oc_descr_ciclo
capture drop cod_locale_progetto oc_titolo_progetto cup oc_link cod_grande_progetto
capture drop oc_codfisc_programmatore oc_codfisc_attuatore oc_codfisc_beneficiario
capture drop oc_codfisc_realizzatore

/// Drop Group 2: Fasi progettuali e metadata
capture drop oc_cod_fase_corrente oc_descr_fase_corrente oc_flag_cup oc_flag_pac
capture drop oc_flag_regione_unica oc_flag_visualizzazione data_aggiornamento

/// Drop Group 3: Ambiti e programmazione
capture drop oc_ambito oc_descr_fonte oc_codice_programma oc_descrizione_programma
capture drop oc_articolazione_programma oc_cod_articolaz_programma oc_descr_articolaz_programma
capture drop oc_subarticolazione_programma oc_descr_subarticolaz_programma oc_cod_subarticolaz_programma 
capture drop cod_strumento descr_strumento descr_tipo_strumento cod_proced_attivazione
capture drop descr_proced_attivazione cod_tipo_proced_attivazione 
capture drop oc_descr_categoria_spesa oc_cod_categoria_spesa 

/// Drop Group 4: Pagamenti aggregati (non abbiamo bisogno se aggrego)
capture drop descr_tipo_proced_attivazione oc_tot_pagamenti_rendicontab_ue oc_tot_pagamenti_fsc
capture drop oc_tot_pagamenti_pac costo_rendicontabile_ue 

/// Drop Group 5: Date multiple
capture drop data_inizio_prev_studio_fatt data_fine_prev_studio_fatt data_inizio_eff_studio_fatt 
capture drop data_fine_eff_studio_fatt data_inizio_prev_prog_prel data_fine_prev_prog_prel 
capture drop data_inizio_eff_prog_prel data_fine_eff_prog_prel data_inizio_prev_prog_def 
capture drop data_fine_prev_prog_def data_inizio_eff_prog_def data_fine_eff_prog_def 
capture drop data_inizio_prev_prog_esec data_fine_prev_prog_esec data_inizio_eff_prog_esec 
capture drop data_fine_eff_prog_esec data_inizio_prev_agg_bando data_fine_prev_agg_bando 
capture drop data_inizio_eff_agg_bando data_fine_eff_agg_bando data_inizio_prev_stip_attrib 
capture drop data_fine_prev_stip_attrib data_inizio_eff_stip_attrib  data_fine_eff_stip_attrib 
capture drop data_inizio_prev_esecuzione data_fine_prev_esecuzione data_inizio_eff_esecuzione 
capture drop data_fine_eff_esecuzione data_inizio_prev_collaudo data_fine_prev_collaudo 
capture drop data_inizio_eff_collaudo data_fine_eff_collaudo

/// Drop Group 6: Indicatori (dettagliati)
capture drop cod_indicatore_1 cod_indicatore_2 cod_indicatore_3 cod_indicatore_4
capture drop descr_indicatore_1 descr_indicatore_2 descr_indicatore_3 descr_indicatore_4
capture drop unita_misura_indicatore_1 unita_misura_indicatore_2 unita_misura_indicatore_3 unita_misura_indicatore_4
capture drop programmato_indicatore_1 programmato_indicatore_2 programmato_indicatore_3 programmato_indicatore_4
capture drop realizzato_indicatore_1 realizzato_indicatore_2 realizzato_indicatore_3 realizzato_indicatore_4

/// Drop Group 7: Totali (non usiamo per aggregazione manuale)
capture drop oc_totale_beneficiari oc_totale_programmatori oc_totale_attuatori
capture drop oc_totale_realizzatori oc_totale_indicatori

/// Drop Group 8: Denominazioni (redundant dopo drop nomi)
capture drop oc_denom_programmatore oc_cod_forma_giu_programmatore oc_descr_forma_giu_programmatore
capture drop oc_denom_attuatore oc_cod_forma_giu_attuatore oc_descr_forma_giu_attuatore
capture drop oc_denom_beneficiario oc_cod_forma_giu_beneficiario oc_descr_forma_giu_beneficiario
capture drop oc_denom_realizzatore oc_cod_forma_giu_realizzatore oc_descr_forma_giu_realizzatore

// Drop Group 9: Tipologia di finanziamento

capture drop finanz_ue finanz_ue_fse finanz_ue_fesr finanz_ue_feasr finanz_ue_feamp 
capture drop finanz_ue_iog finanz_stato_fondo_di_rotazione finanz_stato_fsc finanz_stato_pac
capture drop finanz_stato_completamenti finanz_stato_altri_provvedimenti finanz_regione 
capture drop finanz_provincia finanz_comune finanz_risorse_liberate finanz_altro_pubblico 
capture drop oc_finanz_ue_netto oc_finanz_ue_fse_netto oc_finanz_ue_fesr_netto 
capture drop oc_finanz_ue_feasr_netto oc_finanz_ue_feamp_netto oc_finanz_ue_iog_netto 
capture drop oc_finanz_stato_fondo_rot_netto oc_finanz_stato_fsc oc_finanz_stato_pac_netto 
capture drop oc_finanz_stato_compl_netto oc_finanz_stato_altri_prov_netto 
capture drop oc_finanz_regione_netto oc_finanz_provincia_netto oc_finanz_comune_netto 
capture drop oc_finanz_risorse_liberate_netto oc_finanz_altro_pubblico_netto

capture drop finanz_stato_estero finanz_privato finanz_da_reperire 
capture drop economie_totali economie_totali_pubbliche
capture drop oc_finanz_stato_estero_netto oc_finanz_privato_netto
capture drop impegni oc_impegni_giurid_vincolanti oc_impegni_trasferimenti
capture drop oc_impegni_coesione oc_tot_pagamenti_beneficiari
capture drop tot_pagamenti oc_tot_pagamenti_trasferimenti oc_pagamenti_coesione

// Drop Group 10: Stato finanziamento
capture drop oc_stato_finanziario oc_stato_progetto oc_stato_procedurale

// Drop Group 11: Altro
capture drop oc_cod_fonte oc_cod_ciclo

/// ============================================================================
/// STEP 2: PREPARAZIONE DATI
/// ============================================================================

// Eliminiamo i progetti che interessano più comuni, segendo anche la metodologia usata da SOSE
// 21,602
* drop if regexm(den_comune, ":::")

// Eliminiamo i progetti non rivolti ai comuni
// 53,395
* drop if den_comune == ""

// droppiamo i progetti multi provincia/regione
// 28
drop if regexm(den_provincia, ":::")
drop if regexm(den_regione, ":::")
drop if regexm(den_regione, "NAZIONALE")
drop if den_regione == ""
drop if den_provincia == ""


//Droppiamo progetti all'Estero (irrilevanti)
// 1,068
drop if oc_macroarea == "Estero"

// creare variabile anno
replace oc_data_inizio_progetto = floor(oc_data_inizio_progetto/10000)
replace oc_data_fine_progetto_prevista = floor(oc_data_fine_progetto_prevista/10000)
replace oc_data_fine_progetto_effettiva = floor(oc_data_fine_progetto_effettiva/10000)

rename oc_data_inizio_progetto anno_inizio
rename oc_data_fine_progetto_prevista anno_fine_previsto
rename oc_data_fine_progetto_effettiva anno_fine

//Droppiamo i progetti mai iniziati (se ci sono)
// 0
drop if anno_inizio == .

// Selezioniamo una variabile economica
// Destring delle tre variabili
foreach costvar in costo_realizzato finanz_totale_pubblico oc_finanz_tot_pub_netto oc_costo_coesione {
    capture confirm variable `costvar'
    if !_rc {
        di "  Convertendo `costvar'..."
        
        // Rimuovi eventuali spazi, virgole, simboli €
        replace `costvar' = trim(`costvar')
        replace `costvar' = subinstr(`costvar', "€", "", .)
        replace `costvar' = subinstr(`costvar', ",", ".", .)
        replace `costvar' = subinstr(`costvar', " ", "", .)
        
        // Converti a numerica
        destring `costvar', replace force
        
        // Check
        summarize `costvar', detail
        di ""
    }
}

// selezioniamo finanz_totale_pubblico
drop oc_finanz_tot_pub_netto oc_costo_coesione

// Generiamo variabile percentuale di completamento
gen settlment_ratio = (costo_realizzato/finanz_totale_pubblico)*100

// Drop se realizzazione <95%
// 225,362 + 16,612
* drop if settlment_ratio < 95
drop if settlment_ratio == .

// Drop result = 318,067/1,094,617 | 29% of the starting dataset


// TEMI OC
* 1: Ricerca e innovazione
* 2: Reti e servizi digitali
* 3: Competitività delle imprese
* 4: Energia
* 5: Ambiente
* 6: Cultura e turismo
* 7:Trasporti e mobilità
* 8: Occupazione e lavoro
* 9: Inclusione sociale e salute
* 11: Istruzione e formazione
* 13: Capacità amministrativa

// Drop tematiche inutili
keep if inlist(oc_cod_tema_sintetico, 2, 7, 8, 9, 11, 13)

// Deleted: 173,579, aggregate: 491,646/1,094,617 | 44,9% of the starting dataset

gen anno = anno_fine

drop if anno == .

* Collapse to provincial level first (optional, but recommended)
* This aggregates all projects within each province-year
collapse (sum) importo = finanz_totale_pubblico ///
         (count) n_progetti = finanz_totale_pubblico ///
         (mean) media_progetto = finanz_totale_pubblico ///
		 (first) den_regione cod_regione, ///
         by(den_provincia anno)
		 

replace den_regione = lower(den_regione)
replace den_provincia = lower(den_provincia)


* Label variables
label var importo "Total OC spending (€)"
label var n_progetti "Number of OC projects"
label var media_progetto "Average project size (€)"

// generiamo clasificaizone regionale
gen classificazione = .

replace classificazione = 1 if den_regione == "basilicata" | den_regione == "calabria" | ///
den_regione == "campania" | den_regione == "puglia" | den_regione == "sicilia"

replace classificazione = 2 if den_regione == "abruzzo" | den_regione == "molise" | ///
den_regione == "sardegna"

replace classificazione = 3 if den_regione == "emilia-romagna" | den_regione == "friuli-venezia giulia" | ///
den_regione == "lazio" | den_regione == "liguria" | den_regione == "umbria" | den_regione == "marche" ///
| den_regione == "toscana" | den_regione == "piemonte" | den_regione == "lombardia" | ///
den_regione == "trentino-alto adige" | den_regione == "valle d'aosta" | den_regione == "veneto" 


local numvars `r(varlist)'
* Convert each variable from string to numeric
foreach var in `numvars' {
    destring `var', replace force
}

recast str30 den_provincia
recast str30 den_regione


keep if anno > 2013 & anno < 2025

* replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")

save "coesione_14_20.dta", replace

/// ============================================================================

import delimited "population.csv", clear

gen den_provincia = lower(substr(geogeopoliticalentityreporting, 8, .))

drop structure structure_id freqtimefrequency sexsex unitunitofmeasure ageageclass ///
geogeopoliticalentityreporting obs_flagobservationstatusflagv2s conf_statusconfidentialitystatus

rename time_periodtime anno
rename obs_valueobservationvalue popolazione

replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")
replace den_provincia = "bolzano" if regexm(den_provincia, "bolzano")
replace den_provincia = "trento" if regexm(den_provincia, "trento")
replace den_provincia = "l'aquila" if regexm(den_provincia, "aquila")
replace den_provincia = "reggio nell'emilia" if regexm(den_provincia, "emilia")
replace den_provincia = "reggio di calabria" if regexm(den_provincia, "calabria")
replace den_provincia = "aosta" if regexm(den_provincia, "aosta")
replace den_provincia = "carbonia-iglesias" if regexm(den_provincia, "carbonia-iglesias")
replace den_provincia = "medio campidano" if regexm(den_provincia, "medio campidano")
replace den_provincia = "ogliastra" if regexm(den_provincia, "ogliastra")
replace den_provincia = "olbia-tempio" if regexm(den_provincia, "olbia-tempio")
drop if regexm(den_provincia, "2016")

merge 1:m anno den_provincia using coesione_14_20.dta

drop if den_provincia == "olbia-tempio" | den_provincia == "ogliastra" | ///
		den_provincia == "carbonia-iglesias" | den_provincia == "medio campidano"
drop if _merge == 1
drop _merge


sort anno den_provincia


save "coesione_14_20.dta", replace

/// ============================================================================

import delimited "area.csv", clear

drop structure structure_id structure_name freq landuse timefrequency v7 unit ///
unitofmeasure geo time observationvalue obs_flag observationstatusflagv2s ///
conf_status confidentialitystatus

rename time_period anno
rename obs_value area
rename geopoliticalentityreporting den_provincia

replace den_provincia = lower(den_provincia)

replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")
replace den_provincia = "bolzano" if regexm(den_provincia, "bolzano")
replace den_provincia = "trento" if regexm(den_provincia, "trento")
replace den_provincia = "l'aquila" if regexm(den_provincia, "aquila")
replace den_provincia = "reggio nell'emilia" if regexm(den_provincia, "emilia")
replace den_provincia = "reggio di calabria" if regexm(den_provincia, "calabria")
replace den_provincia = "aosta" if regexm(den_provincia, "aosta")
replace den_provincia = "carbonia-iglesias" if regexm(den_provincia, "carbonia-iglesias")
replace den_provincia = "medio campidano" if regexm(den_provincia, "medio campidano")
replace den_provincia = "ogliastra" if regexm(den_provincia, "ogliastra")
replace den_provincia = "olbia-tempio" if regexm(den_provincia, "olbia-tempio")
drop if regexm(den_provincia, "2016")

merge 1:m anno den_provincia using coesione_14_20.dta

drop if den_provincia == "olbia-tempio" | den_provincia == "ogliastra" | ///
		den_provincia == "carbonia-iglesias" | den_provincia == "medio campidano"
drop if _merge == 1
drop _merge

sort anno den_provincia

gen pop_density = popolazione/area

save "coesione_14_20.dta", replace

/// ============================================================================

import delimited "pil_regionale.csv", clear

drop structure structure_id structure_name freq timefrequency unit ///
unitofmeasure geo time observationvalue obs_flag observationstatusflagv2s ///
conf_status confidentialitystatus

rename time_period anno
rename geopoliticalentityreporting den_provincia

gen pil = obs_value*1000000
drop obs_value

format pil %20.0f

replace den_provincia = lower(den_provincia)

replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")
replace den_provincia = "bolzano" if regexm(den_provincia, "bolzano")
replace den_provincia = "trento" if regexm(den_provincia, "trento")
replace den_provincia = "l'aquila" if regexm(den_provincia, "aquila")
replace den_provincia = "reggio nell'emilia" if regexm(den_provincia, "emilia")
replace den_provincia = "reggio di calabria" if regexm(den_provincia, "calabria")
replace den_provincia = "aosta" if regexm(den_provincia, "aosta")
replace den_provincia = "carbonia-iglesias" if regexm(den_provincia, "carbonia-iglesias")
replace den_provincia = "medio campidano" if regexm(den_provincia, "medio campidano")
replace den_provincia = "ogliastra" if regexm(den_provincia, "ogliastra")
replace den_provincia = "olbia-tempio" if regexm(den_provincia, "olbia-tempio")
drop if regexm(den_provincia, "2016")

merge 1:m anno den_provincia using coesione_14_20.dta

drop if den_provincia == "olbia-tempio" | den_provincia == "ogliastra" | ///
		den_provincia == "carbonia-iglesias" | den_provincia == "medio campidano"
drop if _merge == 1
drop _merge

sort anno den_provincia

gen pil_pc = pil/popolazione

save "coesione_14_20.dta", replace

/// ============================================================================

import delimited "neet", clear

drop structure structure_id structure_name freq timefrequency sex v7 age ageclass ///
training v11 wstatus labourforceandemploymentstatus unit unitofmeasure geo ///
time observationvalue obs_flag observationstatusflagv2structure conf_status confidentialitystatusflag

gen den_regione = lower(geopoliticalentityreporting)
drop geopoliticalentityreporting

gen base_neet = obs_value if time_period == 2013

sort den_regione time_period
by den_regione (time_period): replace base_neet = base_neet[_n-1] if missing(base_neet)

replace den_regione = "valle d'aosta" if regexm(den_regione,"valle")

replace den_regione = trim(den_regione)

save neet.dta, replace

import delimited "pop_reg_eurostat", clear

drop structure structure_id freqtimefrequency unitunitofmeasure sex ageageclass /// 
obs_flag conf_statusconfidentialitystatus

gen den_regione = substr(geogeopoliticalentityreporting, 6, .)
drop geogeopoliticalentityreporting

replace den_regione = lower(den_regione)

replace den_regione = "valle d'aosta" if regexm(den_regione,"valle")

rename time_periodtime time_period

replace den_regione = trim(den_regione)

merge 1:1 den_regione time_period using neet.dta

drop _merge

replace den_regione = "trentino-alto adige" if regexm(den_regione,"bozen")|regexm(den_regione,"trento")

rename obs_valueobservationvalue pop
rename obs_value neet

collapse (mean) base_neet neet (sum) pop [aw=pop], by(time_period den_regione)

drop pop

rename time_period anno

recast str30 den_regione

merge 1:m den_regione anno using coesione_14_20.dta

drop if anno == 2013

drop _merge

save "coesione_14_20.dta", replace

/// ============================================================================




