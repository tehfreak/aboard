delimiter $$

CREATE TABLE `profile_phone` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profileId` int(11) NOT NULL,
  `value` varchar(255) NOT NULL,
  `verifiedAt` timestamp NULL DEFAULT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_phone` (`value`),
  KEY `i_profile_phone_profileId` (`profileId`),
  CONSTRAINT `f_profile_phone_profileId` FOREIGN KEY (`profileId`) REFERENCES `profile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$
