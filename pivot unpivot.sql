/*USO DE PIVOT Y UNPIVOT*/
--|colum1|colum2|
--| Act1 |  A	|
--| Act1 |  A	|     |  Act | A | B
--| Act2 |  B	|     | Act1 |A	 |B
--| Act2 |  A	|  => | Act2 |A	 |NULL
--| Act3 |  B	|	  | Act3 |A	 |B
--| Act3 |  A	|	  
--| Act3 |  B	|

/*
SELECT * FROM #piv_nuptipobenefic
--opcion 1
SELECT SELECCIONADO, 
[NULL] = (Select NUP FROM #piv_nuptipobenefic WHERE t.SELECT = action and SELEC IS NULL),
[CC]   = (Select NUP FROM #piv_nuptipobenefic WHERE t.SELECT = action and SELEC = 'CC'),
[PMM]  = (Select NUP FROM #piv_nuptipobenefic WHERE t.SELECT = action and SELEC = 'PMM'),
[PU]   = (Select NUP FROM #piv_nuptipobenefic WHERE t.SELECT = action and SELEC = 'PU')
FROM #piv_nuptipobenefic t
GROUP BY SELECCIONADO
	
--opcion 2
SELECT [Action], [View], [Edit] FROM
(SELECT [Action], view_edit FROM tbl) AS t1 
PIVOT (MAX(view_edit) FOR view_edit IN ([View], [Edit]) ) AS t2
*/

CREATE TABLE dbo.tbl (
    action VARCHAR(20) NOT NULL,
    view_edit VARCHAR(20) NOT NULL
);

INSERT INTO dbo.tbl (action, view_edit)
VALUES ('Action1', 'VIEW'),
       ('Action1', 'EDIT'),
       ('Action2', 'VIEW'),
       ('Action3', 'VIEW'),
       ('Action3', 'EDIT');

--DROP TABLE dbo.tbl       
SELECT action, view_edit FROM dbo.tbl

SELECT Action, 
[View] = (Select view_edit FROM tbl WHERE t.action = action and view_edit = 'VIEW'),
[Edit] = (Select view_edit FROM tbl WHERE t.action = action and view_edit = 'EDIT')
FROM tbl t
GROUP BY ACTION

SELECT [Action], [View], [Edit] FROM
(SELECT [Action], view_edit FROM tbl) AS t1 
PIVOT (MAX(view_edit) FOR view_edit IN ([View], [Edit]) ) AS t2

--EJEMPLO SQL AUTORIDAD
-- Creating Test Table
CREATE TABLE dbo.Product(Cust VARCHAR(25), Product VARCHAR(20), QTY INT)
GO
-- Inserting Data into Table
INSERT INTO dbo.Product(Cust, Product, QTY) VALUES('KATE','VEG',2)
INSERT INTO dbo.Product(Cust, Product, QTY) VALUES('KATE','SODA',6)
INSERT INTO dbo.Product(Cust, Product, QTY) VALUES('KATE','MILK',1)
INSERT INTO dbo.Product(Cust, Product, QTY) VALUES('KATE','BEER',12)
INSERT INTO dbo.Product(Cust, Product, QTY) VALUES('FRED','MILK',3)
INSERT INTO dbo.Product(Cust, Product, QTY) VALUES('FRED','BEER',24)
INSERT INTO dbo.Product(Cust, Product, QTY) VALUES('KATE','VEG',3)
GO
-- Selecting and checking entires in table
SELECT * FROM dbo.Product
GO
-- Pivot Table ordered by PRODUCT
SELECT PRODUCT, FRED, KATE
FROM (SELECT CUST, PRODUCT, QTY
	  FROM Product) up
PIVOT (SUM(QTY) FOR CUST IN (FRED, KATE)) AS pvt
ORDER BY PRODUCT
GO
-- Pivot Table ordered by CUST
SELECT CUST, VEG, SODA, MILK, BEER, CHIPS
FROM (SELECT CUST, PRODUCT, QTY
	  FROM Product) up
PIVOT (SUM(QTY) FOR PRODUCT IN (VEG, SODA, MILK, BEER, CHIPS)) AS pvt
ORDER BY CUST
GO
-- Unpivot Table ordered by CUST
SELECT CUST, PRODUCT, QTY
FROM
   (SELECT CUST, VEG, SODA, MILK, BEER, CHIPS
	FROM (
	SELECT CUST, PRODUCT, QTY
	FROM Product) up
	PIVOT (SUM(QTY) FOR PRODUCT IN (VEG, SODA, MILK, BEER, CHIPS)) AS pvt
   ) p
   UNPIVOT	(QTY FOR PRODUCT IN (VEG, SODA, MILK, BEER, CHIPS)) AS Unpvt
GO
-- Clean up database
DROP TABLE dbo.Product
GO