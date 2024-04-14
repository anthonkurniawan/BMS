<?php
    include("ldap.class.php");
	$ldap=new Ldap();
	$ldap->connect("ldaps://10.98.195.14",3);
	if ($ldap->isConnected())
	{ 
		$dn="uid=\"<USERNAME>\",ou=\"People\",ou=\"AsiaPac\",o=\"Pfizer\",c=\"ID\"";
		$ldap->setDn($dn);
		$ldap->bind("widiaa01","oran66antenG");
		if ($ldap->isBinded())
		{
			$_SESSION['connected']=1;
			$result=$ldap->search("ou=AsiaPac, c=ID","uid=".$_SESSION['username']);
			echo $namaDanNPM=split("(,,,)",$result[0]["gecos"][0]);
			$_SESSION['fullname']=$namaDanNPM[0];
			$_SESSION['NPM']=$namaDanNPM[1];
			$ldap->close();
		}
		else
		{
			$_SESSION['connected']=0;
			echo "DODOL";
		}
	}
	else
	{
	   echo "<h4>Unable to connect to LDAP server</h4>";
	}
?>
