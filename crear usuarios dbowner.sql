USE SENASIR
CREATE USER [Vcostas] FOR LOGIN [SENASIR\VCostas] WITH DEFAULT_SCHEMA=[dbo]
ALTER AUTHORIZATION ON SCHEMAb_owner] TO [Vcostas]
EXEC sp_addrolemember N'SENASIR', N'Vcostas'
EXEC sp_addrolemember N'db_owner', N'Vcostas'
GO