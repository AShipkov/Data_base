USE vk;


-- 3. Подсчитать общее количество лайков десяти самым молодым пользователям 
-- (сколько лайков получили 10 самых молодых пользователей).
SELECT * FROM likes;
SELECT DISTINCT 
	p.user_id, 
	CONCAT(first_name, " ", last_name) as user, 
	TIMESTAMPDIFF(YEAR, birthday, NOW()) as age, -- TIMESTAMPDIFF() Вычитает интервал из даты — времени.
	COUNT(DISTINCT l.id) as SUM_likes
  FROM profiles p
   		 JOIN users u
      ON u.id = p.user_id
		LEFT JOIN likes l
      ON u.id = target_id AND target_type_id = 4
 		GROUP BY p.user_id 
        ORDER BY age LIMIT 10  
;

-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT CASE (gender)
      WHEN 'm' THEN 'male'
      WHEN 'f' THEN 'female'
    	END as sex, 
    	COUNT(*) as likes_count
  FROM profiles as p
    JOIN likes as l
      ON p.user_id = l.user_id
    GROUP BY sex 
    ORDER BY likes_count DESC LIMIT 1
 ;     

  
 -- 5. Найти 10 пользователей, которые проявляют наименьшую активность в
-- использовании социальной сети

SELECT DISTINCT u.id,
CONCAT(first_name, " ", last_name) AS user, 
COUNT(DISTINCT m1.user_id) + 
COUNT(DISTINCT l.user_id) + 
COUNT(DISTINCT cu.user_id )+
COUNT(DISTINCT f.friend_id)+
COUNT(DISTINCT f.user_id)+
COUNT(DISTINCT m.from_user_id) AS activity 
FROM users u
	LEFT JOIN likes l 
		ON l.user_id = u.id
	LEFT JOIN media m1
		ON m1.user_id = u.id	
	LEFT JOIN messages m 
		ON m.from_user_id = u.id
	LEFT JOIN communities_users cu 
		ON cu.user_id = u.id
	LEFT JOIN friendship f 
		ON u.id IN (f.friend_id, f.user_id)
GROUP BY u.id
ORDER BY activity 
LIMIT 10
;