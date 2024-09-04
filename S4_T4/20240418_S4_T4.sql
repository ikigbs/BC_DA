-- NIVELL 1 ---------------------------------------
-- EXERCICI 1
USE bbdd_tasca_4;
SELECT
u.*
FROM users u
WHERE u.id IN (
	SELECT
	t.user_id
	FROM transactions t
	GROUP BY t.user_id
	HAVING COUNT(t.user_id)>30);

-- EXERCICI 2
USE bbdd_tasca_4;
SELECT
c.iban,
AVG(t.amount)
FROM transactions t
INNER JOIN credit_card c ON t.card_id=c.id
WHERE t.business_id IN (SELECT c.company_id FROM companies c WHERE c.company_name='Donec Ltd')
GROUP BY c.iban;

-- NIVELL 2-------------------------------------------------------
-- EXERCICI 1
    
USE bbdd_tasca_4;
-- Creem una vista que s'anomena estat_targetes
	CREATE VIEW estat_targetes AS
    SELECT
    t_num_dec.card_id,
    IF (t_num_dec.num_declinades=3, 'No','Sí') Tar_Activa
    FROM (SELECT
		t_row_num.card_id,
		SUM(t_row_num.declined) num_declinades
		FROM (SELECT
			t1.card_id,
			t1.id,
			t1.timestamp,
			t1.declined,
			ROW_NUMBER() OVER (PARTITION BY t1.card_id ORDER BY t1.timestamp DESC) row_num
			FROM transactions t1) t_row_num
			WHERE t_row_num.row_num<=3
		 GROUP BY t_row_num.card_id) t_num_dec;
            
	-- EXERCICI 1
	USE bbdd_tasca_4;
	SELECT
    COUNT(*)
    FROM estat_targetes e
    WHERE e.Tar_Activa='Sí';
    
-- NIVELL 3 ------------------------------------
-- EXERCICI 1
USE bbdd_tasca_4;
CREATE TABLE IF NOT EXISTS products_ids (
id INT PRIMARY KEY,
product_name VARCHAR(50),
price VARCHAR(20),
colour VARCHAR(20),
weight DECIMAL(3,1),
warehouse_id  VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Entren les dades a products_ids mitjançant 20240415_Codi_sql_Introduir_dades_taula_products_ids.sql

-- A continuació l'objectiu serà crear una taula intermitja, per tal que poguem enllaçar-la amb la BBDD amb transactions i products_ids
-- La taula tindrà dues columnes i es dirà trans_x_product. Es a dir per una mateixa transacció podem tenir molts productes en files.
USE bbdd_tasca_4;
-- CREATE TABLE trans_x_product_aux 
CREATE TABLE trans_x_product
	WITH trans_x_product_aux_1 AS
	(SELECT 
	t.id,
	t.product_ids
	FROM transactions t),
-- el camp products_ids, que com a molt hem vist que només pot contenir 4 productes per transacció, el separem en diferents columnes
	trans_x_product_aux_2 AS 
	(SELECT
	t.id,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(t.product_ids, ',', 1), ',', -1)) AS valor_1,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(t.product_ids, ',', 2), ',', -1)) AS valor_2,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(t.product_ids, ',', 3), ',', -1)) AS valor_3,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(t.product_ids, ',', 4), ',', -1)) AS valor_4
	FROM trans_x_product_aux_1 t),
   -- Hem de convertir la consulta anterior en una taula de dues columnes
	trans_x_product_aux_3 AS
	(SELECT
	id,
	t.valor_1 
	FROM trans_x_product_aux_2 t
	UNION
	SELECT
	t.id,
	t.valor_2
	FROM trans_x_product_aux_2 t
	UNION
	SELECT
	t.id,
	t.valor_3
	FROM trans_x_product_aux_2 t
	UNION
	SELECT
	t.id,
	t.valor_4
	FROM trans_x_product_aux_2 t)
	SELECT
    t3.id,
    t3.valor_1 product_ids
    FROM trans_x_product_aux_3 t3
    ORDER BY t3.id;
	

ALTER TABLE trans_x_product MODIFY product_ids INT;
ALTER TABLE trans_x_product ADD PRIMARY KEY (id,product_ids);
-- Afegeixo les claus externes, encara que el nom de la clau externa me'l triarà ell
ALTER TABLE trans_x_product ADD FOREIGN KEY trans_x_product(id) REFERENCES transactions(id);
ALTER TABLE trans_x_product ADD FOREIGN KEY trans_x_product(product_ids) REFERENCES products_ids(id);
SHOW CREATE TABLE trans_x_product;

-- EXERCICI 1 ------
-- Número de vendes per cada producte
USE bbdd_tasca_4;
SELECT
t.product_ids,
COUNT(t.product_ids)
FROM trans_x_product t
GROUP BY 1
ORDER BY 1;







