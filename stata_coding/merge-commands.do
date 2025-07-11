********************************************************************************
*** IMPATTO DELEL POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
********************************************************************************
* Author: Matteo Consalvi
* Project: Impact evaluation of cohesion policies on publci services quality
* do-file: quality indicators
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

import excel "Codici-statistici-e-denominazioni-al-01_01_2025.xlsx", firstrow clear

gen Code = upper(Siglaautomobilistica) + ProgressivodelComune2

save "ISTAT_codes.dta", replace

import delimited "2022_Ind_FC80TOT_1", varnames(1) clear

describe

codebook

gen Code = substr(username, 1, 5)

save "quality_ind.dta", replace

use "ISTAT_codes", clear

merge 1:m Code using "quality_ind.dta"

list Code if _merge == 2

gen sigla_provincia = substr(Code, 1, 2)

sort Code

drop if _merge == 1

save "services_quality_data.dta", replace

replace nome_provincia = "Ascoli Piceno" if sigla_provincia == "AP"
replace nome_provincia = "Roma" if sigla_provincia == "RM"
replace nome_provincia = "Milano" if sigla_provincia == "MI"

