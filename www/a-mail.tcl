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

set body {{
    "key": "qyiG4vN3tJvbxJIdN1DwBQ",
    "message": {
        "html": "<p>Example HTML content</p>",
        "text": "Example text content",
        "subject": "example subject",
        "from_email": "info@pfexpo.it",
        "from_name": "PFEXPO",
        "to": [
            {
                "email": "mattia.righetti@professionefinanza.com",
                "name": "Mattia Righetti",
                "type": "to"
            }
        ],
        "important": false,
        "track_opens": null,
        "track_clicks": null,
        "auto_text": null,
        "auto_html": null,
        "inline_css": null,
        "url_strip_qs": null,
        "preserve_recipients": null,
        "view_content_link": null,
	"tracking_domain": null,
        "signing_domain": null,
        "return_path_domain": null,
        "merge": true,
        "merge_language": "mailchimp",
	"metadata": {
            "website": "www.pfexpo.it"
        },
    },
    "async": false,
    "ip_pool": "Main Pool",
}}
if {[util::json::validate $body]} {
    set json_request [util::http::post -body $body -url "https://mandrillapp.com/api/1.0/messages/send.json" -headers {Content-Type application/json}]
} else {
    set json_request [util::json::validate $body]
}
ad_return_complaint 1 $json_request
#[llength $json_request]
