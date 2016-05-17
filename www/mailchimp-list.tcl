ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 03 Devember 2014
}
set page_title "Lists - Mailchimp PF"
set context ""
db_dml query "delete from mailchimp_lists where 1=1"
set apikey "54d506beb4848e355c839f5e235f463b-us8"
set json_request [util::http::get -url "https://us8.api.mailchimp.com/3.0/lists/b0f25644de/members?apikey=$apikey"]
set json_request [string replace $json_request 0 5 ""]
set json_request [string reverse $json_request]
set json_request [string replace $json_request 0 32 ""]
set json_request [string reverse $json_request]
#db_dml query "insert into json_tmp values (1, :json_request)"
set data ""
set json_data [db_string query "select json_data->'data' from json_tmp"]
db_foreach query "select * from json_array_elements(:json_data)" {
    append data $value "<br>"
}
ad_return_template


