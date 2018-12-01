<?php

namespace Hpapi;

class DbaDb extends \Hpapi\Db {

    private $columns        = null;
    private $params         = array ();
    private $primary        = null;
    private $query          = null;
    private $queryDefn      = array (
                'insert'    => array (
                    'start'     => "INSERT INTO `<table/>` SET"
                   ,'column'    => "\n`<column/>`=?"
                )
               ,'select'    => array (
                    'start'     => "SELECT"
                   ,'column'    => "\n`<table/>`.`<column/>`"
                   ,'from'      => "\nFROM `<table/>`"
                   ,'where'     => "\nWHERE"
                )
               ,'update'    => array (
                    'start'     => "UPDATE `<table/>` SET"
                   ,'column'    => "\n`<column/>`=?"
                   ,'where'     => "\nWHERE"
                   ,'restrict'  => "\n`<primary/>`=?"
                )
            );
    private $queryType      = null;
    private $tableName      = null;

    public function __construct (\Hpapi\Hpapi $hpapi,$model) {
        parent::__construct ($hpapi,$model);
    }

    public function addColumn ($columnName,$value=null) {
        if ($this->columns===null) {
            $this->columns = new \stdClass ();
        }
        $this->columns->{$columnName} = $this->pdoCast ($value);
    }

    public function addPrimary ($columnName,$value=null) {
        if ($this->primary===null) {
            $this->primary = new \stdClass ();
        }
        $this->primary->{$columnName} = $this->pdoCast ($value);
    }

    public function queryBuild ( ) {
        try {
            $query  = str_replace ('<table/>',$this->tableName,$this->queryDefn[$this->queryType]['start']);
            $loop   = array ();
            foreach ($this->columns as $c=>$v) {
                array_push ($loop,str_replace('<column/>',$c,$this->queryDefn[$this->queryType]['column']));
                array_push ($this->params,$v);
            }
            $query .= implode (",",$loop);
            if ($this->queryType=='select') {
                return;
            }
            if ($this->queryType=='update') {
                if ($this->primary==null) {
                    throw new \Exception (HPAPI_DBA_STR_QUERY_PRI);
                    return false;
                }
                $query .= $this->queryDefn[$this->queryType]['where'];
                $loop   = array ();
                foreach ($this->primary as $p=>$v) {
                    array_push ($loop,str_replace('<primary/>',$p,$this->queryDefn[$this->queryType]['restrict']));
                    array_push ($this->params,$v);
                }
                $query .= implode ("\nAND ",$loop);
            }
            $this->query = $query;
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return true;
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
        foreach ($this->params as $param) {
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
            throw new \Exception (HPAPI_DBA_STR_QUERY_EXEC);
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

