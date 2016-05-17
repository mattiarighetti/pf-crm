# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-01-18
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

proc jsonget {json args} {
    foreach key $args {
        if {[dict exists $json $key]} {
            set json [dict get $json $key]
        } elseif {[string is integer $key]} {
	    if {$key >= 0 && $key < [llength $json]} {
		set json [lindex $json $key]
            } else {
                error "can't get item number $key from {$json}"
	    }
        } else {
            error "can't get \"$key\": no such key in {$json}"
	}
    }
    return $json
}
	    
set apikey "54d506beb4848e355c839f5e235f463b-us8"
set json_request [util::http::get -url "https://us8.api.mailchimp.com/3.0/lists?apikey=$apikey"]
set json_request [dict get $json_request page]
#set json_request [util::json::object::create $json_request]
#set json_request [util::json::object::get_value -object $json_request -attribute lists]
#set json_request [util::json::parse $json_request]
#set json_request [util::json::object::get_values $json_request]
set json_request [::json::json2dict $json_request]
set json_request [dict get $json_request lists]
#foreach {mclist} $json_request {
 #   set html "</br><table border=1>"
  #  dict for {key value} $mclist {
#	append html "<tr><td>" $key "</td><td>" $value "</td></tr>"
#    }
#}
set html [llength $json_request]
#set json_request [jsonget $json_request page]

#set json_request [jsonget $json_request lists]
ad_return_complaint 1 $html
#$json_request
#[llength $json_request]
