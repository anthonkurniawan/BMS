<?php
include_once("lib/adodb5/adodb.inc.php");

class Db {
	private static $host = 'localhost';
	private static $port = 1433;
	private static $dbname = 'BMS3';
	private static $uname = 'sa';
	private static $pass = 'belang@9';

	public static function connect(){
		$ADODB_COUNTRECS = false;
		$ADODB_FETCH_MODE = ADODB_FETCH_NUM;
		// ON XP
		$db = ADONewConnection("pdo");
		$constr = "sqlsrv:Server=tcp:".self::$host.",".self::$port.";Database=".self::$dbname;
		$db->Connect($constr, $uname, $pass);
		if(!$db->IsConnected()){
			if(isset($_SERVER['HTTP_X_REQUESTED_WITH']) && $_SERVER['HTTP_X_REQUESTED_WITH']=='XMLHttpRequest'){
	
			}else{
				header("Location: databaseError.php");
			}
			exit;
		}
		return $db;
	}
	
}
