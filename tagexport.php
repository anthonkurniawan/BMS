<?php
include("verifyLogin.php");
if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
 
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");
$smarty=new Smarty; //$db->debug=true;
$smarty->caching=true;
$smarty->cache_lifetime=86400;

function getTagsDataExp($unit, $dateR){
	$db = getDb();
	$db->SetFetchMode(ADODB_FETCH_NUM);
	$rtime=$db->CacheGetOne(86400, "SELECT time FROM tagtime");
	if(!$rtime){
			return array('error'=>"<b>Failed get setting interval tagtime:</b><br>".$db->ErrorMsg());
	}else{
		foreach($dateR as $d){
			$tbl=getTable($d); 
			if(is_array($tbl))
				return $tbl;
			$table[$d]= $tbl;
		}
			
		if($table[$dateR[0]]==$table[$dateR[1]]){
			$q="BETWEEN '".$dateR[0]."' AND '".$dateR[1]." 23:30'";
			$data=getData($db, $unit, $table[$dateR[0]], $q);
		}
		else{
			$data=array();
			$start=new DateTime($dateR[0]);
			while($start->format('Y-m-d') <= $dateR[1]){
				if($start->format('Y')==date("Y"))
					$datels['currY'][]=$start->format('Y-m-d');
				else
					$datels['pastY'][]=$start->format('Y-m-d');
				$start->modify('+1 day');
			}
			
			# CHECK IF DATE LIST=CURRENT YEAR (IF NOT THEN "TAGSDATA+YEAR")
			if(isset($datels['pastY'])){
				$data=getDiffTagData($db, $datels['pastY'], $table[$dateR[0]]);
			}
			if(isset($datels['currY'])){
				$data=array_merge($data, getDiffTagData($db, $datels['currY'], $table[$dateR[1]]));
			}
		}
		return $data;	
	}
}

function getDiffTagData($db, $ls, $table, $data=array()){   
	$c=count($ls); 
	$t1=date("Y", strtotime($ls[0]));
	$t2=date("Y", strtotime($ls[$c-1]));
				
	if($c >1){
		if($t1===$t2){
			$q="BETWEEN '".$ls[0]."' AND '".$ls[$c-1]." 23:30'"; //cth 2015-12-07 to 2016-01-01
			$data=getData($db, $unit, $table, $q);
		}else{// cth: 2014-12-31 to 2015-01-02
			$start=new DateTime($ls[0]);
			while($start->format('Y-m-d') <= $ls[$c-1]){
				if($start->format('Y')==$y){
					$datepy['y1'][]=$start->format('Y-m-d');
					$datepy['y1-tbl']="TAGS_DATA".$y;
				}else{
					$datepy['y2'][]=$start->format('Y-m-d');
					$datepy['y2-tbl']="TAGS_DATA".$start->format('Y');;
				}
				$start->modify('+1 day');
				$y=$start->format('Y');
			}
			
			if(isset($datepy['y2'])){
				$data=array_merge($data, getDiffTagData($db, $datepy['y2'], $datepy['y2-tbl']));
			}
			if(isset($datepy['y1'])){
				$data=array_merge($data, getDiffTagData($db, $datepy['y1'], $datepy['y1-tbl']));
			}
		}
	}
	else{
		$q="BETWEEN '".$ls[0]."' AND '".$ls[0]." 23:30'"; //cth 2015-12-07 to 2016-01-01
		$data=getData($db, $unit, $table, $q);
	}
	return $data;
}

function getData($db, $unit, $table, $q){
	$sql=getQueryTag($db,$unit, $table, $q, true);
  if(is_array($sql))
    return $sql;
	$rs=$db->_Execute($sql);
	if($rs===false)
		return array('error'=>$db->ErrorMsg());
	else
		return $rs->getArray();
}

if($_POST){
	$data=validateInput($_POST, array('unit','DateFrom','DateTo'));
	if($data['error']) $error=$data['error'];
	
	if(!$error){
		$dateR=array(date('Y-m-d', strtotime($data['DateFrom'])), date('Y-m-d', strtotime($data['DateTo'])));
		$tdata=getTagsDataExp($data['unit'], $dateR);
		if(isset($tdata['error']))
			$error=$tdata['error'];
		elseif(!count($tdata)){
			$error="Data is empty";
		}else{
			$unit=unitData($data['unit']);
			$dr=$dateR[0]." to ".$dateR[1];
			$smarty->assign("print",1,true);
			$smarty->assign("unit", array('label'=>$unit['unit_lbl'],'file'=>$data['unit'].".tpl"),true);
			$smarty->assign("report", array('tdata'=>$tdata));
			$smarty->registerPlugin("function", "tdata", "tdata");
			$html=$smarty->fetch('tagdataexport.tpl'); //echo $html;die();
			$colsAtr=array('A'=>array('width'=>'AT','align'=>'C'));
			$setting=array('label'=>$unit['unit_lbl']." ({$dr})", 'headRows'=>($error)?2:3, 'colsAtr'=>$colsAtr, 'colsize'=>13);
			//usrlog("Export Tags Data to Excel {$dr}", $db);
			printXls($html,  $dr, $setting);
		}
	}
}
//else usrlog("Access tags data export", $db);

if($error){
	$msg['error']=setMsg($error, 'ui-state-error',null,null,'ui-icon-alert');
}	

$smarty->assign("data", array('unitlist'=>getUnits(true,false,true),'unitselect'=>$data['unit'],'ds'=>$data['DateFrom'],'de'=>$data['DateTo'], 'msg'=>$msg), true);
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("page", array('title'=>'BMS-Tags&nbsp;&nbsp;Data&nbsp;&nbsp;Export','content'=>"tagexport.tpl"), true);
$smarty->display("layout.tpl" );  

function tdata($param){
	$v=$param['v']; $dec= isset($param['d']) ? $param['d'] : 0;
	if($v===null) return '<td class="txtErr">n/a</td>';
	$val = $dec ? number_format($v, $dec, '.', '') : ( $v > 999.99 ? number_format($v, 0, '', '') : number_format($v, 2, '.', ''));
	$cond=isset($param['c']) ? getCond($param['c'], $val) : true;  //var_dump($cond);
	$td = $cond ? '<td>'.$val.'</td>' : '<td class="txtErr">'.$val.'</td>'; 
	return $td;
}
function getCond($cond, $v){
	$c = str_replace('x', $v, $cond);
	return eval("return ($c);");
}
?>
