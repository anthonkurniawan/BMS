<?php
class Historian //extends Table
{
	public $areaName;
	public $dept;
	public $date;
	public $dateTo;
  public $startTime;
  public $endTime;
	public $isMultidate=false;
	public $isPrint = false;
  public $interval = '30m';
  public $samplingMode = 'Interpolated'; //'Calculated' Trend, currentvalue, interpolated, Lab, Trend2, RawByTime, RawByNumber, InterpolatedtoRaw, 
	public $time_marker;
	public $data;
	public $tagnames;
	public $error;
	protected $db;
	const minDataTime = '01-01-2017';
	
  public function __construct($area, $date = null, $dateTo = null, $print = false){
		$this->areaName = $area;
		$this->date = $date ? date('Y-m-d', strtotime($date)) : date('Y-m-d');
		$this->dateTo = $dateTo ? $dateTo : $this->date;  
    $this->startTime = $this->date.' 00:00';
		if($this->date != $this->dateTo)
			$this->endTime = $this->dateTo.' 23:30'; //date('Y-m-d h:i', strtotime($this->dateTo));
		else
			$this->endTime = date('Y-m-d h:i'); //echo $this->endTime; die();
		$this->isPrint = $print;
		$this->db = getDb();
		// $this->data = $this->getDataHis();
		// if($this->areaName){
			// $area = Area::findOne(['name'=>$this->areaName]);
		// }
    //\yii\helpers\VarDumper::dump($this, 10, 1); exit;
  }

	public function getTagnames() {
		// $this->areaName = 20;
		// echo $this->areaName;
    $cond = $this->areaName ? "WHERE t2.code='$this->areaName'" : "";
    $sql = "SELECT t1.tagname as tag, t1.alias as tagname, t1.label as tag_label,
				t2.id as areaId, t2.label as area,
				t3.id as deptId, t3.label as dept
				FROM tagname as t1
				LEFT JOIN units as t2 ON t1.unitId=t2.id
				LEFT JOIN depts as t3 ON t2.deptId=t3.id
				$cond order by areaId asc";
		// $sql = "select * from depts";
		// $this->db->debug = true;
		$this->db->SetFetchMode(ADODB_FETCH_ASSOC);
		return $this->db->GetAll($sql);
		// return $this->db->CacheGetAll(2592000, $sql);
  }
	
  public function getDataHis() {
		// // ini_set('memory_limit','500M'); // def: 128m
		$this->tagnames = $this->getTagnames(); //print_r($this->tagnames);die();
		if(!count($this->tagnames))
			return $this->error = "Area Not Found";
		$this->dept = $this->tagnames[0]['dept'];
		$deptId = $this->tagnames[0]['deptId']; 
		$areaId = $this->tagnames[0]['areaId'];
		//echo "<pre>";print_r($this); echo "</pre>"; die();
		
		$sql ="EXEC SP_GETHISTORIAN @area_id=$areaId,
			@start_time='$this->startTime',
			@end_time='$this->endTime',
			@intv='$this->interval', @samplingMode='$this->samplingMode'";
		// if($this->samplingMode)
			// $sql .= ",@samplingMode='$this->samplingMode'";
		
		// $this->data = $db->_Execute($sql);
		$rs = $this->db->_Execute($sql);
		if (!$rs)
			return $this->error = $this->db->ErrorMsg();
		else
			$this->data = $rs->getArray();
		 // echo "<pre>";print_r($this->data); echo "</pre>"; die();
  }
	
	public function getDateLabel(){
		if($this->dateTo && $this->dateTo != $this->date){
			return (date("d-m-Y", strtotime($this->date)) ." - ". date("d-m-Y", strtotime($this->dateTo)));
		}else{
			return date("d-m-Y", strtotime($this->date));
		}
	}
}

/*

--select * from tagname where unitId=1
SELECT t1.tagname as tag, t1.alias as tag_alias, t1.label as tag_label, t2.id as areaId, t2.label as area,
t3.id as deptId, t3.label as dept 
FROM tagname as t1 
LEFT JOIN units as t2 ON t1.unitId=t2.id 
LEFT JOIN depts as t3 ON t2.deptId=t3.id 
WHERE t2.code='his_sample' 
order by areaId asc  

 --EXEC SP_GETHISTORIAN @area_id=15, @start_time='2023-07-27 00:00', @end_time='2023-07-27 12:00', @intv='30m', @samplingMode='Calculated'  

SELECT TOP 2 tagname, CONVERT(datetime, timestamp) AS time, CONVERT(decimal(10,2), value) AS value, quality 
FROM openquery(HISTORIAN, 
'SELECT tagname, timestamp,value,quality FROM IHRAWDATA WHERE tagname=XP-SP3.Simulation00001
OR tagname=SAMPLE.IFIX1_BATCH_REACTORLEVEL.B_CUALM AND timestamp >="2023-07-28 21:00"') 
order by timestamp DESC

*/