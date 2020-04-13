-- Практическое задание по теме “Управление БД”

1). Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.
[mysql]
user=root
password=

MacBook-Air-Andrey:~ AShipkov$ mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 39
Server version: 8.0.19 Homebrew

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

2).Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.

MacBook-Air-Andrey:~ AShipkov$ mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 16
Server version: 8.0.19 Homebrew

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE example;
Query OK, 1 row affected (0,06 sec)

mysql> CREATE DATABASE sample;
Query OK, 1 row affected (0,01 sec)

mysql> USE example;
Database changed
mysql> CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(255) COMMENT 'Имя пользователя');
Query OK, 0 rows affected (0,09 sec)

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| example            |
| information_schema |
| mysql              |
| performance_schema |
| sample             |
| sys                |
+--------------------+
6 rows in set (0,00 sec)


3).Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.

MacBook-Air-Andrey:~ AShipkov$ mysqldump -uroot example > sample.sql
MacBook-Air-Andrey:~ AShipkov$ mysql -uroot sample < sample.sql  
MacBook-Air-Andrey:~ AShipkov$ mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 21
Server version: 8.0.19 Home-brew

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| example            |
| information_schema |
| mysql              |
| performance_schema |
| sample             |
| sys                |
+--------------------+
6 rows in set (0,00 sec)

mysql> DESCRIBE sample.users;
+-------+-----------------+------+-----+---------+----------------+
| Field | Type            | Null | Key | Default | Extra          |
+-------+-----------------+------+-----+---------+----------------+
| id    | bigint unsigned | NO   | PRI | NULL    | auto_increment |
| name  | varchar(255)    | YES  |     | NULL    |                |
+-------+-----------------+------+-----+---------+----------------+
2 rows in set (0,01 sec)

mysql> DESCRIBE example.users;
+-------+-----------------+------+-----+---------+----------------+
| Field | Type            | Null | Key | Default | Extra          |
+-------+-----------------+------+-----+---------+----------------+
| id    | bigint unsigned | NO   | PRI | NULL    | auto_increment |
| name  | varchar(255)    | YES  |     | NULL    |                |
+-------+-----------------+------+-----+---------+----------------+
2 rows in set (0,01 sec)
mysql> SHOW VARIABLES LIKE 'datadir';
+---------------+-----------------------+
| Variable_name | Value                 |
+---------------+-----------------------+
| datadir       | /usr/local/var/mysql/ |
+---------------+-----------------------+
1 row in set (0,09 sec)

mysql> \q
Bye
MacBook-Air-Andrey:~ AShipkov$ cd /usr/local/var/mysql/
MacBook-Air-Andrey:mysql AShipkov$ ls
#innodb_temp			ibdata1
MacBook-Air-Andrey.local.err	ibtmp1
MacBook-Air-Andrey.local.pid	mysql
auto.cnf			mysql.ibd
binlog.000001			performance_schema
binlog.index			private_key.pem
ca-key.pem			public_key.pem
ca.pem				sample
client-cert.pem			server-cert.pem
client-key.pem			server-key.pem
example				sys
ib_buffer_pool			undo_001
ib_logfile0			undo_002
ib_logfile1
mysql> USE SAMPLE 
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+------------------+
| Tables_in_sample |
+------------------+
| users            |
+------------------+
1 row in set (0,01 sec)


4)(по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.

MacBook-Air-Andrey:~ AShipkov$ mysqldump -uroot --opt --where="1 limit 100" mysql help_keyword > first_100_rows_help_keyword.sql
MacBook-Air-Andrey:~ AShipkov$ ls
Algorithms			Public
Applications			PycharmProjects
Creative Cloud Files		Untitled.ipynb
Desktop				VirtualBox VMs
Documents			Yandex.Disk.localized
Downloads			base_python
Hello				cd
Library				dz
Movies				first_100_rows_help_keyword.sql
Music				opt
Pictures			sample.sql
PlayOnMac's virtual drives
MacBook-Air-Andrey:~ AShipkov$ cat first_100_rows_help_keyword.sql 
-- MySQL dump 10.13  Distrib 8.0.19, for osx10.15 (x86_64)
--
-- Host: localhost    Database: mysql
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `help_keyword`
--

DROP TABLE IF EXISTS `help_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_keyword` (
  `help_keyword_id` int unsigned NOT NULL,
  `name` char(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='help keywords';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_keyword`
--
-- WHERE:  1 limit 100

LOCK TABLES `help_keyword` WRITE;
/*!40000 ALTER TABLE `help_keyword` DISABLE KEYS */;
INSERT INTO `help_keyword` VALUES (225,'(JSON'),(226,'->'),(228,'->>'),(46,'<>'),(628,'ACCOUNT'),(422,'ACTION'),(40,'ADD'),(653,'ADMIN'),(108,'AES_DECRYPT'),(109,'AES_ENCRYPT'),(341,'AFTER'),(95,'AGAINST'),(675,'AGGREGATE'),(342,'ALGORITHM'),(488,'ALL'),(41,'ALTER'),(343,'ANALYZE'),(47,'AND'),(311,'ANY_VALUE'),(423,'ARCHIVE'),(102,'ARRAY'),(489,'AS'),(259,'ASC'),(404,'AT'),(513,'AUTOCOMMIT'),(447,'AUTOEXTEND_SIZE'),(344,'AUTO_INCREMENT'),(345,'AVG_ROW_LENGTH'),(527,'BACKUP'),(541,'BEFORE'),(514,'BEGIN'),(48,'BETWEEN'),(72,'BIGINT'),(104,'BINARY'),(704,'BINLOG'),(312,'BIN_TO_UUID'),(8,'BOOL'),(9,'BOOLEAN'),(62,'BOTH'),(408,'BTREE'),(260,'BY'),(33,'BYTE'),(712,'CACHE'),(455,'CALL'),(283,'CAN_ACCESS_COLUMN'),(284,'CAN_ACCESS_DATABASE'),(285,'CAN_ACCESS_TABLE'),(286,'CAN_ACCESS_VIEW'),(424,'CASCADE'),(53,'CASE'),(608,'CATALOG_NAME'),(75,'CEIL'),(76,'CEILING'),(515,'CHAIN'),(346,'CHANGE'),(547,'CHANNEL'),(34,'CHAR'),(30,'CHARACTER'),(687,'CHARSET'),(347,'CHECK'),(348,'CHECKSUM'),(629,'CIPHER'),(609,'CLASS_ORIGIN'),(654,'CLIENT'),(683,'CLONE'),(461,'CLOSE'),(349,'COALESCE'),(707,'CODE'),(316,'COLLATE'),(689,'COLLATION'),(350,'COLUMN'),(351,'COLUMNS'),(610,'COLUMN_NAME'),(321,'COMMENT'),(516,'COMMIT'),(530,'COMMITTED'),(425,'COMPACT'),(322,'COMPLETION'),(679,'COMPONENT'),(426,'COMPRESSED'),(352,'COMPRESSION'),(475,'CONCURRENT'),(605,'CONDITION'),(353,'CONNECTION'),(517,'CONSISTENT'),(354,'CONSTRAINT'),(611,'CONSTRAINT_CATALOG'),(612,'CONSTRAINT_NAME'),(613,'CONSTRAINT_SCHEMA'),(606,'CONTINUE'),(103,'CONVERT'),(258,'COUNT'),(42,'CREATE'),(256,'CREATE_DH_PARAMETERS'),(506,'CROSS'),(427,'CSV'),(268,'CUME_DIST'),(630,'CURRENT'),(116,'CURRENT_ROLE'),(323,'CURRENT_USER');
/*!40000 ALTER TABLE `help_keyword` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-04-13 19:57:56
MacBook-Air-Andrey
