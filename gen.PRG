
SET PROCEDURE TO gen ADDITIVE 

FUNCTION picklang
IF NOT USED('lang')
	USE lang IN 0 
ENDIF
SELECT lang
SCAN
TEXT TO lctemp TEXTMERGE ADDITIVE noshow
<a href="https://insurance195.com/default.i195?code=<<code>>">
    <<language>>
</a>
ENDTEXT
ENDSCAN
RETURN lctemp

ENDFUNC


FUNCTION translate
LPARAMETERS tcwhat2, tccode

IF EMPTY(tcwhat2)
	RETURN ''
ELSE
	tcwhat2 = STRTRAN(ALLTRIM(tcwhat2),"'","")
	IF NOT USED('translate')
		USE translate IN 0 
	ENDIF
	IF NOT USED('lang')
		USE lang IN 0 
	ENDIF 
ENDIF

IF EMPTY(tccode) 
	IF VARTYPE(session)='O'
		tccode = Session.getsessionvar('code')
	ELSE

*jlee
*!*			tccode = 'zh-hant'
		tccode = ''
	ENDIF
ELSE
	SELECT lang
	LOCATE FOR code = tccode
	IF NOT FOUND()
		tccode = ''
	ENDIF
ENDIF

IF EMPTY(tccode)	
	SELECT lang
	LOCATE FOR default
	IF FOUND()
		tccode = code 
	ELSE
		RETURN tcwhat2 
	ENDIF
ENDIF

LOCAL lcreturn 
lcreturn = ''

SELECT translate
LOCATE FOR c1before = SUBSTR(tcwhat2,1,240) ;
	AND code = tccode
IF NOT FOUND()
	APPEND BLANK 
	replace c2before WITH tcwhat2, ;
		c1before WITH tcwhat2, ;
		code WITH tccode
	LOCAL lcjson
	TEXT TO lcjson NOSHOW textmerge
	[{
		'Text':'<<tcwhat2>>'
	}]
	ENDTEXT

	DO wwsmtp
	DO wwjsonserializer
	DO wwhttp

	loSer = CREATEOBJECT("wwJsonSerializer")
	loHttp = CREATEOBJECT("wwHttp")

	*darrin
*!*		lohttp.appendheader("Ocp-Apim-Subscription-Key","68c6af1d9b824418b71b49a9db6ddf0e")
	lohttp.appendheader("Ocp-Apim-Subscription-Key","5fbe9df6e2cb495aa73a4f4112887d39")

	*william
	* lohttp.appendheader("Ocp-Apim-Subscription-Key","ce202f86eb0a45e9b4b20f7ebcb858b3")

	lohttp.appendheader("Ocp-Apim-Subscription-Region","eastus")
	lohttp.appendheader("Content-Type","application/json")
	lohttp.appendheader("Host","api.cognitive.microsofttranslator.com")
	lohttp.appendheader("Content-Length",TRANSFORM(LEN(lcjson)))
	lohttp.cHttpVerb = 'POST'
	lohttp.addPostKey(lcjson)

	* lcjson = loHttp.httpGet("https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=zh-Hant")
	* lcjson = loHttp.httpGet("https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=yue")
	lcjson = loHttp.httpGet("https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to="+tccode)

	IF 'error' $ LOWER(lcjson)
		RETURN RTRIM(c2before)
	ELSE
	
		lcjson = STRCONV(lcjson,11)
		lcjson = substr(lcjson,2,LEN(lcjson)-2)
		loResult = loSer.DeserializeJson(lcjson)
		IF NOT ISNULL(loResult)
			replace c2after WITH loresult.translations[1].text
		ENDIF
	ENDIF
ENDIF

lcreturn = RTRIM(c2after)
RETURN lcreturn 

ENDFUNC
