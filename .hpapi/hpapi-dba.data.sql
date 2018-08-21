
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT IGNORE INTO `hpapi_dba_grant` (`grant_Usergroup`, `grant_Type`, `grant_Level`) VALUES
('sysadmin',	'call',	0),
('sysadmin',	'membership',	0),
('sysadmin',	'run',	1),
('admin',	'membership',	2),
('staff',	'membership',	100000);

INSERT IGNORE INTO `hpapi_dba_node` (`node_Node`, `node_Name`) VALUES
('default',	'Default Node');

