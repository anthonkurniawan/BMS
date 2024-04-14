<?php
include( "lib/adodb/adodb.inc.php" );

	$ldap = ldap_connect("10.98.195.14");
	$bind = ldap_bind($ldap, "apac\\widiaa01", "K4g4kpak3");
	
	if($bind) echo "Konek cuy";
	else echo "gagal cuy";
	
	$database = "mssql";
  $host = "aspja2w003";
  $username = "bas";
  $password = "bas";
  $dbname = "bas";

  $db = &ADONewConnection( $database );
  $connect = $db->Connect( $host, $username, $password, $dbname );

	if($db->IsConnected()) echo "konek DB cuy";
	else echo "gagal DB cuy";
?>