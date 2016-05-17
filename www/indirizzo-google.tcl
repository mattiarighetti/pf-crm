ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} 
set indirizzo "via giuseppe verdi 13, volta mantovana"
set indirizzo_html [string map {" " +} $indirizzo]
#Controlla indirizzo e sostituisce con dati Google Maps                                                                                                                                                     
set google_api_response [util::http::get -url https://maps-api-ssl.google.com/maps/api/geocode/json?key=AIzaSyATmOxNeOSX2bwDvduCTbhbf-EEwnCgzsQ&address=$indirizzo_html]
set html "Google api: <br><br><code>$google_api_response</code><br><br>"
#set google_api_response [string replace $google_api_response 0 5 ""]
#set google_api_response [string reverse $google_api_response]
#set google_api_response [string replace $google_api_response 0 32 ""]
#set google_api_response [string reverse $google_api_response]
#append html "Parsed Google api: <br><br><code>$google_api_response</code><br><br>"
set json [dict get $google_api_response page]
append html "Dict results: <br><br><code>$json</code><br><br>"
set json [string replace $json 0 1 ""]
#set json [dict get $json results]
append html "Results: <br><br><code>$json</code><br><br>"

#set results [util::json::object::get_value -object $google_api_response -attribute "results"]
#append html "Results: <br><br><code>$results</code><br><br>"
#set address_components [util::json::object::get_value -object $results -attribute "address_components"]
#append html"Address components: <br><br><code>$address_components</code><br><br>"
ad_return_template
