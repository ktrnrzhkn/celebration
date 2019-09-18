CREATE DATABASE IF NOT EXISTS job_result CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON job_result.* TO 'kthrn'@'localhost';
flush PRIVILEGES;

#
DROP TABLE IF EXISTS tbl_list;
DROP TABLE IF EXISTS tbl_celebration;

#
CREATE TABLE IF NOT EXISTS tbl_list (
        id              INT(11)     NOT NULL AUTO_INCREMENT,
        name_patronymic VARCHAR(30) NOT NULL,
        lastname        VARCHAR(30) NOT NULL,
        gender          TINYINT(1) NOT NULL,
        position        VARCHAR(50) NOT NULL,
        date_of_birth   DATE NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#    
CREATE TABLE IF NOT EXISTS  tbl_celebration (
        id             INT(11)     NOT NULL AUTO_INCREMENT,
        celebration    VARCHAR(200) NOT NULL,
        gender      TINYINT(1) NOT NULL,
        text    VARCHAR(500) NOT NULL,
        PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
INSERT INTO `tbl_list` (`name_patronymic`,`lastname`,`gender`,`position`,`date_of_birth`) VALUES ('Виктор Филиппович','Рашников',0,'Председатель совета директоров ММК','1948-10-13');
INSERT INTO `tbl_list` (`name_patronymic`,`lastname`,`gender`,`position`,`date_of_birth`) VALUES ('Павел Владимирович','Шиляев',0,'Генеральный директор ММК','1970-07-03');
INSERT INTO `tbl_list` (`name_patronymic`,`lastname`,`gender`,`position`,`date_of_birth`) VALUES ('Ольга Викторовна','Рашникова',1,'Неисполнительный директор ММК','1977-02-06');
INSERT INTO `tbl_list` (`name_patronymic`,`lastname`,`gender`,`position`,`date_of_birth`) VALUES ('Сергей Валентинович','Кривощеков',0,'Директор по корпоративным вопросам ММК','1961-02-16');

#
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ("День рождения","0","Поздравляю Вас с днем рождения!");
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ("День рождения","1","Поздравляю Вас с днем рождения!");
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ("Новый год","2","Поздравляю Вас с Новым годом!");
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ("23 февраля","0","Поздравляю Вас с Днем защитника Отечества!");
INSERT INTO `tbl_celebration` (`celebration`,`gender`,`text`)  VALUES ("8 Марта","1","Поздравляю Вас с 8 Марта!");

# 
SELECT CONCAT('Уважаемый ', name_patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender=0 AND tbl_celebration.celebration="День рождения" AND tbl_celebration.gender=0;

SELECT CONCAT('Уважаемая ', name_patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender=1 AND tbl_celebration.celebration="День рождения" AND tbl_celebration.gender=1;

SELECT CONCAT('Уважаемый ', name_patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender=0 AND tbl_celebration.celebration="Новый год" AND tbl_celebration.gender=2;

SELECT CONCAT('Уважаемая ', name_patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender=1 AND tbl_celebration.celebration="Новый год" AND tbl_celebration.gender=2;

SELECT CONCAT('Уважаемый ', name_patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender=0 AND tbl_celebration.celebration="23 февраля" AND tbl_celebration.gender=0;

SELECT CONCAT('Уважаемая ', name_patronymic, '! ', text) FROM tbl_list, tbl_celebration WHERE tbl_list.gender=1 AND tbl_celebration.celebration="8 Марта" AND tbl_celebration.gender=1;

