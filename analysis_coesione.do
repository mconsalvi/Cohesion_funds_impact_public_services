/// ============================================================================
/// IMPATTO DELLE POLITICHE DI COESIONE SULLA QUALITÀ DEI SERVIZI PUBBLICI
/// ============================================================================

// Author: Matteo Consalvi
// Project: Impact evaluation of cohesion policies on public services quality
// do-file: final merge and analysis
// Created: 07/01/2026
// Last Modified: 21/01/2026
// Each section title is indicated with "///"
// Comments are indicated with "*" or with "//"

// Set up Stata environment 
set more off       // Disable pause in output
clear all          // Clear any existing data in memory
macro drop _all    // Drop all macros
* log using "log.txt", text replace  

/// ============================================================================
/// *** USE E MERGE DATI
/// ============================================================================

use "coesione_14_20.dta", clear

collapse (sum) importo pil popolazione n_progetti area (mean) neet ///
			(first) classificazione den_regione base_neet, by(den_provincia anno)
			
gen pil_pc = pil/popolazione
gen importo_pc = importo/popolazione
gen pop_density = popolazione/area

merge m:1 anno den_provincia using "indicatori.dta"

sort anno den_provincia

keep if _merge == 3
drop _merge

save "final_coesione.dta", replace

/// ============================================================================
/// *** ANALYSIS
/// ============================================================================

use "final_coesione.dta", clear

table anno, ///
    statistic(sum importo) ///
    statistic(mean importo)

describe

encode den_provincia, gen(prov_id)

	
*** CREIAMO IL TRATTAMENTO ====================================================

preserve

*** Collassa a livello provincia (somma su tutti gli anni)
collapse (sum) importo (first) popolazione classificazione, by(prov_id)

*** Calcola spesa pro-capite totale
gen oc_per_capita_total = importo / popolazione

*** Verifica distribuzione
summarize oc_per_capita_total

*** Calcola percentili 30-70
_pctile oc_per_capita_total, percentiles(30 70)

local p30 = r(r1)
local p70 = r(r2)

*** Crea treatment (FISSO per provincia)
gen treated = .
replace treated = 1 if oc_per_capita_total >= `p70'
replace treated = 0 if oc_per_capita_total < `p30'

tab treated

*** Merge
keep prov_id treated
tempfile treatment_assignment
save `treatment_assignment'

restore

merge m:1 prov_id using `treatment_assignment'
drop _merge

* Step 3: Create explicit sample indicator (optional, for clarity)
gen sample_extreme = (treated != .)

* Verification
tab treated
tab treated if sample_extreme == 1

*** CREIAMO I BASELINE PER IL PROPENSITY SCORE MATCHING =======================
bysort prov_id (anno): gen b_neet = base_neet
bysort prov_id: replace b_neet = b_neet[_n-1] if missing(b_neet)

bysort prov_id (anno): gen b_occupazione = lav_occupazione if anno == 2015
bysort prov_id: replace b_occupazione = b_occupazione[_n-1] if missing(b_occupazione)

bysort prov_id (anno): gen b_pil = pil_pc if anno == 2015
bysort prov_id: replace b_pil = b_pil[_n-1] if missing(b_pil)

bysort prov_id (anno): gen b_densità = pop_density if anno == 2015
bysort prov_id: replace b_densità = b_densità[_n-1] if missing(b_densità)

gen log_pop = log(popolazione)

gen meno_sviluppata = (classificazione == 1)  // 1 se <75% EU-27, 0 altrimenti

*** CREIAMO INDICATORI TEMPORALI ==============================================

* PRE-PERIOD: 2014-2020 (test parallel trends here)
gen pre_period = (anno >= 2014 & anno <= 2015)

* POST-PERIOD: 2021-2024 (measure effects here)
* Also try 2022-2024 for robustness (after deadline)
gen post = (anno >= 2022)

* DiD interaction
gen treated_post = treated * post

* Time trend (for parallel trends test)
gen time_trend = anno - 2015 

preserve
*** PROPENSITY SCORE ESTIMATION (ANNO 2015) ===================================
    keep if anno == 2015 & sample_extreme == 1

    * 1. Stima PS
    logit treated ///
      i.meno_sviluppata ///
      b_neet ///
      b_occupazione ///
	  b_pil ///
      log_pop, ///
      cluster(prov_id)

    predict ps, pr

	* Histogram overlay
	histogram ps if treated == 0, width(0.02) color(blue%40) ///
    addplot(histogram ps if treated == 1, width(0.02) color(red%40)) ///
    legend(order(1 "Control" 2 "Treated")) ///
    title("Propensity score - 2015 (before matching)") ///
    xtitle("ps") ytitle("Frequency")
	graph export "ps_before_2015.png", replace 

	* Kernel densities
	twoway (kdensity ps if treated==0, lcolor(blue)) ///
		(kdensity ps if treated==1, lcolor(red)), ///
		legend(order(1 "Control" 2 "Treated")) ///
		title("PS density - 2015 (before matching)") ///
		xtitle("ps") ytitle("Density")
		graph export "kernel_density.png", replace


    * 2. Matching su anno 2015
	psmatch2 treated, outcome(b_neet) ps(ps) ///
    caliper(0.15) common noreplace
	 
	gen in_matched = (_weight < .)

	twoway (kdensity ps if treated==0 & in_matched, lcolor(blue)) ///
       (kdensity ps if treated==1 & in_matched, lcolor(red)), ///
       legend(order(1 "Control (matched)" 2 "Treated (matched)")) ///
       title("PS density - 2015 (after matching)") ///
       xtitle("ps") ytitle("Density") ///
       name(ps_after, replace)
	graph export "ps_after_2015.png", replace

    * 3. Test di bilanciamento dopo il matching
	pstest b_neet b_occupazione b_pil log_pop, both

    * 4. Costruisco indicatore province matched e salvo
	keep prov_id treated ps _weight in_matched ///
    log_pop b_neet b_occupazione b_pil meno_sviluppata

    tempfile matches
    save `matches'
restore 

* Uniamo le info di matching 2017 al pannello completo
merge m:1 prov_id using `matches'
drop _merge

* Teniamo solo le province che sono nel common support 2017
keep if in_matched == 1

* (Opzionale) Controllo quanti trattati/controlli rimangono
tab treated


/// ============================================================================
/// *** DIFFERENCE IN DIFFERENCES ANALYSIS
/// ============================================================================

* Crea le DiD su OUTCOME PRIMARI
regress neet ///
    treated post treated_post ///
    b_neet i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_neet

regress lav_occupazione ///
    treated post treated_post ///
    b_occupazione i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_occupazione

*** SCOLARITÀ - Partecipazione scolastica
regress ist_partecipazione_scolastica ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_scolarita

*** SCOLARITÀ - Diplomati (25-64)
regress ist_diplomati ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_diplomati

*** SCOLARITÀ - Laureati (25-39)
regress ist_laureati ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_laureati

*** INFRASTRUTTURE - Trasporti (TPL)
regress ser_tpl_km ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_tpl

*** AMBIENTE - Raccolta differenziata
regress ser_raccolta_rifiuti ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_rifiuti

*** AMBIENTE - Irregolarità elettrica
regress ser_irregolarita_elettrica ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_elettrica

*** AMMINISTRAZIONE - Capacità riscossione
regress pol_com_riscossione ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_capacita

*** SANITÀ - Mortalità infantile
regress ser_emigrazione_osp ///
    treated post treated_post ///
    i.anno i.meno_sviluppata ///
    [pw=_weight], cluster(prov_id)
lincom treated_post
est store m_emigrazione_osp

*** Crea tabella con TUTTI gli effetti DiD
esttab m_neet m_occupazione m_scolarita m_diplomati m_laureati ///
       m_tpl m_rifiuti m_elettrica m_capacita m_emigrazione_osp, ///
    keep(treated_post) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("DiD Effects of Cohesion Spending on Multiple Outcomes")
