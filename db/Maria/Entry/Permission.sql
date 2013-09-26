delimiter $$

CREATE TABLE `entry_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `permissionId` int(11) NOT NULL,
  `value` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `i_entry_permission_entryId` (`entryId`),
  KEY `i_entry_permission_permissionId` (`permissionId`),
  CONSTRAINT `f_entry_permission_entryId` FOREIGN KEY (`entryId`) REFERENCES `entry` (`id`) ON DELETE CASCADE,
  CONSTRAINT `f_entry_permission_permissionId` FOREIGN KEY (`permissionId`) REFERENCES `permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
