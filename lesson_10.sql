-- 1. Проанализировать какие запросы могут выполняться наиболее часто 
-- в процессе работы приложения и добавить необходимые индексы.

-- запросы на поиск и фильтрацию пользователей по дате рождения и городу проживания
CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE INDEX profiles_hometown_idx ON profiles(city);

-- если у пользователя много документов он ищет их по имени
CREATE INDEX media_filename_idx ON media(filename);

-- просматривать кто-что лайкнул
CREATE INDEX likes_user_id_target_id_like_type_id_idx ON media (user_id, filename);

-- Вся история переписки с другом заслуживает индекса. 
CREATE INDEX messages_from_user_id_to_user_id_created_at_idx ON messages (from_user_id, to_user_id, created_at);
CREATE INDEX messages_to_user_id_from_user_id_created_at_idx ON messages (to_user_id, from_user_id, created_at);

-- поиск по тексту сообщений 
CREATE INDEX messages_body_idx ON messages(body(10));

-- 2. Задание на оконные функции

-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT * FROM communities_users;
SELECT DISTINCT
  communities.name AS group_name,
  COUNT(communities_users.user_id) OVER()/
  (SELECT COUNT(*) FROM communities) AS avg_users_in_groups,
  FIRST_VALUE(users.id) 
    OVER(PARTITION BY communities.id ORDER BY profiles.birthday DESC) AS the_youngest,
  FIRST_VALUE(users.id) 
    OVER(PARTITION BY communities.id ORDER BY profiles.birthday) AS the_oldest,
  COUNT(communities_users.user_id) 
    OVER(PARTITION BY communities.id) AS users_in_groups,
  COUNT(communities_users.user_id) OVER() AS users_total,
  COUNT(communities_users.user_id) OVER(PARTITION BY communities.id)/
  COUNT(communities_users.user_id) OVER() *100 AS '%%'
    FROM communities
    LEFT JOIN communities_users 
    	ON communities_users.community_id = communities.id
	JOIN users 
        ON communities_users.user_id = users.id
    JOIN profiles 
        ON profiles.user_id = users.id;