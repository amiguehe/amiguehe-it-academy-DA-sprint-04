use sprint;
select * from companies;
select * from credit_cards;
select * from products;
select * from transactions;
select * from users;

#ex 1


SELECT users.name, users.surname, users.id, count(transactions.user_id) as ct, sum(amount)
FROM transactions
INNER JOIN users on users.id = user_id
GROUP BY users.name, users.surname, users.id, transactions.user_id
HAVING ct>=30
order by ct desc; 

select count(user_id) as total_orders, sum(amount), users.name, users.surname, users.id
from transactions 
INNER JOIN users on users.id = user_id
GROUP BY users.name, users.surname, users.id, transactions.user_id
having count(transactions.user_id) >= 30;


#ex 2
select credit_cards.iban as iban, transactions.card_id, avg(amount), transactions.user_id, companies.company_name from credit_cards
JOIN transactions ON transactions.card_id = credit_cards.id
join users on credit_cards.user_id = users.id
JOIN companies ON transactions.business_id = company_id
where iban = 'PT87806228135092429456346'
group by iban, transactions.card_id, transactions.user_id, company_name
;

#ex 2.1
select sum(declined) as declined_total, transactions.user_id, if(sum(declined) >= 3, "inactiva", "activa") as activacion from transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
join users on transactions.user_id = users.id
group by user_id
order by declined_total desc;

#ex 3.1
select product_name, count(product_ids) as totalorders, products.id as ItemId from transactions
join products on product_ids = products.id
group by product_name, itemid
order by totalorders desc;

select * from transactions
join products on product_ids = products.id
where product_ids = "47";

select * from products
where product_name = 'direwolf stannis';



#Codigo alternativo para hacer la union entre products y transactions. Saltó un error en el que no podía hacer la relación entre transactions
#y products cuando importé la información mediante el "table data import wizard" de mysql bench.
#Con Find_in_set lo que hacemos es buscar todos los products.id dentro de transactions.product_ids, además nos da la información de la tabla de products.
#lo dejo como mención a la ayuda de mi hermano.
SELECT
transactions.*,
products.*
FROM transactions JOIN products ON FIND_IN_SET(products.id, transactions.product_ids) > 0 ;
