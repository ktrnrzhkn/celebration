CREATE DATABASE IF NOT EXISTS job_result CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON job_result.* TO 'kthrn'@'localhost';
flush PRIVILEGES;

#
DROP TABLE IF EXISTS tbl_name;
DROP TABLE IF EXISTS tbl_patronymic;
DROP TABLE IF EXISTS tbl_people;
DROP TABLE IF EXISTS tbl_celebration;

#
CREATE TABLE IF NOT EXISTS tbl_name (
        id              INT(11)         NOT NULL AUTO_INCREMENT,
        name            VARCHAR(30)     NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
CREATE TABLE IF NOT EXISTS tbl_patronymic (
        id              INT(11)         NOT NULL AUTO_INCREMENT,
        patronymic      VARCHAR(30)     NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `patronymic` (`patronymic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
CREATE TABLE IF NOT EXISTS tbl_people (
        id              INT(11)         NOT NULL AUTO_INCREMENT,
        id_name         INT(11)	        NOT NULL,	#ID из таблицы имен
        id_patronymic   INT(11)         NOT NULL,	#ID из таблицы отчеств
        lastname        VARCHAR(30)     NOT NULL,
        gender          ENUM('M', 'F')  NOT NULL,
        position        VARCHAR(50)     NOT NULL,
        active          TINYINT(1)      NOT NULL,
        date_of_birth   DATE            NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `unique_key_tbl_people` (`id_name`,`id_patronymic`,`lastname`,`date_of_birth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#    
CREATE TABLE IF NOT EXISTS  tbl_celebration (
        id             INT(11)          NOT NULL AUTO_INCREMENT,
        celebration    VARCHAR(200)     NOT NULL,
        gender_relation  ENUM('M', 'F', 'C')   NOT NULL,
        text           VARCHAR(500)     NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `unique_key_tbl_celebration` (`celebration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
INSERT INTO `tbl_name` (`name`) VALUES ('Алексей');
INSERT INTO `tbl_name` (`name`) VALUES ('Анна');
INSERT INTO `tbl_name` (`name`) VALUES ('Марк');
INSERT INTO `tbl_name` (`name`) VALUES ('Матвей');

#
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Алексеевич');
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Викторовна');
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Владимирович');
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Леонидович');

#
INSERT INTO `tbl_people` (`id_name`,`id_patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES (3,4,'Гусинский','M','Председатель совета директоров XXX',1,'1958-10-13');
INSERT INTO `tbl_people` (`id_name`,`id_patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES (4,1,'Синица','M','Генеральный директор XXX',1,'1980-09-03');
INSERT INTO `tbl_people` (`id_name`,`id_patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES (2,2,'Кузьмина','F','Директор по корпоративным вопросам XXX',1,'1967-05-07');
INSERT INTO `tbl_people` (`id_name`,`id_patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES (1,3,'Горячев','M','Директор по производству XXX',1,'1979-05-16');

# Не поняла, что прописывать в `gender_relation` для дня рождения. Оставила пустым. Так выборка за месяц работает. 
INSERT INTO `tbl_celebration` (`celebration`,`gender_relation`,`text`)  VALUES ('День рождения','','Поздравляю Вас с днем рождения!');
INSERT INTO `tbl_celebration` (`celebration`,`gender_relation`,`text`)  VALUES ('Новый год','C','Поздравляю Вас с Новым годом!');
INSERT INTO `tbl_celebration` (`celebration`,`gender_relation`,`text`)  VALUES ('23 февраля','M','Поздравляю Вас с Днем защитника Отечества!');
INSERT INTO `tbl_celebration` (`celebration`,`gender_relation`,`text`)  VALUES ('8 Марта','F','Поздравляю Вас с 8 Марта!');

# Только люди (ФИО):
SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_people.lastname FROM tbl_name, tbl_patronymic, tbl_people WHERE tbl_name.id = tbl_people.id_name AND tbl_patronymic.id = tbl_people.id_patronymic;

# Люди и связанные с ними ОБЩИЕ праздники (НЕ ДНИ РОЖДЕНИЯ!):
SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_people.lastname, tbl_celebration.text FROM tbl_name, tbl_patronymic, tbl_people, tbl_celebration WHERE tbl_name.id = tbl_people.id_name AND tbl_patronymic.id = tbl_people.id_patronymic AND tbl_celebration.gender_relation = 'C';

# Праздники только для мужчин:
SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_people.lastname, tbl_celebration.text FROM tbl_name, tbl_patronymic, tbl_people, tbl_celebration WHERE tbl_name.id = tbl_people.id_name AND tbl_patronymic.id = tbl_people.id_patronymic AND tbl_celebration.gender_relation = 'M' AND tbl_celebration.gender_relation = tbl_people.gender;

# Праздники только для женщин:
SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_people.lastname, tbl_celebration.text FROM tbl_name, tbl_patronymic, tbl_people, tbl_celebration WHERE tbl_name.id = tbl_people.id_name AND tbl_patronymic.id = tbl_people.id_patronymic AND tbl_celebration.gender_relation = 'F' AND tbl_celebration.gender_relation = tbl_people.gender;

#Дни рождения за определенный месяц. Например, май:
SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_people.lastname, tbl_celebration.text FROM tbl_name, tbl_patronymic, tbl_people, tbl_celebration WHERE tbl_name.id = tbl_people.id_name AND tbl_patronymic.id = tbl_people.id_patronymic AND tbl_celebration.celebration = 'День рождения' AND tbl_people.active = 1 AND MONTHNAME(tbl_people.date_of_birth) = 'May';
