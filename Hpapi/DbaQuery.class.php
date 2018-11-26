<?php

namespace Hpapi;

class DbaQuery extends \Hpapi\Db {

    public function __construct (\Hpapi\Hpapi $hpapi,$model) {
        parent::__construct ($hpapi,$model);
    }

}

