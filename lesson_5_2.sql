-- Практическое задание теме “Агрегация данных”

-- 1) Подсчитайте средний возраст пользователей в таблице users взял таблицу из 4 урока 
USE VK;
SELECT *FROM profiles;
SELECT AVG(age) FROM (SELECT YEAR(CURRENT_TIMESTAMP) - YEAR(birthday) as age FROM profiles) AS Avg_age;

-- 2) Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения

SELECT COUNT(*) as stats from (SELECT DAYOFWEEK(CONCAT(YEAR(NOW()),'-',MONTH(birthday),'-',DAYOFMONTH(birthday))) 
as date from profiles) as stats where date=6;
-- где date=1 для понедельника, date=2 для вторника и т.д

-- 3) Подсчитайте произведение чисел в столбце таблицы

SELECT EXP(sum(log(photo_id))) from profiles;