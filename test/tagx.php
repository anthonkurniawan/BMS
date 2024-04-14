<?php
//include("verifyLogin.php");
require("../lib/Smarty/libs/Smarty.class.php");
include("../function.php");

$smarty=new Smarty;//$smarty->debugging=true;
//$smarty->caching=true;
//$smarty->cache_lifetime=86400;
$data['msg'] = setMsg("BMS Ver 3.0",'ui-state-default',null,"padding:20px 10px;font-size:20px;width:550px;margin-top:200px",'ui-icon-info');

#FROM DB
//$db->debug=true;
$unit ='ahu1';
$db->cacheFlush("select t1.tagname, t1.label, t1.header, t1.spec, t2.anyHeader from tagname as t1 join units as t2 on t1.unitId=t2.id where code='{$unit}'");
$rs = $db->CacheGetAll(1000, "select t1.tagname, t1.label, t1.header, t1.spec, t2.anyHeader from tagname as t1 join units as t2 on t1.unitId=t2.id where code='{$unit}'");
echo "Count: ".count($rs).'<pre>';print_r($rs);echo '</pre>'; die();

//CREATE HEADER
$anyHead = $rs[0][4];  //echo $anyHead; die();
$i=0;
foreach($rs as $k=>$v){ //echo "<br>key:$k, label:$v[1], header:$v[2], spec:$v[3]";//print_r($v);
	$head = $v[2] ? $v[2] : $v[1]; //echo "<b>#$k ==>head:$head i:$i</b>"; print_r($arrHead); echo '<br>'; // HEADER SAAT INPUT HARUS DI TRIM UNTUK CEGAH "  "
	if($v[2]){  //echo ">ADA HEAD: $head<br>";
		if(!array_key_exists($head, $arrHead)){
			$arrHead[$head] = ['key'=>'H-'.$i, 'count'=>1]; 
			$table['headers'][$arrHead[$head]['key']]= ['label'=>$head, 'colspan'=>1, 'rowspan'=>1];  
			$table['headers'][$arrHead[$head]['key']]['member'][] = ['head'=>$v[2],'tagname'=>$v[0],'label'=>$v[1] ? $v[1] : $v[0], 'spec'=>$v[3]]; //echo "	>NEW RESULT: count:$headCount >"; print_r($table['headers'][$head]); echo "<br>";
		}else{ //echo "## HEAD SUDAH ADA: $head ##! $arrHead[$head]<br>";
			$arrHead[$head]['count']++;
			$table['headers'][$arrHead[$head]['key']]['colspan'] = $arrHead[$head]['count'];  
			$table['headers'][$arrHead[$head]['key']]['member'][] = ['head'=>$v[2],'tagname'=>$v[0],'label'=>$v[1] ? $v[1] : $v[0], 'spec'=>$v[3]];
			//echo "	>UPDATE RESULT: count:$headCount >"; print_r($table['headers']); echo "<br>";
		}
	}
	else{ //echo "GA ADA HEAD: $head<br>";
		$table['headers'][$i]= ['label'=>$head, 'spec'=>$v[3], 'tagname'=>$v[0], 'colspan'=>1, 'rowspan'=>$anyHead ? 2 : 1];  
	}
	$i++;
}
//echo '<pre>';print_r($table);echo '</pre>'; die();

// PRINT HTML TABLE
$html="<html><head><link href='../css/style.css' rel='stylesheet' type=text/css></link></head><body>";
$html.="<table class=\"report first\"><thead>";
$tr="<tr><th rowspan=\"".($anyHead ? 2 : 1)."\"><div class=\"head\">Time</div></th>";
$tr2="<tr>";
foreach($table['headers'] as $k=>$v){ //echo "<br>$k ";print_r($v);
	if($v['member']){
		foreach($v['member'] as $i=>$v2){
			$tr2.="<th class=''>$v2[label]<br><small>$v2[tagname]<br>($v2[spec])</small></th>";
		}
	}
	$tr.= "<th colspan=\"$v[colspan]\" rowspan=\"$v[rowspan]\">$v[label]". ($v['tagname'] ? "<br><small>$v[tagname]<br>($v[spec])</small>" : json_decode($v['member']))."</th>";
}
$tr2.="</tr>";
$tr.="</tr>";

$html2="</thead></table>";
$html2.="</body></html>";
echo "<br><hr>HTML-1: ".htmlspecialchars($html);
echo "<br><hr>TR-1: ".htmlspecialchars($tr);
echo "<br><hr>TR-2: ".htmlspecialchars($tr2);
echo "<br><hr>HTML-2: ".htmlspecialchars($html2);
echo $html.$tr. ($anyHead ? $tr2 : "") .$html2;
die();
# SAVE TO FILE
//$tpl = "sources/input.php";
$source = $html.$tr. ($anyHead ? $tr2 : "") .$html2;
$output = "output/output.php";

if(file_exists($output)) echo "<br><b>Template exists (OVERWRITE) !!<b><br>";   
echo htmlspecialchars($source); //die();
try{
	echo file_put_contents($output, $source);  // save code to file
}catch(Exception $e){
	echo "ERROR:"; print_r($e);
}

//$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
//$smarty->assign("data", $data, true); 
//$smarty->assign("page", array('title'=>'BMS-About','content'=>"done.tpl"),true);
//$smarty->display("layout.tpl");
?>

ACS1.ROOM210_TEMP.F_CV |
| ACS1.ROOM212_TEMP.F_CV |
| ACS1.ROOM213_TEMP.F_CV |
| ACS1.ROOM253_TEMP.F_CV |
| ACS1.ROOM257_TEMP.F_CV
