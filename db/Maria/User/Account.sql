delimiter $$

CREATE TABLE `user_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `pass` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_user_account_identity` (`name`),
  UNIQUE KEY `u_user_account_credential` (`name`,`pass`),
  KEY `i_user_account_userId` (`userId`),
  CONSTRAINT `f_user_account_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
