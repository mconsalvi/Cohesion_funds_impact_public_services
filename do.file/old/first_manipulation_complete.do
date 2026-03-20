********************************************************************************
*** IMPATTO DELLE POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
********************************************************************************
* Author: Matteo Consalvi
* Project: Impact evaluation of cohesion policies on public services quality
* do-file: clean merged dataset
* Created: 10/07/2025
* Last Modified: 24/08/2025
* Each section title is indicated with "***"
* Comments are indicated with "*", intra-formula comments with "//"

* Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
*log using "data_analysis_log.txt", replace 

********************************************************************************
*** LOAD AND CLEAN MERGED DATASET
********************************************************************************

use "dataset_final", clear

* destring numeric variables for better handling

foreach var of varlist finanz_ue finanz_ue_fse finanz_ue_fesr finanz_ue_feasr ///
finanz_ue_feamp finanz_ue_iog finanz_stato_fondo_di_rotazione ///
 finanz_stato_fsc finanz_stato_pac finanz_stato_completamenti ///
 finanz_stato_altri_provvedimenti finanz_regione finanz_provincia finanz_comune ///
 finanz_risorse_liberate finanz_altro_pubblico finanz_stato_estero finanz_privato ///
 finanz_da_reperire finanz_totale_pubblico {
    replace `var' = subinstr(`var', ",", ".", .)
    destring `var', replace
}

foreach var of varlist economie_totali economie_totali_pubbliche {
    replace `var' = subinstr(`var', ",", ".", .)
    destring `var', replace
}

foreach var of varlist oc_finanz_ue_netto oc_finanz_ue_fse_netto oc_finanz_ue_fesr_netto ///
 oc_finanz_ue_feasr_netto oc_finanz_ue_feamp_netto oc_finanz_ue_iog_netto ///
 oc_finanz_stato_fondo_rot_netto oc_finanz_stato_fsc oc_finanz_stato_pac_netto ///
 oc_finanz_stato_compl_netto oc_finanz_stato_altri_prov_netto ///
 oc_finanz_regione_netto oc_finanz_provincia_netto oc_finanz_comune_netto ///
 oc_finanz_risorse_liberate_netto oc_finanz_altro_pubblico_netto ///
 oc_finanz_stato_estero_netto oc_finanz_privato_netto oc_finanz_tot_pub_netto {
    replace `var' = subinstr(`var', ",", ".", .)
    destring `var', replace
}

foreach var of varlist oc_costo_coesione impegni oc_impegni_giurid_vincolanti ///
 oc_impegni_trasferimenti oc_impegni_coesione tot_pagamenti oc_tot_pagamenti_trasferimenti ///
 oc_pagamenti_coesione costo_realizzato oc_tot_pagamenti_beneficiari {
    replace `var' = subinstr(`var', ",", ".", .)
    destring `var', replace
}

* drop duplicates or useless variables

drop oc_macroarea oc_costo_coesione impegni oc_impegni_giurid_vincolanti ///
 oc_impegni_trasferimenti oc_impegni_coesione tot_pagamenti oc_tot_pagamenti_trasferimenti ///
 oc_pagamenti_coesione costo_realizzato oc_tot_pagamenti_beneficiari
 
drop oc_stato_finanziario oc_stato_procedurale oc_stato_progetto

drop economie_totali economie_totali_pubbliche
 

********************************************************************************
*** SAVE AND USE FINAL DATASET #2
********************************************************************************
 
save "dataset_final2", replace

use "dataset_final2", clear

*drop finanz_ue finanz_ue_fse finanz_ue_fesr finanz_ue_feasr ///
finanz_ue_feamp finanz_ue_iog finanz_stato_fondo_di_rotazione ///
 finanz_stato_fsc finanz_stato_pac finanz_stato_completamenti ///
 finanz_stato_altri_provvedimenti finanz_regione finanz_provincia finanz_comune ///
 finanz_risorse_liberate finanz_altro_pubblico oc_finanz_ue_netto /// 
 oc_finanz_ue_fse_netto oc_finanz_ue_fesr_netto ///
 oc_finanz_ue_feasr_netto oc_finanz_ue_feamp_netto oc_finanz_ue_iog_netto ///
 oc_finanz_stato_fondo_rot_netto oc_finanz_stato_fsc oc_finanz_stato_pac_netto ///
 oc_finanz_stato_compl_netto oc_finanz_stato_altri_prov_netto ///
 oc_finanz_regione_netto oc_finanz_provincia_netto oc_finanz_comune_netto ///
 oc_finanz_risorse_liberate_netto oc_finanz_altro_pubblico_netto


drop oc_descr_categoria_spesa oc_cod_categoria_spesa descr_priorita_invest cod_priorita_invest descr_ob_tematico cod_ob_tematico
 
* Create three dummy variables for OpenCoesione project data
 
* Assuming your date variables are: oc_data_inizio_progetto, oc_data_fine_progetto_prevista, oc_data_fine_progetto_effettiva


* Dummy 1: Expected end date was respected (actual <= expected)
* Only for completed projects (where actual date is not missing)
gen deadline_respected = .

replace deadline_respected = 1 if oc_data_fine_progetto_effettiva <= oc_data_fine_progetto_prevista

replace deadline_respected = 0 if oc_data_fine_progetto_effettiva > oc_data_fine_progetto_prevista | oc_data_fine_progetto_effettiva == .

* Dummy 2: Project completed before financing end date (actual <= 20201231)
* Only for completed projects
gen completed_before_cycle = .

replace completed_before_cycle = 1 if oc_data_fine_progetto_effettiva <= 20201231

replace completed_before_cycle = 0 if oc_data_fine_progetto_effettiva > 20201231 | oc_data_fine_progetto_effettiva == .

* Dummy 3: Project was completed (actual date exists)
gen project_completed = 1
replace project_completed = 0 if oc_data_fine_progetto_effettiva == .
 

* Aggregate OpenCoesione data by province and thematic variables
* Sum project financing variables, keep public service quality variables as they are

drop oc_data_inizio_progetto oc_data_fine_progetto_prevista oc_data_fine_progetto_effettiva

// Remove value labels from the variables
foreach var of varlist _all {
    label variable `var' ""
}

describe
		

collapse (sum) finanz_ue finanz_ue_fse finanz_ue_fesr finanz_ue_feasr finanz_ue_feamp finanz_ue_iog finanz_stato_fondo_di_rotazione finanz_stato_fsc finanz_stato_pac finanz_stato_completamenti finanz_stato_altri_provvedimenti finanz_regione finanz_provincia finanz_comune finanz_risorse_liberate finanz_altro_pubblico finanz_stato_estero finanz_privato finanz_da_reperire finanz_totale_pubblico oc_finanz_ue_netto oc_finanz_ue_fse_netto oc_finanz_ue_fesr_netto oc_finanz_ue_feasr_netto oc_finanz_ue_feamp_netto oc_finanz_ue_iog_netto oc_finanz_stato_fondo_rot_netto oc_finanz_stato_fsc oc_finanz_stato_pac_netto oc_finanz_stato_compl_netto oc_finanz_stato_altri_prov_netto oc_finanz_regione_netto oc_finanz_provincia_netto oc_finanz_comune_netto oc_finanz_risorse_liberate_netto oc_finanz_altro_pubblico_netto oc_finanz_stato_estero_netto oc_finanz_privato_netto oc_finanz_tot_pub_netto deadline_respected completed_before_cycle project_completed ///
         (mean) build_total descr_nv_spesa ed_nursery_number ed_total_students high_spend_high_serv housing_inhab_per_house labor_cost_roads low_serv mun_context_waste nv_serv performance_serv pop_density raccolta_diff spend_serv std_spend_tot waste_disposal_distance armed_police commuters_net ed_full_time_classes ed_private_students ed_transport_students ed_transport_handicap_students high_spend housing_used labor_cost_territory mun_roads_km nv_serv_per_function performance_serv_avg_pc pop_foreign scale_diseconomies ss_hours tot_buildings waste_infrastructure_level ass_mananagement_waste complaint_reports ed_handicap_students ed_school_area high_spend_low_serv labor_cost_admin level_services_territory low_spend_high_serv mun_surface nv_spend_per_function pop_15_64 pop_landslide_risk se_deprivation ss_structures tourist_tot waste_manag_type avg_labour_cost_pc cost_cars ed_handicap_students_mun_ic ed_school_numb high_seismic_risk_k hospitality_employee labor_cost_education level_total_services low_spend_low_serv mun_workforce_pth nv_spend pop_3_14 pop_over_75 spend_pc_hist ss_users traffic_accidents waste_tons_produced avg_labour_cost_pw descr_nv_servizi ed_meals_provided ed_summer_courses high_serv housing_avbailable labor_cost_police level_total_spending mkt_days nv_both paid_parking pop_65_74 population spend_tot_hist std_spend_pc violent_crimes, ///
		 by(den_provincia oc_cod_tema_sintetico oc_tema_sintetico cup_cod_natura cup_descr_natura  macroarea cod_macroarea cod_regione den_regione sigla_provincia)
         

