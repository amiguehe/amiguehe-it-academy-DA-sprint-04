 -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS sprint;
    USE sprint;
    # IMPORTANTE GENERAR CADA TABLA INDIVIDUALMENTE, SI SE HACE DEL TIRON PUEDE QUE FALLE ALGUNA TABLA.

    -- Creamos la tabla companies
    CREATE TABLE IF NOT EXISTS companies (
		company_id varchar (20) PRIMARY KEY,
        company_name varchar (255),
        phone varchar (20),
		email varchar (100), 
        country varchar (100),
        website varchar (255)
    );
    
        -- Creamos la tabla products
    CREATE TABLE IF NOT EXISTS products (
        id varchar(50) PRIMARY KEY,
        product_name VARCHAR(30),
        price varchar (20),
		colour varchar (10),
        weight varchar (5),
        warehouse_id varchar (10)
    );
drop table products;

    -- Creamos la tabla credit_cards
    CREATE TABLE IF NOT EXISTS credit_cards (
        id varchar (15) PRIMARY KEY,
        user_id INT,
		iban varchar (100),
        pan varchar (100), 
        pin varchar(5),
        cvv decimal (3),
        track1 varchar (255),
        track2 varchar (255),
        expiring_date varchar(100)
    );
    
     -- Creamos la tabla Users_usa
    CREATE TABLE IF NOT EXISTS users_usa (
        id INT PRIMARY KEY,
		name varchar (10),
        surname varchar (10), 
        phone varchar (20),
        email varchar (100),
        birth_date varchar (20),
        country varchar (100),
        city varchar (100),
        postal_code varchar (10),
        address varchar (100)
	);
    
         -- Creamos la tabla Users_uk
    CREATE TABLE IF NOT EXISTS users_uk (
        id INT PRIMARY KEY,
		name varchar (10),
        surname varchar (10), 
        phone varchar (20),
        email varchar (100),
        birth_date varchar (20),
        country varchar (100),
        city varchar (100),
        postal_code varchar (10),
        address varchar (100)
	);
    
         -- Creamos la tabla Users_ca
    CREATE TABLE IF NOT EXISTS users_ca (
        id INT PRIMARY KEY,
		name varchar (10),
        surname varchar (15), 
        phone varchar (20),
        email varchar (100),
        birth_date varchar (20),
        country varchar (100),
        city varchar (100),
        postal_code varchar (10),
        address varchar (100)
	);
    drop table users_ca;
    
#Utilizar estas dos lineas de codigo para evitar checks de foreign keys que nos obliga a dropear relaciones 
#Aplicar safe updates para poder insertar los datos sin problemas.

SET FOREIGN_KEY_CHECKS=0;
set SQL_SAFE_UPDATES = 0;
    
    #merge users
create table Users as select * from users_usa UNION select * from users_uk union select * from users_ca;
alter table Users add primary key (id);

    -- Creamos la tabla transactions
    CREATE TABLE IF NOT EXISTS transactions (
        id VARCHAR(255),
        card_id VARCHAR(15) references credit_cards(id),
        business_id varchar (20) references companies(company_id),
        timestamp TIMESTAMP,
        amount decimal (10,2),
        declined int,
        product_ids varchar(50) references products(id),
        user_id INT references users(id),
        lat float,
        longitude float,
		FOREIGN KEY (card_id) REFERENCES credit_cards(id),
        FOREIGN KEY (business_id) REFERENCES companies(company_id),
        FOREIGN KEY (product_ids) REFERENCES products(id),
        foreign key (user_id) references users(id)
    );

drop table users;
drop table transactions;

alter table transactions drop constraint transactions_ibfk_4; #drop constraint para poder hacer la relacion entre users y la tabla de transactions
Alter table transactions add foreign key (user_id) references users(id);
CREATE INDEX transactions_ibfk_4 on users(id); #create index para la tabla de transactions y añadir los datos de "datos_insertar_sprint_04"
alter table transactions drop constraint transactions_ibfk_3; #drop constraint en caso de que haya problemas entre products y transactions
alter table transactions modify product_ids varchar(50); #modificación hecha posteriori en transactions(product_ids y products(id), valor original INT.
alter table products modify id varchar(50);
Alter table transactions add foreign key (product_ids) references products(id);