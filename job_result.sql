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
        id_name            INT(11)	    NOT NULL,	#ID из таблицы имен
        id_patronymic   INT(11)     NOT NULL,	#ID из таблицы отчеств
        lastname        VARCHAR(30) NOT NULL,
        gender          ENUM('M', 'F')  NOT NULL,
        position        VARCHAR(50) NOT NULL,
        active          TINYINT(1)  NOT NULL,
        date_of_birth   DATE        NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `unique_key_tbl_list` (`id_name`,`id_patronymic`,`lastname`,`date_of_birth`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#    
CREATE TABLE IF NOT EXISTS  tbl_celebration (
        id             INT(11)      NOT NULL AUTO_INCREMENT,
        celebration    VARCHAR(200) NOT NULL,
        gender         ENUM('M', 'F', 'C')   NOT NULL,
        text           VARCHAR(500) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `unique_key_tbl_celebration` (`celebration`)
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
INSERT INTO `tbl_list` (`id_name`,`id_patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES (1, 1,'Гусинский','M','Председатель совета директоров XXX',1,'1958-10-13');
#
# Дальше самостоятельно сейчас эти три строки - неправильные.
#
INSERT INTO `tbl_list` (`name`,`patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES ('Матвей',' Алексеевич','Синица','M','Генеральный директор XXX',1,'1980-09-03');
INSERT INTO `tbl_list` (`name`,`patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES ('Анна',' Викторовна','Кузьмина','F','Директор по корпоративным вопросам XXX',1,'1967-05-07');
INSERT INTO `tbl_list` (`name`,`patronymic`,`lastname`,`gender`,`position`,`active`,`date_of_birth`) VALUES ('Алексей',' Валентинович','Горячев','M','Директор по производству XXX',1,'1979-01-16');

#ошибка строкой ниже: день рождения не есть гендерно-зависимый праздник. Не 'M' а 'C' учти, что 'M', 'F' и 'C' - латинские
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('День рождения','M','Поздравляю Вас с днем рождения!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('День рождения','F','Поздравляю Вас с днем рождения!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('Новый год','C','Поздравляю Вас с Новым годом!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('23 февраля','M','Поздравляю Вас с Днем защитника Отечества!');
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ('8 Марта','F','Поздравляю Вас с 8 Марта!');

# Здесь вопросы опять же к name и patronymic

# Вот так доставать из таблиц только людей: 

SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_list.lastname FROM tbl_name, tbl_patronymic, tbl_list WHERE tbl_name.id = tbl_list.id_name AND tbl_patronymic.id = tbl_list.id_patronymic;

# Вот так доставать из таблиц людей и связанные с ними ОБЩИЕ праздники (НЕ ДНИ РОЖДЕНИЯ!):

SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_list.lastname, tbl_celebration.text FROM tbl_name, tbl_patronymic, tbl_list, tbl_celebration WHERE tbl_name.id = tbl_list.id_name AND tbl_patronymic.id = tbl_list.id_patronymic AND tbl_celebration.gender = 'C';

# Вот так доставать праздники для мужиков (обрати внимание, что запрос отличается): 

SELECT tbl_name.name, tbl_patronymic.patronymic, tbl_list.lastname, tbl_celebration.text FROM tbl_name, tbl_patronymic, tbl_list, tbl_celebration WHERE tbl_name.id = tbl_list.id_name AND tbl_patronymic.id = tbl_list.id_patronymic AND tbl_celebration.gender = 'M' AND tbl_celebration.gender = tbl_list.gender;

# Для женщин напишешь сама. 

# весь блок ниже - мусор. Выброси сама, потом обьясню, почему. 


SELECT CONCAT('Уважаемый ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='М' AND tbl_celebration.celebration='День рождения' AND tbl_celebration.gender='М';

SELECT CONCAT('Уважаемая ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='Ж' AND tbl_celebration.celebration='День рождения' AND tbl_celebration.gender='Ж';

SELECT CONCAT('Уважаемый ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='М' AND tbl_celebration.celebration='Новый год' AND tbl_celebration.gender='О';

SELECT CONCAT('Уважаемая ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='Ж' AND tbl_celebration.celebration='Новый год' AND tbl_celebration.gender='О';

SELECT CONCAT('Уважаемый ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='М' AND tbl_celebration.celebration='23 февраля' AND tbl_celebration.gender='М';

SELECT CONCAT('Уважаемая ', name, ' ', patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender='Ж' AND tbl_celebration.celebration='8 Марта' AND tbl_celebration.gender='Ж';
