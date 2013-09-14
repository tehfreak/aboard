delimiter $$

CREATE TABLE `entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'entryId',
  `name` varchar(45) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT NULL,
  `deletedAt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_entry_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
