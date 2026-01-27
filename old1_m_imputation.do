* ============================================================================
*** IMPATTO DELLE POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
*=============================================================================*/

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
*log using "log.txt", text replace  

use "coesione_qualita.dta", clear

/* ============================================================================
*** IMPATTO DELLE POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
=============================================================================*/
* Create numeric version of province names
encode den_provincia, gen(prov)

collapse (sum) investimento n_progetti ///
         (mean) irreg_servizio_el medici_spec differenziata ///
         (mean) posti_letto_elev posti_letto_osp ///
         (mean) internet_veloce tpl_km ///
		 (mean) emigr_ospedaliera ///
         (first)den_provincia cod_provincia cod_regione den_regione, ///
         by(prov anno)

* Set panel
* xtset com anno

gen ln_investimento = ln(investimento)

save "coesione_collapsed_prov.dta", replace

summarize irreg_servizio_el medici_spec differenziata posti_letto_elev posti_letto_osp ///
 internet_veloce tpl_km emigr_ospedaliera

mi set mlong

* Register variables to impute
mi register imputed differenziata emigr_ospedaliera medici_spec ///
                      posti_letto_elev posti_letto_osp irreg_servizio_el ///
                      internet_veloce tpl_km

* IMPROVED: Use more stable imputation for bounded variables
mi impute chained ///
    (regress) differenziata emigr_ospedaliera medici_spec ///
              posti_letto_elev posti_letto_osp irreg_servizio_el tpl_km ///
    (pmm, knn(5)) internet_veloce ///
    = i.prov i.anno, ///
    add(20) burnin(20) rseed(12345) augment

mi xtset prov anno


* ============================================================================
* CHECK 1: Convergence Diagnostics
* ============================================================================

* Check all imputed variables at once
mi xeq: summarize differenziata emigr_ospedaliera medici_spec posti_letto_elev posti_letto_osp irreg_servizio_el internet_veloce tpl_km

* ============================================================================
* BOUNDING IMPUTED VALUES (Component Level)
* ============================================================================

* differenziata: 0-100 (percentage)
mi passive: gen diff_bounded = max(0, min(100, differenziata))

* emigr_ospedaliera: observed 1.8-33.5, set floor to 0 (could be zero emigration theoretically)
mi passive: gen emig_bounded = max(0, min(100, emigr_ospedaliera))

* medici_spec: observed 16.5-62.1, use observed range
mi passive: gen spec_bounded = max(16.5, min(62.1, medici_spec))

* posti_letto_elev: observed 0.1-9, use observed range
mi passive: gen elev_bounded = max(0.1, min(9, posti_letto_elev))

* posti_letto_osp: observed 14.2-61.6, use observed range
mi passive: gen osp_bounded = max(14.2, min(61.6, posti_letto_osp))

* irreg_servizio_el: observed 0.3-7.2, use observed range
mi passive: gen irreg_bounded = max(0.3, min(7.2, irreg_servizio_el))

* internet_veloce: 0-100 (percentage)
mi passive: gen inter_bounded = max(0, min(100, internet_veloce))

* tpl_km: observed 46-16827, use observed range
mi passive: gen tpl_bounded = max(46, min(16827, tpl_km))

mi register imputed diff_bounded emig_bounded spec_bounded ///
                  elev_bounded osp_bounded irreg_bounded inter_bounded tpl_bounded

* ============================================================================
* CHECK 2: Compare Distributions (Observed vs. Imputed)
* ============================================================================

mi xeq 0: summarize diff_bounded
mi xeq 1: summarize diff_bounded

mi xeq 0: summarize emig_bounded
mi xeq 1: summarize emig_bounded

mi xeq 0: summarize inter_bounded
mi xeq 1: summarize inter_bounded

mi xeq 0: summarize spec_bounded
mi xeq 1: summarize spec_bounded

mi xeq 0: summarize elev_bounded
mi xeq 1: summarize elev_bounded

mi xeq 0: summarize osp_bounded
mi xeq 1: summarize osp_bounded

mi xeq 0: summarize irreg_bounded
mi xeq 1: summarize irreg_bounded

mi xeq 0: summarize tpl_bounded
mi xeq 1: summarize tpl_bounded

mi xeq: summarize diff_bounded emig_bounded inter_bounded spec_bounded elev_bounded ///
osp_bounded irreg_bounded tpl_bounded

* ============================================================================
* CONSTRUCT COMPOSITE INDEX (From Bounded Imputed Components)
* ============================================================================

* Standardize each bounded component
mi passive: egen diff_z = std(diff_bounded)
mi passive: egen emig_z = std(emig_bounded)
mi passive: egen spec_z = std(spec_bounded)
mi passive: egen elev_z = std(elev_bounded)
mi passive: egen osp_z = std(osp_bounded)
mi passive: egen irreg_z = std(irreg_bounded)
mi passive: egen inter_z = std(inter_bounded)
mi passive: egen tpl_z = std(tpl_bounded)

* Create composite PSQ index (reverse code "bad" indicators)
* mi passive: gen psq_index = diff_z - emig_z + spec_z + elev_z + osp_z ///
- irreg_z + inter_z

mi passive: gen psq_index = spec_z + diff_z - irreg_z

* Standardize the composite index
mi passive: egen psq_index_std = std(psq_index)

mi register imputed psq_index_std

* ============================================================================
* VERIFY QUALITY
* ============================================================================

mi xeq: summarize psq_index_std

save "coesione_final_prov.dta", replace

* ============================================================================
* MAIN ECONOMETRIC MODELS
* ============================================================================

use "coesione_final_prov.dta", clear

* Model 1: Basic specification
mi estimate: xtreg psq_index_std ln_investimento, fe cluster(prov)

* Model 2: With project count
mi estimate: xtreg psq_index_std ln_investimento n_progetti, fe cluster(com)

* Model 3: Lagged effects
gen ln_inv_lag1 = L.ln_investimento
mi estimate: xtreg psq_index_std ln_inv_lag1, fe cluster(com)

* Model 4: Individual dimensions

mi estimate: xtreg spec_z ln_investimento i.anno, fe cluster(prov)
mi estimate: xtreg diff_z ln_investimento i.anno, fe cluster(prov)
mi estimate: xtreg inter_z ln_investimento i.anno, fe cluster(prov)
mi estimate: xtreg tpl_z ln_investimento i.anno, fe cluster(prov)
mi estimate: xtreg emig_z ln_investimento i.anno, fe cluster(prov)
mi estimate: xtreg elev_z ln_investimento i.anno, fe cluster(prov)
mi estimate: xtreg osp_z ln_investimento i.anno, fe cluster(prov)
mi estimate: xtreg irreg_z ln_investimento i.anno, fe cluster(prov)

mi xeq 0: corr ln_investimento diff_z emig_z spec_z elev_z osp_z irreg_z inter_z tpl_z


