-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

USE SAMPLE;
SHOW TABLES;
DESC users;

ALTER TABLE users ADD COLUMN created_at DATETIME;
ALTER TABLE users ADD COLUMN updated_at DATETIME;
INSERT INTO `users` (`id`, `name`) VALUES (1, 'Ally');
INSERT INTO `users` (`id`, `name`) VALUES (2, 'Luis');
INSERT INTO `users` (`id`, `name`) VALUES (3, 'Katrina');
INSERT INTO `users` (`id`, `name`) VALUES (4, 'Hilda');
INSERT INTO `users` (`id`, `name`) VALUES (5, 'Esperanza');
INSERT INTO `users` (`id`, `name`) VALUES (6, 'Lucy');
INSERT INTO `users` (`id`, `name`) VALUES (7, 'Icie');
INSERT INTO `users` (`id`, `name`) VALUES (8, 'Martina');

SELECT * FROM users;
ALTER TABLE users DROP COLUMN created_at, DROP COLUMN updated_at ;
ALTER TABLE users 
	ADD COLUMN created_at DATETIME DEFAULT NOW(),
 	ADD COLUMN updated_at DATETIME DEFAULT NOW();

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
--    типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
--    Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

ALTER TABLE users MODIFY COLUMN created_at varchar(100); 
ALTER TABLE users MODIFY COLUMN updated_at varchar(100); 
UPDATE users SET
	created_at = '20.10.2017 8:10',
	updated_at = '20.10.2017 8:10';
DESC users;
SELECT * FROM users;
UPDATE users SET
	created_at= STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');

ALTER TABLE users MODIFY created_at DATETIME, MODIFY updated_at DATETIME;
DESC users;

 
-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться
-- самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
-- Однако, нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE storehouses_products;

CREATE TABLE `storehouses_products` (
  `storehouse_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,  
  `value` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`storehouse_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SELECT * FROM storehouses_products
;
INSERT INTO storehouses_products
	(storehouse_id, product_id, value, created_at, updated_at) VALUES
	(1, 12, 23, now(), now()),
	(2, 1, 12, now(), now()),
	(3, 33, 53, now(), now()),
	(4, 42, 0, now(), now()),
	(5, 24, 40, now(), now()),
	(6, 6, 111, now(), now())
;

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 9999 ELSE value END;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
-- Месяцы заданы в виде списка английских названий ('may', 'august')

ALTER TABLE users DROP COLUMN birthday_at;
ALTER TABLE users ADD COLUMN birthday_at varchar(100);
INSERT INTO `users` 
	(`birthday_at`) VALUES ('may'),
	('august'),
	('september'),
	('may'),
	('desember'),
	('august'),
	('march'),
	('june')
;

SELECT * FROM users;
DESC users;
SELECT * FROM users WHERE birthday_at RLIKE '^(may|august)'

-- Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN.

CREATE TABLE `catalogs` (
  `id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,  
  `value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
;
SHOW TABLES;
INSERT INTO catalogs
	(id, product_id, value) VALUES (1, 12, 23),
	(2, 1, 12),
	(3, 33, 53),
	(4, 42, 0),
	(5, 24, 4),
	(6, 6, 111)
;
SELECT * FROM catalogs;
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);
