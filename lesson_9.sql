-- 1)В базе данных SAMPLE (у меня вместо SHOP) и EXAMPLE присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы sample.users в таблицу example.users. Используйте транзакции.

USE EXAMPLE;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) COMMENT = 'Покупатели';

SELECT * FROM users;

START TRANSACTION;
INSERT INTO users SELECT * FROM sample.users WHERE id = 1;
DELETE FROM sample.users WHERE id = 1;
COMMIT;

-- 2 Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.
USE sample;

SELECT * FROM products;
SELECT * FROM catalogs; 

DROP VIEW IF EXISTS pretty_catalog;
CREATE VIEW pretty_catalog (product_name, catalog_name) AS
SELECT p.name, c.name FROM products p
	LEFT JOIN catalogs c ON c.id = p.catalog_id;

SELECT * from pretty_catalog;

-- 3)по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года 
-- '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 
-- 0, если она отсутствует.

DROP TABLE IF EXISTS test_table;
CREATE TABLE test_table (created_at DATETIME);
INSERT INTO test_table (created_at) 
VALUES ('2018-08-01'), ('2018-08-04'), ('2018-08-16'), 
('2018-08-17'), ('2018-08-21'), ('2018-08-24');
SET @startdate := '2018-08-01';
WITH RECURSIVE T (`date`, is_exist) AS 
(
SELECT @startdate,
       EXISTS(SELECT * FROM test_table WHERE created_at = @startdate)
UNION ALL
SELECT @startdate := @startdate + INTERVAL 1 DAY,
       EXISTS(SELECT * FROM test_table WHERE created_at = @startdate )
FROM T
WHERE @startdate < '2018-08-31'
)
SELECT * FROM T;

-- 4)(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, 
-- оставляя только 5 самых свежих записей.
INSERT INTO test_table (created_at) 
VALUES ('2019-08-01'), ('2019-08-04'), ('2019-08-16'), 
('2019-08-17'), ('2019-08-21'), ('2019-08-24');

PREPARE delf FROM "DELETE FROM test_table ORDER BY created_at LIMIT ?";
SET @lim := (SELECT COUNT(*) -5 FROM test_table);
EXECUTE delf USING @lim;

SELECT * FROM test_table;

-- 5)Практическое задание по теме “Администрирование MySQL” 
-- Создайте двух пользователей которые имеют доступ к базе данных sample. 
-- Первому пользователю sample_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю sample — любые операции в пределах базы данных sample.

DROP USER IF EXISTS sample_read;
CREATE USER sample_read IDENTIFIED BY 'passwd111';
GRANT SELECT ON sample.* TO sample_read;

DROP USER IF EXISTS sample;
CREATE USER sample IDENTIFIED BY 'passwd111';
GRANT ALL ON sample.* TO sample;

-- 6)(по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
-- содержащие первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, 
-- мог бы извлекать записи из представления username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	name VARCHAR (250),
	password VARCHAR(100)
);

DROP VIEW IF EXISTS username;
CREATE VIEW username(id, name) AS
SELECT id, name FROM accounts;

DROP USER IF EXISTS user_read;
CREATE USER user_read IDENTIFIED BY 'passwd111';
GRANT SELECT ON sample.username TO user_read;

-- 7)Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

SELECT HOUR(now());
-- ЗАПУСКАЛ ИЗ КОНСОЛИ 
DELIMITER //
DROP FUNCTION IF EXISTS sample.hello;
CREATE FUNCTION sample.hello ()
RETURNS TINYTEXT DETERMINISTIC
BEGIN
DECLARE time_now INT;
SET time_now = HOUR(NOW());
CASE
WHEN time_now BETWEEN 6 AND 11 THEN
RETURN "Доброе утро";
WHEN time_now BETWEEN 12 AND 17 THEN
RETURN "Добрый день";
WHEN time_now BETWEEN 18 AND 23 THEN
RETURN "Добрый вечер";
WHEN time_now BETWEEN 0 AND 5 THEN
RETURN "Доброй ночи";
END CASE;
END//
DELIMITER ;

SELECT sample.hello() as greeting, now() as time_now ; -- СКРИН ПРИЛОЖИЛ

-- 8) В таблице products есть два текстовых поля: 
-- name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.


DROP TABLE IF EXISTS products;
CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
);

DROP TRIGGER IF EXISTS check_product_insert;
-- ЗАПУСКАЛ ИЗ КОНСОЛИ
DELIMITER //
CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! NULL in both fields!';
END IF;
END //
DELIMITER;

INSERT INTO products (name, description) VALUES (NULL, NULL); -- SQL Error [1644] [45000]: Trigger Warning! NULL in both fields!
INSERT INTO products (name, description) VALUES ('NAME', NULL);
INSERT INTO products (name, description) VALUES (NULL, 'DESCRIPTION');
INSERT INTO products (name, description) VALUES ('NAME', 'DESCRIPTION');
SELECT * FROM products;

DROP TRIGGER IF EXISTS check_product_update;
-- ЗАПУСКАЛ ИЗ КОНСОЛИ
DELIMITER //
CREATE TRIGGER check_product_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
IF NEW.name IS NULL AND NEW.description is NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled. NAME or DESCRIPTION required';
END IF;
END//
DELIMITER;

UPDATE products SET name = NULL, description = NULL; -- SQL Error [1644] [45000]: UPDATE canceled. NAME or DESCRIPTION required

-- 3)(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
 -- Числами Фибоначчи называется последовательность в которой число равно сумме двух 
 -- предыдущих чисел. 
 -- Вызов функции FIBONACCI(10) должен возвращать число 55

DROP FUNCTION IF EXISTS FIBONACCI; 
-- ЗАПУСКАЛ ИЗ КОНСОЛИ
DELIMITER //
CREATE FUNCTION FIBONACCI(n INT)
RETURNS TEXT DETERMINISTIC
BEGIN
DECLARE p1 INT DEFAULT 1;
DECLARE p2 INT DEFAULT 1;
DECLARE i INT DEFAULT 2;
DECLARE res INT DEFAULT 0;
IF (n <= 1) THEN RETURN n;
ELSEIF (n = 2) THEN RETURN 1;
END IF;  
WHILE i < n DO
SET i = i + 1;
SET res = p2 + p1;
SET p2 = p1;
SET p1 = res;
END WHILE;
RETURN res;
END// 
DELIMITER ;

SELECT SAMPLE.FIBONACCI(10);