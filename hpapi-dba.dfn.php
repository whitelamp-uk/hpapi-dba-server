<?php

// Error strings - \Hpapi\Dba
define ( 'HPAPI_DBA_STR_MODEL',                 '301 400 Model not identified'                                                      );
define ( 'HPAPI_DBA_STR_COLS_DIR',              '303 500 Column definitions directory is not writable'                              );
define ( 'HPAPI_DBA_STR_COLS_WRITE',            '304 500 Could not write model column definitions'                                  );
define ( 'HPAPI_DBA_STR_IN_OBJECT',             '305 400 Input argument was not an object'                                          );
define ( 'HPAPI_DBA_STR_IN_MODEL',              '306 400 Input object missing model'                                                );
define ( 'HPAPI_DBA_STR_IN_TABLE',              '307 400 Input object missing table'                                                );
define ( 'HPAPI_DBA_STR_IN_ROW',                '308 400 Input object missing row object'                                           );
define ( 'HPAPI_DBA_STR_IN_COL_EXISTS',         '309 400 Column does not exist'                                                     );
define ( 'HPAPI_DBA_STR_IN_COL_PRIV_UPDATE',    '310 403 Column update denied'                                                      );
define ( 'HPAPI_DBA_STR_IN_COL_AUTO_INC',       '311 403 Cannot update auto-increment column'                                       );
define ( 'HPAPI_DBA_STR_IN_COL_VALID',          '312 400 Input value is invalid'                                                    );


define ( 'HPAPI_DBA_STR_QUERY_BUILD',           '331 500 Could not build dba query'                                                 );
define ( 'HPAPI_DBA_STR_QUERY_PREP',            '332 500 Could not prepare dba query statement'                                     );
define ( 'HPAPI_DBA_STR_QUERY_BIND',            '333 500 Could not bind to dba query statement'                                     );
define ( 'HPAPI_DBA_STR_QUERY_EXEC',            '334 500 Could not execute dba query statement'                                     );
define ( 'HPAPI_DBA_STR_QUERY_PRI',             '335 400 Missing primary key'                                                       );


define ( 'HPAPI_DBA_STR_GRANT_ALLOW',           '341 403 Grant was not allowed'                                                     );



// Diagnostic strings - \Hpapi\DbaDb
define ( 'HPAPI_STR_DB_QUERY_TYPE',             '\Hpapi\DbaDb::setType(): query type not supported'                                 );


// Userland configuration - definitions and classes
require_once HPAPI_DIR_CONFIG.'/whitelamp-uk/hpapi-dba.cfg.php';

