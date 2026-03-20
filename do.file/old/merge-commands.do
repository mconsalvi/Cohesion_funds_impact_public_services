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

use "services_quality_data.dta", clear

drop DenominazioneItalianaestrani Denominazionealtralingua CodiceComuneformatoalfanumeri ///
CodiceComuneformatonumerico CodiceComunenumericocon103p CodiceComunenumericocon107p

drop anomalia privacy CodiceNUTS12021 CodiceNUTS12024 CodiceNUTS220213 CodiceNUTS220243 ///
CodiceNUTS32021 CodiceNUTS32024

drop Siglaautomobilistica

drop TipologiadiUnitàterritoriale FlagComunecapoluogodiprovinc CodiceComunenumericocon110p ///
CodiceCatastaledelcomune

drop CodicedellUnitàterritoriales CodiceProvinciaStorico1

drop _merge

gen quality = subinstr(valore, ",", ".", .)

destring quality, gen(quality_num) force

drop Denominazioneinitaliano ProgressivodelComune2



replace DenominazionedellUnitàterrito = "Agrigento" if sigla_provincia == "AG"
replace DenominazionedellUnitàterrito = "Alessandria" if sigla_provincia == "AL"
replace DenominazionedellUnitàterrito = "Ancona" if sigla_provincia == "AN"
replace DenominazionedellUnitàterrito = "Aosta" if sigla_provincia == "AO"
replace DenominazionedellUnitàterrito = "Arezzo" if sigla_provincia == "AR"
replace DenominazionedellUnitàterrito = "Ascoli Piceno" if sigla_provincia == "AP"
replace DenominazionedellUnitàterrito = "Asti" if sigla_provincia == "AT"
replace DenominazionedellUnitàterrito = "Avellino" if sigla_provincia == "AV"
replace DenominazionedellUnitàterrito = "Bari" if sigla_provincia == "BA"
replace DenominazionedellUnitàterrito = "Barletta-Andria-Trani" if sigla_provincia == "BT"
replace DenominazionedellUnitàterrito = "Belluno" if sigla_provincia == "BL"
replace DenominazionedellUnitàterrito = "Benevento" if sigla_provincia == "BN"
replace DenominazionedellUnitàterrito = "Bergamo" if sigla_provincia == "BG"
replace DenominazionedellUnitàterrito = "Biella" if sigla_provincia == "BI"
replace DenominazionedellUnitàterrito = "Bologna" if sigla_provincia == "BO"
replace DenominazionedellUnitàterrito = "Bolzano" if sigla_provincia == "BZ"
replace DenominazionedellUnitàterrito = "Brescia" if sigla_provincia == "BS"
replace DenominazionedellUnitàterrito = "Brindisi" if sigla_provincia == "BR"
replace DenominazionedellUnitàterrito = "Cagliari" if sigla_provincia == "CA"
replace DenominazionedellUnitàterrito = "Caltanissetta" if sigla_provincia == "CL"
replace DenominazionedellUnitàterrito = "Campobasso" if sigla_provincia == "CB"
replace DenominazionedellUnitàterrito = "Caserta" if sigla_provincia == "CE"
replace DenominazionedellUnitàterrito = "Catania" if sigla_provincia == "CT"
replace DenominazionedellUnitàterrito = "Catanzaro" if sigla_provincia == "CZ"
replace DenominazionedellUnitàterrito = "Chieti" if sigla_provincia == "CH"
replace DenominazionedellUnitàterrito = "Como" if sigla_provincia == "CO"
replace DenominazionedellUnitàterrito = "Cosenza" if sigla_provincia == "CS"
replace DenominazionedellUnitàterrito = "Cremona" if sigla_provincia == "CR"
replace DenominazionedellUnitàterrito = "Crotone" if sigla_provincia == "KR"
replace DenominazionedellUnitàterrito = "Cuneo" if sigla_provincia == "CN"
replace DenominazionedellUnitàterrito = "Enna" if sigla_provincia == "EN"
replace DenominazionedellUnitàterrito = "Fermo" if sigla_provincia == "FM"
replace DenominazionedellUnitàterrito = "Ferrara" if sigla_provincia == "FE"
replace DenominazionedellUnitàterrito = "Firenze" if sigla_provincia == "FI"
replace DenominazionedellUnitàterrito = "Foggia" if sigla_provincia == "FG"
replace DenominazionedellUnitàterrito = "Forlì-Cesena" if sigla_provincia == "FC"
replace DenominazionedellUnitàterrito = "Frosinone" if sigla_provincia == "FR"
replace DenominazionedellUnitàterrito = "Genova" if sigla_provincia == "GE"
replace DenominazionedellUnitàterrito = "Gorizia" if sigla_provincia == "GO"
replace DenominazionedellUnitàterrito = "Grosseto" if sigla_provincia == "GR"
replace DenominazionedellUnitàterrito = "Imperia" if sigla_provincia == "IM"
replace DenominazionedellUnitàterrito = "Isernia" if sigla_provincia == "IS"
replace DenominazionedellUnitàterrito = "L'Aquila" if sigla_provincia == "AQ"
replace DenominazionedellUnitàterrito = "La Spezia" if sigla_provincia == "SP"
replace DenominazionedellUnitàterrito = "Latina" if sigla_provincia == "LT"
replace DenominazionedellUnitàterrito = "Lecce" if sigla_provincia == "LE"
replace DenominazionedellUnitàterrito = "Lecco" if sigla_provincia == "LC"
replace DenominazionedellUnitàterrito = "Livorno" if sigla_provincia == "LI"
replace DenominazionedellUnitàterrito = "Lodi" if sigla_provincia == "LO"
replace DenominazionedellUnitàterrito = "Lucca" if sigla_provincia == "LU"
replace DenominazionedellUnitàterrito = "Macerata" if sigla_provincia == "MC"
replace DenominazionedellUnitàterrito = "Mantova" if sigla_provincia == "MN"
replace DenominazionedellUnitàterrito = "Massa-Carrara" if sigla_provincia == "MS"
replace DenominazionedellUnitàterrito = "Matera" if sigla_provincia == "MT"
replace DenominazionedellUnitàterrito = "Messina" if sigla_provincia == "ME"
replace DenominazionedellUnitàterrito = "Milano" if sigla_provincia == "MI"
replace DenominazionedellUnitàterrito = "Modena" if sigla_provincia == "MO"
replace DenominazionedellUnitàterrito = "Monza e della Brianza" if sigla_provincia == "MB"
replace DenominazionedellUnitàterrito = "Napoli" if sigla_provincia == "NA"
replace DenominazionedellUnitàterrito = "Novara" if sigla_provincia == "NO"
replace DenominazionedellUnitàterrito = "Nuoro" if sigla_provincia == "NU"
replace DenominazionedellUnitàterrito = "Oristano" if sigla_provincia == "OR"
replace DenominazionedellUnitàterrito = "Padova" if sigla_provincia == "PD"
replace DenominazionedellUnitàterrito = "Palermo" if sigla_provincia == "PA"
replace DenominazionedellUnitàterrito = "Parma" if sigla_provincia == "PR"
replace DenominazionedellUnitàterrito = "Pavia" if sigla_provincia == "PV"
replace DenominazionedellUnitàterrito = "Perugia" if sigla_provincia == "PG"
replace DenominazionedellUnitàterrito = "Pesaro e Urbino" if sigla_provincia == "PU"
replace DenominazionedellUnitàterrito = "Pescara" if sigla_provincia == "PE"
replace DenominazionedellUnitàterrito = "Piacenza" if sigla_provincia == "PC"
replace DenominazionedellUnitàterrito = "Pisa" if sigla_provincia == "PI"
replace DenominazionedellUnitàterrito = "Pistoia" if sigla_provincia == "PT"
replace DenominazionedellUnitàterrito = "Pordenone" if sigla_provincia == "PN"
replace DenominazionedellUnitàterrito = "Potenza" if sigla_provincia == "PZ"
replace DenominazionedellUnitàterrito = "Prato" if sigla_provincia == "PO"
replace DenominazionedellUnitàterrito = "Ragusa" if sigla_provincia == "RG"
replace DenominazionedellUnitàterrito = "Ravenna" if sigla_provincia == "RA"
replace DenominazionedellUnitàterrito = "Reggio Calabria" if sigla_provincia == "RC"
replace DenominazionedellUnitàterrito = "Reggio Emilia" if sigla_provincia == "RE"
replace DenominazionedellUnitàterrito = "Rieti" if sigla_provincia == "RI"
replace DenominazionedellUnitàterrito = "Rimini" if sigla_provincia == "RN"
replace DenominazionedellUnitàterrito = "Roma" if sigla_provincia == "RM"
replace DenominazionedellUnitàterrito = "Rovigo" if sigla_provincia == "RO"
replace DenominazionedellUnitàterrito = "Salerno" if sigla_provincia == "SA"
replace DenominazionedellUnitàterrito = "Sassari" if sigla_provincia == "SS"
replace DenominazionedellUnitàterrito = "Savona" if sigla_provincia == "SV"
replace DenominazionedellUnitàterrito = "Siena" if sigla_provincia == "SI"
replace DenominazionedellUnitàterrito = "Siracusa" if sigla_provincia == "SR"
replace DenominazionedellUnitàterrito = "Sondrio" if sigla_provincia == "SO"
replace DenominazionedellUnitàterrito = "Taranto" if sigla_provincia == "TA"
replace DenominazionedellUnitàterrito = "Teramo" if sigla_provincia == "TE"
replace DenominazionedellUnitàterrito = "Terni" if sigla_provincia == "TR"
replace DenominazionedellUnitàterrito = "Torino" if sigla_provincia == "TO"
replace DenominazionedellUnitàterrito = "Trapani" if sigla_provincia == "TP"
replace DenominazionedellUnitàterrito = "Trento" if sigla_provincia == "TN"
replace DenominazionedellUnitàterrito = "Treviso" if sigla_provincia == "TV"
replace DenominazionedellUnitàterrito = "Trieste" if sigla_provincia == "TS"
replace DenominazionedellUnitàterrito = "Udine" if sigla_provincia == "UD"
replace DenominazionedellUnitàterrito = "Varese" if sigla_provincia == "VA"
replace DenominazionedellUnitàterrito = "Venezia" if sigla_provincia == "VE"
replace DenominazionedellUnitàterrito = "Verbano-Cusio-Ossola" if sigla_provincia == "VB"
replace DenominazionedellUnitàterrito = "Vercelli" if sigla_provincia == "VC"
replace DenominazionedellUnitàterrito = "Verona" if sigla_provincia == "VR"
replace DenominazionedellUnitàterrito = "Vibo Valentia" if sigla_provincia == "VV"
replace DenominazionedellUnitàterrito = "Vicenza" if sigla_provincia == "VI"
replace DenominazionedellUnitàterrito = "Viterbo" if sigla_provincia == "VT"


replace DenominazioneRegione = "Sicilia" if inlist(sigla_provincia,"AG","CL","CT","EN","ME","PA","RG","SR","TP")
replace DenominazioneRegione = "Piemonte" if inlist(sigla_provincia,"AL","AT","BI","CN","NO","TO","VB","VC")
replace DenominazioneRegione = "Marche" if inlist(sigla_provincia,"AN","AP","FM","MC","PU")
replace DenominazioneRegione = "Valle d'Aosta" if sigla_provincia == "AO"
replace DenominazioneRegione = "Toscana" if inlist(sigla_provincia,"AR","FI","GR","LI","LU")
replace DenominazioneRegione = "Toscana" if inlist(sigla_provincia, "MS","PI","PT","PO","SI")

replace DenominazioneRegione = "Campania" if inlist(sigla_provincia,"AV","BN","CE","NA","SA")
replace DenominazioneRegione = "Puglia" if inlist(sigla_provincia,"BA","BT","BR","FG","LE","TA")
replace DenominazioneRegione = "Veneto" if inlist(sigla_provincia,"BL","PD","RO","TV","VE","VR","VI")
replace DenominazioneRegione = "Calabria" if inlist(sigla_provincia,"CS","CZ","KR","RC","VV")
replace DenominazioneRegione = "Lombardia" if inlist(sigla_provincia,"BG","BS","CO","CR","LC","LO")
replace DenominazioneRegione = "Lombardia" if inlist(sigla_provincia, "MB","MI","MN","PV","SO","VA")
replace DenominazioneRegione = "Sardegna" if inlist(sigla_provincia,"CA","NU","OR","SS")
replace DenominazioneRegione = "Molise" if inlist(sigla_provincia,"CB","IS")
replace DenominazioneRegione = "Abruzzo" if inlist(sigla_provincia,"AQ","CH","PE","TE")
replace DenominazioneRegione = "Liguria" if inlist(sigla_provincia,"GE","IM","SP","SV")
replace DenominazioneRegione = "Friuli-Venezia Giulia" if inlist(sigla_provincia,"GO","PN","TS","UD")
replace DenominazioneRegione = "Emilia-Romagna" if inlist(sigla_provincia,"BO","FC","FE","MO","PR","PC","RA","RE","RN")
replace DenominazioneRegione = "Lazio" if inlist(sigla_provincia,"FR","LT","RI","RM","VT")
replace DenominazioneRegione = "Trentino-Alto Adige" if inlist(sigla_provincia,"BZ","TN")
replace DenominazioneRegione = "Umbria" if inlist(sigla_provincia,"PG","TR")

* Nord-ovest
replace Ripartizionegeografica = "Nord-ovest" if inlist(sigla_provincia,"AL","AT","BI","CN","NO","TO","VB","VC")
replace Ripartizionegeografica = "Nord-ovest" if inlist(sigla_provincia,"IM","GE","SP","SV")
replace Ripartizionegeografica = "Nord-ovest" if inlist(sigla_provincia,"BG","BS","CO","CR","LC","LO")
replace Ripartizionegeografica = "Nord-ovest" if inlist(sigla_provincia, "MB","MI","MN","PV","SO","VA")

* Nord-est
replace Ripartizionegeografica = "Nord-est" if inlist(sigla_provincia,"BZ","TN")
replace Ripartizionegeografica = "Nord-est" if inlist(sigla_provincia,"BL","PD","RO","TV","VE","VR","VI")
replace Ripartizionegeografica = "Nord-est" if inlist(sigla_provincia,"FE","BO","FC","MO","PR","PC","RA","RE","RN")
replace Ripartizionegeografica = "Nord-est" if inlist(sigla_provincia,"GO","PN","TS","UD")

* Centro
replace Ripartizionegeografica = "Centro" if inlist(sigla_provincia,"AR","FI","GR","LI","LU")
replace Ripartizionegeografica = "Centro" if inlist(sigla_provincia, "MS","PI","PT","PO","SI")
replace Ripartizionegeografica = "Centro" if inlist(sigla_provincia,"PG","TR")
replace Ripartizionegeografica = "Centro" if inlist(sigla_provincia,"FR","LT","RI","RM","VT")
replace Ripartizionegeografica = "Centro" if inlist(sigla_provincia,"AN","AP","FM","MC","PU")

* Sud
replace Ripartizionegeografica = "Sud" if inlist(sigla_provincia,"AQ","CH","PE","TE")
replace Ripartizionegeografica = "Sud" if inlist(sigla_provincia,"CB","IS")
replace Ripartizionegeografica = "Sud" if inlist(sigla_provincia,"AV","BN","CE","NA","SA")
replace Ripartizionegeografica = "Sud" if inlist(sigla_provincia,"BR","FG","LE","TA","BT","BA")
replace Ripartizionegeografica = "Sud" if inlist(sigla_provincia,"CS","CZ","KR","RC","VV")

* Isole
replace Ripartizionegeografica = "Isole" if inlist(sigla_provincia,"AG","CL","CT","EN","ME","PA","RG","SR","TP")
replace Ripartizionegeografica = "Isole" if inlist(sigla_provincia,"CA","NU","OR","SS")

// Aggiungiamo i codici
* Nord-ovest → codice 1
replace CodiceRipartizione = 1 if inlist(sigla_provincia,"AL","AT","BI","CN","NO","TO","VB","VC")
replace CodiceRipartizione = 1 if inlist(sigla_provincia,"IM","GE","SP","SV")
replace CodiceRipartizione = 1 if inlist(sigla_provincia,"BG","BS","CO","CR","LC","LO","MB")
replace CodiceRipartizione = 1 if inlist(sigla_provincia,"MI","MN","PV","SO","VA")

* Nord-est → codice 2
replace CodiceRipartizione = 2 if inlist(sigla_provincia,"BZ","TN")
replace CodiceRipartizione = 2 if inlist(sigla_provincia,"BL","PD","RO","TV","VE","VR","VI")
replace CodiceRipartizione = 2 if inlist(sigla_provincia,"FE","BO","FC","MO","PR","PC","RA","RE","RN")
replace CodiceRipartizione = 2 if inlist(sigla_provincia,"GO","PN","TS","UD")

* Centro → codice 3
replace CodiceRipartizione = 3 if inlist(sigla_provincia,"AR","FI","GR","LI","LU")
replace CodiceRipartizione = 3 if inlist(sigla_provincia, "MS","PI","PT","PO","SI")
replace CodiceRipartizione = 3 if inlist(sigla_provincia,"PG","TR")
replace CodiceRipartizione = 3 if inlist(sigla_provincia,"FR","LT","RI","RM","VT")
replace CodiceRipartizione = 3 if inlist(sigla_provincia,"AN","AP","FM","MC","PU")

* Sud → codice 4
replace CodiceRipartizione = 4 if inlist(sigla_provincia,"AQ","CH","PE","TE")
replace CodiceRipartizione = 4 if inlist(sigla_provincia,"CB","IS")
replace CodiceRipartizione = 4 if inlist(sigla_provincia,"AV","BN","CE","NA","SA")
replace CodiceRipartizione = 4 if inlist(sigla_provincia,"BR","FG","LE","TA","BT","BA")
replace CodiceRipartizione = 4 if inlist(sigla_provincia,"CS","CZ","KR","RC","VV")

* Isole → codice 5
replace CodiceRipartizione = 5 if inlist(sigla_provincia,"AG","CL","CT","EN","ME","PA","RG","SR","TP")
replace CodiceRipartizione = 5 if inlist(sigla_provincia,"CA","NU","OR","SS")

replace CodiceRegione = "01" if DenominazioneRegione == "Piemonte"
replace CodiceRegione = "02" if DenominazioneRegione == "Valle d'Aosta"
replace CodiceRegione = "03" if DenominazioneRegione == "Lombardia"
replace CodiceRegione = "04" if DenominazioneRegione == "Trentino-Alto Adige"
replace CodiceRegione = "05" if DenominazioneRegione == "Veneto"
replace CodiceRegione = "06" if DenominazioneRegione == "Friuli Venezia Giulia"
replace CodiceRegione = "07" if DenominazioneRegione == "Liguria"
replace CodiceRegione = "08" if DenominazioneRegione == "Emilia-Romagna"
replace CodiceRegione = "09" if DenominazioneRegione == "Toscana"
replace CodiceRegione = "10" if DenominazioneRegione == "Umbria"
replace CodiceRegione = "11" if DenominazioneRegione == "Marche"
replace CodiceRegione = "12" if DenominazioneRegione == "Lazio"
replace CodiceRegione = "13" if DenominazioneRegione == "Abruzzo"
replace CodiceRegione = "14" if DenominazioneRegione == "Molise"
replace CodiceRegione = "15" if DenominazioneRegione == "Campania"
replace CodiceRegione = "16" if DenominazioneRegione == "Puglia"
replace CodiceRegione = "17" if DenominazioneRegione == "Basilicata"
replace CodiceRegione = "18" if DenominazioneRegione == "Calabria"
replace CodiceRegione = "19" if DenominazioneRegione == "Sicilia"
replace CodiceRegione = "20" if DenominazioneRegione == "Sardegna"


save "services_quality_data.dta", replace

use "services_quality_data.dta", clear

rename DenominazionedellUnitàterrito den_provincia
rename CodiceRegione cod_regione
rename CodiceRipartizioneGeografica cod_macroarea
rename Ripartizionegeografica macroarea
rename DenominazioneRegione den_regione

drop Code username

save "services_quality_data.dta", replace

use "services_quality_data.dta", clear

collapse (mean) public_services_quality, by(cod_macroarea cod_regione macroarea den_regione /// 
den_provincia indicatoredeterminante sigla_provincia)


* Performance and positioning indicators
replace indicatoredeterminante = "performance_servizi" if indicatoredeterminante == "COORD_OUT"
replace indicatoredeterminante = "spesa_servizi" if indicatoredeterminante == "COORD_SPESA"
replace indicatoredeterminante = "performance_servizi_su_media_pc" if indicatoredeterminante == "DIFF_OUT_PERC_TOT"
replace indicatoredeterminante = "level_total_services" if indicatoredeterminante == "POSIZIONE_OUTPUT_PERC_TOT"
replace indicatoredeterminante = "level_total_spending" if indicatoredeterminante == "POSIZIONE_SPESA_PERC_TOT"

* Staff and demographics
replace indicatoredeterminante = "avg_labour_cost_pc" if indicatoredeterminante == "COSTO_LAVORO_PROAB"
replace indicatoredeterminante = "avg_labour_cost_pw" if indicatoredeterminante == "D03"
replace indicatoredeterminante = "mun_workforce_x1000" if indicatoredeterminante == "DIPENDENTI_X1000AB"
replace indicatoredeterminante = "standard_spend_total" if indicatoredeterminante == "FST_RIPROPORZIONATO_BI"
replace indicatoredeterminante = "standard_spend_pc" if indicatoredeterminante == "FST_RIPROPORZIONATO_BI_PROAB"
replace indicatoredeterminante = "population" if indicatoredeterminante == "F_FASCIA_SON"

* Service quality flags
replace indicatoredeterminante = "high_serv" if indicatoredeterminante == "FL_DIF_OUTPUT_MAG_0"
replace indicatoredeterminante = "low_serv" if indicatoredeterminante == "FL_DIF_OUTPUT_MIN_0"
replace indicatoredeterminante = "high_spend" if indicatoredeterminante == "FL_DIF_SPESA_MAG_0"
replace indicatoredeterminante = "low_spend" if indicatoredeterminante == "FL_DIF_SPESA_MIN_0"

* Combined performance indicators
replace indicatoredeterminante = "high_spend_high_serv" if indicatoredeterminante == "FL_SPESA_PIU_OUT_PIU"
replace indicatoredeterminante = "high_spend_low_serv" if indicatoredeterminante == "FL_SPESA_PIU_OUT_MENO"
replace indicatoredeterminante = "low_spend_low_serv" if indicatoredeterminante == "FL_SPESA_MENO_OUT_MENO"
replace indicatoredeterminante = "low_spend_high_serv" if indicatoredeterminante == "FL_SPESA_MENO_OUT_PIU"

* Costs and spending
replace indicatoredeterminante = "spend_pc_hist" if indicatoredeterminante == "SPESA_STORICA_PROAB"
replace indicatoredeterminante = "spend_tot_hist" if indicatoredeterminante == "SPESA_STORICA"
replace indicatoredeterminante = "pop_density" if indicatoredeterminante == "F_DENSITA_MEAN"
replace indicatoredeterminante = "pop_3_14" if indicatoredeterminante == "F_INTERCEPT_POP_3_14"
replace indicatoredeterminante = "pop_foreign" if indicatoredeterminante == "F_INCID_POP_STRA_MEAN"
replace indicatoredeterminante = "pop_15_64" if indicatoredeterminante == "F_INCID_15_64_MEAN"
replace indicatoredeterminante = "pop_65_74" if indicatoredeterminante == "F_INCID_65_74_MEAN"
replace indicatoredeterminante = "pop_over_75" if indicatoredeterminante == "F_INCID_OLTRE_75_MEAN"
replace indicatoredeterminante = "cost_cars" if indicatoredeterminante == "F_PREZZO_VEIC_FINALE_POL_SCOST"

* Municipal characteristics
replace indicatoredeterminante = "se_deprivation" if indicatoredeterminante == "F_DEPRIVAZIONE_MEAN"
replace indicatoredeterminante = "scale_diseconomies" if indicatoredeterminante == "F_DISECONOMIA_SCALA"
replace indicatoredeterminante = "total_buildings" if indicatoredeterminante == "F_IMMOBILI_TOTALI_P"
replace indicatoredeterminante = "high_seismic_risk" if indicatoredeterminante == "F_SISMICO_RISCHIO_ALTO"
replace indicatoredeterminante = "mun_surface" if indicatoredeterminante == "F_ISTAT_SUPERF_TOTALE_KMQ_P"
replace indicatoredeterminante = "pop_landslide_risk_" if indicatoredeterminante == "F_P4_P3_Q"

* Education indicators
replace indicatoredeterminante = "ed_nursery_number" if indicatoredeterminante == "F_ASILO_NIDO"
replace indicatoredeterminante = "ed_total_students" if indicatoredeterminante == "F_M_AL_COMUNALI_P_MEAN"
replace indicatoredeterminante = "ed_private_students" if indicatoredeterminante == "F_M_AL_PRIVATE_P"
replace indicatoredeterminante = "ed_fulltime_classes" if indicatoredeterminante == "F_QUOTA_CLTP_PRIMSEC1"
replace indicatoredeterminante = "ed_handicap_students" if indicatoredeterminante == "F_ALUNNI_HANDICAP_MEAN"
replace indicatoredeterminante = "ed_hanmdicap_students_munic" if indicatoredeterminante == "F_M_AL_DISABILI_COMU_P_MEAN"
replace indicator_clean = "school_buildings_sqm" if indicatoredeterminante == "F_M_SPAZI_TOT_P"
replace indicatoredeterminante = "ed_meals_provided" if indicatoredeterminante == "F_M_PASTI_TOT_P_MEAN"
replace indicatoredeterminante = "ed_summer_courses" if indicatoredeterminante == "F_M_PREPOST_ESTIVI_P"
replace indicatoredeterminante = "ed_transport_students" if indicatoredeterminante == "F_M_TRASPORTO_UTENTI_P"
replace indicatoredeterminante = "ed_transport_handicap_students" if indicatoredeterminante == "F_M_TRASP_DISABILI_P_MEAN"
replace indicatoredeterminante = "ed_school_numb" if indicatoredeterminante == "F_M_SCUOLE_STAT_COM_N_P"
replace indicatoredeterminante = "ed_school_area" if indicatoredeterminante == "F_M_SPAZI_TOT_P"

* Public safety and services
replace indicatoredeterminante = "armed_police" if indicatoredeterminante == "F_DUMMY_ARMATO"
replace indicatoredeterminante = "traffic_accidents" if indicatoredeterminante == "F_M_INCIDENTI_P"
replace indicatoredeterminante = "complaints_reports" if indicatoredeterminante == "F_M_QUERELE_P"
replace indicatoredeterminante = "violent_crimes" if indicatoredeterminante == "F_OUTPUT_ALTRI_ESOGENI_P"

* Waste management
replace indicatoredeterminante = "waste_mun_context" if indicatoredeterminante == "F_CONTESTO"
replace indicatoredeterminante = "waste_disposal_distance" if indicatoredeterminante == "F_DISTANZA"
replace indicatoredeterminante = "waste_ass_management" if indicatoredeterminante == "F_GESTIONE"
replace indicatoredeterminante = "waste_infrastructure_level" if indicatoredeterminante == "F_INFRASTRUTTURE"
replace indicatoredeterminante = "waste_management_type" if indicatoredeterminante == "F_TIPRACCOLTA"
replace indicatoredeterminante = "raccolta_diff" if indicatoredeterminante == "F_DIFFERENZIATA"
replace indicatoredeterminante = "waste_tons_produced" if indicatoredeterminante == "F_INTERCEPT_TONN_RIF"

* Territory and infrastructure
replace indicatoredeterminante = "build_total" if indicatoredeterminante == "F_INTERCEPT_IMM_VET"
replace indicatoredeterminante = "level_services_territory" if indicatoredeterminante == "F_OUTPUT_ST_CON_P_LUCE_C"
replace indicatoredeterminante = "paid_parking" if indicatoredeterminante == "F_STALLI_P_MEAN"
replace indicatoredeterminante = "mun_roads_km" if indicatoredeterminante == "F_ISTAT_GENER_STRADE_KM_MEAN"

* Tourism and economy
replace indicatoredeterminante = "tourists_tot" if indicatoredeterminante == "F_PRESENZE_COMUNE_MEAN"
replace indicatoredeterminante = "hospitality_employees" if indicatoredeterminante == "F_ADDETTI_I_P_MEAN"
replace indicatoredeterminante = "commuters_net" if indicatoredeterminante == "F_DIFF_PENDOLARI_N_P"
replace indicatoredeterminante = "mkt_days" if indicatoredeterminante == "F_MERCATI_P_MEAN"

* Housing
replace indicatoredeterminante = "housing_available" if indicatoredeterminante == "F_ABIT_DISP_MEAN_C"
replace indicatoredeterminante = "housing_used" if indicatoredeterminante == "F_ABIT_LOC_E_ALTRI_UTIL_MEAN_C"
replace indicatoredeterminante = "housing_inhab_per_house" if indicatoredeterminante == "F_POP_C"

* Social services
replace indicatoredeterminante = "ss_structures" if indicatoredeterminante == "F_DUMMY_STRUTTURE"
replace indicatoredeterminante = "ss_hours" if indicatoredeterminante == "F_VALORE_BENCHMARK_ORE"
replace indicatoredeterminante = "ss_users" if indicatoredeterminante == "F_VALORE_BENCHMARK_UT"

* Labor costs by service
replace indicatoredeterminante = "lab_cost_admin" if indicatoredeterminante == "F_COSTO_LAV_SCOST_AMM"
replace indicatoredeterminante = "lab_cost_police" if indicatoredeterminante == "F_COSTO_LAV_SCOST_POL"
replace indicatoredeterminante = "lab_cost_education" if indicatoredeterminante == "F_COSTO_LAV_SCOST_IST"
replace indicatoredeterminante = "lab_cost_roads" if indicatoredeterminante == "F_COSTO_LAV_SCOST_VIAB"
replace indicatoredeterminante = "lab_cost_territory" if indicatoredeterminante == "F_COSTO_LAV_SCOST_TERR"

* Non-evaluable cases and other codes
replace indicatoredeterminante = "nv_servizi" if indicatoredeterminante == "FL_NO_CONFRONTO_OUT"
replace indicatoredeterminante = "nv_spesa" if indicatoredeterminante == "FL_NO_CONFRONTO_SPESA"
replace indicatoredeterminante = "nv_both" if indicatoredeterminante == "FL_NO_VALUTABILE"
replace indicatoredeterminante = "descr_nv_servizi" if indicatoredeterminante == "DESCR_NON_VALUTABILE_OUT_TOT"
replace indicatoredeterminante = "descr_nv_spesa" if indicatoredeterminante == "DESCR_NON_VALUTABILE_SPESA_TOT"
replace indicatoredeterminante = "nv_serv_per_function" if indicatoredeterminante == "SERV_NO_VALUT_OUT_TOT"
replace indicatoredeterminante = "nv_spend_per_function" if indicatoredeterminante == "SERV_NO_VALUT_SPESA_TOT"

replace public_services_quality = 0 if public_services_quality == .

rename indicatoredeterminante public_service_indicator

describe public_service_indicator

levelsof public_service_indicator

ds

save "services_quality_data.dta", replace

use "services_quality_data.dta", clear

replace public_service_indicator = subinstr(public_service_indicator, "_", "", .)

rename public_services_quality psq

reshape wide psq, i(sigla_provincia) j(public_service_indicator) string

rename psqbuildto~l build_total
rename psqdescrnv~a descr_nv_spesa
rename psqednurse~r ed_nursery_number
rename psqedtotal~s ed_total_students
rename psqhighspendhighserv high_spend_high_serv
rename psqhousin~se housing_inhab_per_house
rename psqlaborco~s labor_cost_roads
rename psqlowserv low_serv
rename psqmuncont~e mun_context_waste
rename psqnvservizi nv_serv
rename psqperform~i performance_serv
rename psqpopdens~y pop_density
rename psqraccolt~f raccolta_diff
rename psqspesase~i spend_serv
rename psqstandar~l std_spend_tot
rename psqwastedi~e waste_disposal_distance

rename psqarmedpo~e armed_police
rename psqcommute~t commuters_net
rename psqedfullt~s ed_full_time_classes
rename psqedpriva~s ed_private_students
rename psqedtransportstudents ed_transport_students
rename psqedtransporthandicapstudents ed_transport_handicap_students
rename psqhighspend high_spend
rename psqhousing~d housing_used
rename psqlaborco~y labor_cost_territory
rename psqmunroad~m mun_roads_km
rename psqnvservp~n nv_serv_per_function
rename psqperform~c performance_serv_avg_pc
rename psqpopfore~n pop_foreign
rename psqscaledi~s scale_diseconomies
rename psqsshours ss_hours
rename psqtotalbu~s tot_buildings
rename psqwastein~l waste_infrastructure_level

rename psqassmana~e ass_mananagement_waste
rename psqcomplai~s complaint_reports
rename psqedhandi~s ed_handicap_students
rename psqedschoo~a ed_school_area
rename ps~tstudents t_students
rename psqhig~wserv high_spend_low_serv
rename psqlaborc~in labor_cost_admin
rename psqlevelse~y level_services_territory
rename psqlow~hserv low_spend_high_serv
rename psqmunsurf~e mun_surface
rename psqnvspend~n nv_spend_per_function
rename psqpop1564 pop_15_64
rename psqpopland~k pop_landslide_risk
rename psqsedepri~n se_deprivation
rename psqssstruc~s ss_structures
rename psqtourist~t tourist_tot
rename waste_managament_distance waste_manag_type

rename psqavglabo~c avg_labour_cost_pc
rename psqcostcars cost_cars
rename psqedhanmd~c ed_handicap_students_mun_ic
rename psqedschoo~b ed_school_numb
rename psqhighsei~k high_seismic_risk_k
rename psqhospita~s hospitality_employees
rename psqlaborc~on labor_cost_education
rename psqlevelto~s level_total_services
rename psqlow~wserv low_spend_low_serv
rename psqmunw~1000 mun_workforce_pth
rename psqnvspesa nv_spend
rename pop_314 pop_3_14
rename psqpopover75 pop_over_75
rename psqspendpc~t spend_pc_hist
rename psqssusers ss_users
rename psqtraffic~s traffic_accidents
rename psqwasteto~d waste_tons_produced

rename psqavglabo~w avg_labour_cost_pw
rename psqdescrnv~i descr_nv_servizi
rename psqedmeals~d ed_meals_provided
rename psqedsumme~s ed_summer_courses
rename psqhighserv high_serv
rename psqhousin~le housing_avbailable
rename psqlaborco~e labor_cost_police
rename psqlevelto~g level_total_spending
rename psqmktdays mkt_days
rename psqnvboth nv_both
rename psqpaidpar~g paid_parking
rename pop_6574 pop_65_74
rename psqpopulat~n population
rename psqspendto~t spend_tot_hist
rename psqstandar~c std_spend_pc
rename psqviolent~s violent_crimes


save "services_quality_data.dta", replace

recast str244 den_provincia, force


drop if den_provincia == ""