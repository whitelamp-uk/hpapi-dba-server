

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;


CREATE TABLE IF NOT EXISTS `hpapi_dba_access` (
  `access_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `access_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `access_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `access_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `access_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`access_Node`,`access_Model`),
  KEY `access_Usergroup` (`access_Usergroup`),
  KEY `access_Model` (`access_Model`,`access_Node`),
  KEY `access_Model_2` (`access_Model`,`access_Table`,`access_Column`),
  CONSTRAINT `hpapi_dba_access_ibfk_2` FOREIGN KEY (`access_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_dba_access_ibfk_3` FOREIGN KEY (`access_Model`, `access_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`),
  CONSTRAINT `hpapi_dba_access_ibfk_5` FOREIGN KEY (`access_Model`, `access_Table`, `access_Column`) REFERENCES `hpapi_dba_column` (`column_Model`, `column_Table`, `column_Column`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_column` (
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
  CONSTRAINT `hpapi_dba_column_ibfk_1` FOREIGN KEY (`column_Model`, `column_Table`) REFERENCES `hpapi_dba_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_dba_column_ibfk_2` FOREIGN KEY (`column_Pattern`) REFERENCES `hpapi_pattern` (`pattern_Pattern`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='column_Ignore = do not include in the model';


CREATE TABLE IF NOT EXISTS `hpapi_dba_columnevent` (
  `columnevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Export_On_Insert` int(1) unsigned NOT NULL,
  `columnevent_Export_On_Update` int(1) unsigned NOT NULL,
  PRIMARY KEY (`columnevent_Node`,`columnevent_Model`,`columnevent_Table`,`columnevent_Column`,`columnevent_Transport`),
  KEY `columnevent_Model` (`columnevent_Model`,`columnevent_Table`,`columnevent_Column`),
  KEY `columnevent_Transport` (`columnevent_Transport`),
  KEY `columnevent_Model_2` (`columnevent_Model`,`columnevent_Node`),
  CONSTRAINT `hpapi_dba_columnevent_ibfk_3` FOREIGN KEY (`columnevent_Model`, `columnevent_Table`, `columnevent_Column`) REFERENCES `hpapi_dba_column` (`column_Model`, `column_Table`, `column_Column`),
  CONSTRAINT `hpapi_dba_columnevent_ibfk_4` FOREIGN KEY (`columnevent_Transport`) REFERENCES `hpapi_dba_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_dba_columnevent_ibfk_5` FOREIGN KEY (`columnevent_Model`, `columnevent_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_export` (
  `export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Exported_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_Expiry_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_SQL` text NOT NULL,
  PRIMARY KEY (`export_Model`,`export_Node`,`export_Transport`,`export_Exported_Datetime`),
  KEY `export_Transport` (`export_Transport`),
  KEY `export_Node` (`export_Node`,`export_Model`),
  CONSTRAINT `hpapi_dba_export_ibfk_2` FOREIGN KEY (`export_Transport`) REFERENCES `hpapi_dba_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_dba_export_ibfk_3` FOREIGN KEY (`export_Model`, `export_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_grant` (
  `grant_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `grant_Type` varchar(64) CHARACTER SET ascii NOT NULL,
  `grant_Level` int(11) unsigned NOT NULL,
  PRIMARY KEY (`grant_Usergroup`,`grant_Type`),
  KEY `grant_Level` (`grant_Level`),
  CONSTRAINT `hpapi_dba_grant_ibfk_1` FOREIGN KEY (`grant_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_dba_grant_ibfk_2` FOREIGN KEY (`grant_Level`) REFERENCES `hpapi_level` (`level_Level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_import` (
  `import_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Cron_Time` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`import_Node`,`import_Model`,`import_Transport`),
  KEY `import_Transport` (`import_Transport`),
  KEY `import_Model` (`import_Model`,`import_Node`),
  CONSTRAINT `hpapi_dba_import_ibfk_2` FOREIGN KEY (`import_Transport`) REFERENCES `hpapi_dba_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_dba_import_ibfk_3` FOREIGN KEY (`import_Model`, `import_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_imported` (
  `imported_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `imported_Import_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`imported_Node`,`imported_Model`,`imported_Transport`,`imported_Export_Datetime`),
  KEY `imported_Export_Model` (`imported_Export_Model`),
  KEY `imported_Export_Node` (`imported_Export_Node`,`imported_Export_Model`,`imported_Transport`,`imported_Export_Datetime`),
  KEY `imported_Model` (`imported_Model`,`imported_Node`),
  CONSTRAINT `hpapi_dba_imported_ibfk_5` FOREIGN KEY (`imported_Export_Node`, `imported_Export_Model`, `imported_Transport`, `imported_Export_Datetime`) REFERENCES `hpapi_dba_export` (`export_Node`, `export_Model`, `export_Transport`, `export_Exported_Datetime`),
  CONSTRAINT `hpapi_dba_imported_ibfk_6` FOREIGN KEY (`imported_Model`, `imported_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_insert` (
  `insert_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`insert_Model`,`insert_Table`,`insert_Usergroup`),
  KEY `insert_Usergroup` (`insert_Usergroup`),
  KEY `insert_Model` (`insert_Model`,`insert_Node`),
  CONSTRAINT `hpapi_dba_insert_ibfk_1` FOREIGN KEY (`insert_Model`, `insert_Table`) REFERENCES `hpapi_dba_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_dba_insert_ibfk_2` FOREIGN KEY (`insert_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_dba_insert_ibfk_3` FOREIGN KEY (`insert_Model`, `insert_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_node` (
  `node_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `node_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `node_DSN` varchar(64) CHARACTER SET ascii NOT NULL,
  `node_Notes` varchar(255) NOT NULL,
  PRIMARY KEY (`node_Model`,`node_Node`),
  CONSTRAINT `hpapi_dba_node_ibfk_1` FOREIGN KEY (`node_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_sprevent` (
  `sprevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`sprevent_Node`,`sprevent_Model`,`sprevent_Spr`,`sprevent_Transport`),
  KEY `sprevent_Model` (`sprevent_Model`,`sprevent_Spr`),
  KEY `sprevent_Transport` (`sprevent_Transport`),
  KEY `sprevent_Model_2` (`sprevent_Model`,`sprevent_Node`),
  CONSTRAINT `hpapi_dba_sprevent_ibfk_3` FOREIGN KEY (`sprevent_Transport`) REFERENCES `hpapi_dba_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_dba_sprevent_ibfk_6` FOREIGN KEY (`sprevent_Model`, `sprevent_Spr`) REFERENCES `hpapi_dba_spr` (`spr_Model`, `spr_Spr`),
  CONSTRAINT `hpapi_dba_sprevent_ibfk_7` FOREIGN KEY (`sprevent_Model`, `sprevent_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_table` (
  `table_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Title` varchar(64) NOT NULL,
  `table_Description` varchar(255) NOT NULL,
  PRIMARY KEY (`table_Model`,`table_Table`),
  CONSTRAINT `hpapi_dba_table_ibfk_1` FOREIGN KEY (`table_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table_Ignore = do not include in the model';


CREATE TABLE IF NOT EXISTS `hpapi_dba_tableevent` (
  `tableevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Export_Inserts` int(1) unsigned NOT NULL,
  `tableevent_Export_Deletes` int(1) unsigned NOT NULL,
  PRIMARY KEY (`tableevent_Node`,`tableevent_Model`,`tableevent_Table`,`tableevent_Transport`),
  KEY `tableevent_Model` (`tableevent_Model`,`tableevent_Table`),
  KEY `tableevent_Transport` (`tableevent_Transport`),
  KEY `tableevent_Model_2` (`tableevent_Model`,`tableevent_Node`),
  CONSTRAINT `hpapi_dba_tableevent_ibfk_2` FOREIGN KEY (`tableevent_Model`, `tableevent_Table`) REFERENCES `hpapi_dba_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_dba_tableevent_ibfk_3` FOREIGN KEY (`tableevent_Transport`) REFERENCES `hpapi_dba_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_dba_tableevent_ibfk_4` FOREIGN KEY (`tableevent_Model`, `tableevent_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_dba_transport` (
  `transport_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `transport_Notes` text NOT NULL,
  `transport_Persistence_Days` int(4) unsigned NOT NULL,
  PRIMARY KEY (`transport_Transport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grouping of SQL for export to (many) database instances';


CREATE TABLE IF NOT EXISTS `hpapi_dba_update` (
  `update_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`update_Model`,`update_Table`,`update_Column`,`update_Usergroup`),
  KEY `update_Usergroup` (`update_Usergroup`),
  KEY `update_Model` (`update_Model`,`update_Node`),
  CONSTRAINT `hpapi_dba_update_ibfk_2` FOREIGN KEY (`update_Model`, `update_Table`, `update_Column`) REFERENCES `hpapi_dba_column` (`column_Model`, `column_Table`, `column_Column`),
  CONSTRAINT `hpapi_dba_update_ibfk_3` FOREIGN KEY (`update_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_dba_update_ibfk_4` FOREIGN KEY (`update_Model`, `update_Node`) REFERENCES `hpapi_dba_node` (`node_Model`, `node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

