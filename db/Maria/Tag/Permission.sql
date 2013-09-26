delimiter $$

CREATE TABLE `tag_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tagId` int(11) NOT NULL,
  `permissionId` int(11) NOT NULL,
  `value` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `i_tag_permission_tagId` (`tagId`),
  KEY `i_tag_permission_permissionId` (`permissionId`),
  CONSTRAINT `f_tag_permission_tagId` FOREIGN KEY (`tagId`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `f_tag_permission_permissionId` FOREIGN KEY (`permissionId`) REFERENCES `permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
