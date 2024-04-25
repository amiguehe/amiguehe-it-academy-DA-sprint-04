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

SELECT iban, AVG(amount), transactions.card_id, transactions.user_id, companies.company_name FROM transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
JOIN companies ON transactions.business_id = company_id
JOIN users ON transactions.user_id = users.id
WHERE company_name ="Donec Ltd"
GROUP BY iban, card_id, user_id, company_name;

#ex 2.1
SELECT SUM(declined) AS declined_total, transactions.user_id, IF(SUM(declined) >= 3, "inactiva", "activa") AS activacion FROM transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
JOIN users ON transactions.user_id = users.id
GROUP BY user_id
ORDER BY declined_total DESC;

#ex 3.1
SELECT product_name, COUNT(product_ids) AS totalorders, products.id AS ItemId FROM transactions
JOIN products ON product_ids = products.id
GROUP BY product_name, itemid
ORDER BY totalorders DESC;

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
