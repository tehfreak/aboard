delimiter $$

CREATE TABLE `profile_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profileId` int(11) NOT NULL,
  `permissionId` int(11) NOT NULL,
  `value` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `i_profile_permission_profileId` (`profileId`),
  KEY `i_profile_permission_permissionId` (`permissionId`),
  CONSTRAINT `f_profile_permission_profileId` FOREIGN KEY (`profileId`) REFERENCES `profile` (`id`) ON DELETE CASCADE,
  CONSTRAINT `f_profile_permission_permissionId` FOREIGN KEY (`permissionId`) REFERENCES `permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
