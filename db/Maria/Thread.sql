delimiter $$

CREATE TABLE `thread` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_thread_entryId` (`entryId`),
  CONSTRAINT `f_thread_entryId` FOREIGN KEY (`entryId`) REFERENCES `entry` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
