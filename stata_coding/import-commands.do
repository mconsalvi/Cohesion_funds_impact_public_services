********************************************************************************
*** IMPACT EVALUATION OF COHESION POLICIES ON PUBLIC SERVICES QUALITY IN ITALY
********************************************************************************
* Author: Matteo Consalvi
* Project: Cohesion polices impact
* do-file: analysis
* Created: 16/06/2025
* Last Modified: 16/06/2025

* Set up Stata environment 
cd "C:\Users\matteo.consalvi\OneDrive - CNEL\Desktop\COHESION_POLICIES_IMPACT"
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
log using "data_analysis_log.txt", replace  

********************************************************************************
*** IMPORT AND CLEAN DATASET
********************************************************************************

import delimited "progetti_14-20", clear

describe
summarize
list
codebook