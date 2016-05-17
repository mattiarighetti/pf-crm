ad_page_contract {}
    set subject "my subject"

    set message "<b>Bold</b> not bold"

set from_addr "mattia.righetti@professionefinanza.com"

    set to_addr "mattiarighe@me.com"

    # the from to html closes any open tags.
set message_html [ad_html_text_convert -from html -to html $message]

    # some mailers chop off the last few characters.
    append message_html "   "
set message_text [ad_html_text_convert -from html -to text $message]
        
set message_data [build_mime_message $message_text $message_html]
    
set extra_headers [ns_set new]

ns_set put $extra_headers MIME-Version [ns_set get $message_data MIME-Version]
ns_set put $extra_headers Content-ID [ns_set get $message_data Content-ID]
ns_set put $extra_headers Content-Type [ns_set get $message_data Content-Type]
set message [ns_set get $message_data body]
    
acs_mail_lite::send \
    -send_immediately \
asdf 
   -to_addr $to_addr \
    -from_addr $from_addr \
    -subject $subject \
    -body $message \
    -extraheaders $extra_headers
