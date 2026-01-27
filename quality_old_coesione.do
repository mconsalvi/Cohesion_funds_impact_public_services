/* ============================================================================
*** IMPATTO DELLE POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
=============================================================================*/

// Author: Matteo Consalvi
// Project: Impact evaluation of cohesion policies on public services quality
// do-file: publice services quality index merging
// Created: 28/11/2025
// Last Modified: 28/11/2025
// Each section title is indicated with "///"
// Comments are indicated with "*" or with "//"

// Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
log using "log.txt", text replace  

/* ============================================================================
*** IMPORTA DATASET QUALITÀ DEI SERVIZI E MERGE
=============================================================================*/

import delimited "qualita_dei_servizi", clear

browse

tab indicatore

ds

drop freq domain sex v17 v21 v25 v29 v33 frequenza dominio sesso v18 v22 v26 v30 ///
v34 ref_area data_type edition obs_status v19 v23 v27 v31 v35 edizione statodello~r v20 v28 v36 v37 v32 v24

* 1. Clean variable names to make them valid (remove spaces, special chars)
* Alternatively, you can create a short code for each.
replace indicatore = subinstr(indicatore, " ", "_", .)
replace indicatore = subinstr(indicatore, "-", "_", .)
keep if indicatore != "" 

replace indicatore = "internet_veloce" if indicatore == "Copertura_della_rete_fissa_di_accesso_ultra_veloce_a_internet"
replace indicatore = "posti_letto" if indicatore == "Posti_letto_per_specialità_ad_elevata_assistenza"
replace indicatore = "differenziata" if indicatore == "Servizio_di_raccolta_differenziata_dei_rifiuti_urbani"
replace indicatore = "irreg_servizio_el" if indicatore == "Irregolarità_del_servizio_elettrico"
replace indicatore = "emigr_ospedaliera" if indicatore == "Emigrazione_ospedaliera_in_altra_regione"
replace indicatore = "tpl_km" if indicatore == "Posti_km_offerti_dal_Tpl"
replace indicatore = "medici_spec" if indicatore == "Medici_specialisti"
replace indicatore = "posti_letto_osp" if indicatore == "12SER003P_N25"

* 2. Reshape from Long to Wide
* i = unique identifiers (Province + Year)
* j = the column that contains the new variable names
* string = tells Stata that 'indicatore' is text, not a number
reshape wide osservazione, i(territorio time_period) j(indicatore) string

* Now you will have variables like: osservazioneIrregolarità_del..., osservazionePosti_km...
* You can rename them later if they are too long.

* 3. Standardize Keys for Merging
* Rename variables to match Dataset 1
rename time_period anno
rename territorio den_provincia

replace den_provincia = "Bolzano" if den_provincia == "Bolzano / Bozen"
replace den_provincia = "Aosta" if strpos(den_provincia, "Vall") > 0

* CRITICAL: Fix Case Sensitivity
* Dataset 1 (Image 1) has "TORINO" (Uppercase).
* Dataset 2 (Image 2) has "Torino" (Title case).
* We must make them identical.
replace den_provincia = upper(den_provincia)
replace den_provincia = "FORLI'-CESENA" if den_provincia == "FORLì-CESENA"

rename osservazi~ta differenziata
rename osservazioneemigr_ospedaliera emigr_ospedaliera
rename osservazio~e internet_veloce
rename osservazio~l irreg_servizio_el
rename osservazio~c medici_spec
rename osservazio~o posti_letto_elev
rename osservazio~p posti_letto_osp
rename osservazio~m tpl_km

recast str50 den_provincia

destring anno, replace

* Save the temporary prepared file
save "quality_wide_ready.dta", replace

merge 1:m anno den_provincia using progetti_coesione_clean.dta


/* ============================================================================
*** CHECK MISSING VALUES DYNAMICS
=============================================================================*/

// Identify the two missing provinces
list den_provincia if _merge == 2
tab den_provincia if _merge == 2

// Check structure of matched data
unique den_provincia if _merge == 3
unique anno if _merge == 3

keep if _merge == 3

drop _merge

// Step 1: Overall picture
describe
misstable summarize

// Step 2: Count how many indicators are present per observation
egen n_indicators = rownonmiss(differenziata emigr_ospedaliera irreg_servizio_el ///
	internet_veloce medici_spec posti_letto_elev posti_letto_osp tpl_km)
tab n_indicators

// Step 3: Get province-year level summary 
preserve

// First, create the rownonmiss variable using egen
egen n_indicators_obs = rownonmiss(differenziata emigr_ospedaliera irreg_servizio_el ///
	internet_veloce medici_spec posti_letto_elev posti_letto_osp tpl_km)

// Create flag for complete observations
generate complete_py = (n_indicators_obs == 8)

// Now count complete observations per province-year using egen
bysort den_provincia anno: egen n_complete = total(complete_py)
bysort den_provincia anno: egen n_total = count(den_provincia)  // Count observations per group

// Get unique province-year combinations
duplicates drop den_provincia anno, force

// Calculate percentage complete
generate pct_complete = (n_complete / n_total) * 100

// Sort for inspection
sort den_provincia anno

// View all problematic province-years
list den_provincia anno n_complete n_total pct_complete if pct_complete < 100, sepby(den_provincia)

// Export for detailed analysis
export delimited den_provincia anno n_complete n_total pct_complete using "missing_map.csv", replace

// Summary statistics
display "========================================="
display "MISSINGNESS SUMMARY"
display "========================================="
count if pct_complete == 100
display "Province-years with complete data: " r(N)

count if pct_complete < 100 & pct_complete > 0
display "Province-years with partial data: " r(N)

count if pct_complete == 0
display "Province-years with NO data: " r(N)

restore

/* ============================================================================
*** CHECK MISSING PROVINCES
=============================================================================*/

// Create a dataset of provinces with their missingness patterns
preserve

// For each province-year-indicator combination, check if missing
local indicators differenziata emigr_ospedaliera irreg_servizio_el ///
	internet_veloce medici_spec posti_letto_elev posti_letto_osp tpl_km

foreach indicator of local indicators {
	generate missing_`indicator' = missing(`indicator')
}

// Create a flag for each observation showing which indicators are missing
generate missing_indicators_list = ""
foreach indicator of local indicators {
	replace missing_indicators_list = missing_indicators_list + "`indicator' " if missing(`indicator')
}

// Get province-year summary
bysort den_provincia anno: generate n_missing_py = ///
	missing_differenziata + missing_emigr_ospedaliera + missing_irreg_servizio_el + ///
	missing_internet_veloce + missing_medici_spec + missing_posti_letto_elev + ///
	missing_posti_letto_osp + missing_tpl_km

// Identify provinces with ANY missing data for that year
bysort den_provincia anno: generate any_missing_py = (n_missing_py > 0)

// Get unique province-years with missing data
duplicates drop den_provincia anno if any_missing_py == 1, force

// Now we have all province-years with missing data
list den_provincia anno n_missing_py if any_missing_py == 1, sepby(den_provincia)

// Export this list for reference
export delimited den_provincia anno n_missing_py using "provinces_with_missing.csv", replace

restore

drop if anno == 2024

drop if anno == 2023

preserve
// See which indicators are missing in each year
local indicators differenziata emigr_ospedaliera irreg_servizio_el ///
	internet_veloce medici_spec posti_letto_elev posti_letto_osp tpl_km

foreach indicator of local indicators {
	generate missing_`indicator' = missing(`indicator')
}

// Collapse to show missing counts by year-indicator
collapse (sum) missing_differenziata missing_emigr_ospedaliera ///
	missing_irreg_servizio_el missing_internet_veloce missing_medici_spec ///
	missing_posti_letto_elev missing_posti_letto_osp missing_tpl_km, by(anno)

list anno missing_*
export delimited using "missing_by_year_detailed.csv", replace
restore

log close

save coesione_qualita.dta, replace


