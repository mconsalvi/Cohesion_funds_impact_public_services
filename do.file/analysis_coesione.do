/// ============================================================================
/// IMPACT OF COHESION POLICIES ON QUALITY OF PUBLIC SERVICES
/// ============================================================================

// Author: Matteo Consalvi
// Project: Impact evaluation of cohesion policies on public services quality
// do-file: final merge and analysis
// Created: 07/01/2026
// Last Modified: 01/02/2026
// Each section title is indicated with "///"
// Comments are indicated with "*" or with "//"

// Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
* log using "log.txt", text replace  

/// ============================================================================
/// *** LOAD AND MERGE DATA
/// ============================================================================

// Load the cohesion policies dataset
use "coesione_total.dta", clear

// Merge with public services quality indicators at the province-year level
merge m:m anno den_comune using "clean_spesa.dta"

// Sort data by year and province for consistency
sort anno den_comune
bysort anno den_comune: gen dup = _N
tab dup

drop _merge

// Generate regional classification
gen classificazione = .

replace classificazione = 1 if den_regione == "basilicata" | den_regione == "calabria" | ///
den_regione == "campania" | den_regione == "puglia" | den_regione == "sicilia"

replace classificazione = 2 if  den_regione == "abruzzo" | den_regione == "molise" | ///
den_regione == "sardegna" |den_regione == "emilia-romagna" | den_regione == "friuli-venezia giulia" | ///
den_regione == "lazio" | den_regione == "liguria" | den_regione == "umbria" | den_regione == "marche" ///
| den_regione == "toscana" | den_regione == "piemonte" | den_regione == "lombardia" | ///
den_regione == "trentino-alto adige" | den_regione == "valle d'aosta" | den_regione == "veneto" 


drop if macroarea == "altro" | macroarea == "ambito nazionale"

// Save the merged dataset for subsequent analysis
save "final.dta", replace

/// ============================================================================
/// *** ANALYSIS
/// ============================================================================

// Load the final merged dataset
use "final.dta", clear

// Encode province and municipality names as numeric identifiers
// This is required for fixed effects estimation
encode den_provincia, gen(prov_id)
encode den_comune, gen(comune_id)
encode den_regione, gen(reg_id)
encode macroarea, gen(area_geo)

tabulate anno, summarize(importo)
tabulate anno, summarize(totale04)
tabulate anno, summarize(totale05)


// Per capita variables
bysort anno prov_id: gen oc_pc = importo/popolazione

bysort anno prov_id: gen spesa_pc05 = totale05/popolazione
bysort anno prov_id: gen spesa_pc04 = totale04/popolazione

* Baseline CORRETTA: importo cumulato pro-capite 2007-2013
* Prima si cumula l'importo totale (non pro-capite) per provincia nel periodo
bysort prov_id: egen importo_cum = total(importo) if inrange(anno, 2007, 2013)

* Poi si prende la popolazione di un anno di riferimento stabile (es. 2010)
bys prov_id: gen pop_ref = popolazione if anno==2010
bys prov_id: egen pop_baseline = max(pop_ref)

* Importo cumulato pro-capite
bys prov_id: gen oc_pc_baseline = importo_cum / pop_baseline
bys prov_id: egen oc_pc_baseline_fill = max(oc_pc_baseline)
drop oc_pc_baseline
rename oc_pc_baseline_fill oc_pc_baseline

* Percentili sulla distribuzione cumulata (un'osservazione per provincia)
_pctile oc_pc_baseline if anno==2010, p(40 60)

gen treated = .

replace treated = 1 if oc_pc_baseline >= r(r2) & !missing(oc_pc_baseline)
replace treated = 0 if oc_pc_baseline < r(r1) & !missing(oc_pc_baseline)

gen post = (anno >= 2015)
gen oc_post = oc_pc * post  // Interaction continua
gen treated_post = treated * post  // INTERAZIONE SINGOLA

tab treated if anno==2015
bys prov_id: egen treated_sd = sd(treated)
tab treated_sd

reghdfe spesa_pc04 treated_post c.gdp_pc c.pop_density i.area_geo, ///
    absorb(prov_id anno) vce(cluster prov_id)
est store baseline04

reghdfe spesa_pc05 treated_post c.gdp_pc c.pop_density i.area_geo, ///
    absorb(prov_id anno) vce(cluster prov_id)
est store baseline05


esttab baseline04 baseline05 ///
    using "baseline_did.tex", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    b(3) se(3) ///
    label nogaps ///
    keep(treated_post gdp_pc pop_density) ///
    order(treated_post gdp_pc pop_density) ///
    title("Baseline DiD: OC Intensity $\rightarrow$ Municipal Spending") ///
    mtitles("Spesa corrente pc" "Spesa capitale pc") ///
    alignment(D{.}{.}{-1}) ///
    addnotes("Errori standard clusterizzati a livello provinciale.", ///
             "Tutti i modelli includono effetti fissi di provincia e anno", ///
             "Dummies per macro-area geografica incluse ma non riportate.")


// Regression control

forval y = 2013/2015 {
    gen D`y' = (anno == `y') * treated
}

reghdfe spesa_pc04 D2013-D2015 c.gdp_pc c.pop_density i.area_geo, ///
    absorb(prov_id) vce(cluster prov_id)
est store pretrend04

reghdfe spesa_pc05 D2013-D2015 c.gdp_pc c.pop_density i.area_geo, ///
    absorb(prov_id) vce(cluster prov_id)
est store pretrend05

esttab pretrend04 pretrend05 ///
    using "pretrend.tex", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    b(3) se(3) ///
    label nogaps ///
    keep(D2013 D2014 D2015) ///
    order(D2013 D2014 D2015) ///
    varlabels(D2013 "Trattamento $\times$ 2013" ///
              D2014 "Trattamento $\times$ 2014" ///
              D2015 "Trattamento $\times$ 2015") ///
    title("Controllo Pre-trend: Interazioni Anno $\times$ Trattamento") ///
    mtitles("Spesa corrente pc" "Spesa capitale pc") ///
    stats(N r2_within, labels("Osservazioni" "R$^2$ within") fmt(%9.0fc %9.3f)) ///
    addnotes("Errori standard clusterizzati a livello provinciale." ///
             "Effetti fissi provinciali inclusi. Assenza di effetti fissi d'anno." ///
             "Coefficienti non significativi nel pre-periodo supportano l'ipotesi di trend paralleli.")


coefplot, keep(D*)


* Finto post nel pre-periodo

gen placebo_post = (anno >= 2008)
gen placebo_treated_post = treated * placebo_post   // stesso schema della baseline

reghdfe spesa_pc04 placebo_treated_post c.gdp_pc c.pop_density i.area_geo, ///
    absorb(prov_id anno) vce(cluster prov_id)
est store placebo04

reghdfe spesa_pc05 placebo_treated_post c.gdp_pc c.pop_density i.area_geo, ///
    absorb(prov_id anno) vce(cluster prov_id)
est store placebo05

esttab placebo04 placebo05 ///
    using "placebo.tex", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    b(3) se(3) ///
    label nogaps ///
    keep(placebo_treated_post gdp_pc pop_density) ///
    order(placebo_treated_post gdp_pc pop_density) ///
    varlabels(placebo_treated_post "Trattamento $\times$ Post placebo (2008)") ///
    title("Test Placebo: Post anticipato al 2008") ///
    mtitles("Spesa corrente pc" "Spesa capitale pc") ///
    stats(N r2_within, labels("Osservazioni" "R$^2$ within") fmt(%9.0fc %9.3f)) ///
    addnotes("Errori standard clusterizzati a livello provinciale." ///
             "Un coefficiente non significativo conferma l'assenza di effetti anticipati spurî.")

describe

/// ============================================================================
/// *** ANALISI SETTORIALE COMPLETA - TUTTI GLI ITEM 04 (CORRENTI)
/// ============================================================================

* Usa i nomi completi come da describe
local correnti "amministrazione04 sicurezza04 giustizia04 polizia_locale04 istruzione04 cultura04 sport_ricreativo04 turismo04 viabilita_trasporti04 territorio_ambiente04 urbanistica04 edilizia_residenziale04 servizio_idrico04 rifiuti04 tutela_ambiente04 sociale04 asili_nido04 strutture_anziani04 assistenza04 sviluppo_economico04 servizi_produttivi04"

* Dizionario etichette per la tabella finale
local lbl_amministrazione04       "Amministrazione"
local lbl_sicurezza04             "Sicurezza"
local lbl_giustizia04             "Giustizia"
local lbl_polizia_locale04        "Polizia locale"
local lbl_istruzione04            "Istruzione"
local lbl_cultura04               "Cultura"
local lbl_sport_ricreativo04      "Sport e ricreazione"
local lbl_turismo04               "Turismo"
local lbl_viabilita_trasporti04   "Viabilità e trasporti"
local lbl_territorio_ambiente04   "Territorio e ambiente"
local lbl_urbanistica04           "Urbanistica"
local lbl_edilizia_residenziale04 "Edilizia residenziale"
local lbl_servizio_idrico04       "Servizio idrico"
local lbl_rifiuti04               "Rifiuti"
local lbl_tutela_ambiente04       "Tutela ambientale"
local lbl_sociale04               "Servizi sociali"
local lbl_asili_nido04            "Asili nido"
local lbl_strutture_anziani04     "Strutture anziani"
local lbl_assistenza04            "Assistenza"
local lbl_sviluppo_economico04    "Sviluppo economico"
local lbl_servizi_produttivi04    "Servizi produttivi"

* Loop regressioni - correnti
local stored_c ""   // terrà i nomi degli stime store con p<0.10
local mtitles_c ""  // etichette colonne per esttab

local i = 1
foreach v in `correnti' {
    cap confirm variable `v'
    if _rc != 0 {
        di "Variabile `v' non trovata, salto."
        local ++i
        continue
    }

    cap drop `v'_pc
    gen `v'_pc = `v' / popolazione

    qui count if !missing(`v'_pc, treated_post)
    if r(N) > 1000 {
        capture reghdfe `v'_pc treated_post c.gdp_pc c.pop_density i.area_geo, ///
            absorb(prov_id anno) vce(cluster prov_id)

        if _rc == 0 & e(N) > 500 {
            * Recupera p-value di treated_post
            local pval = 2 * ttail(e(df_r), abs(_b[treated_post] / _se[treated_post]))

            * Salva solo se significativo al 10%
            if `pval' < 0.10 {
                est store sect_c`i'
                local stored_c  "`stored_c' sect_c`i'"
                local mtitles_c `"`mtitles_c' "`lbl_`v''""'
                di "SIGNIFICATIVO: `v' (p=`pval')"
            }
            else {
                di "Non significativo: `v' (p=`pval')"
            }
        }
    }

    drop `v'_pc
    local ++i
}

* Tabella finale - solo item significativi
if "`stored_c'" != "" {
    esttab `stored_c' ///
        using "settoriale_corrente_full.tex", replace ///
        se star(* 0.10 ** 0.05 *** 0.01) ///
        b(3) se(3) ///
        label nogaps ///
        keep(treated_post) ///
        mtitles(`mtitles_c') ///
        title("Analisi Settoriale: Spesa Corrente per Missione (item significativi)") ///
        stats(N r2_within, labels("Osservazioni" "R\$^2$ within") fmt(%9.0fc %9.3f)) ///
        addnotes("Errori standard clusterizzati a livello provinciale." ///
                 "Tutti i modelli includono effetti fissi di provincia e anno." ///
                 "Sono riportati solo i settori con p < 0.10 su treated\_post.")
}
else {
    di "Nessun item corrente significativo al 10%."
}


/// ============================================================================
/// *** ANALISI SETTORIALE COMPLETA - TUTTI GLI ITEM 05 (CONTO CAPITALE)
/// ============================================================================

local capitale "amministrazione05 sicurezza05 giustizia05 polizia_locale05 istruzione05 cultura05 sport_ricreativo05 turismo05 viabilita_trasporti05 territorio_ambiente05 urbanistica05 edilizia_residenziale05 servizio_idrico05  rifiuti05 tutela_ambiente05 sociale05 asili_nido05 strutture_anziani05 assistenza05 sviluppo_economico05 servizi_produttivi05"

local lbl_amministrazione05       "Amministrazione"
local lbl_sicurezza05             "Sicurezza"
local lbl_giustizia05             "Giustizia"
local lbl_polizia_locale05        "Polizia locale"
local lbl_istruzione05            "Istruzione"
local lbl_cultura05               "Cultura"
local lbl_sport_ricreativo05      "Sport e ricreazione"
local lbl_turismo05               "Turismo"
local lbl_viabilita_trasporti05   "Viabilità e trasporti"
local lbl_territorio_ambiente05   "Territorio e ambiente"
local lbl_urbanistica05           "Urbanistica"
local lbl_edilizia_residenziale05 "Edilizia residenziale"
local lbl_servizio_idrico05       "Servizio idrico"
local lbl_rifiuti05               "Rifiuti"
local lbl_tutela_ambiente05       "Tutela ambientale"
local lbl_sociale05               "Servizi sociali"
local lbl_asili_nido05            "Asili nido"
local lbl_strutture_anziani05     "Strutture anziani"
local lbl_assistenza05            "Assistenza"
local lbl_sviluppo_economico05    "Sviluppo economico"
local lbl_servizi_produttivi05    "Servizi produttivi"

local stored_k  ""
local mtitles_k ""

local i = 1
foreach v in `capitale' {
    cap confirm variable `v'
    if _rc != 0 {
        di "Variabile `v' non trovata, salto."
        local ++i
        continue
    }

    cap drop `v'_pc
    gen `v'_pc = `v' / popolazione

    qui count if !missing(`v'_pc, treated_post)
    if r(N) > 1000 {
        capture reghdfe `v'_pc treated_post c.gdp_pc c.pop_density i.area_geo, ///
            absorb(prov_id anno) vce(cluster prov_id)

        if _rc == 0 & e(N) > 500 {
            local pval = 2 * ttail(e(df_r), abs(_b[treated_post] / _se[treated_post]))

            if `pval' < 0.10 {
                est store sect_k`i'
                local stored_k  "`stored_k' sect_k`i'"
                local mtitles_k `"`mtitles_k' "`lbl_`v''""'
                di "SIGNIFICATIVO: `v' (p=`pval')"
            }
            else {
                di "Non significativo: `v' (p=`pval')"
            }
        }
    }

    drop `v'_pc
    local ++i
}

if "`stored_k'" != "" {
    esttab `stored_k' ///
        using "settoriale_capitale_full.tex", replace ///
        se star(* 0.10 ** 0.05 *** 0.01) ///
        b(3) se(3) ///
        label nogaps ///
        keep(treated_post) ///
        mtitles(`mtitles_k') ///
        title("Analisi Settoriale: Spesa in Conto Capitale per Missione (item significativi)") ///
        stats(N r2_within, labels("Osservazioni" "R\$^2$ within") fmt(%9.0fc %9.3f)) ///
        addnotes("Errori standard clusterizzati a livello provinciale." ///
                 "Tutti i modelli includono effetti fissi di provincia e anno." ///
                 "Sono riportati solo i settori con p < 0.10 su treated\_post.")
}
else {
    di "Nessun item capitale significativo al 10%."
}
