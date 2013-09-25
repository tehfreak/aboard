delimiter $$

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_user_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
