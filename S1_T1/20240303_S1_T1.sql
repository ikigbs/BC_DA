/*---------------------SCRIPTS DELS EXERCICIS CORRESPONENT AL NIVELL 1----------*/
USE transactions;
/*EXERCICI 1--------------------------------------------------------------------*/
/*No s'afegeixen els scripts de creació de taules i d'insertar dades, 
ja que es troben a l'enunciat*/

/*EXERCICI 2--------------------------------------------------------------------*/
SELECT
company_name,
email,
country
FROM company
ORDER by company_name;

/*EXERCICI 3--------------------------------------------------------------------*/
SELECT
DISTINCT country
FROM transaction
INNER JOIN company ON
transactions.company.id=transactions.transaction.company_id;

/*EXERCICI 4--------------------------------------------------------------------*/
SELECT
COUNT(DISTINCT country)
FROM transaction
INNER JOIN company ON
transactions.company.id=transactions.transaction.company_id;

/*EXERCICI 5--------------------------------------------------------------------*/
SELECT
country,
company_name
FROM transactions.company
WHERE id='b-2354';


/*Aquesta consulta sql respont l'Exercici 6 del Nivell 1*. Es una consulta auxiliar, per verificar
que la mitjana la calcula sobre els elements repetits que es troben a la consulta transaccions. No és
la solució, és per verificar/
SELECT
company_id,
company_name,
sum(amount),
count(company_id),
AVG(amount)
FROM transactions.transaction
INNER JOIN company ON
transactions.company.id=transactions.transaction.company_id
GROUP BY company_id
ORDER BY AVG(amount) DESC;

/*EXERCICI 6--------------------------------------------------------------------*/
SELECT
company_name,
AVG(amount)
FROM transaction
INNER JOIN company ON
transactions.company.id=transactions.transaction.company_id
GROUP BY company_id
ORDER BY AVG(amount) DESC;

/*---------------------SCRIPTS DELS EXERCICIS CORRESPONENT AL NIVELL 2----------*/
/*EXERCICI 1--------------------------------------------------------------------*/
SELECT
id,
count(id) as count_id
FROM transactions.company
GROUP BY id
ORDER BY count_id DESC;

/*EXERCICI 1 (Solució Variant)--------------------------------------------------------------------*/
/*SELECT
id,
count(id) count_id
FROM transactions.company
GROUP BY id
HAVING COUNT(id)>1;*/

/*EXERCICI 2 auxiliar------------------------------------------------------------------------------------*/
/*SELECT
t.timestamp,*/
/*CONVERT(DATE, t.timestamp) date_timestamp Preguntar perquè no funciona*/
/*CONVERT(VARCHAR(8),t.timestamp,112) date_timestamp Preguntar perquè no funciona*/
/*CAST(t.timestamp as DATE)
FROM transactions.transaction t;*/

/*EXERCICI 2 ------------------------------------------------------------------------------------*/
SELECT
CAST(t.timestamp as DATE) fecha_sin_hora,
COUNT(user_id),
SUM(amount) suma_transaccions
FROM transaction t
GROUP BY fecha_sin_hora
HAVING COUNT(user_id)>=5
ORDER by suma_transaccions DESC;

/*EXERCICI 2 Detall del dia de 5 ventes més costoses------------------------ ---------------------*/
/*SELECT
t.*
FROM 
(SELECT 
CAST(t.timestamp as DATE)  fecha_sin_hora,
user_id,
amount
FROM transaction t
WHERE CAST(t.timestamp as DATE) ='20210509') T
ORDER BY t.amount DESC;/*

/*EXERCICI 3 ------------------------------------------------------------------------------------*/
SELECT
CAST(t.timestamp as DATE) fecha_sin_hora,
COUNT(user_id),
SUM(amount) suma_transaccions
FROM transaction t
GROUP BY fecha_sin_hora
HAVING COUNT(user_id)>=5
ORDER by suma_transaccions;

/*EXERCICI 3 Detall del dia de 5 vendes menors---------------------------------------------------*/
SELECT
t.*
FROM 
(SELECT 
CAST(t.timestamp as DATE)  fecha_sin_hora,
user_id,
amount
FROM transaction t
WHERE CAST(t.timestamp as DATE) ='20210706') t
ORDER BY t.amount;

/*EXERCICI 4 -----------------------------------------------------------------*/
SELECT
country,
/*count(user_id) num_transaccions,*/
/*SUM(amount) despesa_total_transaccions,*/
AVG(amount) despesa_mitjana_transaccions
FROM transaction
INNER JOIN company on
transaction.company_id=company.id
GROUP BY country
ORDER by AVG(amount) DESC;

/*EXERCICI 4 Per comprovar que l'ordre de les taules no importa----------------*/
/*SELECT
country,
count(user_id) num_transaccions,
SUM(amount) despesa_total_transaccions,
AVG(amount) despesa_mitjana_transaccions
FROM company
INNER JOIN transaction on
transaction.company_id=company.id
GROUP BY country
ORDER by AVG(amount) DESC;*/

/*-----------------NIVELL 3----------------------------------------------------*/
/*EXERCICI 1-------------------------------------------------------------------*/
SELECT
t.company_name,
t.phone,
t.country,
SUM(amount)
FROM (SELECT
company_name,
phone,
country,
amount
FROM transaction
INNER JOIN company ON
transaction.company_id=company.id
WHERE amount BETWEEN 100 AND 200
ORDER BY company_name DESC) t
GROUP BY t.company_name,t.phone, t.country
ORDER BY SUM(amount) DESC;

/*EXERCICI 2-------------------------------------------------------------------*/
SELECT
DISTINCT company_name
FROM transaction t
INNER JOIN company c ON
t.company_id=c.id
WHERE CAST(t.timestamp as DATE) ='20220316' OR CAST(t.timestamp as DATE) ='20220228' OR CAST(t.timestamp as DATE) ='20220213';

