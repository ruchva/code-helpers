ALTER FUNCTION dbo.fn_CharLTrim
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