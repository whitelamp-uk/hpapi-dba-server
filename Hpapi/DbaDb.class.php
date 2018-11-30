<?php

namespace Hpapi;

class DbaDb extends \Hpapi\Db {

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
echo $query."\n";
die ();
    }

    public function queryExecute ( ) {
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

