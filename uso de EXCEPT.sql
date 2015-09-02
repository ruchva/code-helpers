--USO DE EXCEPT INTRODUCCION:
--
--La operacion EXCEPT es una extensión del lenguaje SQL introducida en Microsoft SQL-Server a partir de la version 2005, y resulta muy útil en diversas labores.
--
--¿PARA QUE USAR EXCEPT?
--
--Consideremos la situación en que tenemos dos tablas del mismo nombre en dos bases de datos diferentes.  Por ejemplo, la misma tabla en una base de datos de pruebas y otra en la base de datos en producción.
--
--Ahora, para comprobar que los datos de prueba están actualizados, deseamos saber si hay CUALQUIER diferencia en los valores de CUALQUIERA de las columnas de las dos tablas.
--
--Dado que EXCEPT retorna "cualquier valor distinto de la consulta izquierda que no se encuentre en la consulta derecha", parece una buena situación para usar EXCEPT.
--
--Veamos

SELECT * FROM pruebas.dbo.Clientes
EXCEPT
SELECT * FROM produccion.dbo.Clientes

--Este es un buen inicio, pero si recordamos la especificacion del EXCEPT veremos que solo vamos a obtener los registros que estan en la tabla de pruebas para los cuales hay diferencias con respecto a la tabla en producción, pero NO veremos los registros en producción que no están en la tabla de pruebas.
--
--Para ello, podemos realizar una UNION como esta:

SELECT * FROM pruebas.dbo.Clientes
EXCEPT
SELECT * FROM produccion.dbo.Clientes

UNION

SELECT * FROM produccion.dbo.Clientes
EXCEPT
SELECT * FROM pruebas.dbo.Clientes

--Pera debido a que el operador UNION tiene precedencia sobre el EXCEPT, la operacion de UNION se realizar ANTES del EXCEPT y de nuevo obtendremos solo una parte de las diferencias.
--
--Corrijamos entonces esa construcción de esta forma:

SELECT * FROM

(SELECT * FROM pruebas.dbo.Clientes
EXCEPT
SELECT * FROM produccion.dbo.Clientes) AS IZQUIERDA

UNION

SELECT * FROM

(SELECT * FROM produccion.dbo.Clientes
EXCEPT
SELECT * FROM pruebas.dbo.Clientes) AS DERECHA

--Ahora si tendremos la lista completa de diferencias entre una y otra tabla.  Tendremos tanto las filas que tienen valores con diferencias, como las filas que están en una tabla pero no en la otra.
--
--Asi que esta consulta funciona correctamente, pero al ejecutarla notaremos que tenemos las diferencias, pero la consulta no nos indica de donde proviene.
--
--De modo que hacemos un último ajuste:

SELECT 'pruebas' AS origen,* FROM

(SELECT * FROM pruebas.dbo.Clientes
EXCEPT
SELECT * FROM produccion.dbo.Clientes) AS IZQUIERDA

UNION

SELECT 'produccion' AS origen,* FROM

(SELECT * FROM produccion.dbo.Clientes
EXCEPT
SELECT * FROM pruebas.dbo.Clientes) AS DERECHA

--Finalmente, tenemos una lista Ãºtil de todas las diferencias entre ambas tablas, debidamente identificadas.
--
--PRECAUCIONES:
--
--El uso de tablas que tengan una llave primaria mejora el desempeño de la sentencia EXCEPT.
--
--Además, las tablas deben tener la misma estructura (es decir, los campos deben tener los mismos nombres, ser del mismo tipo y estar en el mismo orden en ambas tablas).  Aunque hay pequeáas excepciones (por ejemplo, dos campos de tipo VARCHAR con el mismo nombre y diferente longitud pueden compararse sin problemas), es preferible garantizar esta igualdad.
--
--Para una absoluta garantía, tal vez valga la pena no utilizar "*" sino especificar la lista de campos de ambas tablas.
--
--Note que esto nos lleva a un punto interesante: el EXCEPT compara TODOS los campos incluidos en la consulta, pero no aquellos que se omitan.  De manera que podemos utilizar una consulta similar a la indicada solo para garantizar cosas como por ejemplo: que todos los códigos de clientes tengan el mismo nombre y dirección (aunque otros campos que existan en las tablas puedan ser diferentes).