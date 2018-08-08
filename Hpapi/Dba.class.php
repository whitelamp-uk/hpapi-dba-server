<?php

namespace Hpapi;

class Dba extends \Hpapi\Db {

    public $hpapi;

    public function __construct (\Hpapi\Hpapi $hpapi) {
        parent::__construct ($hpapi);
    }

    public function __destruct ( ) {
        parent::__destruct ();
    }

    // ADMINISTRATE ACCESS TO USER GROUPS

    public function grantUsergroupToUser ($usergroup,$user_uuid) {
        try {
            $grant      = $this->hpapi->dbCall (
                'hpapiMembershipInsert'
               ,$usergroup
               ,$user_uuid
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $grant;
    }

    public function revokeUsergroupFromUser ($usergroup,$user_uuid) {
        try {
            $revoke     = $this->hpapi->dbCall (
                'hpapiMembershipInsert'
               ,$usergroup
               ,$user_uuid
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $revoke;
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
        try {
            $grant      = $this->hpapi->dbCall (
                'hpapiRunInsert'
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
        return $grant;
    }

    public function revokeMethodFromUsergroup ($vendor,$package,$class,$method,$usergroup) {
        try {
            $revoke     = $this->hpapi->dbCall (
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
        return $revoke;
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
        try {
            $grant      = $this->hpapi->dbCall (
                'hpapiCallInsert'
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
        return $grant;
    }

    public function revokeSprFromMethod ($model,$spr,$vendor,$package,$class,$method) {
        try {
            $revoke     = $this->hpapi->dbCall (
                'hpapiCallDelete'
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
        return $revoke;
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

}

?>
