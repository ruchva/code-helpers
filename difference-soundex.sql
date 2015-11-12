--sql server	
--grado de igualdad de cadenas

SELECT DIFFERENCE('smithers', 'smothers');--grado de similitud de 0 a 4, aplicar control de espacios en blanco
SELECT DIFFERENCE('smithers', 'ruchva');
SELECT DIFFERENCE('chiara', 'chura');

SELECT SOUNDEX('smith'), SOUNDEX ('smythe');--codigo de un conjunto de caracteres
SELECT SOUNDEX('smithers'), SOUNDEX ('smothers');
SELECT SOUNDEX('smithers'), SOUNDEX('ruchva');
SELECT SOUNDEX('chiara'), SOUNDEX('chura');

	
	
	