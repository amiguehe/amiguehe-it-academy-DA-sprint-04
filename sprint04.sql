USE sprint;
SELECT * FROM companies;
SELECT * FROM credit_cards;
SELECT * FROM products;
SELECT * FROM transactions;
SELECT * FROM users;

#ex 1


SELECT users.name, users.surname, users.id, COUNT(transactions.user_id) AS ct, SUM(amount)
FROM transactions
INNER JOIN users ON users.id = user_id
GROUP BY users.name, users.surname, users.id, transactions.user_id
HAVING ct>=30
ORDER BY ct DESC; 

SELECT COUNT(user_id) AS total_orders, SUM(amount), users.name, users.surname, users.id
FROM transactions 
INNER JOIN users ON users.id = user_id
GROUP BY users.name, users.surname, users.id, transactions.user_id
HAVING COUNT(transactions.user_id) >= 30;


#ex 2

SELECT iban, AVG(amount), transactions.card_id, credit_cards.user_id, transactions.user_id, companies.company_name FROM transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
JOIN companies ON transactions.business_id = company_id
JOIN users ON transactions.user_id = users.id
WHERE company_name ="Donec Ltd"
GROUP BY iban, card_id, credit_cards.user_id, company_name, transactions.user_id;

#ex 2.1
SELECT SUM(declined) AS declined_total, transactions.user_id, IF(SUM(declined) >= 3, "inactiva", "activa") AS activacion FROM transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
JOIN users ON transactions.user_id = users.id
GROUP BY user_id
ORDER BY declined_total DESC;

CREATE TEMPORARY TABLE tarjeta (WITH ct AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS seq
FROM transactions)
SELECT card_id,
	IF (SUM(declined) >= 3, 'inactiva', 'activa') AS activa
FROM ct
WHERE seq <= 3
GROUP BY card_id);

SELECT COUNT(activa) AS 'tarjetas activas'
FROM tarjeta
WHERE activa = 'activa';


#ex 3.1, NO FUNCIONA.
SELECT product_name, COUNT(product_ids) AS totalorders, products.id AS ItemId FROM transactions
JOIN products ON product_ids = products.id
GROUP BY product_name, itemid
ORDER BY totalorders DESC;

SELECT * FROM transactions;
CREATE TABLE new_transactions AS SELECT * FROM transactions;
SELECT * FROM new_transactions;

 SELECT
 product_ids,
SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 1), ',', 1) AS product_id_1,
IF(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 2), ',', -1) = product_ids, NULL,
SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 2), ',', -1)) AS product_id_2,
IF(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', -2), ',', 1) = product_ids, NULL,
SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', -2),',',1)) AS product_id_3,
IF (SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', -1),',', -1) = product_ids, NULL,
SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', -1),',', -1)) AS product_ids_4
FROM new_transactions;


SELECT product_ids,
  substring_index(substring_index(product_ids, ',', 1), ',', 1) product_id_1,
  substring_index(substring_index(product_ids, ',', 2), ',', -1) product_id_2,
  substring_index(substring_index(product_ids, ',', -2),',',1) product_id_3,
  substring_index(product_ids, ',', -1) product_id_4
FROM new_transactions;



select * from new_transactions;
drop table new_transactions;



SELECT * FROM transactions
JOIN products ON product_ids = products.id
WHERE product_ids = "47";

SELECT * FROM products
WHERE product_name = 'direwolf stannis';



#Codigo alternativo para hacer la union entre products y transactions. Saltó un error en el que no podía hacer la relación entre transactions
#y products cuando importé la información mediante el "table data import wizard" de mysql bench.
#Con Find_in_set lo que hacemos es buscar todos los products.id dentro de transactions.product_ids, además nos da la información de la tabla de products.
#lo dejo como mención a la ayuda de mi hermano.
SELECT
transactions.*,
products.*
FROM transactions JOIN products ON FIND_IN_SET(products.id, transactions.product_ids) > 0 ;
