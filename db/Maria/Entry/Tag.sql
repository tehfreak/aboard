delimiter $$

CREATE TABLE `entry_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `tagId` int(11) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT NULL,
  `deletedAt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_entry_tag` (`entryId`,`tagId`),
  UNIQUE KEY `u_tag_entry` (`tagId`,`entryId`),
  KEY `f_entry_tag_entry_idx` (`entryId`),
  KEY `f_entry_tag_tag_idx` (`tagId`),
  CONSTRAINT `f_entry_tag_tag` FOREIGN KEY (`tagId`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `f_entry_tag_entry` FOREIGN KEY (`entryId`) REFERENCES `entry` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
