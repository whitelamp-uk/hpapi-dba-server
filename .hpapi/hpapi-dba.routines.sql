

SET NAMES utf8;
SET time_zone = '+00:00';


DELIMITER $$




-- COLUMN INFORMATION

DROP PROCEDURE IF EXISTS `hpapiDbaColumnsInfo`$$
CREATE PROCEDURE `hpapiDbaColumnsInfo`(
  IN        `databaseName` VARCHAR(64) CHARSET ascii
 ,IN        `tableName` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    `COLUMNS`.`TABLE_SCHEMA` AS `database`
   ,`COLUMNS`.`TABLE_NAME` AS `table`
   ,`COLUMNS`.`COLUMN_NAME` AS `column`
   ,`COLUMNS`.`IS_NULLABLE` AS `emptyIsNull`
   ,`COLUMNS`.`CHARACTER_MAXIMUM_LENGTH` AS `varcharLength`
  FROM `INFORMATION_SCHEMA`.`COLUMNS`
  LEFT JOIN `INFORMATION_SCHEMA`.`KEY_COLUMN_USAGE`
         ON `KEY_COLUMN_USAGE`.`CONSTRAINT_NAME`='PRIMARY'
        AND `KEY_COLUMN_USAGE`.`TABLE_CATALOG`=`COLUMNS`.`TABLE_CATALOG`
        AND `KEY_COLUMN_USAGE`.`TABLE_SCHEMA`=`COLUMNS`.`TABLE_SCHEMA`
        AND `KEY_COLUMN_USAGE`.`TABLE_NAME`=`COLUMNS`.`TABLE_NAME`
        AND `KEY_COLUMN_USAGE`.`COLUMN_NAME`=`COLUMNS`.`COLUMN_NAME`
  WHERE `COLUMNS`.`TABLE_CATALOG`='def'
    AND `COLUMNS`.`TABLE_SCHEMA`=databaseName
    AND `COLUMNS`.`TABLE_NAME`=tableName
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaColumnsDefn`$$
CREATE PROCEDURE `hpapiDbaColumnsDefn`(
  IN        `columnModel` VARCHAR(64) CHARSET ascii
 ,IN        `columnTable` VARCHAR(64) CHARSET ascii
 ,IN        `columnColumn` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    `column_Model` AS `model`
   ,`column_Table` AS `table`
   ,`column_Column` AS `column`
   ,`column_Heading` AS `heading`
   ,`column_Hint` AS `hint`
   ,`column_Means_Is_Readable` AS `meansIsVisible`
   ,`column_Means_Is_Trashed` AS `meansIsTrashed`
   ,`column_Means_Edited_Datetime` AS `meansEditedDatetime`
   ,`column_Means_Editor_UUID` AS `meansEditorUUID`
   ,`pattern_Pattern` AS `pattern`
   ,`pattern_Constraints` AS `constraints`
   ,`pattern_Expression` AS `expression`
   ,`pattern_Input` AS `input`
   ,`pattern_Php_Filter` AS `phpFilter`
   ,`pattern_Length_Minimum` AS `lengthMinimum`
   ,`pattern_Length_Maximum` AS `lengthMaximum`
   ,`pattern_Value_Minimum` AS `valueMinimum`
   ,`pattern_Value_Maximum` AS `valueMinimum`
  FROM `hpapi_dba_column`
  LEFT JOIN `hpapi_dba_pattern`
         ON `pattern_Pattern`=`column_Pattern`
  WHERE `column_Model`=columnModel
    AND `column_Table`=columnTable
    AND `column_Column`=columnColumn
  ;
END$$





-- ALLOW GRANTING

DROP PROCEDURE IF EXISTS `hpapiDbaGrantAllowed`$$
CREATE PROCEDURE `hpapiDbaGrantAllowed`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `grantType` VARCHAR(64) CHARSET ascii
 ,IN        `membershipUsergroup` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    COUNT(`grant_Level`)>0 AS `allowed`
  FROM `hpapi_dba_grant`
  INNER JOIN `hpapi_membership`
          ON `membership_Usergroup`=`grant_Usergroup`
  INNER JOIN `hpapi_usergroup` AS `granter`
          ON `granter`.`usergroup_Usergroup`=`membership_Usergroup`
  INNER JOIN `hpapi_usergroup` AS `grantee`
          ON `grantee`.`usergroup_Usergroup`=`membership_Usergroup`
  WHERE `membership_User_UUID`=userUUID
    AND `grant_Type`=grantType
    AND (
      (
           grantType='call'
      )
      OR (
           grantType!='call'
           `grant_Level`='0'
       AND `grant_Usergroup`=`granter`.`membership_Usergroup`
      )
      OR (
           grantType!='call'
           `grant_Level`!='0'
       AND `grant_Level`<=`grantee`.`usergroup_Level`
      )
    )
  ;
END$$



-- ADMINISTRATE ACCESS TO USERGROUPS

DROP PROCEDURE IF EXISTS `hpapiDbaMembershipInsert`$$
CREATE PROCEDURE `hpapiDbaMembershipInsert`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  INSERT IGNORE INTO `hpapi_membership`
  SET
    `membership_UserUUID`=userUUID
   ,`membership_Usergroup`=usergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaMembershipDelete`$$
CREATE PROCEDURE `hpapiDbaMembershipDelete`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_membership`
  WHERE `membership_UserUUID`=userUUID
    AND `membership_Usergroup`=usergroup
    AND CHAR_LENGTH(`membership_UserUUID`)>0
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaMembershipsForUser`$$
CREATE PROCEDURE `hpapiDbaMembershipsForUser`(
  IN        `userUUID` CHAR(52) CHARSET ascii
)
BEGIN
  SELECT
    `usergroup_Name` AS `usergroupName`
   ,`usergroup_Notes` AS `usergroupNotes`
   ,`usergroup_Level` AS `usergroupLevel`
   ,`level_Name` AS `levelName`
   ,`level_Notes` AS `levelNotes`
  FROM `hpapi_membership`
  LEFT JOIN `hpapi_usergroup`
         ON `usergroup_Usergroup`=`membership_Usergroup`
  LEFT JOIN `hpapi_level`
         ON `level_Level`=`usergroup_Level`
  WHERE `membership_UserUUID`=userUUID
  ORDER BY `level_Level`
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaMembershipsForUsergroup`$$
CREATE PROCEDURE `hpapiDbaMembershipsForUsergroup`(
  IN        `usergroup` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    IF(`user_Active`>0,'ACTIVE','') AS `active`
   ,`user_UUID` AS `userUUID`
   ,GROUP_CONCAT(`key_Key` SEPARATOR ',') AS `keys`
   ,GROUP_CONCAT(`email_Email` SEPARATOR ',') AS `emails`
   ,`user_Name`
   ,`user_Notes`
  FROM `hpapi_membership`
  LEFT JOIN `hpapi_user`
         ON `user_UUID`=`membership_User_UUID`
  WHERE (
        `membership_Usergroup`=usergroup
     OR usergroup='*'
        )
  GROUP BY `user_UUID`
  ORDER BY
        `usergroup_Level`
       ,`usergroup_Name`
       ,`user_Active` DESC
       ,`user_UUID`
  ;
END$$





-- ADMINISTRATE ACCESS TO METHODS

DROP PROCEDURE IF EXISTS `hpapiDbaRunInsert`$$
CREATE PROCEDURE `hpapiDbaRunInsert`(
  IN        `usergroup` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  INSERT IGNORE INTO `hpapi_run`
  SET
    `run_Usergroup`=usergroup
   ,`run_Vendor`=vendor
   ,`run_Package`=package
   ,`run_Class`=class
   ,`run_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaRunDelete`$$
CREATE PROCEDURE `hpapiDbaRunDelete`(
  IN        `usergroup` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_run`
  WHERE `run_Usergroup`=usergroup
    AND `run_Vendor`=vendor
    AND `run_Package`=package
    AND `run_Class`=class
    AND `run_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaRunsForUsergroup`$$
CREATE PROCEDURE `hpapiDbaRunsForUsergroup`(
  IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  SELECT
    `run_Vendor` AS `vendor`
   ,`run_Package` AS `package`
   ,`run_Class` AS `class`
   ,`run_Method` AS `method`
   ,`run_Usergroup` AS `usergroup`
  FROM `hpapi_run`
  WHERE (
        `run_Usergroup`=usergroup
     OR usergroup='*'
  
  )
  ORDER BY
    `run_Usergroup`
   ,`run_Vendor`
   ,`run_Package`
   ,`run_Class`
   ,`run_Method`
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaRunsForMethod`$$
CREATE PROCEDURE `hpapiDbaRunsForMethod`(
  IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  SELECT
    `run_Vendor` AS `vendor`
   ,`run_Package` AS `package`
   ,`run_Class` AS `class`
   ,`run_Method` AS `method`
   ,`run_Usergroup` AS `usergroup`
  FROM `hpapi_run`
  WHERE (
        `run_Vendor`=vendor
     OR vendor='*'
  )
    AND (
        `run_Package`=package
     OR package='*'
    )
    AND (
        `run_Class`=class
     OR class='*'
    )
    AND (
        `run_Method`=method
     OR method='*'
    )
  ORDER BY
    `run_Vendor`
   ,`run_Package`
   ,`run_Class`
   ,`run_Method`
   ,`run_Usergroup`
  ;
END$$





-- ADMINISTRATE ACCESS TO STORED PROCEDURES

DROP PROCEDURE IF EXISTS `hpapiDbaCallInsert`$$
CREATE PROCEDURE `hpapiDbaCallInsert`(
  IN        `model` varchar(64) CHARSET ascii
 ,IN        `spr` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  INSERT IGNORE INTO `hpapi_call`
  SET
    `call_Model`=model
   ,`call_Spr`=spr
   ,`call_Vendor`=vendor
   ,`call_Package`=package
   ,`call_Class`=class
   ,`call_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaCallDelete`$$
CREATE PROCEDURE `hpapiDbaCallDelete`(
  IN        `model` varchar(64) CHARSET ascii
 ,IN        `spr` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_call`
  WHERE `call_Model`=model
    AND `call_Spr`=spr
    AND `call_Vendor`=vendor
    AND `call_Package`=package
    AND `call_Class`=class
    AND `call_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaCallsForSpr`$$
CREATE PROCEDURE `hpapiDbaCallsForSpr`(
  IN        `model` varchar(64) CHARSET ascii
 ,IN        `spr` varchar(64) CHARSET ascii
)
BEGIN
  SELECT
    `call_Vendor` AS `vendor`
   ,`call_Package` AS `package`
   ,`call_Class` AS `class`
   ,`call_Method` AS `method`
   ,`call_Model` AS `model`
   ,`call_Spr` AS `spr`
  FROM `hpapi_call`
  WHERE `call_Model`=model
    AND (
        `call_Spr`=spr
     OR spr='*'
  )
  ORDER BY
    `call_Model`
   ,`call_Spr`
   ,`call_Vendor`
   ,`call_Package`
   ,`call_Class`
   ,`call_Method`
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaCallsForMethod`$$
CREATE PROCEDURE `hpapiDbaCallsForMethod`(
  IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  SELECT
    `call_Vendor` AS `vendor`
   ,`call_Package` AS `package`
   ,`call_Class` AS `class`
   ,`call_Method` AS `method`
   ,`call_Model` AS `model`
   ,`call_Spr` AS `spr`
  FROM `hpapi_call`
  WHERE (
        `call_Vendor`=vendor
     OR vendor='*'
  )
    AND (
        `call_Package`=package
     OR package='*'
    )
    AND (
        `call_Class`=class
     OR class='*'
    )
    AND (
        `call_Method`=method
     OR method='*'
    )
  ORDER BY
    `call_Vendor`
   ,`call_Package`
   ,`call_Class`
   ,`call_Method`
   ,`call_Model`
   ,`call_Spr`
  ;
END$$





-- ADMINISTRATE INSERT PERMISSION

DROP PROCEDURE IF EXISTS `hpapiDbaInsertInsert`$$
CREATE PROCEDURE `hpapiDbaInsertInsert`(
  IN        `insertModel` varchar(64) CHARSET ascii
 ,IN        `insertTable` varchar(64) CHARSET ascii
 ,IN        `insertUsergroup` varchar(64) CHARSET ascii
)
BEGIN
  INSERT IGNORE INTO `hpapi_insert`
  SET
    `insert_Model`=insertModel
   ,`insert_Table`=insertTable
   ,`insert_Usergroup`=insertUsergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaInsertDelete`$$
CREATE PROCEDURE `hpapiDbaInsertDelete`(
  IN        `insertModel` varchar(64) CHARSET ascii
 ,IN        `insertTable` varchar(64) CHARSET ascii
 ,IN        `insertUsergroup` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_insert`
  WHERE `insert_Model`=insertModel
    AND `insert_Table`=insertTable
    AND `insert_Usergroup`=insertUsergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaInsertsForUsergroup`$$
CREATE PROCEDURE `hpapiDbaInsertsForUsergroup`(
  IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  SELECT
    `insert_Model` AS `model`
   ,`insert_Table` AS `table`
  FROM `hpapi_insert`
  WHERE ( 
        `insert_Usergroup`=usergroup
     OR usergroup='*'
  )
  ORDER BY
    `insert_Model`
   ,`insert_Table`
  ;
END$$



-- ADMINISTRATE UPDATE PERMISSION

DROP PROCEDURE IF EXISTS `hpapiDbaUpdateInsert`$$
CREATE PROCEDURE `hpapiDbaUpdateInsert`(
  IN        `updateModel` varchar(64) CHARSET ascii
 ,IN        `updateTable` varchar(64) CHARSET ascii
 ,IN        `updateColumn` varchar(64) CHARSET ascii
 ,IN        `updateUsergroup` varchar(64) CHARSET ascii
)
BEGIN
  INSERT IGNORE INTO `hpapi_update`
  SET
    `update_Model`=updateModel
   ,`update_Table`=updateTable
   ,`update_Column`=updateColumn
   ,`update_Usergroup`=updateUsergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaUpdateDelete`$$
CREATE PROCEDURE `hpapiDbaUpdateDelete`(
  IN        `updateModel` varchar(64) CHARSET ascii
 ,IN        `updateTable` varchar(64) CHARSET ascii
 ,IN        `updateColumn` varchar(64) CHARSET ascii
 ,IN        `updateUsergroup` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_update`
  WHERE `update_Model`=updateModel
    AND `update_Table`=updateTable
    AND `update_Column`=updateColumn
    AND `update_Usergroup`=updateUsergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaUpdatesForUsergroup`$$
CREATE PROCEDURE `hpapiDbaUpdatesForUsergroup`(
  IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  SELECT
    `update_Model` AS `model`
   ,`update_Table` AS `table`
   ,`update_Column` AS `column`
  FROM `hpapi_update`
  WHERE ( 
        `update_Usergroup`=usergroup
     OR usergroup='*'
  )
  ORDER BY
    `update_Model`
   ,`update_Table`
   ,`update_Column`
  ;
END$$



-- ADMINISTRATE TRASH PERMISSION

DROP PROCEDURE IF EXISTS `hpapiDbaTrashInsert`$$
CREATE PROCEDURE `hpapiDbaTrashInsert`(
  IN        `trashModel` varchar(64) CHARSET ascii
 ,IN        `trashTable` varchar(64) CHARSET ascii
 ,IN        `trashUsergroup` varchar(64) CHARSET ascii
)
BEGIN
  INSERT IGNORE INTO `hpapi_trash`
  SET
    `trash_Model`=trashModel
   ,`trash_Table`=trashTable
   ,`trash_Usergroup`=trashUsergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaTrashDelete`$$
CREATE PROCEDURE `hpapiDbaTrashDelete`(
  IN        `trashModel` varchar(64) CHARSET ascii
 ,IN        `trashTable` varchar(64) CHARSET ascii
 ,IN        `trashUsergroup` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_trash`
  WHERE `trash_Model`=insertModel
    AND `trash_Table`=insertTable
    AND `trash_Usergroup`=insertUsergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiDbaTrashesForUsergroup`$$
CREATE PROCEDURE `hpapiDbaTrashesForUsergroup`(
  IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  SELECT
    `trash_Model` AS `model`
   ,`trash_Table` AS `table`
  FROM `hpapi_trash`
  WHERE ( 
        `trash_Usergroup`=usergroup
     OR usergroup='*'
  )
  ORDER BY
    `insert_Model`
   ,`insert_Table`
  ;
END$$



DELIMITER ;

