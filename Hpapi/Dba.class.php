<?php

namespace Hpapi;

class Dba {

    public $userId;
    public $modelDb;

    public function __construct (\Hpapi\Hpapi $hpapi) {
        $this->hpapi                        = $hpapi;
        $this->userId                       = $this->hpapi->userId;
    }

    public function __destruct ( ) {
    }



    // MODEL DATABASE

    public function model ($model) {
        try {
            $this->db                       = new \Hpapi\Db ($this->hpapi,$this->hpapi->models->$model);
        }
        catch (\Exception $e) {
            $this->hpapi->diagnostic ($e->getMessage());
            return false;
        }
    }



    // TABLE ADMIN

    public function writeTuple ($model,$table,$column,$primaries,$value) {
        if (!$this->model($model)) {
            return false;
        }
        
    }



    // GRANT PERMISSIONS

    public function grantAllowed ($type,$usergroup='') {
        try {
            $this->hpapi->dbCall (
                'hpapiDbaGrantAllowed'
               ,$this->userUUID
               ,$type
               ,$usergroup
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
        }
        return false;
    }

    // ADMINISTRATE ACCESS TO USER GROUPS

    public function grantUsergroupToUser ($usergroup,$user_uuid) {
        if (!$this->grantAllowed('membership',$usergroup)) {
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
        if (!$this->grantAllowed('membership',$usergroup)) {
            throw new \Exception (HPAPI_STR_DBA_GRANT_ALLOW);
            return false;
        }
        try {
            $this->hpapi->dbCall (
                'hpapiDbaMembershipDelete'
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
        if (!$this->grantAllowed('run',$usergroup)) {
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
        if (!$this->grantAllowed('run',$usergroup)) {
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
        if (!$this->grantAllowed('call')) {
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
        if (!$this->grantAllowed('call')) {
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
        if (!$this->grantAllowed('insert',$usergroup)) {
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
        if (!$this->grantAllowed('insert',$usergroup)) {
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
        if (!$this->grantAllowed('update',$usergroup)) {
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
        if (!$this->grantAllowed('update',$usergroup)) {
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

    // DESCRIBE DATA STRUCTURE

    public function describeTable ($modelName,$tableName) {
        $dbName                 = $this->hpapi->pdoDbName ($this->hpapi->models->{$modelName}->dsn);
        try {
            $columns            = $this->hpapi->dbCall (
                'hpapiDbaColumnsTable'
               ,$dbName
               ,$tableName
            );
            $columns            = $this->hpapi->parse2D ($columns);
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        if (!count($columns)) {
            throw new \Exception (HPAPI_STR_DBA_TABLE_COLS);
            return false;
        }
        $table                      = new \stdClass ();
        $table->model               = $columns[0]->model;
        $table->table               = $columns[0]->table;
        $table->title               = $columns[0]->title;
        $table->description         = $columns[0]->description;
        $table->columns             = array ();
        foreach ($columns as $c) {
            unset ($c->title);
            unset ($c->description);
            array_push ($table->columns,$c);
        }
        return $table;
        $table->relationsStrong     = $this->describeRelations ($dbName,$tableName,false);
        $table->relationsWeak       = $this->describeRelations ($dbName,$tableName,'weak');
        return $table;
   }

    public function describeRelations ($dbName,$tableName,$weak=false) {
        try {
            if ($weak) {
                $columns            = $this->hpapi->dbCall (
                    'hpapiDbaColumnsWeak'
                   ,$dbName
                   ,$tableName
                );
            }
            else {
                $columns            = $this->hpapi->dbCall (
                    'hpapiDbaColumnsStrong'
                   ,$dbName
                   ,$tableName
            }
            $columns                = $this->hpapi->parse2D ($columns);
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        $relations = new \stdClass ();
        foreach ($columns as $c) {
            if (!property_exists($relations,$c->table)) {
                $relations->{$c->table}                 = new \stdClass ();
                $relations->{$c->table}->model          = $c->model;
                $relations->{$c->table}->table          = $c->table;
                $relations->{$c->table}->title          = $c->title;
                $relations->{$c->table}->description    = $c->description;
                $relations->{$c->table}->columns        = array ();
            }
            unset ($c->title);
            unset ($c->description);
            array_push ($relations->{$c->table}->columns,$c);
        }
        return $relations;
    }

}

