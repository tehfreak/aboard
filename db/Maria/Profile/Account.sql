delimiter $$

CREATE TABLE `profile_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profileId` int(11) NOT NULL,
  `type` varchar(45) NOT NULL DEFAULT 'local',
  `name` varchar(45) NOT NULL,
  `pass` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_profile_account_identity` (`name`),
  UNIQUE KEY `u_profile_account_credential` (`name`,`pass`),
  KEY `i_profile_account_profileId` (`profileId`),
  CONSTRAINT `f_profile_account_profileId` FOREIGN KEY (`profileId`) REFERENCES `profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
