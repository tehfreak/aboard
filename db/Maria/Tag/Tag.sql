delimiter $$

CREATE TABLE `tag_tag` (
  `id` int(11) NOT NULL,
  `tagId` int(11) NOT NULL,
  `parentId` int(11) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT NULL,
  `deletedAt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_tag_tag` (`tagId`,`parentId`),
  KEY `f_tag_tag_tagId_idx` (`tagId`),
  KEY `f_tag_tag_parentId_idx` (`parentId`),
  CONSTRAINT `f_tag_tag_parentId` FOREIGN KEY (`parentId`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `f_tag_tag_tagId` FOREIGN KEY (`tagId`) REFERENCES `tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
