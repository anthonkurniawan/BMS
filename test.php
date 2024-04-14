<?php
include("verifyLogin.php");
require( "lib/Smarty/libs/Smarty.class.php" );
include( "function.php" );
$db->debug=true;

//echo "<pre>";print_r($_SESSION['user']['priviledges']);echo"</pre>";
//print_r(getPriv()); print_r(getPriv(true));
//echo getPrivDepts();
//echo "<pre>"; print_r($_SESSION['units']); echo "</pre.";
//echo "<br>". deptLabel('eng');
//echo "<br>". getDept('eng');
//echo "<pre>";print_r(unitData('retain'));echo"</pre>";
echo progressValidate(1);
echo progressValidate(0);
var_dump((preg_match('/qo||qa/',$_SESSION['user']["dept"])));
var_dump((preg_match('/qa/',$_SESSION['user']['priviledges'])));
var_dump((preg_match('/qo||qa/',$_SESSION['user']["dept"]) && preg_match('/qa/',$_SESSION['user']['priviledges'])));

//$units = getUnits();  echo"UNITS: <pre>";print_r($units);echo"</pre>";

// CacheGetAssoc
//$deptls = $db->CacheGetAll(1800, 'select code, label from depts'); //echo"DEPTS: <pre>";print_r($deptls);echo"</pre>";
//$unitls = $db->CacheGetAll(1800, 'select t2.code as dept, t1.code as unit from units as t1 join depts as t2 on t1.deptId=t2.id;'); //echo"DEPTS: <pre>";print_r($unitls);echo"</pre>"; die();

//foreach($deptls as $d){
	//$depts[$d[0]]['units'] =null; 
	//$depts[$d[0]]['label'] =$d[1]; 
//}																				echo"DEPTS: <pre>";print_r($depts);echo"</pre>";

//$db->CacheFlush('select t2.code as dept, t2.label as dept_lbl, t1.code as unit, t1.label as unit_lbl from units as t1 join depts as t2 on t1.deptId=t2.id');
//$arr = $db->CacheGetAll(1000, 'select t2.code as dept, t2.label as dept_lbl, t1.code as unit, t1.label as unit_lbl from units as t1 join depts as t2 on t1.deptId=t2.id'); //echo"ARR: <pre>";print_r($arr);echo"</pre>"; die();
//foreach($arr as $v){
	//if($v[2])
		//$depts[$v[0]]['units'][$v[2]] = $v[3];
	//else 
		//$depts[$v[0]]['units']=[];
	//$depts[$v[0]]['label'] =$v[1]; 
//}																				echo"DEPTS: <pre>";print_r($depts);echo"</pre>";

//$rs=$db->Execute('execute getTagData'); 
//$data=$rs->getArray();			echo"DATA: <pre>";print_r($data);echo"</pre>";

// $a=array(1,2);
// $a=array(0=>'',1=>'');

// $x=preg_match('/\d/', implode(',',$a));
// var_dump($x);

// echo pathinfo(__DIR__);
// ECHO "<br>".basename(dirname($_SERVER[PHP_SELF]));
// echo"<br>".dirname($_SERVER[PHP_SELF]);

//$rs=$db->CacheGetAll(86400, "getTagname");
//$rs=$db->_Execute("exec getTagname");  print_r($rs->getArray());
//echo getMsg();

//echo strtok("eng,wh","/");

//echo"<br>==><pre>";print_r($_SESSION['user']);echo"</pre>";
//$x=strpos("a,b", ",");  var_dump($x);
//$priv=str_replace('"','',$_SESSION["user"]["priviledges"]);  echo $priv;
//$db->execute("update report set progress=2 where id in(181,182,183,184,185,186)");
?>
