# 

ad_page_contract {
    
    Ciclo per merging da mailchimp_tmp a crm_persone
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-23
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

db_foreach query "select emailaddress from mailchimp_tmp" {
    if {[db_0or1row query "select * from crm_contatti where valore ilike '%:emailaddress%' limit 1"]} {
	# Fai cose di aggiormento
    } else {
	# Fai cose di inserimento
    }
}
