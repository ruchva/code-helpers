CREATE FUNCTION [dbo].[eliminapuntos]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%.%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%.%', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminaLetras]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%[aA-zZ]%', @string)
     
    WHILE @IncorrectCharLoc > 0
    BEGIN
        
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%[aA-zZ]%', @string)
        
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminaespacios]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('% %', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('% %', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[fn_CharLTrim]  --elimina ceros a la izquierda
(
	@char       CHAR(1)
   ,@cadena     NVARCHAR(255)
)
RETURNS NVARCHAR(20)
AS
BEGIN
	DECLARE @posicion INTEGER
	SELECT  @posicion = PATINDEX('[' + @char + ']%' ,@cadena)
	WHILE   @posicion > 0
	BEGIN
	    SELECT @cadena = STUFF(@cadena,@posicion,1,'')
	    SELECT @posicion = PATINDEX('[' + @char + ']%' ,@cadena)
	END
	RETURN @cadena
END

--SELECT dbo.fn_CharLTrim('0','0000210215-152')

CREATE FUNCTION [dbo].[eliminaapostrofes]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%' + CHAR(39) + '%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%' + CHAR(39) + '%', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminaceros]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%0%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%0%', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminacoma]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%,%', @string)
     
    WHILE @IncorrectCharLoc > 0
    BEGIN
        
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%,%', @string)
        
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminamas] --elimina +
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%+%', @string)
     
    WHILE @IncorrectCharLoc > 0
    BEGIN
        
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%+%', @string)
        
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminanull]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%\0%', @string)
     
    WHILE @IncorrectCharLoc > 0
    BEGIN
        
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%\0%', @string)
        
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminarayas] --elimina -
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%-%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%-%', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminarayavert] --elimina |
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%|%', @string)
     
    WHILE @IncorrectCharLoc > 0
    BEGIN
        
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%|%', @string)
        
    END
    SET @string = @string
    RETURN @string
END


ALTER FUNCTION [dbo].[eliminasalto]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%' + CHAR(255)+ '%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%' + CHAR (255)+ '%', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminaSENASIR]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%SENASIR\%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 8, '')
        SET @IncorrectCharLoc = PATINDEX('%SENASIR\%', @string)
    END
    SET @string = @string
    RETURN @string
END

--select dbo.eliminaSENASIR ('SENASIR\vivi')


CREATE FUNCTION [dbo].[eliminaslash]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%/%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%/%', @string)
    END
    SET @string = @string
    RETURN @string
END


ALTER FUNCTION [dbo].[fn_DividirCadena]
(
	@nombre as varchar(100)-- ingreso de la cadena
)
RETURNS varchar(100)-- retorno de la cadena
AS
BEGIN
	declare @seg_nombre as varchar(100) --  variable para la partición 

	set @seg_nombre = (case when patindex('% %',rtrim(ltrim(@nombre)))>0 
							then ltrim(rtrim(substring(rtrim(ltrim(@nombre)),patindex('% %',rtrim(ltrim(@nombre)))+1,len(rtrim(ltrim(@nombre)))))) 
							else null 
						end)

	return @seg_nombre

END


ALTER FUNCTION [dbo].[fn_primera_candena]
(
	@nombre as varchar(100)
)
RETURNS varchar(80)
AS
BEGIN
	declare @pri_nombre as varchar(80)

	set @pri_nombre = 	(case when patindex('% %',rtrim(ltrim(@nombre)))>0 
							then substring(rtrim(ltrim(@nombre)),1,patindex('% %',rtrim(ltrim(@nombre)))-1) 
							else rtrim(ltrim(@nombre))
						end)

	return @pri_nombre

END


ALTER FUNCTION [dbo].[fn_pri_nombrePIPE]
(
	@nombre as varchar(45)
)
RETURNS varchar(20)
AS
BEGIN
	declare @pri_nombre as varchar(20)

	set @pri_nombre = 	(case when patindex('%|%',rtrim(ltrim(@nombre)))>0 
							then substring(rtrim(ltrim(@nombre)),1,patindex('%|%',rtrim(ltrim(@nombre)))-1) 
							else rtrim(ltrim(@nombre))
						end)

	return @pri_nombre

END


ALTER FUNCTION [dbo].[fn_seg_nombrePIPE]
(
	@nombre as varchar(45)-- ampliar a 45
)
RETURNS varchar(35)---se amplia de 20 a 35
AS
BEGIN
	declare @seg_nombre as varchar(35) -- ampliar  35

	set @seg_nombre = (case when patindex('%|%',rtrim(ltrim(@nombre)))>0 
							then ltrim(rtrim(substring(rtrim(ltrim(@nombre)),patindex('%|%',rtrim(ltrim(@nombre)))+1,len(rtrim(ltrim(@nombre)))))) 
							else null 
						end)

	return @seg_nombre

END



























