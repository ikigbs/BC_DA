
/*-------------------NIVELL 1-----------------------------------------*/
/*EXERCICI 1 -----------------------------------------------*/
USE transactions;
SELECT 
t.*
FROM transaction t
WHERE t.company_ID IN 
	(SELECT 
	c.id
	FROM company c
	WHERE c.country='Germany');

/*EXERCICI 2 -----------------------------------------------*/
USE transactions;
SELECT
c.company_name
FROM company c
WHERE c.id IN (
	SELECT
	t.company_id
	FROM transaction t
	WHERE t.amount>(
	SELECT AVG(t.amount) FROM transaction t));

/*EXERCICI 3  -----------------------------------------------*/
USE transactions;
SELECT
t.*
FROM transaction t
WHERE t.company_id IN 
	(SELECT
	c.id
	FROM company c
	WHERE c.company_name LIKE 'c%');

/*EXERCICI 4 --------------------------------------------------*/
USE transactions;
SELECT
c.company_name
FROM company c
WHERE c.id NOT IN 
	(SELECT
	DISTINCT t.company_id
	FROM transaction t);

/*-------------------NIVELL 2-----------------------------------------*/
/*EXERCICI 1 -----------------------------------------------*/
USE transactions;
SELECT 
t.*
FROM transaction t
	WHERE t.company_id IN (
		SELECT c.id 
		FROM company c 
		WHERE c.country= 
			(SELECT c.country 
			FROM company c 
			WHERE c.company_name='Non Institute'));

/*EXERCICI 2 --------------------------------------------*/
USE transactions;
SELECT
c.company_name
FROM company c
WHERE c.id=
	(SELECT
	t.company_id
	FROM transaction t
	WHERE t.amount=(SELECT
	MAX(amount)
	FROM transaction t));
    
/*-------------------NIVELL 3-----------------------------------------*/
  
/*EXERCICI 1 -----------------------------------------------*/
USE transactions;
SELECT
c1.country
-- AVG(t1.amount) avg_amount
FROM transaction t1
INNER JOIN company c1 ON t1.company_id=c1.id
GROUP BY c1.country
HAVING AVG(t1.amount)>(SELECT AVG(t.amount)FROM transaction t)
ORDER BY AVG(t1.amount) DESC;
      

/*EXERCICI 2----------------------------------------------------------*/
USE transactions;
SELECT
trans_x_company.company_name,
IF(trans_x_company.count_trans>=4,'Sí','No')  'Empreses amb 4 o més transaccions'
FROM (SELECT
	c.company_name,
	COUNT(t.company_id) count_trans
	FROM transaction t
	INNER JOIN company c ON t.company_id=c.id
	GROUP BY c.company_name) trans_x_company;

-- Per mostrar quines companyies van tenir més de 4 transaccions.
USE transactions;
SELECT
c.company_name
	-- COUNT(t.company_id) count_trans
FROM transaction t
INNER JOIN company c ON t.company_id=c.id
GROUP BY c.company_name
HAVING COUNT(t.company_id)>=4;




