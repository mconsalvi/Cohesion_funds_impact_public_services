********************************************************************************
*** IMPATTO DELEL POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
********************************************************************************
* Author: Matteo Consalvi
* Project: Impact evaluation of cohesion policies on publci services quality
* do-file: intro
* Created: 07/07/2025
* Last Modified: 07/07/2025
* Each section title is indicated with "***"
* Comments are indicated with "*", intra-formula comments with "//"

* Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
*log using "data_analysis_log.txt", replace  

********************************************************************************
*** IMPORT AND CLEAN DATA
********************************************************************************
cd "C:\Users\matteo.consalvi\OneDrive - CNEL\Desktop\COHESION_POLICIES_IMPACT"

import delimited "progetti_14-20", clear

describe

drop cod_locale_progetto oc_titolo_progetto cup oc_link cod_grande_progetto ///
descrizione_grande_progetto cod_ateco descrizione_ateco oc_cod_tipo_aiuto ///
oc_descr_tipo_aiuto oc_cod_sll oc_denominazione_sll

drop oc_sintesi_progetto oc_descr_ciclo

drop oc_cod_fase_corrente oc_descr_fase_corrente oc_flag_cup oc_flag_pac ///
oc_flag_regione_unica oc_flag_visualizzazione data_aggiornamento

drop oc_ambito oc_descr_fonte oc_codice_programma oc_descrizione_programma ///
oc_articolazione_programma oc_cod_articolaz_programma oc_descr_articolaz_programma ///
oc_subarticolazione_programma oc_descr_subarticolaz_programma oc_cod_subarticolaz_programma 

drop descr_tipo_proced_attivazione oc_tot_pagamenti_rendicontab_ue oc_tot_pagamenti_fsc ///
oc_tot_pagamenti_pac costo_rendicontabile_ue 

drop data_inizio_prev_studio_fatt data_fine_prev_studio_fatt data_inizio_eff_studio_fatt ///
data_fine_eff_studio_fatt data_inizio_prev_prog_prel data_fine_prev_prog_prel ///
data_inizio_eff_prog_prel data_fine_eff_prog_prel data_inizio_prev_prog_def ///
data_fine_prev_prog_def data_inizio_eff_prog_def data_fine_eff_prog_def ///
data_inizio_prev_prog_esec data_fine_prev_prog_esec data_inizio_eff_prog_esec ///
data_fine_eff_prog_esec data_inizio_prev_agg_bando data_fine_prev_agg_bando ///
data_inizio_eff_agg_bando data_fine_eff_agg_bando data_inizio_prev_stip_attrib ///
data_fine_prev_stip_attrib data_inizio_eff_stip_attrib  data_fine_eff_stip_attrib ///
data_inizio_prev_esecuzione data_fine_prev_esecuzione data_inizio_eff_esecuzione ///
data_fine_eff_esecuzione data_inizio_prev_collaudo data_fine_prev_collaudo ///
data_inizio_eff_collaudo data_fine_eff_collaudo

drop cod_strumento descr_strumento descr_tipo_strumento cod_proced_attivazione ///
descr_proced_attivazione cod_tipo_proced_attivazione 

drop oc_codfisc_programmatore oc_codfisc_attuatore oc_codfisc_beneficiario ///
oc_codfisc_realizzatore

drop cod_indicatore_1 cod_indicatore_2 cod_indicatore_3 cod_indicatore_4 ///
descr_indicatore_1 descr_indicatore_2 descr_indicatore_3 descr_indicatore_4 ///
unita_misura_indicatore_1 unita_misura_indicatore_2 unita_misura_indicatore_3 ///
unita_misura_indicatore_4 programmato_indicatore_1 programmato_indicatore_2 ///
programmato_indicatore_3 programmato_indicatore_4 realizzato_indicatore_1 ///
realizzato_indicatore_2 realizzato_indicatore_3 realizzato_indicatore_4

drop oc_totale_beneficiari oc_totale_programmatori oc_totale_attuatori ///
oc_totale_programmatori oc_totale_realizzatori oc_totale_indicatori

drop if oc_macroarea == "Estero"

save "progetti_coesione_14-20_clean", replace

use "progetti_coesione_14-20_clean.dta ", clear
