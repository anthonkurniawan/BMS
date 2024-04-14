<?php
/*V5.18 3 Sep 2012   (c) 2000-2012 John Lim (jlim#natsoft.com). All rights reserved.*/
class ADODB_Pager {
	var $id; 	// unique id for pager (defaults to 'adodb')
	var $db; 	// ADODB connection object
	var $sql; 	// sql used
	var $rs;	// recordset generated
	var $curr_page;	// current page number before Render() called, calculated in constructor
	var $rows;		// number of rows per page
  var $linksPerPage=5; // number of links per page in navigation bar
  var $showPageLinks; 

	// Localize text strings here
	var $first='<i class="fa fa-angle-left"></i>';//'|&lt;';
	var $prev='<i class="fa fa-angle-double-left"></i>'; //'&lt;&lt;';
	var $next='<i class="fa fa-angle-double-right"></i>';// '>>';
	var $last='<i class="fa fa-angle-right"></i>'; //'>|';
	var $moreLinks = '...';
	var $startLinks = '...';
	//var $gridHeader = false;
	var $htmlSpecialChars = true;
	var $page = 'Page';
	var $cache = 0;  #secs to cache with CachePageExecute()
	
	//----------------------------------------------
	// constructor
	//
	// $db	adodb connection object
	// $sql	sql statement
	// $id	optional id to identify which pager, 
	//		if you have multiple on 1 page. 
	//		$id should be only be [a-z0-9]*
	//
	function ADODB_Pager(&$db,$sql,$id='adodb', $showPageLinks=false)
	{
	  global $PHP_SELF;
		$curr_page = $id.'_curr_page';    //echo "============>". $_SERVER['PHP_SELF'];
		if (!empty($PHP_SELF)) $PHP_SELF = htmlspecialchars($_SERVER['PHP_SELF']); // htmlspecialchars() to prevent XSS attacks

		$this->sql = $sql;
		$this->id = $id;
		$this->db = $db;
		$this->showPageLinks = $showPageLinks;
		
		$next_page = $id.'_page';	
		
		if(isset($_POST[$next_page]))
			$_SESSION[$curr_page] = (integer) $_POST[$next_page];
		if (empty($_SESSION[$curr_page])) 
		  $_SESSION[$curr_page] = 1; ## at first page
		$this->curr_page = $_SESSION[$curr_page];  //echo "CURRENT PAGE : $this->curr_page";
	}
	
	//---------------------------
	// Display link to first page
	function Render_First($anchor=true, $param=null)
	{			
	  $query= ($param) ? "?$param&" : "?"; 	
	
	  global $PHP_SELF;						
		if($anchor) {				
	    ?>
		  <span class="btn btn-primary" onClick="bms.qreport(1,null,event)"><?php echo $this->first;?></span>
	    <?php
		}else
		  print "<span class='btn btn-primary disabled'>$this->first</span>";
	}

	// Display link to next page
	function render_next($anchor=true, $param=null)		# GW TAMBAH PARAM
	{
	  $query= ($param) ? "?$param&" : "?"; 	
	  global $PHP_SELF;
	
		if ($anchor) {     
		?>
		<span class="btn btn-primary" onClick="bms.qreport(<?php echo $this->rs->AbsolutePage() + 1 ?>,null,event)"><?php echo $this->next;?></span>
		<?php
		}else
		  print "<span class='btn btn-primary disabled'>$this->next</span>";
	}

	function render_last($anchor=true, $param=null)		# GW TAMBAH PARAM
	{
	  //$query= ($param) ? "?$param&" : "?"; 	
	  //global $PHP_SELF;
	
		if (!$this->db->pageExecuteCountRows) return;
		
		if ($anchor) {
		  ?>
			<span class="btn btn-primary" onClick="bms.qreport(<?php echo $this->rs->LastPageNo() ?>,null,event)"><?php echo $this->last;?></span>
		  <?php
		}else {
		  print "<span class='btn btn-primary disabled'>$this->last</span>";
		}
	}
	
	// original code by "Pablo Costa" <pablo@cbsp.com.br> 
  function render_pagelinks($param=null)		# GW TAMBAH PARAM
  {
    global $PHP_SELF;
    $pages=$this->rs->LastPageNo();
    $linksperpage=$this->linksPerPage ? $this->linksPerPage : $pages;
    for($i=1; $i <= $pages; $i+=$linksperpage){
      if($this->rs->AbsolutePage() >= $i){
        $start = $i;
       }
    }
	  $numbers='';
    $end=$start+$linksperpage-1;
		$link= ($param) ? $param."&".$this->id . "_page" : $this->id . "_page"; 	# GW MODIFIED	
    if($end > $pages) $end = $pages;	
		if ($this->startLinks && $start > 1) {
	    $pos = $start - 1;
			$numbers .= "<span class='btn btn-primary' onclick='bms.qreport($pos,null,event)'>$this->startLinks</span>";
    } 
			
		for($i=$start; $i <= $end; $i++) {
      if($this->rs->AbsolutePage() == $i){
			  $numbers .="<span class='btn btn-primary active'>$i</span>";
      }else 
        $numbers .="<span class='btn btn-primary' onclick='bms.qreport($i,null,event)'>$i</span>";
    }
		if($this->moreLinks && $end < $pages){ 
		  $numbers .="<span class='btn btn-primary' onclick='bms.qreport($i,null,event)'>$this->moreLinks</span>";
		}
    print $numbers;
  }
		
	// Link to previous page
	function render_prev($anchor=true, $param=null)		# GW TAMBAH PARAM
	{
	  $query= ($param) ? "?$param&" : "?"; 	
	  global $PHP_SELF;
		if ($anchor) {
	  ?>
		<span class="btn btn-primary" onClick="bms.qreport(<?php echo $this->rs->AbsolutePage() - 1 ?>,null,event)"><?php echo $this->prev;?></span>
	  <?php 
		}else{
			print "<span class='btn btn-primary disabled'>$this->prev</span>";
		}
	}
	
	// Navigation bar
	// we use output buffering to keep the code easy to read.
	function RenderNav($param=null)
	{							//print_r($param); print_r($_SERVER['QUERY_STRING']);
		ob_start();			
		if (!$this->rs->AtFirstPage()) {						
			$this->Render_First(true, $param);
			$this->Render_Prev(true, $param);
		}else{
			$this->Render_First(false);
			$this->Render_Prev(false);
		}
    if($this->showPageLinks){
      $this->Render_PageLinks($param);
    }
		if (!$this->rs->AtLastPage()) {
			$this->Render_Next(true, $param);
			$this->Render_Last(true, $param);
		} else {
			$this->Render_Next(false);
			$this->Render_Last(false);
		}
		$s = ob_get_contents();
		ob_end_clean();

		return "<div class='btn-group btn-group-xs'>{$s}</div>";
	}
	
	//-------------------
	// This is the footer
	function RenderPageCount()
	{
		if (!$this->db->pageExecuteCountRows) return '';
		$lastPage = $this->rs->LastPageNo(); //echo "------------------->".$lastPage; //die();
		if ($lastPage == -1) $lastPage = 1; // check for empty rs.
		if ($this->curr_page > $lastPage) $this->curr_page = 1;
		return "$this->page ".$this->curr_page."/".$lastPage;
	}
	
	function myRender($rows=10,$print=false)
	{							//var_dump($print); //die(); //ECHO "$this->sql,$rows,$this->curr_page";
	  global $ADODB_COUNTRECS;
	
		$this->rows = $rows;
		
		if ($this->db->dataProvider == 'informix') $this->db->cursorType = IFX_SCROLL;
		
		$savec = $ADODB_COUNTRECS;
		if ($this->db->pageExecuteCountRows) $ADODB_COUNTRECS = true;
		if ($this->cache)
			$rs = $this->db->CachePageExecute($this->cache,$this->sql,$rows,$this->curr_page);
		else
			$rs = $this->db->PageExecute($this->sql,$rows,$this->curr_page);
		$ADODB_COUNTRECS = $savec;
			
		
		$this->rs = $rs;					
		if(!$rs){
			return array('error'=>$this->db->ErrorMsg());
		}
		if (!$rs->EOF && (!$rs->AtFirstPage() || !$rs->AtLastPage())){ 
			$param = isset($_GET['r']) ? "r={$_GET['r']}" : false;				//echo $param; die();
			$header = (!$print) ? $this->RenderNav($param) : null;							
		}else
			$header = "&nbsp;";             //echo "<pre>";print_r($rs);echo"</pre>";
			
		return array("rs"=>$rs, "pager"=>$header, "pageCount"=>$this->RenderPageCount(), "totalCount"=>$rs->_maxRecordCount);
	}
}
?>
