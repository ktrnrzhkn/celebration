CREATE DATABASE IF NOT EXISTS job_result CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON job_result.* TO 'kthrn'@'localhost';
flush PRIVILEGES;

#
DROP TABLE IF EXISTS tbl_name;
DROP TABLE IF EXISTS tbl_patronymic;
DROP TABLE IF EXISTS tbl_list;
DROP TABLE IF EXISTS tbl_celebration;

#
CREATE TABLE IF NOT EXISTS tbl_name (
        id              INT(11)     NOT NULL AUTO_INCREMENT,
        name            VARCHAR(30) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
CREATE TABLE IF NOT EXISTS tbl_patronymic (
        id              INT(11)     NOT NULL AUTO_INCREMENT,
        patronymic      VARCHAR(30) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `patronymic` (`patronymic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Если name и patronymic будут ссылкой на id, то тип данных VARCHAR должен быть или нет? И тут я пробовала создать FOREIGN KEY, когда все легло
CREATE TABLE IF NOT EXISTS tbl_list (
        id              INT(11)     NOT NULL AUTO_INCREMENT,
        name            VARCHAR(30) NOT NULL,
        patronymic      VARCHAR(30) NOT NULL,
        lastname        VARCHAR(30) NOT NULL,
        gender          VARCHAR(1)  NOT NULL,
        position        VARCHAR(50) NOT NULL,
        active          TINYINT(1)  NOT NULL,
        date_of_birth   DATE        NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `my_unique_key` (`name`,`patronymic`,`lastname`,`date_of_birth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#    
CREATE TABLE IF NOT EXISTS  tbl_celebration (
        id             INT(11)      NOT NULL AUTO_INCREMENT,
        celebration    VARCHAR(200) NOT NULL,
        gender         VARCHAR(1)   NOT NULL,
        text           VARCHAR(500) NOT NULL,
        PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
INSERT INTO `tbl_name` (`name`) VALUES ('Алексей');
INSERT INTO `tbl_name` (`name`) VALUES ('Марк');
INSERT INTO `tbl_name` (`name`) VALUES ('Матвей');
INSERT INTO `tbl_name` (`name`) VALUES ('Ольга');

#
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Алексеевич');
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Викторовна');
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Владимирович');
INSERT INTO `tbl_patronymic` (`patronymic`) VALUES ('Леонидович');

# Ниже не исправлены name и patronymic
INSERT INTO `tbl_list` (`name`,`patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES ('Марк', 'Леонидович','Гусинский','М','Председатель совета директоров XXX',1,'1958-10-13');
INSERT INTO `tbl_list` (`name`,`patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES ('Матвей',' Алексеевич','Синица','М','Генеральный директор XXX',1,'1980-09-03');
INSERT INTO `tbl_list` (`name`,`patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES ('Анна',' Викторовна','Кузьмина','Ж','Директор по корпоративным вопросам XXX',1,'1967-05-07');
INSERT INTO `tbl_list` (`name`,`patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES ('Алексей',' Валентинович','Горячев','М','Директор по производству XXX',1,'1979-01-16');

#
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('День рождения','М','Поздравляю Вас с днем рождения!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('День рождения','Ж','Поздравляю Вас с днем рождения!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('Новый год','О','Поздравляю Вас с Новым годом!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('23 февраля','М','Поздравляю Вас с Днем защитника Отечества!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('8 Марта','Ж','Поздравляю Вас с 8 Марта!');

# Здесь вопросы опять же к name и patronymic
SELECT CONCAT('Уважаемый ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='М' AND tbl_celebration.celebration='День рождения' AND tbl_celebration.gender='М';

SELECT CONCAT('Уважаемая ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='Ж' AND tbl_celebration.celebration='День рождения' AND tbl_celebration.gender='Ж';

SELECT CONCAT('Уважаемый ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='М' AND tbl_celebration.celebration='Новый год' AND tbl_celebration.gender='О';

SELECT CONCAT('Уважаемая ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='Ж' AND tbl_celebration.celebration='Новый год' AND tbl_celebration.gender='О';

SELECT CONCAT('Уважаемый ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='М' AND tbl_celebration.celebration='23 февраля' AND tbl_celebration.gender='М';

SELECT CONCAT('Уважаемая ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='Ж' AND tbl_celebration.celebration='8 Марта' AND tbl_celebration.gender='Ж';
