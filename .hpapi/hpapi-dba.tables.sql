-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;


CREATE TABLE IF NOT EXISTS `hpapi_access` (
  `access_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `access_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `access_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`access_Node`,`access_Model`),
  KEY `access_Usergroup` (`access_Usergroup`),
  CONSTRAINT `hpapi_access_ibfk_1` FOREIGN KEY (`access_Node`, `access_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`),
  CONSTRAINT `hpapi_access_ibfk_2` FOREIGN KEY (`access_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_column` (
  `column_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `column_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `column_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `column_Heading` varchar(64) NOT NULL,
  `column_Hint` varchar(255) NOT NULL,
  `column_Pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `column_Means_Is_Visible` int(1) unsigned NOT NULL,
  `column_Means_Is_Trashed` int(1) unsigned NOT NULL,
  `column_Means_Edited_Datetime` int(1) unsigned NOT NULL,
  `column_Means_Editor_UUID` int(1) unsigned NOT NULL,
  PRIMARY KEY (`column_Model`,`column_Table`,`column_Column`),
  KEY `column_Pattern` (`column_Pattern`),
  CONSTRAINT `hpapi_column_ibfk_1` FOREIGN KEY (`column_Model`, `column_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_column_ibfk_2` FOREIGN KEY (`column_Pattern`) REFERENCES `hpapi_pattern` (`pattern_Pattern`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='column_Ignore = do not include in the model';


CREATE TABLE IF NOT EXISTS `hpapi_columnevent` (
  `columnevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Export_On_Insert` int(1) unsigned NOT NULL,
  `columnevent_Export_On_Update` int(1) unsigned NOT NULL,
  PRIMARY KEY (`columnevent_Node`,`columnevent_Model`,`columnevent_Table`,`columnevent_Column`,`columnevent_Transport`),
  KEY `columnevent_Model` (`columnevent_Model`,`columnevent_Table`,`columnevent_Column`),
  KEY `columnevent_Transport` (`columnevent_Transport`),
  CONSTRAINT `hpapi_columnevent_ibfk_3` FOREIGN KEY (`columnevent_Model`, `columnevent_Table`, `columnevent_Column`) REFERENCES `hpapi_column` (`column_Model`, `column_Table`, `column_Column`),
  CONSTRAINT `hpapi_columnevent_ibfk_4` FOREIGN KEY (`columnevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_columnevent_ibfk_5` FOREIGN KEY (`columnevent_Node`, `columnevent_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_export` (
  `export_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Export_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_Expiry_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_SQL` text NOT NULL,
  PRIMARY KEY (`export_Model`,`export_Transport`,`export_Export_Datetime`),
  KEY `export_Transport` (`export_Transport`),
  KEY `export_Node` (`export_Node`,`export_Model`),
  CONSTRAINT `hpapi_export_ibfk_2` FOREIGN KEY (`export_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_export_ibfk_3` FOREIGN KEY (`export_Node`, `export_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_import` (
  `import_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Cron_Time` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`import_Node`,`import_Model`,`import_Transport`),
  KEY `import_Transport` (`import_Transport`),
  CONSTRAINT `hpapi_import_ibfk_2` FOREIGN KEY (`import_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_import_ibfk_3` FOREIGN KEY (`import_Node`, `import_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_imported` (
  `imported_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `imported_Import_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`imported_Node`,`imported_Model`,`imported_Transport`,`imported_Export_Datetime`),
  KEY `imported_Export_Model` (`imported_Export_Model`),
  KEY `imported_Export_Node` (`imported_Export_Node`,`imported_Export_Model`,`imported_Transport`,`imported_Export_Datetime`),
  CONSTRAINT `hpapi_imported_ibfk_3` FOREIGN KEY (`imported_Node`, `imported_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`),
  CONSTRAINT `hpapi_imported_ibfk_5` FOREIGN KEY (`imported_Export_Node`, `imported_Export_Model`, `imported_Transport`, `imported_Export_Datetime`) REFERENCES `hpapi_export` (`export_Node`, `export_Model`, `export_Transport`, `export_Export_Datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_insert` (
  `insert_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`insert_Model`,`insert_Table`,`insert_Usergroup`),
  KEY `insert_Usergroup` (`insert_Usergroup`),
  CONSTRAINT `hpapi_insert_ibfk_1` FOREIGN KEY (`insert_Model`, `insert_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_insert_ibfk_2` FOREIGN KEY (`insert_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_sprevent` (
  `sprevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`sprevent_Node`,`sprevent_Model`,`sprevent_Spr`,`sprevent_Transport`),
  KEY `sprevent_Model` (`sprevent_Model`,`sprevent_Spr`),
  KEY `sprevent_Transport` (`sprevent_Transport`),
  CONSTRAINT `hpapi_sprevent_ibfk_3` FOREIGN KEY (`sprevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_sprevent_ibfk_5` FOREIGN KEY (`sprevent_Node`, `sprevent_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`),
  CONSTRAINT `hpapi_sprevent_ibfk_6` FOREIGN KEY (`sprevent_Model`, `sprevent_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_table` (
  `table_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Title` varchar(64) NOT NULL,
  `table_Description` varchar(255) NOT NULL,
  PRIMARY KEY (`table_Model`,`table_Table`),
  CONSTRAINT `hpapi_table_ibfk_1` FOREIGN KEY (`table_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table_Ignore = do not include in the model';


CREATE TABLE IF NOT EXISTS `hpapi_tableevent` (
  `tableevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Export_Inserts` int(1) unsigned NOT NULL,
  `tableevent_Export_Deletes` int(1) unsigned NOT NULL,
  PRIMARY KEY (`tableevent_Node`,`tableevent_Model`,`tableevent_Table`,`tableevent_Transport`),
  KEY `tableevent_Model` (`tableevent_Model`,`tableevent_Table`),
  KEY `tableevent_Transport` (`tableevent_Transport`),
  CONSTRAINT `hpapi_tableevent_ibfk_2` FOREIGN KEY (`tableevent_Model`, `tableevent_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_tableevent_ibfk_3` FOREIGN KEY (`tableevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_tableevent_ibfk_4` FOREIGN KEY (`tableevent_Node`, `tableevent_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_transport` (
  `transport_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `transport_Notes` text NOT NULL,
  `transport_Persistence_Days` int(4) unsigned NOT NULL,
  PRIMARY KEY (`transport_Transport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grouping of SQL for export to (many) database instances';


CREATE TABLE IF NOT EXISTS `hpapi_trash` (
  `delete_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `delete_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `delete_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`delete_Model`,`delete_Table`,`delete_Usergroup`),
  KEY `delete_Usergroup` (`delete_Usergroup`),
  CONSTRAINT `hpapi_trash_ibfk_1` FOREIGN KEY (`delete_Model`, `delete_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_trash_ibfk_2` FOREIGN KEY (`delete_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_update` (
  `update_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`update_Model`,`update_Table`,`update_Column`,`update_Usergroup`),
  KEY `update_Usergroup` (`update_Usergroup`),
  CONSTRAINT `hpapi_update_ibfk_2` FOREIGN KEY (`update_Model`, `update_Table`, `update_Column`) REFERENCES `hpapi_column` (`column_Model`, `column_Table`, `column_Column`),
  CONSTRAINT `hpapi_update_ibfk_3` FOREIGN KEY (`update_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


