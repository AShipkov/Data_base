
-- Требования к курсовому проекту:
-- Составить общее текстовое описание БД и решаемых ею задач;
-- минимальное количество таблиц - 10;
-- скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
-- создать ERDiagram для БД;
-- скрипты наполнения БД данными;
-- скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
-- представления (минимум 2);
-- хранимые процедуры / триггеры;


-- База данных для регистрации, анкетирования и оценки соискателей на групповых собеседованиях, 
-- экзаменах, тестировании.


DROP DATABASE IF EXISTS group_interview;
CREATE DATABASE group_interview;

USE group_interview;

-- Таблица пользователей

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL,
  email VARCHAR(200) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  INDEX users_id_idx (id),
  INDEX users_firstname_lastname_idx (firstname, lastname),
  INDEX users_email_idx (email)
);
  

-- Таблица паролей

DROP TABLE IF EXISTS passwords;
CREATE TABLE passwords (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY,
  password VARCHAR(20) NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
 CONSTRAINT passwords_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)
 );
  
-- Таблица профилей

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY,
  sex CHAR(1) NOT NULL,
  birthday DATE,
  hh_link VARCHAR(250),
  fb_link VARCHAR(250),
  insta_link VARCHAR(250),
  vk_link VARCHAR(250),
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
CONSTRAINT profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)
 );
  
 -- Таблица опыта работы

DROP TABLE IF EXISTS  experience;
CREATE TABLE experience (
  user_id INT UNSIGNED NOT NULL,
  company VARCHAR(100) NOT NULL,
  job_position VARCHAR(100) NOT NULL,
  job_recomendations VARCHAR(250),
  begin_date DATE NOT NULL,
  end_date DATE,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
 CONSTRAINT experience_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) 
 );
  
-- Таблица навыков

DROP TABLE IF EXISTS skills;
CREATE TABLE skills (
  id INT UNSIGNED NOT NULL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Навык',
  UNIQUE unique_name(name(25))
);

-- Таблица оценочных вопросов по навыкам

DROP TABLE IF EXISTS skills_points;
CREATE TABLE skills_points (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  serial_number INT NOT NULL UNIQUE COMMENT 'Номер в тесте',
  skill_id INT UNSIGNED NOT NULL,
  body VARCHAR(250) NOT NULL COMMENT 'Вопрос',
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
CONSTRAINT skills_points_skill_id_fk FOREIGN KEY (skill_id) REFERENCES skills(id)
  );
  
 -- Таблица вариантов ответов

DROP TABLE IF EXISTS answer_choices;
CREATE TABLE answer_choices (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  point_id INT UNSIGNED NOT NULL,
  serial_number INT NOT NULL COMMENT 'Номер варианта ответа',
  answer VARCHAR(250) NOT NULL COMMENT 'Ответ',
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
CONSTRAINT answer_choices_skill_id_fk FOREIGN KEY (point_id) REFERENCES skills_points(id)
  );
  
 -- Таблица правильных ответов

DROP TABLE IF EXISTS right_answers;
CREATE TABLE right_answers (
  point_id INT UNSIGNED NOT NULL,
  answer_id INT UNSIGNED NOT NULL,
PRIMARY KEY (point_id, answer_id),
  CONSTRAINT answer_choices_point_id_fk FOREIGN KEY (point_id) REFERENCES skills_points(id),
  CONSTRAINT answer_choices_answer_id_fk FOREIGN KEY (answer_id) REFERENCES answer_choices(id) 
  );
  
 -- Таблица ответов кандидатов

DROP TABLE IF EXISTS user_answers;
CREATE TABLE user_answers (
  user_id INT UNSIGNED NOT NULL,
  point_id INT UNSIGNED NOT NULL,
  answer_id INT UNSIGNED NOT NULL,
  answer_date DATE NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
 PRIMARY KEY (user_id, answer_date, point_id, answer_id),
  CONSTRAINT user_answers_point_id_fk FOREIGN KEY (point_id) REFERENCES skills_points(id),
  CONSTRAINT user_answers_answer_id_fk FOREIGN KEY (answer_id) REFERENCES answer_choices(id),
  CONSTRAINT user_answers_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)
  );
  
 -- Таблица расширенной анкеты

DROP TABLE IF EXISTS candidate_profiles_points;
CREATE TABLE candidate_profiles_points (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  serial_number INT NOT NULL UNIQUE COMMENT 'Номер в анкете',
  body VARCHAR(250) NOT NULL COMMENT 'Вопрос',
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- Таблица заполненных расширенных анкет кандидатов

DROP TABLE IF EXISTS completed_candidate_profiles;
CREATE TABLE completed_candidate_profiles (
  user_id INT UNSIGNED NOT NULL,
  point_id INT UNSIGNED NOT NULL,
  answer VARCHAR(250) COMMENT 'Ответ',
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
PRIMARY KEY (user_id, point_id),
  CONSTRAINT completed_candidate_profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT completed_candidate_profiles_point_id_fk FOREIGN KEY (point_id) REFERENCES candidate_profiles_points(id) 
  );
  
 -- заполняем с помощью сайта http://filldb.info
 
 -- Generation time: Sat, 30 May 2020 13:01:32 +0000
-- Host: mysql.hostinger.ro
-- DB name: u574849695_24
/*!40030 SET NAMES UTF8 */;
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

INSERT INTO `users` VALUES ('1','Gardner','Stehr','rice.ari@example.net','1991-09-26 20:03:28','2015-03-14 01:43:48'),
('2','Malvina','Upton','gunnar29@example.org','1992-12-20 05:53:01','1984-02-09 09:11:37'),
('3','Kristopher','Nader','althea.jaskolski@example.com','1997-10-15 04:44:17','1989-11-14 21:48:53'),
('4','Tobin','Kling','dejah04@example.org','2006-10-24 03:34:38','1977-12-03 04:20:25'),
('5','Anastacio','Huel','wiley72@example.net','2011-11-13 23:17:08','1991-03-01 02:44:55'),
('6','Jermaine','Fisher','gutmann.santiago@example.org','1981-04-02 00:23:49','2001-10-12 07:50:09'),
('7','Margarett','Legros','lehner.jess@example.net','1973-03-17 19:34:49','2014-11-05 04:50:48'),
('8','Julian','Bergnaum','mills.baylee@example.com','1985-03-18 18:33:25','2011-07-02 19:37:57'),
('9','Santina','Parisian','mervin84@example.com','1989-06-16 15:09:33','1970-11-10 23:11:46'),
('10','Aniyah','Rowe','kadin73@example.net','1973-09-14 18:36:14','2011-09-06 06:42:09'),
('11','Kenyatta','O\'Hara','maynard.satterfield@example.org','1988-07-17 04:20:00','1992-09-16 05:29:04'),
('12','Antonetta','Will','eichmann.helene@example.net','1990-06-01 00:57:58','1991-09-01 22:13:01'),
('13','Aaron','Durgan','mozelle.rau@example.org','2015-12-07 17:50:27','2017-10-31 11:16:47'),
('14','Ana','Yost','mjacobi@example.com','1990-01-14 10:05:46','1989-08-06 07:30:39'),
('15','Sister','Tillman','jaylin.renner@example.com','2018-03-21 22:00:43','2007-06-07 02:31:31'),
('16','Fabiola','Wiza','ho\'conner@example.net','1983-06-16 12:23:08','1999-10-20 06:10:27'),
('17','Mohammad','Bechtelar','llesch@example.net','2008-12-10 17:05:11','1980-07-02 16:34:16'),
('18','Ettie','Zemlak','mcdermott.amos@example.com','2005-08-10 19:02:59','1981-06-18 16:51:55'),
('19','Shanelle','Runolfsson','deckow.ladarius@example.net','1991-09-22 01:55:33','1981-07-16 08:43:42'),
('20','Rashad','Zemlak','kenyon.mosciski@example.net','2019-08-15 23:56:51','1976-06-20 19:44:46'); 

INSERT INTO skills VALUES ('1','Общение с профессиональным сообществом'),
('2','Знакомство с технологиями'),
('3','Критичность мышления и умение решать проблемы'),
('4','Умение продавать'),
('5','Аналитический склад ума'),
('6','Умение работать в команде'), 
('7','Способность управлять временем'),
('8','Уверенность в себе и настойчивость'),
('9','Умение говорить'),
('10','Умение излагать мысли в письменном виде');

INSERT INTO `profiles` VALUES ('1','m','1985-11-15','http://darethiel.com/','http://mclaughlin.org/','http://bogisich.com/','http://romaguera.com/','1976-03-06 12:18:53','1980-09-27 19:24:45'),
('2','m','1985-08-04','http://www.hickledurgan.com/','http://ruecker.com/','http://shields.com/','http://konopelski.com/','1989-05-25 07:16:49','1972-02-17 13:49:24'),
('3','f','1989-07-16','http://www.mertz.biz/','http://www.rolfson.com/','http://www.muller.com/','http://kuphal.com/','2001-09-27 13:18:48','1989-08-18 10:39:53'),
('4','m','1973-11-10','http://www.bartell.com/','http://daresauer.com/','http://www.schimmel.biz/','http://www.mcclure.org/','1999-03-21 23:16:27','2016-08-11 08:47:41'),
('5','f','2008-12-19','http://dach.com/','http://jakubowskihaag.com/','http://gottliebboehm.com/','http://www.brown.com/','2013-09-04 22:07:00','2017-06-28 13:20:01'),
('6','m','2004-10-29','http://williamson.com/','http://www.kertzmann.org/','http://www.kuvalis.net/','http://streichbartoletti.com/','2001-03-18 16:41:29','1985-09-26 10:46:11'),
('7','f','1981-04-18','http://www.haley.com/','http://www.lakin.biz/','http://www.jerde.org/','http://www.cruickshank.info/','1979-03-15 09:42:56','2007-10-23 08:16:55'),
('8','m','1976-11-24','http://nikolaus.com/','http://buckridgewindler.com/','http://rogahn.info/','http://runolfsdottir.com/','1981-03-18 05:38:45','2014-10-14 05:56:23'),
('9','f','1986-12-22','http://aufderhar.com/','http://www.dachterry.com/','http://kesslerglover.com/','http://balistreri.org/','1988-09-20 11:51:41','2015-04-25 10:35:43'),
('10','m','1986-03-19','http://upton.org/','http://www.fahey.biz/','http://www.boyleweimann.org/','http://www.hicklelang.com/','2002-08-05 03:57:02','1975-09-25 02:53:47'),
('11','m','1996-02-09','http://abshirehudson.com/','http://www.rodriguez.com/','http://www.shanahanlarkin.net/','http://www.conn.com/','1984-05-08 09:54:45','1981-03-29 00:24:23'),
('12','m','2017-09-01','http://www.bechtelarnitzsche.com/','http://kuhlman.com/','http://okeefe.org/','http://www.kautzer.info/','2016-03-24 02:50:23','2014-10-24 09:20:41'),
('13','m','1974-09-21','http://www.ziemann.com/','http://www.hickle.com/','http://mosciski.net/','http://rolfson.net/','1983-12-22 01:38:30','1990-09-21 14:29:37'),
('14','f','2008-08-19','http://www.armstrongbergstrom.com/','http://collins.com/','http://pourososinski.biz/','http://www.bergeflatley.com/','1986-02-10 23:22:13','1979-03-09 21:25:58'),
('15','f','2001-03-12','http://www.paucekwehner.com/','http://www.rolfson.org/','http://ratke.com/','http://zboncakritchie.com/','1995-09-16 02:13:09','1993-08-02 02:19:23'),
('16','m','2002-06-04','http://www.lebsack.biz/','http://www.ryan.com/','http://nikolaus.biz/','http://hicklefeeney.com/','1995-10-30 04:31:54','1996-07-25 07:35:24'),
('17','m','1994-05-02','http://ebertcrona.biz/','http://www.huelsstokes.net/','http://www.thiel.com/','http://steuber.info/','1997-07-04 11:36:01','1990-10-07 05:26:21'),
('18','m','2013-08-24','http://abshire.com/','http://eichmannjohnston.com/','http://durganschultz.com/','http://kling.com/','1987-06-27 21:24:17','1997-04-10 02:30:15'),
('19','f','2018-05-19','http://kuhnlowe.org/','http://www.bechtelar.net/','http://fayhowell.com/','http://spinka.com/','1997-04-15 07:56:00','1975-07-10 16:16:20'),
('20','f','2009-05-14','http://www.kochkshlerin.com/','http://lednerhane.biz/','http://www.collins.com/','http://mayert.info/','2016-04-07 22:16:33','2002-04-20 04:14:21'); 

INSERT INTO `passwords` VALUES ('1','4aea6ae7c8822553cc87','2002-10-03 11:08:47','2020-05-06 15:12:52'),
('2','bf3215006af72f40548b','1997-07-06 04:02:48','1990-01-28 18:46:28'),
('3','d9a9f9d5b5193491b5ba','1977-05-30 03:42:36','2016-01-11 09:24:49'),
('4','b0639457ffe418045dda','1992-04-19 23:15:13','2010-02-06 16:42:00'),
('5','d8becc4ad7cad25dad06','1977-07-27 22:27:55','1975-01-30 16:04:57'),
('6','f4b2a896d4014ac85367','1972-02-16 05:39:31','2000-11-03 12:17:34'),
('7','9a4a7b92bd994b21ff14','1990-07-30 07:15:35','2016-10-20 04:16:56'),
('8','3c90742ab9f08e6d2b53','2012-08-12 12:21:07','1984-02-24 09:03:45'),
('9','d7c17baeb3aa75a06f36','2008-06-09 02:20:33','2019-09-18 13:03:16'),
('10','c9ce29e7bc97328db38a','1989-12-30 10:56:06','1995-09-22 23:30:50'),
('11','2e143296898c46136b05','2020-03-06 13:54:32','1988-09-09 17:34:44'),
('12','3cee08224e75ab554b63','1992-01-10 17:06:06','2013-03-13 01:26:24'),
('13','2b361b04bc1d42ad799d','1985-05-30 09:56:21','1972-03-19 17:12:11'),
('14','29858169ebf03ef56549','1997-11-07 06:50:28','2002-12-01 10:26:55'),
('15','1b0372dee919471f2501','1984-08-21 18:23:37','2002-10-25 12:02:05'),
('16','78cd0546c01b3247cf67','2008-07-31 10:36:46','1988-02-06 07:44:14'),
('17','69659f6f919ef185ccc3','1999-12-20 01:46:59','1984-11-25 12:35:43'),
('18','58255c2ddbb7b0be387f','2014-06-26 07:21:27','1985-04-08 06:18:58'),
('19','c0072c47b0fa353cb496','2014-06-19 16:16:53','2002-05-05 21:55:48'),
('20','dd81a558b8a586a5a40e','1981-01-26 09:20:27','1975-11-11 15:48:12'); 

INSERT INTO `experience` VALUES ('1','Bins and Sons','',NULL,'1982-06-19','1989-04-07','2000-09-30 21:08:10','2007-08-26 04:57:34'),
('2','Prosacco-Ritchie','',NULL,'2018-08-17','1972-11-20','2003-04-18 09:06:12','1978-11-23 18:23:18'),
('3','Connelly Inc','',NULL,'2018-02-15','1994-06-07','2007-06-12 19:07:59','1974-04-09 21:59:54'),
('4','Kassulke Inc','',NULL,'2010-05-21','1986-08-09','1988-07-19 11:48:33','1990-01-09 09:06:29'),
('5','Kerluke, Bergnaum and Rau','',NULL,'2008-01-09','1993-12-20','1986-05-24 04:03:30','2017-04-07 15:27:30'),
('6','Heidenreich, Effertz and Lehner','',NULL,'1980-08-02','1971-04-18','2006-11-10 17:05:54','2015-10-17 05:17:13'),
('7','Doyle, Keeling and Harber','',NULL,'1982-01-31','1974-08-04','1997-10-27 02:41:19','1999-07-29 16:16:11'),
('8','Feest-Klein','',NULL,'1981-06-09','2012-08-30','2020-02-03 04:58:14','1990-10-17 07:44:16'),
('9','Conn-Nolan','',NULL,'1975-10-30','2009-04-22','2019-04-06 18:35:22','1982-02-12 03:31:15'),
('10','Rogahn Ltd','',NULL,'2016-05-13','1994-06-26','1987-07-08 20:01:29','2020-01-26 10:50:02'),
('11','Heathcote-Thiel','',NULL,'1988-10-30','2014-08-09','1978-09-21 11:56:19','1972-10-04 15:17:19'),
('12','Reynolds-Will','',NULL,'2019-10-26','1984-05-29','1984-08-13 02:58:36','2012-03-25 06:24:49'),
('13','Bednar LLC','',NULL,'1982-06-14','1978-07-24','1978-09-05 23:06:07','1978-10-20 03:42:30'),
('14','Harris, Parker and Veum','',NULL,'1974-10-13','2000-06-26','2010-11-11 11:16:42','2017-10-22 20:43:59'),
('15','Jaskolski-Block','',NULL,'2014-06-08','1983-01-08','1978-12-10 13:38:39','1996-12-22 10:52:39'),
('16','DuBuque Ltd','',NULL,'1991-12-14','1991-11-10','1973-12-31 20:20:12','1970-11-17 12:06:27'),
('17','Mohr, Beer and Abbott','',NULL,'2017-01-26','2009-12-13','1979-08-30 07:54:36','1977-07-27 00:55:12'),
('18','Ratke, Quitzon and Graham','',NULL,'2005-11-22','2013-11-16','2015-07-24 11:29:13','1971-07-02 15:59:27'),
('19','Parker LLC','',NULL,'2002-09-07','2000-06-25','2009-05-02 17:29:37','1970-09-16 14:50:53'),
('20','Effertz-Hamill','',NULL,'2006-07-04','1982-05-31','1987-11-03 12:01:42','1988-07-10 01:30:57'); 

INSERT INTO `skills_points` VALUES ('1','20','2','Debitis dolor ut est et est nobis nisi quisquam. Nobis consequatur cumque quas fugit nulla dolor dolores. Officia repellat veritatis voluptatem vel natus ullam dolor. Sed delectus ipsum illum quae labore.','1993-04-22 03:26:37','2017-12-06 21:41:40'),
('2','19','1','Saepe dicta quis reiciendis sit. Corrupti ipsam earum id magni hic consequatur ex. Corrupti et nulla odit possimus. Voluptatem doloremque blanditiis eos odit laboriosam blanditiis ut.','1974-10-08 22:38:00','1982-04-15 22:52:02'),
('3','1','4','Nesciunt aut aut at nam est fugiat. Et ipsam vel sit sit nam.','2000-08-17 09:19:03','1989-12-25 16:38:21'),
('4','4','3','Ad neque sed sapiente voluptas sed distinctio aut. Cum sed perferendis est harum. Autem consequatur officia numquam ut quia rerum. Sapiente aut assumenda et nostrum distinctio.','1998-04-17 01:46:58','1975-10-10 20:46:40'),
('5','18','5','Mollitia ut quidem placeat explicabo dicta sequi nihil. Esse ipsam enim enim optio. Vitae perspiciatis aspernatur aut at harum. At est quasi eos et et quia amet.','1973-10-30 10:44:51','1975-07-23 21:04:56'),
('6','17','6','Occaecati voluptas ut tempore eum explicabo aut est consequatur. Autem quos quibusdam voluptate architecto cum. Reprehenderit et est molestias sed cupiditate.','2007-02-23 05:35:18','2011-05-03 02:18:30'),
('7','2','3','Et reiciendis sapiente ut culpa qui officia. Velit labore velit ratione qui. Voluptatem repellendus atque aut. In commodi doloremque laboriosam quaerat aliquid est dignissimos.','1973-12-07 00:38:49','1985-11-29 07:08:42'),
('8','6','8','Ut quidem repellat enim esse. Inventore nemo explicabo tenetur repellat vel ut perspiciatis quis. Explicabo consequuntur amet quis aut error nostrum dolor.','1994-10-22 01:53:07','2020-05-09 23:29:50'),
('9','3','4','Pariatur voluptatem nobis velit quisquam enim. Vel ut ea fuga enim.','2006-04-08 18:48:33','1995-08-31 01:27:14'),
('10','8','2','Quia atque quam ad voluptatem reprehenderit cumque eaque. Voluptatem odio molestiae ut quo omnis eligendi modi. Eum debitis et repellat dolorem ut vel quam. Eos architecto exercitationem facilis esse blanditiis.','1993-10-03 15:15:20','1981-08-12 19:07:49'),
('11','7','1','Magnam blanditiis fuga sed ullam dignissimos est quia. Accusantium incidunt sed explicabo et est ipsum quae. Eius itaque culpa est quia qui. Vero in ut omnis itaque velit.','1992-02-05 02:20:46','1978-04-01 15:40:39'),
('12','5','10','Aut modi voluptatibus et iusto. Saepe molestiae maxime omnis rem laudantium placeat fugit ea. In deleniti aut modi fugit dolore. Repellendus dolor et voluptatem qui temporibus provident quas.','2014-09-08 09:55:09','1991-05-18 16:03:22'),
('13','16','10','Accusamus ea rerum laborum. Est voluptas ipsam qui impedit consequatur et sint. Eos consectetur sunt ducimus earum.','2004-09-22 19:52:09','2000-02-02 02:22:06'),
('14','9','3','Perspiciatis vero voluptatem perspiciatis dolorem aut. Qui ad et dolor sed. Dolore atque tempore non et itaque delectus est sed. Blanditiis quibusdam qui illum quidem qui.','1979-11-17 07:56:33','1982-02-16 06:45:55'),
('15','10','5','Ullam voluptatem molestiae et voluptas perferendis. Pariatur et neque sed nesciunt dolores.','1998-03-02 12:33:26','1979-09-07 13:44:55'),
('16','11','2','Voluptatibus hic occaecati architecto expedita voluptatem facere. Dolorum non alias quibusdam saepe.','1998-09-26 09:46:47','1977-11-24 01:11:38'),
('17','12','10','Totam totam ut maiores maxime. Facere beatae voluptates laborum soluta commodi. Mollitia tempora voluptatem quia inventore iste.','2015-01-29 06:41:16','1990-03-01 06:22:56'),
('18','13','9','Officiis ullam sed rem maxime laborum ut. Voluptas labore doloribus vel ratione. Possimus voluptas sunt ut rerum. Ullam porro autem incidunt placeat.','2017-06-15 19:01:18','2010-06-21 01:02:36'),
('19','14','6','Tempora quos iusto occaecati est dolorem ipsam. Minima omnis rerum rerum modi quae nulla. Occaecati culpa architecto dolores vero quo quasi. Qui aut qui recusandae et non.','1992-03-22 09:42:00','1985-01-01 05:50:11'),
('20','15','3','Iusto perspiciatis tenetur quia vitae rem. Totam est quam voluptas quos aliquid eligendi est. Dolorum dolorem delectus expedita eum. Neque repellendus sint minus veritatis.','1990-05-16 18:22:11','2005-07-18 00:43:05'); 


INSERT INTO `answer_choices` VALUES ('1','1','0','','2002-11-17 07:32:23','2008-01-18 18:19:24'),
('2','2','0','','1979-12-11 17:50:21','1986-01-12 08:52:21'),
('3','3','0','','1991-12-11 13:01:35','2008-07-28 02:56:47'),
('4','4','0','','1981-10-13 02:18:12','2003-07-10 09:45:47'),
('5','5','0','','2010-06-22 16:45:26','1979-03-02 14:02:29'),
('6','6','0','','2013-05-14 04:09:59','1986-06-08 05:41:56'),
('7','7','0','','2013-08-04 17:18:52','2016-07-25 13:34:59'),
('8','8','0','','1995-05-16 11:55:45','1977-05-11 15:05:59'),
('9','9','0','','2014-12-02 20:00:03','1986-10-30 07:12:50'),
('10','10','0','','2003-05-09 20:10:34','1970-07-31 21:59:32'),
('11','11','0','','2004-10-31 13:43:38','1998-05-14 21:30:42'),
('12','12','0','','1981-06-26 01:50:58','1975-11-13 08:51:48'),
('13','13','0','','2016-06-17 07:47:33','1989-09-26 01:47:02'),
('14','14','0','','2001-06-01 19:55:12','1977-11-15 12:55:20'),
('15','15','0','','2000-05-20 03:43:45','1975-06-14 16:03:18'),
('16','16','0','','1979-11-09 12:22:09','2008-02-26 06:06:44'),
('17','17','0','','1984-04-22 12:11:31','2005-01-15 22:03:44'),
('18','18','0','','1997-12-13 04:37:25','1988-08-26 23:17:24'),
('19','19','0','','2008-11-26 05:56:56','1983-05-26 10:52:18'),
('20','20','0','','2005-01-25 20:49:08','2001-04-22 19:12:00'); 

INSERT INTO `right_answers` VALUES ('1','3'),
('2','4'),
('3','3'),
('4','1'),
('5','3'),
('6','1'),
('7','2'),
('8','4'),
('9','2'),
('10','1'),
('11','3'),
('12','2'),
('13','1'),
('14','4'),
('15','1'),
('16','1'),
('17','1'),
('18','2'),
('19','4'),
('20','3'); 

INSERT INTO `user_answers` VALUES ('1','1','1','2010-10-10','1983-07-25 14:58:53','2001-09-25 01:17:20'),
('2','2','2','1994-06-17','2009-05-21 10:54:01','1988-08-31 20:18:50'),
('3','3','3','2018-04-30','2003-08-16 15:07:07','1979-06-27 13:07:12'),
('4','4','4','2002-06-01','1990-11-09 00:38:20','1987-03-15 02:04:50'),
('5','5','5','2016-12-16','2016-08-02 19:32:11','2004-07-20 15:09:23'),
('6','6','6','1980-09-17','2002-01-21 20:55:11','1977-01-13 06:29:41'),
('7','7','7','2012-02-09','1995-01-26 11:01:52','1986-03-21 17:03:41'),
('8','8','8','1987-11-20','1992-05-24 11:59:31','1983-12-27 05:54:23'),
('9','9','9','1976-01-11','2013-12-10 13:27:39','2012-05-08 06:47:17'),
('10','10','10','1993-07-14','1973-07-27 00:09:20','1985-09-13 22:45:28'),
('11','11','11','1972-05-07','1973-08-29 00:26:01','2003-12-15 09:51:12'),
('12','12','12','2005-05-12','1976-09-07 14:47:24','1986-04-15 14:47:03'),
('13','13','13','1981-08-18','2016-12-30 00:35:49','2014-08-21 04:32:56'),
('14','14','14','1980-04-08','2001-03-14 18:47:49','1974-03-03 21:13:23'),
('15','15','15','1975-05-05','2013-06-07 18:04:45','2007-12-24 16:06:14'),
('16','16','16','1987-11-05','1982-08-22 00:47:34','1970-10-08 08:30:04'),
('17','17','17','1979-05-04','2018-11-15 17:22:57','2014-08-10 07:43:04'),
('18','18','18','1974-02-18','2014-09-03 11:27:23','1979-12-14 13:10:06'),
('19','19','19','1990-12-14','1990-11-07 02:08:28','1985-08-23 01:10:16'),
('20','20','20','1985-12-18','1995-08-22 14:07:37','1973-04-11 01:15:03'); 

INSERT INTO `candidate_profiles_points` VALUES ('1','33','Ab corrupti autem non. Consequatur quibusdam molestiae corporis rerum voluptas. Doloremque nihil molestiae et cum voluptas dolores incidunt rem. Reiciendis quam sequi nam quos perspiciatis pariatur est fugiat. Provident sint esse expedita impedit nos','2011-07-25 09:45:49','1971-02-04 12:50:42'),
('2','22','Occaecati delectus debitis corporis. Sequi velit unde est beatae veritatis dolore aut. Autem nobis asperiores sed aliquid veritatis cum at. Qui voluptate rerum earum error.','1985-12-31 17:36:52','1978-11-04 13:53:23'),
('3','30','Sed quo est perferendis eligendi unde sed. Veniam ut consequatur quo aut temporibus corrupti fuga. Voluptas adipisci sit et voluptatibus.','1983-11-27 05:46:44','1985-03-07 10:15:49'),
('4','85','Laboriosam velit eius possimus consectetur reiciendis sint. Error non blanditiis aspernatur. Voluptatem cum velit et provident sed dolorem velit.','2006-08-16 15:15:51','2019-09-03 05:36:12'),
('5','82','Consequatur nam odio animi. Perferendis placeat sed totam nulla vero voluptatibus dolor dolore. Quo debitis sed qui sed deserunt et voluptatem.','1988-03-02 02:42:13','1985-09-09 21:53:20'),
('6','98','Sed aliquam at dolorem cumque. Voluptatem rerum repellendus corporis. Cum impedit perferendis a culpa et.','2008-12-21 14:00:13','1999-01-24 19:32:20'),
('7','49','Provident maiores ut quo eos. Delectus molestiae est et voluptas modi. Placeat asperiores ut tenetur nisi soluta est. Quia non praesentium ab dolor sequi ducimus non.','1985-07-28 02:12:24','1998-04-26 06:38:38'),
('8','59','Nesciunt quia qui natus numquam incidunt enim perspiciatis. Perspiciatis debitis et dolor beatae nostrum officia officia. Sed harum similique quod sunt aut earum odio.','1981-03-25 17:39:05','2000-11-24 02:26:16'),
('9','53','Temporibus ipsam sunt aut eaque perspiciatis. Explicabo eum facilis sit quia consequuntur eligendi eum. Distinctio soluta voluptatem ratione accusamus. Non laboriosam qui nam vero. Quaerat similique repudiandae quo omnis autem vitae sint.','1992-06-14 19:59:01','2019-07-12 18:25:10'),
('10','88','Placeat et tempora temporibus. Excepturi aut provident inventore. Iure temporibus officia et fuga.','1976-08-04 18:50:27','2004-06-26 08:54:42'),
('11','61','Praesentium et vitae officia quo. Veniam aut ut amet quasi occaecati consequatur. Autem vel dolorem iure reiciendis incidunt accusamus. Tempora cumque suscipit ut quod ullam amet.','2015-09-30 12:31:38','1972-05-12 17:39:43'),
('12','28','Voluptatum at delectus sit ut qui. Voluptas qui modi voluptatem quas. Quis sunt asperiores sunt est.','1995-08-03 11:07:52','2013-10-15 01:38:59'),
('13','1','Quia aliquid quibusdam quis qui corporis modi. Quis perspiciatis aut nihil nulla. Aliquid eveniet temporibus eaque temporibus. Impedit exercitationem ea error labore consequuntur earum.','2003-07-13 14:52:41','1993-01-11 13:21:53'),
('14','25','Ratione deserunt est et in vero. Consectetur at eum consectetur sunt minus. Earum et in dolore vel nisi iure.','1982-04-18 02:49:18','1970-05-24 07:06:32'),
('15','54','Nemo rerum at aut sint minima est. Necessitatibus vel aut rerum deleniti aut mollitia quis qui. Et soluta voluptates sit ut vel labore voluptas. Ipsam quod dicta reiciendis consequatur incidunt praesentium.','1989-09-11 08:58:10','2016-06-18 17:05:28'),
('16','77','Ut dolorem ut ea. Enim et rerum laborum earum earum iste. Enim enim velit omnis adipisci dolores ut est. Assumenda nulla laudantium commodi omnis eveniet est. Exercitationem praesentium debitis quos fugit praesentium ipsam.','1998-01-03 23:00:18','1978-06-16 10:38:04'),
('17','13','Et placeat exercitationem sequi. Dolorem ut quisquam voluptate sit vero eligendi adipisci quibusdam. Eaque aut voluptas possimus ut doloremque voluptatem voluptas quae.','1986-01-25 10:04:46','1985-01-23 18:06:31'),
('18','70','Fugiat harum harum eveniet. Aut ea repellendus voluptatem dolores voluptatem culpa. Ea doloribus optio nulla qui.','2011-03-16 00:37:08','1994-04-10 15:08:13'),
('19','56','Ipsam esse tempora libero molestiae sed. Odio ab inventore repudiandae sint consequatur quaerat. Quasi quam voluptatum soluta praesentium rerum. Ad mollitia quos voluptatem.','1977-10-20 16:33:13','2003-12-03 20:20:59'),
('20','44','Sunt deleniti nisi quos eaque rem quia. Corrupti voluptas inventore eaque ut. Laudantium qui numquam facilis laudantium eos sed.','1977-01-30 09:32:35','2000-07-05 02:11:19'); 

INSERT INTO `completed_candidate_profiles` VALUES ('1','1','Enim eligendi nam omnis et ducimus voluptates recusandae veniam.','2012-03-14 06:15:10','1978-11-07 08:42:21'),
('2','2','Qui quo ab debitis quisquam eius et et ut.','1970-09-01 11:29:01','1980-03-30 14:23:49'),
('3','3','Omnis sint minima omnis at rem praesentium.','2017-07-30 16:39:56','1983-10-12 18:54:14'),
('4','4','Quisquam ut laudantium fuga.','1971-03-12 22:03:00','2004-08-07 02:19:52'),
('5','5','Facilis ad atque modi exercitationem.','2017-11-30 09:05:50','1986-02-10 15:06:45'),
('6','6','Totam earum sunt nobis laudantium est eligendi est.','2014-03-26 05:57:43','1973-08-28 09:55:10'),
('7','7','Ullam placeat esse ipsum cumque.','1977-03-14 02:07:48','2013-10-22 16:16:53'),
('8','8','Aliquid adipisci neque alias.','2011-06-10 17:01:17','2007-01-27 13:02:21'),
('9','9','Dolorem molestiae architecto labore quo sapiente debitis.','1979-04-25 18:02:36','2009-01-07 19:56:18'),
('10','10','Quam eos nemo neque voluptatem maxime rerum.','1985-09-28 08:26:40','1999-07-23 02:27:09'),
('11','11','Quia officia nihil quibusdam odit iusto molestiae.','2000-12-30 00:33:24','2005-07-05 16:30:53'),
('12','12','Quis maxime temporibus at enim at qui cupiditate voluptate.','2003-11-23 05:07:49','2000-07-12 02:18:34'),
('13','13','Dolor et modi exercitationem odit quisquam dolores neque.','2001-03-03 20:29:25','1971-11-25 06:54:09'),
('14','14','Eveniet dolorem blanditiis aut debitis ratione accusamus praesentium.','2009-08-23 02:05:53','2003-12-01 07:22:46'),
('15','15','Minima ut fuga quis eum.','2010-08-03 12:36:02','1984-10-26 07:42:15'),
('16','16','Similique quod enim qui voluptas quas quisquam sint.','2004-09-06 19:12:16','1999-12-13 11:24:16'),
('17','17','Non dicta omnis recusandae ullam.','2020-04-11 06:30:44','2001-06-28 21:18:24'),
('18','18','Accusamus dolorum itaque ut laboriosam rerum et omnis non.','1993-03-08 06:25:00','1975-10-19 12:55:07'),
('19','19','Ut et qui ea cumque.','1997-06-16 11:38:55','1980-01-28 19:29:50'),
('20','20','Quos facere est animi consequatur aut rerum.','1981-06-16 07:33:29','2003-07-24 00:27:42'); 

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

SELECT * FROM users u;
UPDATE users SET updated_at = CURRENT_TIMESTAMP() WHERE created_at> updated_at; 

SELECT * FROM passwords p;
UPDATE passwords SET updated_at = CURRENT_TIMESTAMP() WHERE created_at> updated_at;

SELECT * FROM profiles p ;
UPDATE profiles SET created_at = CURRENT_TIMESTAMP() WHERE created_at > birthday ;
UPDATE profiles SET updated_at = CURRENT_TIMESTAMP() WHERE created_at> updated_at;

SELECT * FROM answer_choices ac ;
UPDATE answer_choices SET updated_at = CURRENT_TIMESTAMP() WHERE created_at> updated_at;
UPDATE answer_choices SET serial_number = FLOOR(1 + (RAND()* 100));
UPDATE answer_choices SET answer = FLOOR(1 + (RAND()* 5));


SELECT * FROM candidate_profiles_points ;
UPDATE candidate_profiles_points SET updated_at = CURRENT_TIMESTAMP() WHERE created_at> updated_at;


SELECT * FROM completed_candidate_profiles ccp  ;
UPDATE completed_candidate_profiles SET updated_at = CURRENT_TIMESTAMP() WHERE created_at> updated_at;


SELECT * FROM experience e ;
UPDATE experience SET end_date = CURRENT_TIMESTAMP() WHERE begin_date > end_date;
UPDATE experience SET updated_at = CURRENT_TIMESTAMP() WHERE created_at> updated_at;
UPDATE experience SET job_position = FLOOR(1 + (RAND()* 2));
UPDATE experience SET job_position = 'рабочий' WHERE job_position = 2;
UPDATE experience SET job_position = 'среднее звено' WHERE job_position != 'рабочий';
UPDATE experience SET job_recomendations = FLOOR(1 + (RAND()* 2));
UPDATE experience SET job_recomendations = 'есть' WHERE job_recomendations = 2;
UPDATE experience SET job_recomendations = 'нет' WHERE job_recomendations != 'есть';

SELECT * FROM right_answers ra ;

SELECT * FROM skills s;

SELECT * FROM skills_points sp ;
UPDATE skills_points SET updated_at = CURRENT_TIMESTAMP() WHERE created_at > updated_at;

SELECT * FROM user_answers ua;
UPDATE user_answers SET answer_date = CURRENT_TIMESTAMP() WHERE answer_date > created_at ;
UPDATE user_answers SET updated_at = CURRENT_TIMESTAMP() WHERE created_at > updated_at;

-- представления

-- Таблица профилей

DROP VIEW IF EXISTS users_presentation;
CREATE VIEW users_presentation AS 
SELECT users.id AS id, CONCAT(users.firstname, ' ', users.lastname) AS all_name, 
users.email, profiles.sex, profiles.birthday, profiles.hh_link, profiles.fb_link, profiles.insta_link,profiles.vk_link
  FROM users
	   JOIN profiles ON users.id = profiles.user_id;

SELECT * FROM users_presentation;

-- Таблица вопросов и ответов

DROP VIEW IF EXISTS questions_and_answers;
CREATE VIEW questions_and_answers AS 
SELECT sp.serial_number, s.name, sp.body, ac.serial_number AS answer_number, ac.answer
 FROM skills_points AS sp
      JOIN skills AS s ON sp.skill_id = s.id
      JOIN right_answers AS ra ON sp.id = ra.point_id
      JOIN answer_choices AS ac ON ra.answer_id = ac.id     
ORDER BY sp.serial_number;

SELECT * FROM questions_and_answers;
 
-- Тригерры

-- проверка пароля 

DROP TRIGGER IF EXISTS password_control_insert;
DELIMITER //
CREATE TRIGGER password_control_insert BEFORE INSERT ON passwords
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.password) < 4 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password, It must be more than 4 chars';
	END IF;
END//

DROP TRIGGER IF EXISTS password_control_update;
DELIMITER //
CREATE TRIGGER password_control_update BEFORE update ON passwords
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.password) < 4 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password, It must be more than 4 chars';
	END IF;
END//

-- контроль дат стажа и опыта

DROP TRIGGER IF EXISTS experience_control_insert;

DELIMITER //
CREATE TRIGGER experience_control_insert BEFORE INSERT ON experience
FOR EACH ROW
BEGIN
    IF NEW.begin_date IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Begin_date is NULL';
	END IF;
    IF NEW.end_date IS NOT NULL AND NEW.begin_date > NEW.end_date THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Begin_date is more than End_date';
	END IF;  
END//


-- CHECK
INSERT INTO experience VALUES ('0','A','A',NULL, NULL,'2000-11-11', DEFAULT, DEFAULT);
INSERT INTO experience VALUES ('0','A','A',NULL,'2010-02-02','1999-03-03', DEFAULT, DEFAULT);
UPDATE passwords SET password = '123' WHERE user_id = 1;


-- Хранимые процедуры

-- возраст кандидата


DROP FUNCTION IF EXISTS AGE;
DELIMITER //
CREATE FUNCTION AGE(id INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE Y INT;
    SET Y = (SELECT timestampdiff(year,birthday, now()) FROM profiles WHERE user_id = id);
	RETURN Y;  
END//

SELECT AGE(3);

-- баллы кандидата

DROP FUNCTION IF EXISTS SCORES;
DELIMITER //
CREATE FUNCTION SCORES(id INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE Y INT;
    SET Y = (SELECT COUNT(ua.answer_id) FROM user_answers AS ua
	 JOIN skills_points AS sp
		ON ua.point_id = sp.id
	 JOIN right_answers AS ra 
        ON ua.answer_id = ra.answer_id AND sp.id = ra.point_id
	WHERE user_id = id 
	GROUP BY ua.user_id);
	RETURN Y;  
END//

SELECT SCORES(3); --  есть балл только для id 3 check внизу


-- выборка баллов пользователей

SELECT ua.user_id, COUNT(ua.answer_id) AS scores
  FROM user_answers AS ua
     JOIN skills_points AS sp
       ON ua.point_id = sp.id
     JOIN right_answers AS ra ON ua.answer_id = ra.answer_id AND sp.id = ra.point_id
 GROUP BY ua.user_id
 ORDER BY scores;

-- выборка опыта работы

SELECT up.id, up.all_name, ex.company, ex.job_position, ex.begin_date, 
       CASE WHEN ISNULL(ex.end_date) THEN NOW() ELSE ex.end_date END AS end_date
  FROM users_presentation AS up
       JOIN experience AS ex 
          ON up.id = ex.user_id
 ORDER BY up.all_name, end_date;
 
 -- выборка стажа 

 SELECT exp_begin.user_id, exp_begin.start_stage, exp_end.end_stage, 
        DATEDIFF(exp_end.end_stage, exp_begin.start_stage) AS days
   FROM (SELECT user_id, min(begin_date) AS start_stage
   FROM experience
         GROUP BY user_id) AS exp_begin
	     JOIN (SELECT user_id, max(CASE WHEN ISNULL(end_date) THEN NOW() ELSE end_date END) AS end_stage
            FROM experience
            GROUP BY user_id) AS exp_end 
			ON exp_begin.user_id = exp_end.user_id;
                
-- выборка ответов пользователей

SELECT ua.user_id, sp.serial_number, sp.body, ac.serial_number AS answer_number, ac.answer
  FROM user_answers AS ua
       JOIN skills_points AS sp
              ON ua.point_id = sp.id
	   JOIN answer_choices AS ac ON ua.answer_id = ac.id
 ORDER BY ua.user_id, sp.serial_number;

-- mysqld stop
-- mysqld start

