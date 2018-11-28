<?php

namespace Hpapi;

class DbaDb extends \Hpapi\Db {

    private $queryType;
    private $queryTypes = array ('insert','select','update');
    private $tableName;
    private $columns;

    public function __construct (\Hpapi\Hpapi $hpapi,$model) {
        parent::__construct ($hpapi,$model);
    }

    public function addColumn ($columnName,$value=null) {
        $this->columns[$columnName] = $value;
    }

    public function queryBuild ( ) {
die ("queryBuild() coming soon");
    }

    public function queryExecute ( ) {
    }

    public function setQueryType ($queryType) {
        if (!in_array($queryType,$this->queryTypes)) {
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

