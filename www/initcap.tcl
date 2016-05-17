ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 19 February 2015
}
for {set i 0} {$i < 21594} {incr $i} {
    set persona_id [db_string query "SELECT persona_id FROM temporanea limit 1 offset :i"]
    set riga [db_string query "select nome||cognome||duplicato||albopf||cellulare||telefono||nota||ruolo||intermediario from temporanea limit 1 offset :i"]
    if {$persona_id == ""} {
	set random [db_string query "SELECT TRUNC(RANDOM()*9+1)"]
	set persona_id [expr {$i + $random}]
	db_dml query "update temporanea set persona_id + :random where nome||cognome||duplicato||albopf||cellulare||telefono||nota||ruolo||intermediario = :riga"
    }
    set conta [db_string query "select count(*) from temporanea where persona_id = :persona_id"]
    while {$conta > 1} {
	set random [db_string query "SELECT TRUNC(RANDOM()*9+1)"]
	db_dml query "update temporanea set persona_id = persona_id + :random where nome||cognome||duplicato||albopf||cellulare||telefono||nota||ruolo||intermediario = :riga" 
	set conta [db_string query "select count(*) from temporanea where persona_id = :persona_id"]
    }
}
ad_script_abort
