* curl "https://api.twilio.com/2010-04-01/Accounts/AC95e3f0ff284109ce344b169d4d64e2d2/Messages.json" -X POST --data-urlencode "To=+14089211043" --data-urlencode "From=+17036888225" --data-urlencode "Body=test" --data-urlencode "ApplicationSid=APe31b98af8c5b9f7e7e6d8e6819aa344b" -u AC95e3f0ff284109ce344b169d4d64e2d2:859a357ffa9e54aae9c460e130735a29

Use william
Do wwhttp
loHttp = Createobject("wwHttp")
loHttp.cContentType = "application/x-www-form-urlencoded"
loHttp.cHttpVerb = "POST"
loHttp.AppendHeader("Authorization","Basic " + Strconv(william.accountsid+ ':' + william.authtoken,13))

lcjson = ''
loHttp.AddPostKey("To","+14089211043")
loHttp.AddPostKey("Body",'this is a test')
loHttp.AddPostKey("From","17036888225")
loHttp.AddPostKey("ApplicationSid","APe31b98af8c5b9f7e7e6d8e6819aa344b")
lcjson = loHttp.Post("https://api.twilio.com/2010-04-01/Accounts/" + ;
	william.accountsid + ;
	"/Messages.json")
?lcjson

*!*	If loHttp.cresultcode = '201'
*!*		Replace _error With .F.
*!*	Else
*!*		Replace _error With .T., _errormsg With lcjson
*!*	Endif
*!*	Replace _countsms With _countsms + 1, _sentsms With .T.
