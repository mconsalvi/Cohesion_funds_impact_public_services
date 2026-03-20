/// ============================================================================
/// IMPACT EVALUATION FOR COHESION POLICIES ON PUBLIC SERVICES IN ITALY
/// ============================================================================
// Author: Matteo Consalvi
// Project: Impact evaluation of cohesion policies on public services quality
// do-file: Cleaning of OpenCoesione dataset
// Created: 07/07/2025
// Last Modified: 15/01/2026

// Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
* log using "log.txt", text replace  

/// ============================================================================
/// STEP 1: IMPORT ORIGINAL DATASET
/// ============================================================================

// Import CSV file
import delimited "new_progetti_14-20", clear

// Display info about the dataset
* describe

// Display the first rows
* list in 1/10

// Summary of variables
* summarize

// Optional path: more detailed description
* codebook

/// ============================================================================
/// STEP 2: DATA CLEANING
/// ============================================================================

/// Drop Group 1: Identifiers and textual descriptions
drop descrizione_grande_progetto cod_ateco descrizione_ateco oc_cod_tipo_aiuto
drop oc_descr_tipo_aiuto oc_cod_sll oc_denominazione_sll oc_sintesi_progetto oc_descr_ciclo
drop cod_locale_progetto oc_titolo_progetto cup oc_link cod_grande_progetto
drop oc_codfisc_programmatore oc_codfisc_attuatore oc_codfisc_beneficiario
drop oc_codfisc_realizzatore

/// Drop Group 2: Project phases and metadata
drop oc_cod_fase_corrente oc_descr_fase_corrente oc_flag_cup oc_flag_pac
drop oc_flag_regione_unica oc_flag_visualizzazione data_aggiornamento

/// Drop Group 3: Scopes and programming
drop oc_cod_ciclo oc_cod_fonte oc_descr_fonte oc_codice_programma oc_descrizione_programma
drop oc_articolazione_programma oc_cod_articolaz_programma oc_descr_articolaz_programma
drop oc_subarticolazione_programma oc_descr_subarticolaz_programma oc_cod_subarticolaz_programma 
drop cod_strumento descr_strumento descr_tipo_strumento cod_proced_attivazione
drop descr_proced_attivazione cod_tipo_proced_attivazione 
drop oc_descr_categoria_spesa oc_cod_categoria_spesa 

/// Drop Group 4: Aggregate payments
drop descr_tipo_proced_attivazione oc_tot_pagamenti_rendicontab_ue oc_tot_pagamenti_fsc
drop oc_tot_pagamenti_pac costo_rendicontabile_ue 

/// Drop Group 5: Multiple dates
drop data_inizio_prev_studio_fatt data_fine_prev_studio_fatt data_inizio_eff_studio_fatt 
drop data_fine_eff_studio_fatt data_inizio_prev_prog_prel data_fine_prev_prog_prel 
drop data_inizio_eff_prog_prel data_fine_eff_prog_prel data_inizio_prev_prog_def 
drop data_fine_prev_prog_def data_inizio_eff_prog_def data_fine_eff_prog_def 
drop data_inizio_prev_prog_esec data_fine_prev_prog_esec data_inizio_eff_prog_esec 
drop data_fine_eff_prog_esec data_inizio_prev_agg_bando data_fine_prev_agg_bando 
drop data_inizio_eff_agg_bando data_fine_eff_agg_bando data_inizio_prev_stip_attrib 
drop data_fine_prev_stip_attrib data_inizio_eff_stip_attrib  data_fine_eff_stip_attrib 
drop data_inizio_prev_esecuzione data_fine_prev_esecuzione data_inizio_eff_esecuzione 
drop data_fine_eff_esecuzione data_inizio_prev_collaudo data_fine_prev_collaudo 
drop data_inizio_eff_collaudo data_fine_eff_collaudo

/// Drop Group 6: Indicators
drop cod_indicatore_1 cod_indicatore_2 cod_indicatore_3 cod_indicatore_4
drop descr_indicatore_1 descr_indicatore_2 descr_indicatore_3 descr_indicatore_4
drop unita_misura_indicatore_1 unita_misura_indicatore_2 unita_misura_indicatore_3 unita_misura_indicatore_4
drop programmato_indicatore_1 programmato_indicatore_2 programmato_indicatore_3 programmato_indicatore_4
drop realizzato_indicatore_1 realizzato_indicatore_2 realizzato_indicatore_3 realizzato_indicatore_4

/// Drop Group 7: Totals
drop oc_totale_beneficiari oc_totale_programmatori oc_totale_attuatori
drop oc_totale_realizzatori oc_totale_indicatori

/// Drop Group 8: Denominations
drop oc_denom_programmatore oc_cod_forma_giu_programmatore oc_descr_forma_giu_programmatore
drop oc_denom_attuatore oc_cod_forma_giu_attuatore oc_descr_forma_giu_attuatore
drop oc_denom_beneficiario oc_cod_forma_giu_beneficiario oc_descr_forma_giu_beneficiario
drop oc_denom_realizzatore oc_cod_forma_giu_realizzatore oc_descr_forma_giu_realizzatore

// Drop Group 9: Funding type
drop fondo_comunitario
drop finanz_ue finanz_ue_fse finanz_ue_fesr finanz_ue_feasr finanz_ue_feamp 
drop finanz_ue_iog finanz_stato_fondo_di_rotazione finanz_stato_fsc finanz_stato_pac
drop finanz_stato_completamenti finanz_stato_altri_provvedimenti finanz_regione 
drop finanz_provincia finanz_comune finanz_risorse_liberate finanz_altro_pubblico 
drop oc_finanz_ue_netto oc_finanz_ue_fse_netto oc_finanz_ue_fesr_netto 
drop oc_finanz_ue_feasr_netto oc_finanz_ue_feamp_netto oc_finanz_ue_iog_netto 
drop oc_finanz_stato_fondo_rot_netto oc_finanz_stato_fsc oc_finanz_stato_pac_netto 
drop oc_finanz_stato_compl_netto oc_finanz_stato_altri_prov_netto 
drop oc_finanz_regione_netto oc_finanz_provincia_netto oc_finanz_comune_netto 
drop oc_finanz_risorse_liberate_netto oc_finanz_altro_pubblico_netto

drop finanz_stato_estero finanz_privato finanz_da_reperire 
drop economie_totali economie_totali_pubbliche
drop oc_finanz_stato_estero_netto oc_finanz_privato_netto
drop impegni oc_impegni_giurid_vincolanti oc_impegni_trasferimenti
drop oc_impegni_coesione oc_tot_pagamenti_beneficiari
drop tot_pagamenti oc_tot_pagamenti_trasferimenti oc_pagamenti_coesione

drop oc_finanz_tot_pub_netto oc_costo_coesione finanz_ue_altro oc_finanz_ue_altro_netto


// Drop Group 10: Funding status
drop oc_stato_finanziario oc_stato_progetto oc_stato_procedurale

// Drop group 11: Classification
drop cod_ob_tematico descr_ob_tematico cod_priorita_invest descr_priorita_invest
drop cup_cod_natura cup_descr_natura cup_cod_tipologia cup_descr_tipologia
drop cup_cod_settore cup_descr_settore cup_cod_sottosettore cup_descr_sottosettore
drop cup_cod_categoria cup_descr_categoria

// Drop useless dates
drop oc_data_inizio_progetto
drop oc_data_fine_progetto_prevista

/// ============================================================================
/// DATA PREPARATION
/// ============================================================================

// Create year variable
replace oc_data_fine_progetto_effettiva = floor(oc_data_fine_progetto_effettiva/10000)
rename oc_data_fine_progetto_effettiva anno_fine

// We eliminate projects affecting multiple municipalities, following the methodology used by SOSE
// 21,602
drop if regexm(den_comune, ":::")

// We eliminate projects not directed at municipalities
// 54,039
drop if den_comune == ""

// We drop multi-province/region projects
// 30
drop if regexm(den_provincia, ":::")
drop if regexm(den_regione, ":::")
drop if regexm(den_regione, "NAZIONALE")
drop if den_regione == ""
drop if den_provincia == ""


// Drop projects abroad (irrelevant)
// 1,068
drop if oc_macroarea == "Estero"

// Destring amount variables
foreach costvar in costo_realizzato finanz_totale_pubblico  {
    capture confirm variable `costvar'
    if !_rc {
        di "  Converting `costvar'..."
        
        // Remove any spaces, commas, € symbols
        replace `costvar' = trim(`costvar')
        replace `costvar' = subinstr(`costvar', "€", "", .)
        replace `costvar' = subinstr(`costvar', ",", ".", .)
        replace `costvar' = subinstr(`costvar', " ", "", .)
        
        // Convert to numeric
        destring `costvar', replace force
        
        // Check
        summarize `costvar', detail
        di ""
    }
}


// Generate completion percentage variable
gen settlment_ratio = (costo_realizzato/finanz_totale_pubblico)*100

// Drop if realization < 90%
// 206,503
drop if settlment_ratio < 90

// Drop result = 283,242/1,177,768 | -24% of the starting dataset

// OC THEMES
* 1: Research and innovation
* 2: Digital networks and services
* 3: Business competitiveness
* 4: Energy
* 5: Environment
* 6: Culture and tourism
* 7: Transport and mobility
* 8: Employment and labor
* 9: Social inclusion and health
* 11: Education and training
* 13: Administrative capacity

// Drop unnecessary themes
keep if inlist(oc_cod_tema_sintetico, 2, 7, 8, 9, 11, 13)

// Deleted: 202,080, aggregate: 405,322/1,177,768 | -34% of the starting dataset

rename anno_fine anno

// We eliminate unfinished projects
// 24,478
drop if anno == .
		 
replace den_regione = lower(den_regione)
replace den_provincia = lower(den_provincia)
replace den_comune = lower(den_comune)
replace oc_macroarea = lower(oc_macroarea)
replace oc_tema_sintetico = lower(oc_tema_sintetico)

rename oc_macroarea macroarea

local numvars `r(varlist)'
* Convert each variable from string to numeric
foreach var in `numvars' {
    destring `var', replace force
}


* Collapse to municipal level first
* This aggregates all projects within each municipality-year
collapse (sum) importo = finanz_totale_pubblico ///
         (count) n_progetti = finanz_totale_pubblico ///
         (mean) media_progetto = finanz_totale_pubblico ///
		 (first) den_regione den_provincia macroarea, ///
         by(den_comune cod_comune oc_tema_sintetico oc_cod_tema_sintetico anno)

* Label variables
label var importo "Total OC spending (€)"
label var n_progetti "Number of OC projects"
label var media_progetto "Average project size (€)"

recast str30 den_provincia, force
recast str30 den_regione, force
recast str30 den_comune, force

replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")

capture program drop standardizza_comune
program define standardizza_comune

    syntax varlist(max=1)  // Es: den_comune
	local varname `varlist'
    
    tempvar temp_str orig
    
    gen `orig' = `varname'
    
    // Minuscolo
    gen `temp_str' = lower(`varname')
    
    // Sostituzioni accenti/apostrofi (semplice e veloce)
    replace `temp_str' = subinstr(`temp_str', "à", "a", .)
    replace `temp_str' = subinstr(`temp_str', "è", "e", .)
    replace `temp_str' = subinstr(`temp_str', "é", "e", .)
    replace `temp_str' = subinstr(`temp_str', "ì", "i", .)
    replace `temp_str' = subinstr(`temp_str', "ò", "o", .)
    replace `temp_str' = subinstr(`temp_str', "ù", "u", .)
    replace `temp_str' = subinstr(`temp_str', "'", "'", .)  // Apostrofo
    
    // Rimuovi char strani (solo lettere/spazi)
    replace `temp_str' = regexr(`temp_str', "[^a-z ]", "")
    
    // Trim spazi multipli
    replace `temp_str' = trim(itrim(`temp_str'))
    
    // Sovrascrivi
    drop `varname'
    rename `temp_str' `varname'
    recast str30 `varname', force
    
    // Conta cambiamenti
    count if `orig' != `varname'
    display "Cambiati: " r(N) " su " _N
    
    drop `orig'
end

save "coesione_14_20.dta", replace

use "coesione_14_20.dta", clear
standardizza_comune den_comune

save "coesione_14_20.dta", replace

/// ============================================================================
/// IMPORT PREVIOUS PROJECTS  ==================================================

import delimited "progetti_07_13", clear

/// DATA CLEANING
/// ============================================================================

/// Drop Group 1: Identifiers and textual descriptions
drop descrizione_grande_progetto cod_ateco descrizione_ateco oc_cod_tipo_aiuto
drop oc_descr_tipo_aiuto oc_cod_sll oc_denominazione_sll oc_sintesi_progetto oc_descr_ciclo
drop cod_locale_progetto oc_titolo_progetto cup oc_link cod_grande_progetto
drop oc_codfisc_programmatore oc_codfisc_attuatore oc_codfisc_beneficiario
drop oc_codfisc_realizzatore

/// Drop Group 2: Project phases and metadata
drop oc_cod_fase_corrente oc_descr_fase_corrente oc_flag_cup oc_flag_pac
drop oc_flag_regione_unica oc_flag_visualizzazione data_aggiornamento

/// Drop Group 3: Scopes and programming
drop oc_cod_ciclo oc_cod_fonte oc_descr_fonte oc_codice_programma oc_descrizione_programma
drop oc_articolazione_programma oc_cod_articolaz_programma oc_descr_articolaz_programma
drop oc_subarticolazione_programma oc_descr_subarticolaz_programma oc_cod_subarticolaz_programma 
drop cod_strumento descr_strumento descr_tipo_strumento cod_proced_attivazione
drop descr_proced_attivazione cod_tipo_proced_attivazione 
drop oc_descr_categoria_spesa oc_cod_categoria_spesa 

/// Drop Group 4: Aggregate payments
drop descr_tipo_proced_attivazione oc_tot_pagamenti_rendicontab_ue oc_tot_pagamenti_fsc
drop oc_tot_pagamenti_pac costo_rendicontabile_ue 

/// Drop Group 5: Multiple dates
drop data_inizio_prev_studio_fatt data_fine_prev_studio_fatt data_inizio_eff_studio_fatt 
drop data_fine_eff_studio_fatt data_inizio_prev_prog_prel data_fine_prev_prog_prel 
drop data_inizio_eff_prog_prel data_fine_eff_prog_prel data_inizio_prev_prog_def 
drop data_fine_prev_prog_def data_inizio_eff_prog_def data_fine_eff_prog_def 
drop data_inizio_prev_prog_esec data_fine_prev_prog_esec data_inizio_eff_prog_esec 
drop data_fine_eff_prog_esec data_inizio_prev_agg_bando data_fine_prev_agg_bando 
drop data_inizio_eff_agg_bando data_fine_eff_agg_bando data_inizio_prev_stip_attrib 
drop data_fine_prev_stip_attrib data_inizio_eff_stip_attrib  data_fine_eff_stip_attrib 
drop data_inizio_prev_esecuzione data_fine_prev_esecuzione data_inizio_eff_esecuzione 
drop data_fine_eff_esecuzione data_inizio_prev_collaudo data_fine_prev_collaudo 
drop data_inizio_eff_collaudo data_fine_eff_collaudo

/// Drop Group 6: Indicators
drop cod_indicatore_1 cod_indicatore_2 cod_indicatore_3 cod_indicatore_4
drop descr_indicatore_1 descr_indicatore_2 descr_indicatore_3 descr_indicatore_4
drop unita_misura_indicatore_1 unita_misura_indicatore_2 unita_misura_indicatore_3 unita_misura_indicatore_4
drop programmato_indicatore_1 programmato_indicatore_2 programmato_indicatore_3 programmato_indicatore_4
drop realizzato_indicatore_1 realizzato_indicatore_2 realizzato_indicatore_3 realizzato_indicatore_4

/// Drop Group 7: Totals
drop oc_totale_beneficiari oc_totale_programmatori oc_totale_attuatori
drop oc_totale_realizzatori oc_totale_indicatori

/// Drop Group 8: Denominations
drop oc_denom_programmatore oc_cod_forma_giu_programmatore oc_descr_forma_giu_programmatore
drop oc_denom_attuatore oc_cod_forma_giu_attuatore oc_descr_forma_giu_attuatore
drop oc_denom_beneficiario oc_cod_forma_giu_beneficiario oc_descr_forma_giu_beneficiario
drop oc_denom_realizzatore oc_cod_forma_giu_realizzatore oc_descr_forma_giu_realizzatore

// Drop Group 9: Funding type
drop fondo_comunitario
drop finanz_ue finanz_ue_fse finanz_ue_fesr finanz_ue_feasr finanz_ue_feamp 
drop finanz_ue_iog finanz_stato_fondo_di_rotazione finanz_stato_fsc finanz_stato_pac
drop finanz_stato_completamenti finanz_stato_altri_provvedimenti finanz_regione 
drop finanz_provincia finanz_comune finanz_risorse_liberate finanz_altro_pubblico 
drop oc_finanz_ue_netto oc_finanz_ue_fse_netto oc_finanz_ue_fesr_netto 
drop oc_finanz_ue_feasr_netto oc_finanz_ue_feamp_netto oc_finanz_ue_iog_netto 
drop oc_finanz_stato_fondo_rot_netto oc_finanz_stato_fsc oc_finanz_stato_pac_netto 
drop oc_finanz_stato_compl_netto oc_finanz_stato_altri_prov_netto 
drop oc_finanz_regione_netto oc_finanz_provincia_netto oc_finanz_comune_netto 
drop oc_finanz_risorse_liberate_netto oc_finanz_altro_pubblico_netto

drop finanz_stato_estero finanz_privato finanz_da_reperire 
drop economie_totali economie_totali_pubbliche
drop oc_finanz_stato_estero_netto oc_finanz_privato_netto
drop impegni oc_impegni_giurid_vincolanti oc_impegni_trasferimenti
drop oc_impegni_coesione oc_tot_pagamenti_beneficiari
drop tot_pagamenti oc_tot_pagamenti_trasferimenti oc_pagamenti_coesione

drop oc_finanz_tot_pub_netto oc_costo_coesione finanz_ue_altro oc_finanz_ue_altro_netto

// Drop Group 10: Funding status
drop oc_stato_finanziario oc_stato_progetto oc_stato_procedurale

// Drop group 11: Classification
drop cod_ob_tematico descr_ob_tematico cod_priorita_invest descr_priorita_invest
drop cup_cod_natura cup_descr_natura cup_cod_tipologia cup_descr_tipologia
drop cup_cod_settore cup_descr_settore cup_cod_sottosettore cup_descr_sottosettore
drop cup_cod_categoria cup_descr_categoria

// Drop useless dates
drop oc_data_inizio_progetto
drop oc_data_fine_progetto_prevista

/// ============================================================================

// Create year variable
replace oc_data_fine_progetto_effettiva = floor(oc_data_fine_progetto_effettiva/10000)
rename oc_data_fine_progetto_effettiva anno_fine

// We eliminate projects affecting multiple municipalities, following the methodology used by SOSE
// 14,827
drop if regexm(den_comune, ":::")

// We eliminate projects not directed at municipalities
// 44,744
drop if den_comune == ""

// We drop multi-province/region projects
// 88
drop if regexm(den_provincia, ":::")
drop if regexm(den_regione, ":::")
drop if regexm(den_regione, "NAZIONALE")
drop if den_regione == ""
drop if den_provincia == ""

// Drop projects abroad (irrelevant)
// 0
drop if oc_macroarea == "Estero"

// Destring amount variables
foreach costvar in costo_realizzato finanz_totale_pubblico  {
    capture confirm variable `costvar'
    if !_rc {
        di "  Converting `costvar'..."
        
        // Remove any spaces, commas, € symbols
        replace `costvar' = trim(`costvar')
        replace `costvar' = subinstr(`costvar', "€", "", .)
        replace `costvar' = subinstr(`costvar', ",", ".", .)
        replace `costvar' = subinstr(`costvar', " ", "", .)
        
        // Convert to numeric
        destring `costvar', replace force
        
        // Check
        summarize `costvar', detail
        di ""
    }
}


// Generate completion percentage variable
gen settlment_ratio = (costo_realizzato/finanz_totale_pubblico)*100

// Drop if realization < 90%
// 27,954
drop if settlment_ratio < 90

// Drop result = 87,683/946,488 | -9% of the starting dataset


// OC THEMES
* 1: Research and innovation
* 2: Digital networks and services
* 3: Business competitiveness
* 4: Energy
* 5: Environment
* 6: Culture and tourism
* 7: Transport and mobility
* 8: Employment and labor
* 9: Social inclusion and health
* 11: Education and training
* 13: Administrative capacity

// Drop unnecessary themes
keep if inlist(oc_cod_tema_sintetico, 2, 7, 8, 9, 11, 13)

// Deleted: 56,965, aggregate: 144,648/946,488 | -15% of the starting dataset

rename anno_fine anno

// We eliminate unfinished projects
// 24,651
drop if anno == .
		 
replace den_regione = lower(den_regione)
replace den_provincia = lower(den_provincia)
replace den_comune = lower(den_comune)
replace oc_macroarea = lower(oc_macroarea)
replace oc_tema_sintetico = lower(oc_tema_sintetico)

rename oc_macroarea macroarea

* Collapse to municipal level first
* This aggregates all projects within each municipality-year
collapse (sum) importo = finanz_totale_pubblico ///
         (count) n_progetti = finanz_totale_pubblico ///
         (mean) media_progetto = finanz_totale_pubblico ///
		 (first) den_regione den_provincia macroarea, ///
         by(den_comune cod_comune oc_tema_sintetico oc_cod_tema_sintetico anno)

* Label variables
label var importo "Total OC spending (€)"
label var n_progetti "Number of OC projects"
label var media_progetto "Average project size (€)"

recast str30 den_provincia, force
recast str30 den_regione, force
recast str30 den_comune, force

replace den_provincia = "forli-cesena" if regexm(den_provincia, "cesena")

capture program drop standardizza_comune
program define standardizza_comune

    syntax varlist(max=1)  // Es: den_comune
	local varname `varlist'
    
    tempvar temp_str orig
    
    gen `orig' = `varname'
    
    // Minuscolo
    gen `temp_str' = lower(`varname')
    
    // Sostituzioni accenti/apostrofi (semplice e veloce)
    replace `temp_str' = subinstr(`temp_str', "à", "a", .)
    replace `temp_str' = subinstr(`temp_str', "è", "e", .)
    replace `temp_str' = subinstr(`temp_str', "é", "e", .)
    replace `temp_str' = subinstr(`temp_str', "ì", "i", .)
    replace `temp_str' = subinstr(`temp_str', "ò", "o", .)
    replace `temp_str' = subinstr(`temp_str', "ù", "u", .)
    replace `temp_str' = subinstr(`temp_str', "'", "'", .)  // Apostrofo
    
    // Rimuovi char strani (solo lettere/spazi)
    replace `temp_str' = regexr(`temp_str', "[^a-z ]", "")
    
    // Trim spazi multipli
    replace `temp_str' = trim(itrim(`temp_str'))
    
    // Sovrascrivi
    drop `varname'
    rename `temp_str' `varname'
    recast str30 `varname', force
    
    // Conta cambiamenti
    count if `orig' != `varname'
    display "Cambiati: " r(N) " su " _N
    
    drop `orig'
end

save "coesione_07_13.dta", replace

use "coesione_07_13.dta", clear
standardizza_comune den_comune

save "coesione_07_13.dta", replace

/// ============================================================================
use "coesione_07_13.dta", clear

append using "coesione_14_20"

* Reaggregate
collapse (sum) importo n_progetti ///
         (mean) media_progetto = importo ///
		 (first) den_regione den_provincia macroarea, ///
         by(den_comune cod_comune oc_tema_sintetico oc_cod_tema_sintetico anno)
		 
drop if den_comune == ""

keep if anno > 2000 & anno < 2025

replace den_regione = trim(itrim(den_regione))

drop if regexm(den_regione,"europ")

save "coesione_total.dta", replace

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

merge 1:m anno den_provincia using coesione_total.dta

drop if den_provincia == "olbia-tempio" | den_provincia == "ogliastra" | ///
		den_provincia == "carbonia-iglesias" | den_provincia == "medio campidano"
drop if _merge == 1
drop _merge

sort anno den_comune

save "coesione_total.dta", replace

/// ============================================================================

import delimited "pop_density.csv", clear

gen den_provincia = lower(substr(geogeopoliticalentityreporting, 8, .))


drop structure structure_id freqtimefrequency unitunitofmeasure ///
obs_flagobservationstatusflagv2s conf_statusconfidentialitystatus ///
geogeopoliticalentityreporting
 
rename time_period anno
rename obs_value pop_density

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

merge 1:m anno den_provincia using coesione_total.dta

drop if den_provincia == "olbia-tempio" | den_provincia == "ogliastra" | ///
		den_provincia == "carbonia-iglesias" | den_provincia == "medio campidano"
drop if _merge == 1
drop _merge

sort anno den_comune

save "coesione_total.dta", replace

/// ============================================================================

import delimited "regional_gdp.csv", clear

drop structure structure_id structure_name freq timefrequency unit ///
unitofmeasure geo time observationvalue obs_flag observationstatusflagv2s ///
conf_status confidentialitystatus

rename time_period anno
rename geopoliticalentityreporting den_regione

gen gdp = obs_value*1000000
drop obs_value

format gdp %20.0f

replace den_regione = lower(den_regione)

replace den_regione = "valle d'aosta" if regexm(den_regione,"valle")
replace den_regione = "trentino-alto adige" if regexm(den_regione,"bolzano") | regexm(den_regione,"trento")

collapse (sum) gdp, by (anno den_regione)

replace den_regione = trim(itrim(den_regione))

merge 1:m anno den_regione using coesione_total.dta

drop if _merge == 1
drop _merge

bysort anno den_regione: gen gdp_pc = gdp/popolazione

save "coesione_total.dta", replace


dd

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


import delimited "laureati", clear

drop freq frequenza region_of_study data_type indicatore tipoateneo sex sesso ///
type_degree_course tipologiadicorsodilaurea field_study gruppodiclassidilaurea  ///
obs_status statodellosservazione type_univ_management

gen den_regione = lower(regionedellasededidattica)
drop regionedellasededidattica

drop if regexm(den_regione,"bolzano")|regexm(den_regione,"trento")

replace den_regione = "trentino-alto adige" if regexm(den_regione,"trentino")
replace den_regione = "valle d'aosta" if regexm(den_regione,"valle")

rename time_period anno

merge 1:m anno den_regione using coesione_14_20.dta

bys anno: tab _merge

rename osservazione ist_laureati

drop _merge

sort den_provincia anno

save "coesione_14_20.dta", replace
