delimiter $$

CREATE TABLE `entry_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `role` varchar(45) NOT NULL,
  `value` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `i_entry_permission_entry` (`entryId`),
  CONSTRAINT `f_entry_permission_entry` FOREIGN KEY (`entryId`) REFERENCES `entry` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
