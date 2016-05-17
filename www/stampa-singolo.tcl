ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    badge:integer
}
set iscritto_id [db_string query "SELECT iscritto_id FROM pf_expo_iscr WHERE barcode = :badge"]
set nome [db_string query "SELECT INITCAP(LOWER(nome)) FROM pf_expo_iscr WHERE iscritto_id = :iscritto_id"]
set cognome [db_string query "SELECT INITCAP(LOWER(cognome)) FROM pf_expo_iscr WHERE iscritto_id = :iscritto_id"]
set eventi "<font face=\"Helvetica\" align=\"left\" size=\"2px\">"
set sigle "<font face=\"Helvetica\" align=\"left\" size=\"3px\">"
db_foreach query "SELECT evento_id, TO_CHAR(data, 'dd') AS data, pagato FROM pf_expo_iscrizioni WHERE iscritto_id = :iscritto_id ORDER BY evento_id" {
    append eventi "<br> -&nbsp;"
    append eventi [db_string query "SELECT descrizione FROM pf_expo_eventi WHERE evento_id = :evento_id"]
    if {$pagato == "t" || $pagato == "" && $data < 29} {
        append sigle " "
        append sigle [db_string query "SELECT sigla FROM pf_expo_eventi WHERE evento_id = :evento_id"]
    }

}
append eventi "</font>"
set barnum [expr {9780000 + $iscritto_id}]
with_catch error_msg {
    exec barcode -b $barnum -o /usr/share/openacs/packages/pfexpo/www/barcode/bg-gen/$barnum.eps -e EAN-8 -g 125x100 -p 126x101mm -E
} {
    ad_return_complaint 1 "Si è verificato un errore. Ci dispiace. La invito a riportarmi l'errore a <a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>.<br><br>L'errore riportato è:<br><code>$error_msg</code>"
}
with_catch error_msg {
    exec convert /usr/share/openacs/packages/pfexpo/www/barcode/bg-gen/$barnum.eps /usr/share/openacs/packages/pfexpo/www/barcode/bg-gen/$barnum.jpg
} {
    ad_return_complaint 1 "Si è verificato un errore. Ci dispiace. La invito a riportarmi l'errore a <a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>.<br><br>L'errore riportato è:<br><code>$error_msg</code>"
}
set html "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
  <head>
    <title>Badge PFEXPO15 - Milano.pdf</title>
  </head>
  <body>
    <table align=\"center\" height=\"90em\" width=\"640em\">
      <tr height=\"1%\" bgcolor=\"#194B82\" width=\"640em\">
        <td colspan=\"2\" align=\"center\" width=\"320em\" border=1>
          <img src=\"http://www.pfexpo.it/img2014mi/logo15.png\" width=\"18%\" height=\"8%\"align=\"center\">
        </td>
        <td width=\"320em\">
          <br><font color=\"#ffffff\" face=\"Helvetica\" align=\"left\"><b>Eventi a cui sei iscritto:</b></font><br>
        </td>
      </tr>
      <tr height=\"75%\"> 
        <td align=\"center\">
          <font face=\"Helvetica\" size=\"6px\">$nome<br>$cognome</font> 
        <p>$sigle</p>
        </td>
        <td align=\"center\">
          <img src=\"/usr/share/openacs/packages/pfexpo/www/barcode/bg-gen/$barnum.jpg\" height=\"12%\"></img>
</td>
        <td>
          $eventi
        </td>
      </tr>
      <tr height=\"0.2em\" bgcolor=\"#194B82\" colspan=\"3\">
        <td>&nbsp;</td>
      </tr>
    </table>
    <br><br>
    <h2 align=\"center\"><font face=\"Helvetica\" color=\"#194B82\"><u>Come piegare il badge</u></font></h2><br>
    <center><img src=\"http://app.mattiarighetti.it/pfexpo/images/badge-fold.png\" height=\"25%\"></center>
  </body>
</html>
"
set filenamehtml "/tmp/badge-print.html"
set filenamepdf  "/tmp/badge-print.pdf"
set file_html [open $filenamehtml w]
puts $file_html $html
close $file_html
with_catch error_msg {
    exec htmldoc --portrait --webpage --header ... --footer ... --quiet --left 0.5cm --right 0.5cm --top 0.5cm --bottom 0.5cm --charset utf-8 --fontsize 12 -f $filenamepdf $filenamehtml
} {
    ns_log notice "errore htmldoc <code>$error_msg</code>"
}
ns_returnfile 200 application/pdf $filenamepdf
ns_unlink $filenamepdf
ns_unlink $filenamehtml
ad_script_abort