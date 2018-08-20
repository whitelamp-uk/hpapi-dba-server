
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT IGNORE INTO `hpapi_dba_grant` (`grant_Usergroup`, `grant_Type`, `grant_Level`) VALUES
('sysadmin',  'membership', 0),
('sysadmin',  'call', 1),
('sysadmin',  'run',  1),
('admin', 'membership', 2),
('staff', 'membership', 100000);

INSERT IGNORE INTO `hpapi_dba_import` (`import_Node`, `import_Model`, `import_Transport`, `import_Cron_Time`) VALUES
('babnet',	'BurdenAndBurden',	'transportother',	'05 06 * * * *');

INSERT IGNORE INTO `hpapi_dba_imported` (`imported_Node`, `imported_Model`, `imported_Transport`, `imported_Export_Node`, `imported_Export_Model`, `imported_Export_Datetime`, `imported_Import_Datetime`) VALUES
('babnet',	'BurdenAndBurden',	'transportother',	'janus',	'BurdenAndBurden',	'2018-07-01T16:14:03+00:00',	'');

INSERT IGNORE INTO `hpapi_dba_database` (`database_Node`, `database_Model`, `database_Notes`) VALUES
('default',	'HpapiModel',	'Hpapi database at default location');

INSERT IGNORE INTO `hpapi_dba_node` (`node_Node`, `node_Name`) VALUES
('default',	'Default Node');

