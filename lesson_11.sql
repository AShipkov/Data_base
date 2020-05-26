USE SAMPLE;

-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
-- идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  table_id INT,
  table_name VARCHAR(20),
  name VARCHAR(255),
  created_ad TIMESTAMP
) ENGINE=Archive;

DELIMITER //
CREATE PROCEDURE write_log(IN table_id INT, table_name VARCHAR(20), name VARCHAR(255))
BEGIN
INSERT INTO logs(table_id, table_name, name, created_ad) 
VALUES (table_id, table_name, name, NOW());
END//

DROP TRIGGER IF EXISTS users_log;
CREATE TRIGGER users_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
CALL write_log(NEW.id, "users", NEW.name);
END//

DROP TRIGGER IF EXISTS catalogs_log;
CREATE TRIGGER catalogs_log AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
CALL write_log(NEW.id, "catalogs", NEW.name);
END//

DROP TRIGGER IF EXISTS products_log;
CREATE TRIGGER products_log AFTER INSERT ON products
FOR EACH ROW
BEGIN
CALL write_log(NEW.id, "products", NEW.name);
END//

DELIMITER ;

INSERT INTO users (name) VALUES ('ANDREY');
INSERT INTO catalogs (name) VALUES ('BOOK');
INSERT INTO products (name) VALUES ('PETER THE FIRST');

SELECT * FROM logs;

-- Создайте SQL-запрос, который помещает в таблицу users миллион записей.
DELIMITER //
DROP PROCEDURE IF EXISTS insert_many;
CREATE PROCEDURE insert_many(IN Q INT)
BEGIN
DECLARE i INT DEFAULT 0;    
WHILE i < Q DO
INSERT INTO users (name) VALUES (concat('user', i));
SET i = i + 1;
END WHILE;    
END//
  
CALL insert_many(1000000);

SELECT COUNT(*) FROM USERS;


-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

HSET counters '192.168.0.1' 3
HSET counters '192.168.0.2' 2
HSET counters '192.168.0.3' 5
HGETALL counters


-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя 
-- по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.

HSET email 'AMDREY' 'andrey@gmail.com'
HSET name 'andrey@gmail.com' 'ANDREY'

HSET email 'EXAMPLE' 'example@gmail.com'
HSET name 'example@gmail.com' 'EXAMPLE'

HGET email 'ANDREY'
HGET name 'andrey@gmail.com'


-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных sample в СУБД MongoDB.

use sample

db.sample.insert({catalog: 'Процессоры', products:[
				{id: 1, name: 'Intel i3', description: '', price: 8990}]})
db.sample.update({catalog: 'Процессоры'}, {$push: 
 				{ products: {id: 2, name:'Intel Core i5', description: '',price: 13500 } }})
db.sample.insert({catalog: 'Материнские платы', products:[
 				{id: 3, name: 'Gigabyte H310', description: '', price: 7890}]} )
db.sample.update({catalog: 'Материнские платы'}, {$set: 
				{ products:[{id: 3, name: 'Gigabyte H310M S2H', description: '', price: 4790}]}} )
db.sample.find()