{strip}
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript" src="js/ckeditor/config.js"></script>
<style>
#report{ display:none}
.judul{ display:table;width:100%;text-align:left;padding:2px 0px;}
.title{ font-size:18px;color:#003;vertical-align:sub}
.cell{ display:table-cell;width:150px}
#cmt-con{ margin-top:5px;width:100%;border:1px solid #b6b6b6; border-bottom-color:#E7E7E7;border-left-color: #E7E7E7;display:none}
#cmt-form{ border-right:1px solid #b6b6b6;float:left;}
#cmt-act{ width:179px;text-align:center;float:left;} /*chrome-firefox 179px, ie:180px*/
img.user{ border:none;margin:10px}
img.user.nopic{ height:70px}
#submit .btn{ width:100%;padding:5px 0px;height:18px;border-radius:0px}
#submit .btn-group{ width:100% }
#submit .btn-group .btn{ width:88px}
.pic-cmnt{ height:151px}
.cke_chrome{ border:none;}
.panel3 span{ line-height:2}
.panel3 .fa,.toggle,.toggle .fa{ color:#7b909f}
.toggle:hover{ color:#7eafd2}
i.newReport{ margin:0px -40px 0px 35px;}
.ui-tabs .ui-tabs-panel{ padding:5px}
.ui-accordion-header span.pos{ display:inline-block;min-width:40%}
.ui-accordion-header span.date{ font-size:11px}
{*
.timestamp{ font-size: 10px;margin:0;padding:0; width:100%;line-height:15px;border: 1px solid #E5E3F5;background:#DDD; font-size:10px; font-family:Arial, Helvetica, sans-serif}
.highlight{ padding:9px 14px;margin-bottom:14px;background-color:#f7f7f9;border:1px solid #e1e1e8;border-radius:4px}
*}
.tag-error{ margin-top:100px;height:350px}
.isReject, .isPending, .isApprove{ margin-top:1px}
.ui-widget-content .disabled{ margin-left: 3px}
#tabs{ border:none1}
#tabs ul{ border:0;}
#tabs ul li{ border:1px solid #bdbdca;border-bottom:0}
.ui-tabs .ui-tabs-panel{ border:1px solid #bdbdca}
.ui-accordion-header span{ color:#565c60}
iframe html body.cke_editable p{ margin:0px}

/* DIALOG FORM  */
#dialog-form label { margin:0;font-weight:bold }
#dialog-form input, select { margin-bottom:10px;width:95% }
</style>

<!--DIALOG FORM -->
<div id="dialog-form" title="Create new user" STYLE="display:none">
  <div id="msg-sign" class="ui-corner-all ui-helper-clearfix">
				<div class="msg"></div>
				<a href="#" class="msgClose right ui-icon ui-icon-close"></a>
			</div>

  <form>
    <label for="name">Username</label>
    <input type="text" name="username" id="username" class="text ui-widget-content ui-corner-all">
    <label for="password">Password</label>
    <input type="password" name="password" id="password" class="text ui-widget-content ui-corner-all">

    <label for="reason">Reason</label>
    <select name="reason">
      <option value="1" selected=""> Approved </option>
      <option value="2">Rejected</option>
    </select>

    <!-- Allow form submission with keyboard without duplicating the dialog button -->
    <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
  </form>
</div>
<!-- END -->

<div class="ui-helper-clearfix judul" style="{if !isset($report.tdata)}border-bottom:1px solid gray;{/if}">
	<div class="cell"><i class="fa fa-lg fa-file-text"></i><span class="title">{$unit.label}</span></div>
	<div style="display:table-cell;text-align:center">
		{if isset($report.tdata)}
			<span class="title">Daily Report {$report.0.date|date_format:'%A, %B %e, %Y'}</span>
		{else}
			<span class="disabled">Please select date for show report</span>
		{/if}
	</div>
	<form id="dateForm" class="cell" method="get">
		<input name="unit" type="hidden" value="{$unit.name}">
		<label for="dt">Date : </label>
		<!-- BARU 26-01-2022-->
		{if !$report.0.date} {$date= date('Y-m-d')} {else} {$date=$report.0.date}{/if}
    <input name="date" id="dt" type="text" value="{$date|date_format:'%d-%b-%Y'}" {if !$unit.priv}disabled{/if} placeholder="Click to select date" style="margin-right:1px">
    <!-- END -->
  </form>
</div>

{if $report.0.error} {$report.0.error}{/if}
{if $error} <div style="margin-top:10%">{$error}</div>{/if}

{*UNIT-REPORT*}
{if isset($report.tdata)}
	<div class="box-bdr hide">{include file=$unit.file}</div>
	{if !$report.tdata.error}
	<div class="panel-btm ui-helper-clearfix" style="margin-bottom:10px;display:none">
		<a href="{$attr.print}&print=pdf" class="right btn btn-xs btn-primary print" target="_blank" style="margin-right:5px" title="export to pdf"><i class="fa fa-file-pdf-o"></i>pdf</a>
		<a href="{$attr.print}&print=xls" class="right btn btn-xs btn-primary print" title="export to excel"><i class="fa fa-file-excel-o"></i>excel</a>
	</div>
	{/if}

	{if $report.0.comment}
	<div id="report_msg" class="ui-widget">
		<div class="ui-state-error ui-corner-all">
			<span class="ui-icon ui-icon-alert"></span><b id="msg"></b>
		</div>
	</div>

  <div id="report">
    <div class="left">
      <div id="status-con" class="{$attr.statusDis}">
        <input type="checkbox" value=2 {if $report.0.status==2}checked{/if} {$attr.statusDis}> <span style="margin-right:5px">Deviasi</span>
        <input type="checkbox" value=1 {if $report.0.status==1}checked{/if} {$attr.statusDis}> <span>No Deviasi</span>
      </div>
    </div>

    <!--<div class="right sum">{$attr.reportSum}</div>-->
    <div class="clear"></div>

    <form id="formReport" method="post">
      <div id="tabs" class="box-bdr2">
        <ul class="panel3">
          {if $user.position=='admin'}
          <li><a href="#tabs-1">Progress Summary</a><span></span></li>
          {else}
          <li><a href="#tabs-1">Initiator</a><span id="act_int"></span></li>
          {if !$attr.tab3}
          <li><a href="#tabs-2">Initiator SPV</a><span id="act_spv_int"></span></li>
          {/if}
          <li><a href="#tabs-3">Enginnering SPV</a><span id="act_spv_eng"></span></li>
          <li><a href="#tabs-4">Quality Assurance SPV</a><span id="act_spv_qa"></span></li>
          {/if}
          <i class="right fa fa-lg fa-commenting" style="padding:5px"></i>
        </ul>

        {if $user.position=='admin'}
        <div id="tabs-1">{$report.0.comment.admin}</div>
        {else}
        <div id="tabs-1">{$report.0.comment.int}</div>
        {if !$attr.tab3}<div id="tabs-2">{$report.0.comment.spv_int}</div>{/if}
        <div id="tabs-3">{$report.0.comment.spv_eng}</div>
        <div id="tabs-4">{$report.0.comment.spv_qa}</div>
        {/if}
      </div>

      <input type="hidden" name="id" value="{$report.0.id}">
      <input type="hidden" name="date" id="date" value="{$report.0.date}">
      <input type="hidden" name="progress" id="progress" value="{$report.0.progress}">
      <!--<input type="hidden" name="progressOri" value="{$report.0.progress}">	 	 -->
      <input type="hidden" name="status" id="status" value="{$report.0.status}">
      <input type="hidden" id="isReject" name="isReject" value="{$report.0.rejectBy.position}">
      <input type="hidden" id="kirim" name="kirim">
    </form>
  </div>
	{/if}
{/if}

<script type="text/javascript">
var loader=$('#loader');
$(document).ready(function(){ {*//var x = new report(1, [1,2], 0, "samsul"); x.tab(1, [1,2], 0, null); *}
	{if $sc} loader.show();{$sc} {/if}
});

function report(a, d, p, r){
	var actv=a,dis=d,progress=p,rejectBy=r;	console.log('New repot-tab_act:'+actv+', tab_dis:'+dis+', progress:'+progress+', rejectBy:'+rejectBy);
	bms.synTable();

	$('.box-bdr').animate({
    {*//opacity: 0.25, left: "+=50",*}
    height: "toggle"
  }, 2000, function(){ console.log('TABLE OK', $('table.report.first').width()==$('#table_div').width(), $('table tr .head:last')===$('table tr#firstTr td:last'));
		if($('table.report.first').width()!==$('#table_div').width() || $('table tr .head:last')!==$('table tr#firstTr td:last')) bms.synTable();
		if($('#comment').length){
		 if(/msie/.test(navigator.userAgent.toLowerCase())){ $('#cmt-act').width(180); }
		 if(bms.resizeEditor()){
			loader.hide();
		 }
		 else{
			 var intv=setInterval(function(){
				 if(bms.resizeEditor()){
					 clearInterval(intv); loader.hide();
				 }
			 },1000);
		 }
	 }
	 else loader.hide();
	 tagLoaded=true;
	 $('div.panel-btm').fadeIn();
  });

	$("#comment_accord").accordion({ heightStyle:"content",active:-1 });
	$(".accordion").accordion({ heightStyle:"content",active:-1 });

	$("#tabs").tabs({
		active:actv,
		disabled:dis,
		create:function(event,ui){
		console.log('TAB CREATE : ', event, ui);  {*//console.log('ui tab : ', ui.tab, 'ui-panel : ', ui.panel);*}
			$('#report').show('slideDown');
			if(rejectBy){ $("#act_"+rejectBy).addClass('isReject'); }

			if(progress==0){
        $("#act_int").addClass('isPending');
			}else if(progress==1){
        $("#act_spv_int").addClass('isPending');
			}else if(progress==2){
        $("#act_spv_eng").addClass('isPending');
			}else if(progress==3){
        $("#act_spv_qa").addClass('isPending');
      }
		},
		collapsible:true
	});

  if($('#comment').length){
    if(CKEDITOR.env.ie && CKEDITOR.env.version < 9 ){  {*console.log('BROWSER IS IE. enable html5..');*}
     CKEDITOR.tools.enableHtml5Elements(document);
    }

		var editorW=$('#content').width()-((CKEDITOR.env.ie||CKEDITOR.env.gecko)?202:215);
    CKEDITOR.config.height=180;
    /*CKEDITOR.config.width=editorW; {* //'firefox / ie8:202,chrome:215*} /*CKEDITOR.instances.comment.resize(800)*/

    $('#comment').ckeditor();
    CKEDITOR.instances.comment.on('instanceReady', function(event,editor,data){
      setTimeout(function(){
				$('#cmt-con').fadeIn(1000);
				},2000);
      $("iframe").contents().find('style').append('.cke_editable p{ margin:1px}');
    });


    if(!$('input[type=checkbox]').is(':disabled')){
      $('#status-con').children().bind('click',function(){
        var self=$(this);
        var el=(self[0].localName=='input') ? self : self.prev();
        el.prop('checked', true).siblings('input').prop('checked', false);
        $('#status').val(el.val());
      });
    }

    $('#submit span').click(function(){
      if(!$('#report_msg').is(':hidden')){ $('#report_msg').slideUp(); }
      if(!$('#msg-con').is(':hidden')){ $('#msg-con').slideUp(); }
      var status=$('#status').val(), comment=$('#comment').val(), progress=$('#progress'), isReject=$('#isReject'), reject=$(this).hasClass('reject');
      if(status==""){
        $('input[type=checkbox]').focus();
        showError("Please checklist your status report");
      }else if(comment==""){
        showError("Please write your comment");
        CKEDITOR.instances.comment.focus();
      }else{
        if(reject){
          progress.val(0);
          isReject.val(1);
        }
        else{ isReject.val(0); }

        $('#kirim').val(1);	{*/*alert('comment : ' + comment + ' status : ' + status +' progress : '+progress.val());*/*}
        $('form').submit();
      }
    });

    /* NEW DIGITAL SIGN */
    var form, name = $("#username"), password = $("#password"),
      allFields = $( [] ).add( name ).add( password );

    function sign() {
      bms.msgcon = $('#msg-sign');
      console.log('> sign');
      if(!bms.inputValidate(form, true)) return false;
      $('#msg-sign').fadeOut();
      var data = form.serializeArray();
      $.post('http://127.0.0.1/bms/api.php?q=login', data, function(a, b, c){
        console.log(a, b, c);
      });
      if(!false) return false;
			bms.msgcon = $('#msg-con');
			dialog.dialog( "close" );
    }

    var dialog = $("#dialog-form").dialog({
      autoOpen: false,
      height: 350,
      width: 400,
      modal: true,
      buttons: {
        "Sign": sign,
        Cancel: function() {
          dialog.dialog( "close" );
        }
      },
      close: function() {  console.log('>sign:close');
        bms.msgcon = $('#msg-con');
        form[ 0 ].reset();
        allFields.removeClass( "ui-state-error" );
        $('#msg-sign').fadeOut();
      },
      open: function() {  console.log('>sign:open');

      }
    });

    form = dialog.find("form").on( "submit", function( event ) {
      event.preventDefault();
      sign();
    });

    $('#formReport button#sign').click(function(e){
      e.preventDefault();
      dialog.dialog( "open" );
    });
  }

  $('.toggle').click(function(){
		var acc = $("#comment_accord");
		$('.toggle i').toggleClass('fa-plus-square, fa-minus-square');

    acc.slideToggle(function(){
      if(acc[0].style.display=='block'){
        $('.toggle b').text('Hide All Comments');
      }else{
        $('.toggle b').text('Show All Comments');
      }
    });
	});

	function showError(msg){
		$('#report_msg').slideDown();
		$('#msg').text(msg);
		return false;
	}
}
</script>
{* DEBUG *}
{*
<div style="font-size:10px; text-align:left">
	<b>ENG/QO REPORT: {$attr.eng_qa_rpt}, TAB ACTIVE : {$attr.tabAttr.active}, TAB DISABLED : {$attr.tabAttr.disabled}<br>
	USER : position={$user.position}, dept= {$user.dept}, fname= {$user.fname}<br>
	REPORT-UNIT : unit.dept= {$unit.dept}, unit.name= {$unit.name}, unit.label= {$unit.label}, unit.file= {$unit.file}</BR>
	CURRENT REPORT : report summary->{$attr.reportSum}, ID->{$report.0.id}, progress={$report.0.progress} , rejectBy={$report.0.rejectBy.name} - {$report.0.rejectBy.position}, status={$report.0.status}, statusDis={$attr.statusDis}</b> <BR>
	COMMENT : {$report.0.comment}
</div>
*}
{/strip}
