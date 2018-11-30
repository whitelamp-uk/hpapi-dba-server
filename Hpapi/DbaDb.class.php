<?php

namespace Hpapi;

class DbaDb extends \Hpapi\Db {

    private $query;
    private $queryType;
    private $queryDefn = array (
                'insert' => array (
                    'start' => "INSERT INTO `<table/>` SET"
                   ,'column' => "\n`<column/>`=?"
                )
               ,'select' => array (
                    'start' => "SELECT <columns/> FROM <table/>"
                )
               ,'update' => array (
                    'start' => "UPDATE <table> SET"
                   ,'column' => "\n`<column/>`=?"
                   ,'where' => "WHERE <primaries/>"
                )
            );
    private $tableName;
    private $columns;

    public function __construct (\Hpapi\Hpapi $hpapi,$model) {
        parent::__construct ($hpapi,$model);
    }

    public function addColumn ($columnName,$value=null) {
        $this->columns[$columnName] = $this->pdoCast ($value);
    }

    public function queryBuild ( ) {
        try {
            $query  = str_replace ('<table/>',$this->tableName,$this->queryDefn[$this->queryType]['start']);
            if ($this->queryType=='select') {
                echo $query."\n";
                die ();
                return;
            }
            $loop   = array ();
            foreach ($this->columns as $c=>$v) {
                array_push ($loop,str_replace('<column/>',$c,$this->queryDefn[$this->queryType]['column']));
            }
            $query .= implode (',',$loop);
            if ($this->queryType=='update') {
                echo $query."\n";
                die ();
            }
            $this->query = $query;
            return true;
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
    }

    public function queryExecute ( ) {
        try {
            // SQL statement
            $stmt           = $this->PDO->prepare ($this->query);
        }
        catch (\PDOException $e) {
            throw new \Exception (HPAPI_DBA_STR_QUERY_PREP.' - '.$e->getMessage());
            return false;
        }
        $i = 0;
        foreach ($this->columns as $c=>$param) {
            // Bind value to placeholder
            $i++;
            try {
                $stmt->bindValue ($i,$param[0],$param[1]);
            }
            catch (\PDOException $e) {
                throw new \Exception (HPAPI_DBA_STR_QUERY_BIND.' (arg '.$i.') - '.$e->getMessage());
                return false;
            }
        }
        try {
            // Execute SQL statement
            $stmt->execute ();
        }
        catch (\PDOException $e) {
            // Execution failed
            $this->hpapi->diagnostic (HPAPI_DBA_STR_QUERY_EXEC.' - '.$e->getMessage());
            throw new \Exception ($e->getMessage());
            return false;
        }
        try {
            // Execution OK, fetch data (if any was returned)
            $data           =  $stmt->fetchAll (\PDO::FETCH_ASSOC);
            $stmt->closeCursor ();
        }
        catch (\PDOException $e) {
            // Execution OK, no data fetched
            return true;
        }
        // Execution OK, data fetched
        return $data;
    }

    public function setQueryType ($queryType) {
        if (!array_key_exists($queryType,$this->queryDefn)) {
            $this->hpapi->diagnostic (HPAPI_STR_DB_QUERY_TYPE.' "'.$queryType.'"');
            return false;
        }
        $this->queryType = $queryType;
        return true;
    }

    public function setTable ($tableName) {
        $this->tableName = $tableName;
    }

}

