-- Создать и заполнить таблицы лайков и постов.

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	target_id INT UNSIGNED NOT NULL,
	target_type_id INT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR (255) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO  target_types (name) VALUES
	('messages'),
	('media'),
	('posts'),
	('users')
;

INSERT INTO likes
	SELECT
	id,
	FLOOR(1 + (RAND()* 100)),
	FLOOR(1 + (RAND()* 100)),
	FLOOR(1 + (RAND()* 4)), 
	CURRENT_TIMESTAMP 
	FROM messages
;

SELECT * FROM likes LIMIT 15;
SELECT * FROM profiles LIMIT 15;

-- Создать все необходимые внешние ключи и диаграмму отношений.

SHOW TABLES;

DESC users;	
DESC profiles;
DESC media;

ALTER TABLE profiles 
	ADD CONSTRAINT profiles_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users (id), 
	ADD CONSTRAINT profiles_photo_id_fk 
		FOREIGN KEY (photo_id) REFERENCES media (id);
	
DESC messages ;
DESC communities;

ALTER TABLE messages 
	ADD CONSTRAINT messages_from_user_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users (id), 
	ADD CONSTRAINT messages_to_user_id_fk 
		FOREIGN KEY (to_user_id) REFERENCES users (id),
	ADD CONSTRAINT messages_community_id_fk 
		FOREIGN KEY (community_id) REFERENCES communities (id)
;

SELECT * FROM communities_users;
SELECT * FROM communities;

ALTER TABLE communities_users 
	ADD CONSTRAINT communities_users_community_id_fk
		FOREIGN KEY (community_id) REFERENCES communities (id), 
	ADD CONSTRAINT communities_users_user_id_fk 
		FOREIGN KEY (user_id) REFERENCES users (id);

SELECT * FROM media;
DESC media;
DESC media_types;

ALTER TABLE media
	ADD CONSTRAINT media_media_type_id_fk
		FOREIGN KEY (media_type_id) REFERENCES media_types (id), 
	ADD CONSTRAINT media_user_id_fk 
		FOREIGN KEY (user_id) REFERENCES users (id);

SELECT * FROM friendship;
SELECT * FROM friendship_statuses;
DESC friendship;
DESC friendship_statuses ;
UPDATE friendship SET confirmed_at = NOW() WHERE requested_at > confirmed_at;

ALTER TABLE friendship 
	ADD CONSTRAINT frendship_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users (id), 
	ADD CONSTRAINT frendship_status_id_fk 
		FOREIGN KEY (status_id) REFERENCES friendship_statuses (id);

SELECT * FROM likes;
SELECT * FROM target_types;
DESC likes;

ALTER TABLE likes 
	ADD CONSTRAINT likes_user_id
		FOREIGN KEY (user_id) REFERENCES users (id),
	ADD CONSTRAINT likes_target_type_id
		FOREIGN KEY (target_type_id) REFERENCES target_types (id);
ALTER TABLE likes 
	ADD CONSTRAINT likes_target_id
		FOREIGN KEY (target_id) REFERENCES users (id);
	
-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей

SELECT * FROM profiles;
	
SELECT COUNT(*) FROM likes WHERE target_id IN (
  SELECT * FROM (
    SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10
    ) as smth
);

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT IF(
	(SELECT COUNT(*) FROM LIKES WHERE user_id IN (
		SELECT user_id FROM profiles WHERE gender = "m")
	) 
	> 
	(SELECT COUNT(*) FROM LIKES WHERE user_id IN (
		SELECT user_id FROM profiles WHERE gender = "f")
	), 
   'male', 'female');
  
-- 5) Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.  

  SELECT * FROM likes;
  
WITH SBD as (
 SELECT user_id, COUNT(*) as smth FROM friendship
	GROUP BY user_id	
UNION	
 SELECT friend_id as user_id, COUNT(*) as smth FROM friendship 
	GROUP BY friend_id
UNION	
 SELECT user_id, COUNT(*) as smth FROM communities_users
	GROUP BY user_id
UNION	
 SELECT user_id, COUNT(*) as smth FROM media
	GROUP BY user_id
UNION
 SELECT from_user_id as user_id, COUNT(*) as smth FROM messages
	GROUP BY from_user_id
UNION	
 SELECT user_id, COUNT(*) as smth FROM likes
	GROUP BY user_id)
SELECT user_id,  SUM(SBD.smth) AS smth FROM SBD
	GROUP BY user_id
	ORDER BY smth
	LIMIT 10;
	