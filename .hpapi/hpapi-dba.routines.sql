

SET NAMES utf8;
SET time_zone = '+00:00';


DELIMITER $$


-- ADMINISTRATE ACCESS TO USERGROUPS

DROP PROCEDURE IF EXISTS `hpapiDbaMembershipInsert`$$
CREATE PROCEDURE `hpapiDbaMembershipInsert`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  INSERT INTO `hpapi_membership`
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
    `usergroup_Name`
   ,`usergroup_Notes`
   ,`usergroup_Level`
   ,`level_Name`
   ,`level_Notes`
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
   ,`user_UUID`
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
  INSERT INTO `hpapi_run`
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
    `run_Vendor`
   ,`run_Package`
   ,`run_Class`
   ,`run_Method`
   ,`run_Usergroup`
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
    `run_Vendor`
   ,`run_Package`
   ,`run_Class`
   ,`run_Method`
   ,`run_Usergroup`
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
  INSERT INTO `hpapi_call`
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


--hpapiDbaCallsForSpr
--hpapiDbaCallsForMethod



DELIMITER ;

