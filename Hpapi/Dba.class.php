<?php

namespace Hpapi;

class Dba extends \Hpapi\Db {

/*
Base properties: 
    private $cfg;
    private $dfn;
    private $DSN;
    private $filter;
    public  $hpapi;
    public  $inputs;
    public  $model;
    private $node;
    private $PDO;
    private $sprCmd; // eg. CALL (), SELECT () OR EXEC () keyword
*/
    public $userUUID;

    public function __construct (\Hpapi\Hpapi $hpapi) {
        parent::__construct ($hpapi);
        $this->userUUID = $this->hpapi->userUUID;
    }

    public function __destruct ( ) {
        parent::__destruct ();
    }

    // GRANT PERMISSIONS

    public function grantAllowed ($type,$match) {
        try {
            $this->hpapi->dbCall (
                'hpapiDbaGrant'
               ,$type
               ,$this->userUUID
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        foreach ($grant as $grt) {
            if (preg_match($gtr['expression'],$match)) {
                return true;
            }
            return false;
        }
    }

    // ADMINISTRATE ACCESS TO USER GROUPS

    public function grantUsergroupToUser ($usergroup,$user_uuid) {
        if (!$this->grantAllowed('membership-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaMembershipInsert'
               ,$usergroup
               ,$user_uuid
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function revokeUsergroupFromUser ($usergroup,$user_uuid) {
        if (!$this->grantAllowed('membership-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaMembershipInsert'
               ,$usergroup
               ,$user_uuid
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function showGrantsForUser ($user_uuid) {
        try {
            $usergroups = $this->hpapi->dbCall (
                'hpapiDbaMembershipsForUser'
               ,$user_uuid
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $usergroups;
    }

    public function showGrantedUsers ($usergroup='*') {
        try {
            $users      = $this->hpapi->dbCall (
                'hpapiDbaMembershipsForUsergroup'
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $users;
    }

    // ADMINISTRATE ACCESS TO METHODS

    public function grantMethodToUsergroup ($vendor,$package,$class,$method,$usergroup) {
        if (!$this->grantAllowed('run-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaRunInsert'
               ,$vendor
               ,$package
               ,$class
               ,$method
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function revokeMethodFromUsergroup ($vendor,$package,$class,$method,$usergroup) {
        if (!$this->grantAllowed('run-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaRunDelete'
               ,$vendor
               ,$package
               ,$class
               ,$method
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function showGrantsForUsergroup ($usergroup='*') {
        try {
            $methods    = $this->hpapi->dbCall (
                'hpapiDbaRunsForUsergroup'
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $methods;
    }

    public function showGrantedUsergroups ($vendor='*',$package='*',$class='*',$method='*') {
        try {
            $usergroups = $this->hpapi->dbCall (
                'hpapiDbaRunsForMethod'
               ,$vendor
               ,$package
               ,$class
               ,$method
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $usergroups;
    }

    // ADMINISTRATE ACCESS TO STORED PROCEDURES

    public function grantSprToMethod ($model,$spr,$vendor,$package,$class,$method) {
        if (!$this->grantAllowed('call-model.spr',$model.'.'.$spr)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaCallInsert'
               ,$model
               ,$spr
               ,$vendor
               ,$package
               ,$class
               ,$method
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function revokeSprFromMethod ($model,$spr,$vendor,$package,$class,$method) {
        if (!$this->grantAllowed('call-model.spr',$model.'.'.$spr)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaCallDelete'
               ,$model
               ,$spr
               ,$vendor
               ,$package
               ,$class
               ,$method
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function showGrantsForSpr ($model,$spr='*') {
        try {
            $methods    = $this->hpapi->dbCall (
                'hpapiDbaCallsForSpr'
               ,$model
               ,$spr
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $methods;
    }

    public function showGrantedSprs ($vendor='*',$package='*',$class='*',$method='*') {
        try {
            $sprs       = $this->hpapi->dbCall (
                'hpapiDbaCallsForMethod'
               ,$vendor
               ,$package
               ,$class
               ,$method
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $sprs;
    }

    // ADMINISTRATE PERMISSION TO INSERT

    public function grantInsertToUsergroup ($model,$table,$usergroup) {
        if (!$this->grantAllowed('insert-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaInsertInsert'
               ,$model
               ,$table
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function revokeInsertFromUsergroup ($model,$table,$usergroup) {
        if (!$this->grantAllowed('insert-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaInsertDelete'
               ,$model
               ,$table
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function showInsertsForUsergroup ($model,$table='*') {
        try {
            $inserts    = $this->hpapi->dbCall (
                'hpapiDbaInsertsForUsergroup'
               ,$model
               ,$table
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $inserts;
    }


    // ADMINISTRATE PERMISSION TO UPDATE

    public function grantUpdateToUsergroup ($model,$table,$column,$usergroup) {
        if (!$this->grantAllowed('update-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaUpdateInsert'
               ,$model
               ,$table
               ,$column
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function revokeUpdateFromUsergroup ($model,$table,$column,$usergroup) {
        if (!$this->grantAllowed('update-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaUpdateDelete'
               ,$model
               ,$table
               ,$column
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function showUpdatesForUsergroup ($model,$table='*',$column='*') {
        try {
            $updates    = $this->hpapi->dbCall (
                'hpapiDbaUpdatesForUsergroup'
               ,$model
               ,$table
               ,$column
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $updates;
    }

    // ADMINISTRATE PERMISSION TO TRASH

    public function grantTrashToUsergroup ($model,$table,$usergroup) {
        if (!$this->grantAllowed('trash-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaTrashInsert'
               ,$model
               ,$table
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function revokeTrashFromUsergroup ($model,$table,$usergroup) {
        if (!$this->grantAllowed('trash-usergroup',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaTrashDelete'
               ,$model
               ,$table
               ,$usergroup
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
    }

    public function showTrashesForUsergroup ($model,$table='*') {
        try {
            $trashes    = $this->hpapi->dbCall (
                'hpapiDbaTrashesForUsergroup'
               ,$model
               ,$table
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $trashes;
    }

}

?>
