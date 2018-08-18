
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT IGNORE INTO `hpapi_access` (`access_Node`, `access_Model`, `access_Usergroup`) VALUES
('janus',	'BurdenAndBurden',	'canvasser');

INSERT IGNORE INTO `hpapi_column` (`column_Model`, `column_Table`, `column_Column`, `column_Heading`, `column_Hint`, `column_Means_Is_Visible`, `column_Means_Is_Trashed`, `column_Means_Edited_Datetime`, `column_Means_Editor_UUID`) VALUES
('BurdenAndBurden',	'mytable',	'mycolumn1',	'C1',	'My column 1',	0,	0,	0,	0);

INSERT IGNORE INTO `hpapi_columnevent` (`columnevent_Node`, `columnevent_Model`, `columnevent_Table`, `columnevent_Column`, `columnevent_Transport`, `columnevent_Export_On_Insert`, `columnevent_Export_On_Update`) VALUES
('babnet',	'BurdenAndBurden',	'mytable',	'mycolumn1',	'transport1',	0,	0);

INSERT IGNORE INTO `hpapi_export` (`export_Node`, `export_Model`, `export_Transport`, `export_Export_Datetime`, `export_Expiry_Datetime`, `export_SQL`) VALUES
('janus',	'BurdenAndBurden',	'transport1',	'2018-07-07T16:25:54+00:00',	'2018-07-08T16:25:54+00:00',	'myStoredProcedure(\'68cad87d-8202-11e8-a9fa-001f16148bc1\',\'foo\',\'Bar\');\r\n'),
('janus',	'BurdenAndBurden',	'transportother',	'2018-07-01T16:14:03+00:00',	'2018-07-06T16:14:03+00:00',	'CALL somethingOrOther(\'123\');\r\n');

INSERT IGNORE INTO `hpapi_import` (`import_Node`, `import_Model`, `import_Transport`, `import_Cron_Time`) VALUES
('babnet',	'BurdenAndBurden',	'transportother',	'05 06 * * * *');

INSERT IGNORE INTO `hpapi_imported` (`imported_Node`, `imported_Model`, `imported_Transport`, `imported_Export_Node`, `imported_Export_Model`, `imported_Export_Datetime`, `imported_Import_Datetime`) VALUES
('babnet',	'BurdenAndBurden',	'transportother',	'janus',	'BurdenAndBurden',	'2018-07-01T16:14:03+00:00',	'');

INSERT IGNORE INTO `hpapi_sprevent` (`sprevent_Node`, `sprevent_Model`, `sprevent_Spr`, `sprevent_Transport`) VALUES
('babnet',	'BurdenAndBurden',	'babClient',	'babtest');

INSERT IGNORE INTO `hpapi_table` (`table_Model`, `table_Table`, `table_Title`, `table_Description`) VALUES
('BurdenAndBurden',	'mytable',	'My Table',	'Example table');

INSERT IGNORE INTO `hpapi_tableevent` (`tableevent_Node`, `tableevent_Model`, `tableevent_Table`, `tableevent_Transport`, `tableevent_Export_Inserts`, `tableevent_Export_Deletes`) VALUES
('janus',	'BurdenAndBurden',	'mytable',	'transport1',	1,	0);

INSERT IGNORE INTO `hpapi_transport` (`transport_Transport`, `transport_Notes`, `transport_Persistence_Days`) VALUES
('babtest',	'Bab export from paddy',	1),
('transport1',	'First example of a transport (collection of exported SQL)',	1),
('transportother',	'Second transport with a longer storage persistence.',	5);

