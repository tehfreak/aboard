delimiter $$

CREATE TABLE `profile_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profileId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `i_profile_group_profileId` (`profileId`),
  KEY `i_profile_group_groupId` (`groupId`),
  CONSTRAINT `f_profile_group_groupId` FOREIGN KEY (`groupId`) REFERENCES `profile` (`id`) ON DELETE CASCADE,
  CONSTRAINT `f_profile_group_profileId` FOREIGN KEY (`profileId`) REFERENCES `profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
