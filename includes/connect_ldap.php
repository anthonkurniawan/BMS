<?php

/**
  connect_ldap.php version 1.1
  Jakarta, 21 October, 2005 14:58

  Copyright 2005 Aria Wiratama Nugraha
  Mailto the005@yahoo.com
  Visit the005.csui03.net

  This component is distributed under BSD license
*/

Class Ldap
{
	var $host;
	var $ds;
	var $uid;
	var $password;
	var $dn;
	var $protocolVersion;
	var $bindStatus;

	function isBinded(){
		return $this->bindStatus;
	}

	function isConnected(){
		return $this->ds;
	}

	function connect( $host, $protocol_version ) {
		$this->host = $host;
		$this->ds = ldap_connect( $host );
		$this->protocolVersion = $protocol_version;
		ldap_set_option( $this->ds, LDAP_OPT_PROTOCOL_VERSION, $this->protocolVersion );
	}

	function setDn( $dn ) {
		$this->dn = $dn;
	}

	function bind( $uid, $password ) {
		$this->uid = $uid;
		$this->dn = str_replace( "<USERNAME>", $this->uid, $this->dn );
		$this->password = $password;
		$this->bindStatus = @ldap_bind( $this->ds, $this->dn, $this->password );
	}

	function search( $base_dn, $filter ) {
		$sr = ldap_search( $this->ds, $base_dn, $filter );
		$info = ldap_get_entries( $this->ds, $sr );
		return $info;
	}

	function close(){
		ldap_close( $this->ds );
	}
}
?>