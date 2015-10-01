declare @value varchar(max)
declare @result varchar(max)
--set @value = '  RUBEN        JULIO   '
set @value = '      MARIA      DE             LOS  ANGELES    '
--set @value = 'RUBEN'
--set @value = 'RUBEN JULIO'
set @result = replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')
select @result -- 'alpha beta'
select case when charindex(' ', @result) > 0 then LEFT(@result, charindex(' ', @result)) else @result end
      ,case when charindex(' ', @result) > 0 then RIGHT(@result, len(@result) - charindex(' ', @result)) else '' end
select case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then LEFT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a') end
      ,case when charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) > 0 then RIGHT(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'), len(replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a')) - charindex(' ', replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@value)),'a','aa'),'x','ab'),'  ',' x'),'x ',''),'x',''),'ab','x'),'aa','a'))) else '' end

	  
	  
	  
	  
	  
	  