{strip}
<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
<script type="text/javascript" src="js/ckeditor/config.js"></script>
<script type="text/javascript" src="js/leader-line.min.js"></script>
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
.panel3 .fa,.toggle,.toggle .fa{ color:#7b909f }
.toggle:hover{ color:#7eafd2 }
i.newReport{ margin:0px -40px 0px 35px; }
.ui-tabs .ui-tabs-panel{ padding:5px }
.ui-accordion-header span.pos{ display:inline-block;min-width:40% }
.ui-accordion-header span.date{ font-size:11px }
.tag-error{ margin-top:100px;height:350px }
.isReject, .isPending, .isApprove{ margin-top:1px }
.ui-widget-content .disabled{ margin-left: 3px }
#tabs{ border:none1}
#tabs ul{ border:0;}
#tabs ul li{ border:1px solid #bdbdca;border-bottom:0 }
.ui-tabs .ui-tabs-panel{ border:1px solid #bdbdca }
.ui-accordion-header span{ color:#565c60 }
iframe html body.cke_editable p{ margin:0px }
table.report > tbody > tr.time_marker { background-color: #ffa5009e!important }
#form-his select{ height:20px;margin-right:10px;font-size:12px;padding:0 }
#table_div{ max-height:350px }
#table_div_dialog{ max-height:380px }
.btn-flat{ border-radius:0;background:#f0ffff;outline:none }
.btn-flat:hover{ background:none }
</style>

<div class="ui-helper-clearfix judul" style="{if !isset($report.data)}border-bottom:1px solid gray;{/if}">
	<div class="cell"><i class="fa fa-lg fa-file-text"></i><span class="title">{$report.area}</span></div>
	<div style="display:table-cell;text-align:center">
		{if isset($report.data)}
			<span class="title">Daily Report {$report.date|date_format:'%A, %B %e, %Y'}</span>
		{else}
			<span class="disabled">Please select date for show report</span>
		{/if}
	</div>
	<form id="dateForm" class="cell" method="get">
		<input name="unit" type="hidden" value="{$report.area}">
		<label for="dt">Date : </label>
		{if !$report.date} {$date= date('Y-m-d')} {else} {$date=$report.date}{/if}
    <input name="date" id="dt" type="text" value="{$date|date_format:'%d-%b-%Y'}" placeholder="Click to select date" style="margin-right:1px">
  </form>
</div>

{if $report.error} <div style="margin-top:10%">{$report.error}</div>{/if}

{if isset($report.data)}
	<div class="box-bdr">{include file=$report.file_tpl}</div>
	
	<div class="panel-btm ui-helper-clearfix" style="margin-bottom:10px;">
		<a href="{$attr.print}&print=pdf" class="right btn btn-xs btn-primary print" target="_blank" style="margin-right:5px" title="export to pdf"><i class="fa fa-file-pdf-o"></i>pdf</a>
		<a href="{$attr.print}&print=xls" class="right btn btn-xs btn-primary print" title="export to excel"><i class="fa fa-file-excel-o"></i>excel</a>
	</div>
	
	<div id="dialog-data" style="display:none">
{/if}
{/strip}

<script type="text/javascript">
var loader=$('#loader');
$(document).ready(function(){
	$('form').on('submit', function(el){ console.log('form submit'); 
		bms.dismisMsg();
		if($('#report-isprint').val()){ console.log('remove data-pjax');
			$('#date-form').removeAttr('data-pjax');
		}else{ 	console.log('add data-pjax');
			$('#date-form').attr('data-pjax', 'true');
		}
		if($('#report-ismultidate').val()){ 
			if(!validateDate()) return false;
		}
	});
	
	$('.custom-search span.pick').click(function(e){
		var el = $(this); console.log(el, e, e.target, e.target.innerText);
		$('#date-form :input.hasDatepicker').val('');
		$('#report-isprint').val('');
		$('#report-ismultidate').val('');
		if(e.target.innerText==='Single Date'){
			$('#msg-con').fadeOut('slow').find('.msg').html('');
			$('#date-form .dateR').fadeOut();
			//$('#report-ismultidate').val('');
			e.target.innerText='Range Date';
		}else{
			$('#date-form .dateR').fadeIn();
			e.target.innerText='Single Date';
			$('#report-ismultidate').val(1);
		}
	});
	
	if($('#table_div table tr:first td').length > 1){
    bms.synTable2();
    registerRowClick();
		getTrendData();
		getTrendDataIntv();
  }
	
	bms.REPORT.AREA = '{$report.area}';
	bms.REPORT.DATE = '{$report.date}';
	
	$('#dialog-data').dialog({
		classes: {
			"ui-dialog": null,
			"ui-dialog-titlebar": null,
			"ui-dialog-titlebar-close": 'btn-flat',
			//"ui-dialog-title": null,
			//"ui-dialog-content": null,
			//"ui-dialog-buttonpane": null
		},
		"autoOpen":false, "height":"auto", "minHeight":"120", "maxHeight":"600px", "draggable":true,
		"width":"1000px", "modal":true, "opacity":1, "position":{ my:"center", at:"center", of:window },
		"open":function() {
			console.log('>dialog:open',  bms.connector);
			bms.synTable2($('#table_div_dialog'));
			bms.DIALOG_ISOPEN = true;
			// $('.ui-dialog-titlebar')
			// .after('<input type="text" id="input_search" maxlength="255" style="position:absolute;top:13px;left:135px;">');
		},
		"close":function() {  console.log('>dialog:close', bms.connector);
			if(bms.connector){
				bms.connector.start.parentElement.className='';
				bms.connector = bms.connector.remove();
			}
			$('#dialog-data').html('');
			bms.TREND_ENABLE = true;
			bms.DIALOG_ISOPEN = false;
			bms.TREND_ONDIALOG = false;
		},
		"drag":function(ev, ui){
			bms.connector.position();
		},
		"resize":function(ev, ui){
			bms.connector.position();
			bms.synTable2($('#table_div_dialog'));
		},
		"focus":function(ev, ui){
			console.log('>dialog:focus', ev, ui);
		},
		"create":function(ev, ui){
			console.log('>dialog:create', ev, ui);
		},
		"_allowInteraction":function(ev){
			console.log('>dialog:_allowInteraction', ev);
			// return !!$( event.target ).is('.select2-input') || this._super( event );
			return true;
		}
	});
});
</script>

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
