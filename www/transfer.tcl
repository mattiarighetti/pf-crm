ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
}
set message "Report:\n\n"
ad_progress_bar_begin -title "Trasferimento in corso" -message_2 $message
db_foreach query "SELECT * FROM temporanea" {
    #controllo albopf
    if {$albo_pf == "SI"} {
	set albo_pf 1
    } else {
	set albo_pf 0
    }
    if {$duplicato eq "si"} {
	set conta [db_string query "select count(*) from temporanea where nome = :nome, cognome = :cognome"]
	if {$conta == 2} {
	    set persona_id [db_string query "select persona_id from temporanea where nome = :nome and cognome = :cognome AND duplicato <> 'si'"]
	}		       
    }
    #controlla se nome contiene spazio (il che sarebbe sec_nome e quindi spezza
    set nomi [split $nome " "]
    set sec_nome [lassign $nomi nome]
    set nome [string totitle $nome]
    set sec_nome [string totitle $sec_nome]
    set cognome [string totitle $cognome]
    
    #controlla partita iva
    if {[string length $piva] > 14 || [string length $piva] < 8} {
	set piva ""
    }
    
    #controllo societa
    if {$intermediario != ""} {
	set truefalse [db_0or1row query "select * from crm_societa where ragionesociale = :intermediario limit 1"]
	if {$truefalse == 0} {
	    if {[db_0or1row query "select societa_id from crm_societa limit 1"]} {
		set societa_id [db_string query "SELECT COALESCE(MAX(societa_id)+(SELECT TRUNC(RANDOM()*9+1))) FROM crm_societa"]
	    } else {
		set societa_id [db_string query "SELECT TRUNC(RANDOM()*9+1)"]
	    }
	    db_dml query "insert into crm_societa (societa_id, ragionesociale) values (:societa_id, :intermediario)"
	} else {
	    set societa_id [db_string query "SELECT societa_id from crm_societa where ragionesociale = :intermediario"]
	}
	#aggiunge eventuale carica all'interno della societa prendendola dalla professione
	set truefalse [db_0or1row query "select * from crm_cariche where societa_id = :societa_id and descrizione = :professione limit 1"]
	if {$truefalse == 0} {
	    if {[string length $professione]<= 100} {
		set carica [string totitle $professione]
		if {[db_0or1row query "select carica_id from crm_cariche limit 1"]} {
		    set carica_id [db_string query "SELECT COALESCE(MAX(carica_id)+(SELECT TRUNC(RANDOM()*9+1))) FROM crm_cariche"]
		} else {
		    set carica_id [db_string query "SELECT TRUNC(RANDOM()*9+1)"]
		}
		set professione [string totitle $professione]
		db_dml query "INSERT INTO crm_cariche (carica_id, descrizione, societa_id) values (:carica_id, :professione, :societa_id)"
	    }
	} else {
	    set carica_id ""
	}
    } else {
	set societa_id ""
	set carica_id ""
    }
    #aggiunge eventuale codice fiscale 
    if {$codfisc != "" && [string length $codfisc]<16} {
	set codicefiscale [string toupper $codfisc]
    } else {
	set codicefiscale ""
    }
    #modifica nota e aggiunge il ruolo prof su richiesta di Jonathan
    if {$mailinglist ne ""} {
	append nota "\n\nMailinglist: " $mailinglist
    }
    if {$partecipato ne ""} {
	append nota "\n\nGià partecipato a eventi PF: " $partecipato
    }
    if {$iscritto ne ""} {
	append nota "\n\nIscritto al vecchio portale: " $iscritto
    }
    if {$ruolo ne ""} {
	append nota "\n\nRuolo professionale: " $ruolo 
    }
    if {$numeroclienti ne ""} {
	append nota "\n\nNumero clienti: " $numeroclienti
    }
    if {$efpa ne ""} {
	append nota "\n\nEfpa: " $efpa
    }
    #controllo sulla persona_id
    if {$duplicato ne "si"} {
	set exist [db_0or1row query "select * from crm_persone where persona_id = :persona_id limit 1"]
	if {$exist == 1} {
	    set i 0
	    while {$i == 0} {
		set max [db_string query "select max(persona_id) from crm_persone"]
		set random [db_string query "select trunc(random()*9+1)"]
		set persona_id [expr {$max + $random}]
		if {[db_0or1row query "SELECT * from crm_persone where persona_id = :persona_id limit 1"] == 0} {
		    set i 1
		}
	    }
	}
    	with_catch errmsg {
	    db_dml query "insert into crm_persone (persona_id, nome, sec_nome, cognome, albo_pf, partitaiva, societa_id, carica_id, codicefiscale, note) VALUES (:persona_id, :nome, :sec_nome, :cognome, :albo_pf, :piva, :societa_id, :carica_id, :codicefiscale, :nota)"} {
		ad_return_complaint 1 "<code>$errmsg</code>"
	    }
    } else {
	if {$conta == 2} {
	    with_catch errmsg {
		db_dml query "update "
	    }
	}
    #Aggiunge contatti: mail telefono cellulare eccetera
    if {$cellulare ne ""} {
	set primacifra [string index $cellulare 0]
	if {$primacifra == "0" || $primacifra == "+" || $primacifra == "3"} {
	    if {![db_0or1row query "SELECT * FROM crm_contatti limit 1"]} {
		set contatto_id [db_string query "SELECT TRUNC(RANDOM()*9+1)"]
	    } else {
		set contatto_id [db_string query "SELECT COALESCE(MAX(contatto_id) + (SELECT TRUNC(RANDOM()*9+1))) FROM crm_contatti"]
	    }
	    db_dml query "INSERT INTO crm_contatti (contatto_id, tipo_id, persona_id, valore) VALUES (:contatto_id, 2, :persona_id, :cellulare)"
	}
    }
    if {$telefono ne ""} {
        set primacifra [string index $telefono 0]
        if {$primacifra == "0" || $primacifra == "+"} {
            if {![db_0or1row query "SELECT * FROM crm_contatti limit 1"]} {
		set contatto_id [db_string query "SELECT TRUNC(RANDOM()*9+1)"]
            } else {
		set contatto_id [db_string query "SELECT COALESCE(MAX(contatto_id) + (SELECT TRUNC(RANDOM()*9+1))) FROM crm_contatti"]
            }
            db_dml query "INSERT INTO crm_contatti (contatto_id, tipo_id, persona_id, valore) VALUES (:contatto_id, 1, :persona_id, :telefono)"
        }
    }
    if {$email ne ""} {
        #Ciclo per vedere se l'email contiene chiocciole, punti e no spazi
	for {set i 0} {$i < [string length $email]} {incr i} {
	    if {[string index $email $i] == " "} {
		set punto 0
		break
	    }
	    if {[string index $email $i] == "@"} {
		for {set j $i} {$j > [string length $email]} {incr i} {
		    if {[string index $email $j] == "."} {
			set punto 1
			break
		    }
		}
	    }
	}
	if {![info exists punto]} {
	    set punto 0
	}
        if {$punto == 1} {
	    if {![db_0or1row query "SELECT * FROM crm_contatti limit 1"]} {
		set contatto_id [db_string query "SELECT TRUNC(RANDOM()*9+1)"]
            } else {
		set contatto_id [db_string query "SELECT COALESCE(MAX(contatto_id) + (SELECT TRUNC(RANDOM()*9+1))) FROM crm_contatti"]
            }
	    set email [string tolower $email]
	    db_dml query "INSERT INTO crm_contatti (contatto_id, tipo_id, persona_id, valore) VALUES (:contatto_id, 3, :persona_id, :email)"
	}
    }
    #aggiunge indirizzo uff se presente
    if {$indirizzo != ""} {
	set ufficio01 [db_0or1row query "select comune_id from comuni where lower(denominazione) ~ lower(:comune) limit 1"]
    } else {
	set ufficio01 0
    }
    #aggiunge indirizzo fatt se presente
    if {$indirizzofat != ""} {
	set fatturazione01 [db_0or1row query "select comune_id from comuni where lower(denominazione) ~ lower(:cittafat) limit 1"]
    } else {
	set fatturazione01 0
    }
    append message "- Inserita persona ID $persona_id (Nome: $nome - Cognome: $cognome)\n"
    if {$ufficio01 == 1} {
	if {[db_0or1row query "select indirizzo_id from crm_indirizzi limit 1"] == 0} {
	    set indirizzo_id 2
	    set comune_id [db_string query "select comune_id from comuni where lower(denominazione) ~ lower(:comune) limit 1"]
	    db_dml query "insert into crm_indirizzi (indirizzo_id, via, comune_id, persona_id) values (:indirizzo_id, :indirizzo, :comune_id, :persona_id)"
	} else {
	    set indirizzo_id [db_string query "select coalesce(max(indirizzo_id) + (select trunc(random()*9+1))) from crm_indirizzi"]
	    set comune_id [db_string query "select comune_id from comuni where lower(denominazione) ~ lower(:comune) limit 1"]
	    db_dml query "insert into crm_indirizzi (indirizzo_id, via, comune_id, persona_id) values (:indirizzo_id, :indirizzo, :comune_id, :persona_id)"
	}
    }
    if {$fatturazione01 == 1} {
	if {[db_0or1row query "select indirizzo_id from crm_indirizzi limit 1"] == 0} {
            set indirizzo_id 3
            set comune_id [db_string query "select comune_id from comuni where lower(denominazione) ~ lower(:cittafat) limit 1"]
            db_dml query "insert into crm_indirizzi (indirizzo_id, via, comune_id, persona_id) values (:indirizzo_id, :indirizzo, :comune_id, :persona_id)"
        } else {
	    set indirizzo_id [db_string query "select coalesce(max(indirizzo_id) + (select trunc(random()*9+1))) from crm_indirizzi"]
	    set comune_id [db_string query "select comune_id from comuni where lower(denominazione) ~ lower(:cittafat) limit 1"]
            db_dml query "insert into crm_indirizzi (indirizzo_id, via, comune_id, persona_id) values (:indirizzo_id, :indirizzo, :comune_id, :persona_id)"
	}
    }
    #aggiunta della persona agli eventi a cui ha partecipato
    for {set i 3} {$i < 45} {incr i} {
	if {[set e$i] ne ""} {
	    if {[string index [set e$i] 0] == "x"} {
		if {[db_0or1row query "select partecipazione_id from partecipazioni limit 1"] == 0} {
		    set partecipazione_id 2
		} else {
		    set partecipazione_id [db_string query "select coalesce(max(partecipazione_id)+ (select trunc(random()*9+1))) from partecipazioni"]
		}
		db_dml query "insert into partecipazioni (partecipazione_id, stato_id, evento_id, persona_id) values (:partecipazione_id, :persona_id, :i, 1)"
	    } else {
		if {[db_0or1row query "select partecipazione_id from partecipazioni limit 1"] == 0} {
                    set partecipazione_id 2
                } else {
                    set partecipazione_id [db_string query "select coalesce(max(partecipazione_id)+ (select trunc(random()*9+1))) from partecipazioni"]
                }
                db_dml query "insert into partecipazioni (partecipazione_id, stato_id, evento_id, persona_id) values (:partecipazione_id, :persona_id, :i, 2)"
	    }
	}
    } 
}
ad_progress_bar_end -url "index"
ad_script_abort
