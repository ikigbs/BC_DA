-- NIVELL 1 --------------------------------------
-- EXERCICI 1 
USE transactions;
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(8) PRIMARY KEY,
    iban VARCHAR(50) NOT NULL,
    pan VARCHAR(19) NOT NULL,
    pin SMALLINT NOT NULL,
    cvv SMALLINT NOT NULL,
    /*Por que los datos que insertamos no son formato fecha*/
    expiring_date VARCHAR(8) NOT NULL
);
SHOW CREATE TABLE credit_card;

-- EXERCICI 1 (Modificació expiring_date de VARCHAR a DATE)
USE transactions;
ALTER TABLE credit_card RENAME COLUMN expiring_date to expiring_date_old;
ALTER TABLE credit_card ADD COLUMN expiring_date DATE;
-- Sinó UPDATE falla, ya que no utiliza una condicion WHERE
SET SQL_SAFE_UPDATES=0;
UPDATE credit_card SET expiring_date=STR_TO_DATE(expiring_date_old, '%m/%d/%YY');
ALTER TABLE credit_card  DROP COLUMN expiring_date_old;
-- Restablecemos el UPDATE SAFE como teníamos.
SET SQL_SAFE_UPDATES=1;

-- EXERCICI 1 (Crear relació entre credit_card i transaction)
USE transactions;
ALTER TABLE transaction ADD CONSTRAINT fk_credit_card_id FOREIGN KEY transaction(credit_card_id) REFERENCES credit_card(id);

USE transactions;
SHOW CREATE TABLE transaction;

-- EXERCICI 2 

UPDATE credit_card
SET iban='R323456312213576817699999'
WHERE id='CcU-2938';

-- EXERCICI 3 (Solució definitiva)
USE transactions;
ALTER TABLE credit_card MODIFY expiring_date DATE NULL;

USE transactions;
INSERT INTO company
(id,company_name,phone,email,country,website)
VALUES ('b-9999',NULL, NULL, NULL, NULL,NULL);
INSERT INTO credit_card
(id,iban,pan,pin,cvv,expiring_date)
VALUES ('CcU-9999','', '',-1,-1,NULL);
SHOW CREATE TABLE credit_card;

USE transactions;
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) VALUES 
('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, NULL,111.11, 0);

USE transactions;
SELECT * FROM transaction t
WHERE t.id='108B1D1D-5B23-A76C-55EF-C568E49A99DD';

-- EXERCICI 4
USE transactions;
ALTER TABLE credit_card DROP COLUMN pan;

SELECT * FROM transactions.credit_card;

-- NIVELL 2 ---------------------------------------
-- EXERCICI 1
USE transactions;
SELECT
*
FROM transaction t
WHERE t.id='02C6201E-D90A-1859-B4EE-88D2986D3B02';
DELETE FROM transaction WHERE (id = '02C6201E-D90A-1859-B4EE-88D2986D3B02');

-- EXERCICI 2 (Codi per crear la vista de l'exercici 2)
USE transactions;
SELECT
c.company_name Nom_companyia,
c.phone Telefon,
c.country País,
AVG(t.amount) Mitja_compra_realitzada
FROM transaction t
INNER JOIN company c ON t.company_id=c.id
GROUP BY t.company_id
ORDER BY Mitja_compra_realitzada DESC;

-- EXERCICI 2 (Codi per crear directament la vista de l'exercici 2)
USE transactions;
CREATE VIEW vistamarketing AS
SELECT
c.company_name Nom_companyia,
c.phone Telefon,
c.country País,
AVG(t.amount) Mitja_compra_realitzada
FROM transaction t
INNER JOIN company c ON t.company_id=c.id
GROUP BY t.company_id
ORDER BY Mitja_compra_realitzada DESC;

-- EXERCICI 3
USE transactions;
SELECT * FROM vistamarketing v
WHERE v.País='Germany';

-- NIVELL 3 -------------------------------------
-- EXERCICI 1
USE transactions;
-- Creo la taula user executant estructura_datos_user
-- Elimino la clau externa user_ibfk_1 de la taula user
ALTER TABLE user DROP FOREIGN KEY user_ibfk_1;
-- Executo la consulta datos_introducir_user.sql
-- Canvio el nom email a personal_email
ALTER TABLE user RENAME COLUMN email TO personal_email; 

USE transactions;
SELECT
*
FROM user;
-- Intento afegir clau externa a user_id respecte id de la taula user però falla
ALTER TABLE transaction ADD CONSTRAINT fk_user_id FOREIGN KEY transaction(user_id) REFERENCES user(id);

-- Això no caldria. Miro quants user_id de la taula transaction no estan a la taula user.
USE transactions;
SELECT
u.id,
t.user_id
FROM user u
LEFT JOIN transaction t ON u.id=t.user_id
WHERE t.user_id IS NULL;

-- Miro quants user_id de la taula transaction no estan a la taula user
USE transactions;
SELECT
u.id,
t.user_id
FROM user u
RIGHT JOIN transaction t ON u.id=t.user_id
WHERE u.id IS NULL;

-- Inserto l'element que està en la taula transaction i no està a la taula user
USE transactions;
INSERT INTO user
(id,name,surname,phone,personal_email,birth_date,country,city,postal_code,address)
VALUES
(9999,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

-- Intento afegir clau externa a user_id respecte id de la taula user però falla
ALTER TABLE transaction ADD CONSTRAINT fk_user_id FOREIGN KEY transaction(user_id) REFERENCES user(id);

USE transactions;
SHOW CREATE TABLE transaction;

-- Comprovació taula company
USE transaction;
SHOW CREATE TABLE company;

-- Elimino columna website
USE transactions;
ALTER TABLE company DROP COLUMN website;

-- Comprovacions taula transaction
USE transactions;
SHOW CREATE TABLE transaction;

-- Comprovacions taula credit_card
USE transactions;
SHOW CREATE TABLE credit_card;

USE transactions;
ALTER TABLE credit_card MODIFY id VARCHAR(20) NOT NULL;
ALTER TABLE credit_card MODIFY pin VARCHAR(4) NOT NULL;
ALTER TABLE credit_card MODIFY cvv INT NOT NULL;

-- Per veure si perdo valors al canviar el pin de SMALLINT a VARCHAR(4)
USE transactions;
SELECT
COUNT(*)
FROM credit_card c
WHERE LENGTH(c.pin)=4;

-- Modificar expiring_date de tipus DATE a VARCHAR(10)
USE transactions;
ALTER TABLE credit_card RENAME COLUMN expiring_date TO expiring_date_old;
ALTER TABLE credit_card ADD COLUMN expiring_date VARCHAR(10);
-- Si no faig la instrucció següent UPDATE falla, ja que sinó necessitaria un WHERE
SET SQL_SAFE_UPDATES=0;
UPDATE credit_card SET expiring_date=DATE_FORMAT (expiring_date_old, '%m/%d/%Y');
ALTER TABLE credit_card DROP expiring_date_old;
SET SQL_SAFE_UPDATES=1;

-- Afegir fecha_actual de tipus DATE i per defecte NULL 
USE transactions;
ALTER TABLE credit_card ADD COLUMN fecha_actual DATE NULL;
SET SQL_SAFE_UPDATES=0;
UPDATE credit_card SET fecha_actual=CURDATE();
SET SQL_SAFE_UPDATES=1;
SHOW CREATE TABLE credit_card;













