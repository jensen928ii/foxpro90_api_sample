SET ESCAPE on
SELECT * FROM lang 
GO top
SCAN 
	lctemp = translate('test',code)
	SELECT translate
	APPEND BLANK
	REPLACE code WITH lang.code, ;
		c1before WITH 'test', ;
		c2after WITH lctemp, ;
		temp with lctemp
ENDSCAN
