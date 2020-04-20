use rd_staging;
CREATE TABLE IF NOT EXISTS `seq` (
  `name` varchar(20) NOT NULL,
  `val` int(10) unsigned NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `seq` (`name`, `val`)
SELECT 'cds', 0 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `seq` WHERE `name` = 'cds');