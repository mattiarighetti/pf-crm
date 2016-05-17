ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 03 Devember 2014
} {
    id
}
set page_title "Members - Mailchimp PF"
set context ""
#db_dml query "delete from mailchimp_members where 1=1"
set apikey "54d506beb4848e355c839f5e235f463b-us8"
set json_request [util::http::get -url "https://us8.api.mailchimp.com/2.0/lists/members?apikey=$apikey&id=$id"]
set json_request [string replace $json_request 0 5 ""]
set json_request [string reverse $json_request]
set json_request [string replace $json_request 0 32 ""]
set json_request [string reverse $json_request]
#set json_request [json::json2dict $json_request]
#set json_request_data [dict get $json_request data]
#dict for {dict1 dict2} $json_request_data {
#    dict for {key value} $dict1 {
	


#	if {$key == "id"} {
#	    set list_id $value
#	    db_dml query "insert into mailchimp_lists (id) values (:value)"
#	} else {
#	    set key [string trim $key "'"]
#	    db_dml query "update mailchimp_lists set $key = :value where id = :list_id"
#	} 
#  }
#  dict for {key value} $dict2 {
#	if {$key == "id"} {
#            set list_id $value
#            db_dml query "insert into mailchimp_lists (id) values (:value)"
#        } else {
#	    set key [string trim $key "'"]
#            db_dml query "update mailchimp_lists set $key = :value where id = :list_id"
#        }
#    }
#}
set html $json_request
template::list::create \
    -name lists \
    -multirow lists \
    -elements {
        id {
            label "ID"
        }
        name {
            label "Nome"
        }
	date_created {
	    label "Data creazione"
	}
        edit {
            link_url_col edit_url
            display_template {<img src="images/edit.gif" height="12" border="0">}
            link_html {title "Modifica anagrafica paese"}
            sub_class narrow
        }
    } 
db_multirow \
    -extend {
        edit_url
    } lists query "SELECT id, name, date_created FROM mailchimp_lists" {
        set edit_url [export_vars -base "paesi-gest" {id}]
    }


