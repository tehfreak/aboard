delimiter $$

CREATE TABLE `user_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `permissionId` int(11) NOT NULL,
  `value` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `i_user_permission_userId` (`userId`),
  KEY `i_user_permission_permissionId` (`permissionId`),
  CONSTRAINT `f_user_permission_permissionId` FOREIGN KEY (`permissionId`) REFERENCES `permission` (`id`) ON DELETE CASCADE,
  CONSTRAINT `f_user_permission_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$

