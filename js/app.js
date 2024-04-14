if( ! window.console ) console = { log: function(){} };

function bms(){
	this.REPORT={},
	this.connector,
	this.AJAX_RUN = false,
	this.TREND_ENABLE = false,
	this.DATA_INTV_FAILED = 0,
	this.TREND_ONDIALOG = false,
	// RawByTime, RawByNumber, InterpolatedtoRaw, LabtoRaw, source: https://www.ge.com/digital/documentation/historian/version80/r_hgs_sampling_modes.html
  this.fileExist = function(){

  },
	this.getUrl = function (){
		var arr =window.location.pathname.split('/');
		return {script:arr.pop(),path:arr.join('/')};
	},
	this.ajaxCall = function(loc, dataType, data, fn, noani){
    console.log('ajax call loc: '+ loc, 'script : '+url.script)
		var current_state=window.location.href, loc=(loc) ? loc : current_state;
		$.ajax({
			method:(data)?"POST":"GET",
			url:loc,
			dataType:dataType,
			//async: false,
			//timeout: 10, //Type: Number - Set a timeout (in milliseconds) for the request
			//traditional:true, //Type: Boolean - Set this to true if you wish to use the traditional style of param serialization.
			data:data,
			beforeSend:function(xhr){
				if(!noani)$('#loader').show();//xhr.overrideMimeType( "text/plain; charset=x-user-defined" );
        bms.dismisMsg();
			},
			success:function(rs, x, i){		console.log('on success : ', rs, x, i);
				if(rs.timeout) window.location = 'logout.php';
				else if(rs.dbDisconect) window.location = 'databaseError.php';
				else if(rs.error && url.script!="emailUtil.php"){
					bms.setMsg(rs.error,'ui-state-error','ui-icon-alert');
					if(rs.error=='no authorized'){ setTimeout(function(){window.location.href='./login.php'; },1000); }
				}else{
					fn(rs);
				}
			},
			error:function(xhr, status, errorThrown){ console.log('ERROR FROM REPORT.JS', xhr, status, errorThrown); // xhr.statusText sama dgn errorThrown
        var msg;
        if(xhr.status==0){
          msg=''; //'Retrying connect to server..';
          isConnect=0;
        }
        else msg = xhr.responseText;
				bms.setMsg(msg,'ui-state-error','ui-icon-alert');
			},
			complete:function(){   console.log('on complete');
				if(!noani)$('#loader').hide('slow');
			}
		})
	},
	this.qreport=function(pv,print,e){ console.log('SUBMIT qreport pv:'+pv+', print:'+print+', URL SCRIPT:'+url.script+', e:', e);
		(e.preventDefault) ? e.preventDefault() : e.returnValue = false;
    this.dismisMsg();
		if($('#dt').val()||$('#ds').val()||$('#de').val()){   //alert(this.validateDate());
			if(!this.validateDate()) return false;
		}
		if(url.script!='tagexport.php'){
			if(print){
				$('#q_print').val(1);
				$('form').attr('target', '_blank');
			}else{
				$('#q_print').val(0);
				$('#q_page').val(pv);
				$('form').attr('target', '');
			}
		}
		else $('.report_msg').fadeOut(1000).remove();
		$('form').submit();
	},
	this.validateDate=function(){
		var now=new Date, d = $("#dt").val(), ds= $("#ds").val(), de= $("#de").val();	
		var d = (d) ? new Date(d) : null;			
		var ds = (ds) ? new Date(ds) : null;
		var de = (de) ? new Date(de) : null;		console.log('now='+now +', date='+d+', datestart='+ ds+', dateEnd='+de);		//alert(ds > de);

		if((d==null||d=='1970-01-01'||d > now) && (ds==null||de==null||ds=='1970-01-01'||de=='1970-01-01'||ds > now||ds > de)){  //alert('date salah');
			if(d==null && (ds==null || de==null)){
				this.setMsg("Please Completed Field Date",'ui-state-error','ui-icon-alert');
			}else if(d > now){
				this.setMsg("That date is in the future", 'ui-state-error','ui-icon-alert');
			}else if(ds > now){		
				this.setMsg("That date start is in the future",'ui-state-error','ui-icon-alert');
			}else if(ds > de){
				this.setMsg("That date start greater than date end",'ui-state-error','ui-icon-alert');
			}
			return false;
		}
		return true
	},
	this.setMsg=function(msg, cls, icon,fokus){	console.log('set message-msg:'+msg);
		if(!msg) return;
		if(typeof msg=='object'){
			var err =[];
			$.each(msg, function(i,e){	console.log('msg :' + e);
				err.push("<span class='ui-icon "+icon+"'></span><div>"+e+"</div><br>");
			}); console.log(err);
			msg = err.join(""); console.log(msg)
		}
		else{
			msg ="<span class='ui-icon "+icon+"'></span><div>"+msg+"</div>"
		}
		var msgcon = $('#msg-con');
		msgcon.removeClass('ui-state-error ui-state-highlight');
		msgcon.addClass(cls).fadeIn().find('.msg').html(msg);
		if(fokus)$(fokus).focus();  console.log('done set msg');
	},
  this.dismisMsg=function(){ 
		var msgcon = $('#msg-con');
    if(!msgcon.is(':hidden')){ msgcon.fadeOut(); }
    if($('.report_msg').length==1&&!(url.script==""||url.script=="index.php")){ $('.report_msg').remove(); } 
  },
	this.inputValidate=function(selector, iptvldt){ console.log('validate input : '+selector);
		var err=[], inputs = (selector) ? $(selector).serializeArray() : $('form').serializeArray();
		$.each(inputs, function(i,ipt){
			if(ipt.value==""){ console.log('input :',ipt);
				$("[name='"+ipt.name+"']").parent().addClass('error');
				err.push(ipt.name);
			}
		});
		
		if(err.length){	console.log('err : ', err, 'lenght :'+err.length, 'type :'+typeof err);
			var msg = (iptvldt) ? "Please complete required fields input" : err;
			this.setMsg(msg, 'ui-state-error','ui-icon-alert');
			return false;
		}
		else return true;
	},
	this.buildSelect=function(data,selector,label){
		var opts=['<option value="">'+label+'</option>'];
		$.each(data, function(id,val){ //console.log(val, typeof val)
			if(typeof val=='object'){
				opts.push('<optgroup label="'+id+'">'); 
				$.each(val, function(i,v){ opts.push('<option value="'+i+'">'+v+'</option>'); });
				opts.push('</optgroup>'); 
			}
			else
				opts.push('<option value="'+id+'">'+val+'</option>');
		});	//console.log(opts);
		$(selector).children().remove();
		$(selector).append(opts.join(""));//.removeAttr('disabled');
	},
	this.autoResize=function(){ console.log('> autoResize');
		if($.inArray(url.script, ['login.php', 'logout.php', 'about.php', 'tagexport.php','databaseError.php','user.php','emailUtil.php'])!=-1) $('#page').height($(window).height()-50);
		else $('#page').height('auto');
		if(tagLoaded) this.synTable(); //if(url.script=='reporting.php' && $('#report').length)
		this.resizeEditor();
	},
	this.resizeEditor=function(){
		if(url.script=='reporting.php' && $('#comment').length){
			$('#cke_comment').width($('#content').width()-200);
			if($('#cke_1_top').height()){ 
				$('#cmt-act .panel3').height($('#cke_1_top').height()-2);
				if($('#cke_comment').width() < 828) $('#cmt-act .panel3 span').css('line-height', 5);
				else $('#cmt-act .panel3 span').css('line-height', 2);
				return true;
			}
			console.log('EDITOR-RESIZE:', $('#cke_comment').width(), $('#cke_1_top').height());
			return false;
		}
	},
	this.synTable=function(){
		var colCount=$('#firstTr>td').length, rowCount=$('table.report tbody tr').length, x=0, size; 
		console.log('Syncronize table..', $('table.report:first').width()-16, $('table tr#firstTr td').length, ($('table.report:first').width()-16)/colCount);
		$('.head').each(function(i){
			if(x < colCount){		
				size = (colCount==x+1) ? 
					$('#table_div td:eq('+x+')').width() + ((rowCount>12)?16:0) 
					: $('#table_div td:eq('+x+')').width(); 
				$(this).css('width',size);
			}
			x++; //console.log('=>', x, size);
		});
		//console.log('HAS-SCROLL:', $('.box-bdr')[0].offsetWidth < $('.box-bdr')[0].scrollWidth, $('.box-bdr').is(':hidden'));
	},
	this.synTable2=function(tbl_div){
		var tbl_div = tbl_div ? tbl_div : $('#table_div');
		var tbl_header = tbl_div.prev(); 
		var colSizer = tbl_header.find('tr.sizer th');
		var colCount = colSizer.length;
		var tbl_data = tbl_div.find('table');
		var rowCount = tbl_data.find('tr').length;
		var size, scrollbar=0;
		console.log('Syncronize table-2 ..', tbl_div[0]);
		colSizer.each(function(i){
			// if(i==0) { alert($(this).width()); tbl_data.find('td:eq(0)').width($(this).width());  }
			// else 
				if(i < colCount){
				var el = tbl_data.find('td:eq('+ i +')'); //console.log('============>', i, $(this)[0]);
				var size = el.width();
        if(colCount == i+1) {
          scrollbar = ((rowCount > 17) ? 17 : 0);  // give 15px for scroll tab width
          size = size + scrollbar; 
        }
				$(this).width(Number.parseInt(size));
				// console.log(i, scrollbar, 'size:', size, $(this).width());
			}
		});
	}
}
var bms = new bms(), url=bms.getUrl(), isConnect=0, mobileDis=0, tagLoaded=false, isAdmin=false;

$(document).ready(function(){	//console.log(docHeight());
  bms.autoResize();
  
  var touch=$('#touch-menu'), menu=$('.eflat-menu'), listFilter=['report.php','users.php','userlog.php'], msgFilter=['user.php','users.php'];
	mobileDis=!touch.is(':hidden');
	menuRes();
  
	$(touch).on('click', function(e) {
		e.preventDefault();
		menu.slideToggle();
	});
  
	$(window).resize(function() {  console.log('WINDOW RESIZE.. height:'+$(window).height()+', width:'+$(window).width(), 'MOBILE-DIS:'+mobileDis);
    bms.autoResize();
		mobileDis=!touch.is(':hidden');
    menuRes();
	});
	
	if($.inArray(url.script, msgFilter)!=-1){ console.log('MSG FILTER..')
		if($('.report_msg.ui-state-highlight').length){   console.log('HIDE MESSAGE');
			setTimeout(function(){ $('.report_msg.ui-state-highlight').fadeOut().remove(); }, 5000);
		}	
	}
			
	if($.inArray(url.script, listFilter)!=-1){
		var btnReset='.filter button[type=reset]',btnSubmit='.filter button[type=submit]',
		inputs= function(){ 
			return $(':input:not(button, [type=hidden], .ui-datepicker-month, .ui-datepicker-year)').map(function(){ return this.value }).toArray().toString();//.match(/all/g);
		},
		filterTglBtn=function(){  console.log('this:',$(this),inputs(),'test:'+ /\w/.test(inputs()));
			if(/\w+/.test(inputs())||$(this).is('select')){		console.log('HIDE BTN-RESET & SHOW BTN-FIND..')
				$(btnReset).hide();//$('button[type=reset]').not(':hidden')
				$(btnSubmit).show('swing');
			}else{  console.log('HIDE BTN-RESET..');
				$(btnSubmit).hide('swing');
			}
		}; //console.log(inputs(),'test:'+ /\w/.test(inputs));
		
		//if(/\w+/.test(inputs())&&!$('[name="q[dept]"]').is(':disabled')){ 
		if(/\w+/.test(inputs())&&!$('[name="q[dept]"]').is(':disabled')){ 
			$(btnReset).show('swing');
		}
		$('.filter :input:not(button)').change(function(){
			$('#q_print').val(0);
			$('form').attr('target', '').submit();
		});
		$('.filter :input[type=reset]').click(function(e){  console.log('RESET..', e)
			e.preventDefault();
			$('#q_print').val(0);
			$(':input:not(button)').val('');
			$(this).hide(); /*$(btnSubmit).show('swing');*/
			$('form').attr('target', '').submit();
		});
	}
		
	$("#dt").datepicker({
		//dateFormat: "dd/mm/yy", //"dd/M/yy", //"mm/dd/yy",
		showAnim:'show', //blind
		changeMonth: true,
		changeYear: true,
		minDate:'04/25/2017',
		onSelect:function(){
			if(url.script=='reporting.php' || url.script=='historian.php'){
				if(!bms.validateDate()) return false;
				else $('form#dateForm').submit()
			}
			else{
				$('#ds').val('');$('#de').val(''); $(btnReset).hide(); $(btnSubmit).show('swing');
				if(!bms.validateDate()) return false;
				$('form').submit();
			}
		}
		//onClose:function(){ alert('onClose') }
	});
	$("#ds").datepicker({
		showAnim:'show', //blind
		changeMonth: true,
		changeYear: true,
		minDate:'04/25/2017',
		onSelect:function(x){ $('#dt').val('');  $(btnReset).hide(); $(btnSubmit).show('swing');}
	});
	$("#de").datepicker({
		//dateFormat: "dd/M/yy", //"mm/dd/yy",
		showAnim:'show', //blind
		changeMonth: true,
		changeYear: true,
		minDate:'04/25/2017',
		onSelect:function(){ $('#dt').val('');  $(btnReset).hide(); $(btnSubmit).show('swing');}
	});
	
	$('.msgClose').click(function(){ $(this).parent().fadeOut() });
	$('#logout').click(function(){ isConnect=0; });
	
  function menuRes(){  console.log('> nenures');
    var menu=$('.eflat-menu');
    if(mobileDis){
      menu.hide();
      var left = $('#page').width()-207; console.log('left:'+left);
      if(menu.length > 1){
				$('.eflat-menu.a').removeClass('left');$('.eflat-menu.b').removeClass('right');
        $('.eflat-menu.a').parent().css({float:'right',position:'absolute','left':left});
			}else{
        $('.menu1').css({float:'right',position:'absolute','left':left});
			}
		}  
    else{
      if(menu.length > 1) $('.eflat-menu.a').addClass('left');$('.eflat-menu.b').addClass('right');
      menu.parent().removeAttr('style'); //$('.eflat-menu.a').parent()[0].style='';
      menu.show();
    }
    if($.inArray(url.script, ['login.php', 'logout.php', 'about.php', 'tagexport.php','databaseError.php','user.php','emailUtil.php'])!=-1) $('.footer').fadeIn(1000).offset({top:$(window).height()-30});
    else $('.footer').fadeIn(1000);
  }
});

function registerScroll(el) {
	// console.log('registerScroll:', el[0]);
  var time_marker = $('#dialog-data').find('.time_marker');
  var max_top = 1;
  var max_bottom = el.height() + el[0].offsetTop;

  // row-top: 30, row-bottom: 378
  // $('#dialog-data').position()  {top: 34.140625, left: 3.078125} height: 402.703
  // tbl_div {top: 41.703125, left: 3}, height: 370
  // 41-30 = 11, 370-378 = 8 padding
  console.log('registerScroll:', el[0].scrollHeight, el[0]);
  //var scroll_tm;
  el.scroll(function (e) {
    //clearTimeout(scroll_tm);
    //scroll_tm = setTimeout(function(){
    var pos_y = Math.round(time_marker.position().top);

      //var w_bottom = Math.round($(document).height() - this.innerHeight);
      // console.log(`pos_y:${pos_y} max_bottom:${max_bottom} time_marker:`,time_marker.position(), (pos_y > max_top), (pos_y < max_bottom));
      if(pos_y > max_top && pos_y < max_bottom){
        if(bms.connector.end != time_marker[0])
					bms.connector.setOptions({ end:time_marker[0] });
        bms.connector.position();
      } else {
        //bms.connector.setOptions({ end:el[0] });
      }
    //}, 300);
  });
}

/*
RULE OF SPEC :
- between 1 - 10
  sample: 2  good
	        11 warning
					15 danger
					0  warning
					-5 danger
					
	c="x <= 25"
	c="x >= 45 && x <= 55"
*/
var last_tr_data='';
function getTrendData(samplingmode='interpolated'){
  if(bms.AJAX_RUN || !bms.TREND_ENABLE) return;
  
  bms.AJAX_RUN = true;
  $.get("/bms3/api.php?q=his-trend", {'samplingmode':samplingmode}, function(data) {
		console.log('getTrendData:', data);
    bms.AJAX_RUN = false;
		var cont = bms.TREND_ONDIALOG ? $("table.report.dialog") : $("table.report:not(.dialog)");
    if(data.error){
			bms.DATA_INTV_FAILED++;  console.log('DATA_INTV_FAILED:', bms.DATA_INTV_FAILED);
      if(bms.TREND_ENABLE && bms.DATA_INTV_FAILED > 5){
				var i=0;
        cont.find("tr.sizer th").each(function(i, el){ //console.log('>', i, el);
          $(el).text('N/A');
					if(i==0) $(el).addClass('danger');
					else $(el).removeClass();
        });
        // bms.synTable2();
      }
      // bms.TREND_ENABLE = false;
      return;
    }

		var i=0;
		var danger_spec = 0.5;  // over 50% from spek
		var tr_data='<tr>';
    $.each(data, function(n, val){ //console.log('>', n, val);
			var el = cont.find("tr.sizer th:eq("+i+")");
			// if(!el[0]) return;
			if(i > 0){
				val = Number(val).toFixed(2);
				if(el[0].hasAttribute('data-spek')){
					var s = el[0].getAttribute('data-spek');
					var arr_s = s.replaceAll(' ', '').split('&&');
					var spec='', spec_dgr='', spec_opr1='', spec_val1='', spec_opr2='', spec_val2='';
					let so1 = arr_s[0].match(/\W+/);
					if(so1) {
						spec_opr1 = so1[0];
						let sv1 = arr_s[0].match(/\d*\.?\d+/);
					
						if(sv1) spec_val1 = parseInt(sv1[0]);
						spec += val + spec_opr1 + spec_val1;
						if(spec_opr1.match('>'))
							spec_dgr += val + spec_opr1 + (spec_val1 - (spec_val1 * danger_spec));
						else
							spec_dgr += val + spec_opr1 + (spec_val1 + (spec_val1 * danger_spec));
						
						if(arr_s.length > 1){
							let so2 = arr_s[1].match(/\W+/);
							let sv2 = arr_s[1].match(/\d*\.?\d+/);
							if(so2) spec_opr2 = so2[0];
							if(sv2) spec_val2 = parseInt(sv2[0]);
							spec += ' && ' + val + spec_opr2 + spec_val2;
							if(spec_opr2.match('>'))
								spec_dgr += ' && ' + val + spec_opr2 + (spec_val2 - (spec_val2 * danger_spec));
							else
								spec_dgr += ' && ' + val + spec_opr2 + (spec_val2 + (spec_val2 * danger_spec));
						}
						// console.log(`spec_opr1:"${spec_opr1}" spec_val1:"${spec_val1}" spec_opr2:"${spec_opr2}" spec_val2:"${spec_val2}"`);
						// console.log(`spec_normal:"${spec}" spec_dgr:"${spec_dgr}"`);
						var klas='good';
						if(!eval(spec)){
							klas = eval(spec_dgr) ? 'warning' : 'danger';
						}
						// var kls = eval(val + spek) ? 'good' : 'warning';
						el.text(val).removeClass().addClass(klas);
						if(bms.TREND_ONDIALOG) tr_data += '<td class="'+ klas +'">'+ val +'</td>';
					}
					else el.text('Invalid spec!');
				}
				else{
					el.text(val).addClass('good');
					if(bms.TREND_ONDIALOG) tr_data += '<td>'+ val +'</td>';
				}
			}
			else {
				var d = new Date(val.replace('Z',''));
				var dt = d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds().toString().padStart(2,'0'); // d.toLocaleTimeString()
				el.removeClass('danger').text(dt);
				if(bms.TREND_ONDIALOG) tr_data += '<td class="time">'+ dt +'</td>';
			}
			
			i++;
    });
		
		if(bms.TREND_ONDIALOG){
			tr_data +='</tr>';
			// console.log('TR-DATA:', tr_data);
			if($('#table_div_dialog table tbody tr:first').length)
				$('#table_div_dialog table tbody tr:first').before(last_tr_data);
			else{
				$('#table_div_dialog table tbody').append(last_tr_data);
				bms.synTable2($('#table_div_dialog'));
			}
			last_tr_data = tr_data;
		}
		
    // if(!bms.TREND_ENABLE) bms.synTable2();  // when has error occur and back to normal
		bms.DATA_INTV_FAILED = 0;
    // if(bms.DATA_INTV_ISOPEN) return;
    // if(bms.TREND_ENABLE){  console.log('SHOW DATA INTV');
      // // $('#table_div').css('margin-top', -1);
      // bms.DATA_INTV_ISOPEN = true;
    // }
  }, 'json');
}

function getTrendDataIntv(itv=2000, samplingMode='interpolated') { console.log('getTrendDataIntv');
	bms.TREND_ENABLE = true;
	clearInterval(bms.INTV);
  bms.INTV = setInterval(function(){
    getTrendData(samplingMode);
  }, itv);
}

function registerRowClick() {  console.log(' > registerRowClick');
  $('table.report tbody tr').on('click', function(e){
    $(this).parent().find('.time_marker').removeClass('time_marker');
		$(this).addClass('time_marker');
    var el = $(this).find('td:first')
    getRowDetail(el);
  });
	
	$('tr.sizer').on('click', function(e){
		getHistorian({'trend-table':true, 'unit':bms.REPORT.AREA}, function(){renderDialog();});
	});
}

function createConnectorLine(el1, el2){   console.log('Make connector:', el1, el2);
  // bms.connector.start, bms.connector.end
  bms.connector = new LeaderLine(
    el1,
    el2,
    //$('.ui-dialog-titlebar')[0],
    //LeaderLine.pointAnchor($('.ui-dialog-titlebar')[0], {x:0, y:'200%'}),
    {
      //color:'green',
      startPlug: 'square',
      startSocket: 'left',
      startSocketGravity: 11,
      //endSocketGravity: [-10, -20],
      path: 'grid',
      size: 3,
      dash: true
    });
}

function getHistorian(param, cb){
	var url = '/bms3/historian.php'; //'http://localhost/bms3/api/historian',
  console.log('> getHistorian:', param, url);
	bms.AJAX_LAST_REQ = url;
	$('#loader').show();
  $.ajax({type:'POST', url:url, data:param})
  .done(function(data){
    //console.log(data);
    $('#dialog-data').html(data);
		$('#loader').hide();
    if(cb) cb();
  });
}

function renderDialog(el=null, time=null, timeStart=null, timeEnd=null){
	if(bms.TREND_ONDIALOG){
		var d = new Date();
		timeStart = d.toLocaleString();
		timeEnd = 'Infinity';
	}

	console.log('RenderDialog', el, time, timeStart, timeEnd);
	// var div_el; //= $('#table_div_dialog');
   var dialog_el = $('#dialog-data');
   
   if(!dialog_el.dialog('isOpen')){
		// var div_el = $('#table_div_dialog');
		dialog_el.dialog('open');
		// registerScroll(div_el);
		$('.ui-dialog #form-his').remove();
	
		var txt ='<form id="form-his"><span><b>time-start:</b> '+ timeStart + '</span>&nbsp;'
			+' <span><b>time-end:</b> '+ timeEnd + '</span>&nbsp;'
			+ (bms.TREND_ONDIALOG ?
			' <span><b>interval: </b><select id="interval" name="intv"><option value=1000>1 sec</option><option value=2000 selected>2 sec</option><option value=5000>5 sec</option><option value=10000>10 sec</option></select></span>'
			: ' <span><b>interval: </b><select id="interval" name="intv"><option value="1m">1 min</option><option value="5m">5 min</option><option value="10m">10 min</option></select></span>')
			+' <span><b>sampling-mode: </b><select id="samplingMode" name="smode"><option value="interpolated">interpolated</option><option value="Calculated">Calculated</option>'
			+' <option value="trend">Trend</option><option value="Lab">Lab</option><option value="currentvalue">currentvalue</option></select></span>'
			+'</form>';
		$('.ui-dialog-titlebar').after(txt);
		$('.ui-dialog-title').append('<span class="loader">&nbsp;&nbsp;</span>');
		
		$('#form-his select').on('change', function(){
			if(bms.TREND_ONDIALOG){
				getTrendDataIntv(parseInt($('#interval').val()), $('#samplingMode').val());
				return;
			}else{
				var intv = $('#interval').val();
				var smode = $('#samplingMode').val();
				if(smode=='trend' && intv=='1m'){
					$('#interval').val('5m');
					intv = '5m';
				}
				getHistorian({'trend':true,'unit':bms.REPORT.AREA, 'time_marker':time, 'startTime':timeStart, 'endTime':timeEnd, 'interval':intv, 'samplingMode':smode},
					function(){
						renderDialog(el, time, timeStart, timeEnd);
						bms.synTable2($('#table_div_dialog'));
						bms.connector.position();
					}
				);
			}
		});
	}
	
	if(el){
		var time_marker = $('#dialog-data .time_marker');
		if(!time_marker.length)
			time_marker = $('.ui-dialog');
		if(bms.connector) bms.connector.remove();
		createConnectorLine(el[0], time_marker[0]);
		
		var div_el = $('#table_div_dialog');
		if(div_el[0].scrollHeight > div_el[0].offsetHeight){
			registerScroll(div_el);
			var pos = (div_el[0].scrollHeight - div_el.offset().top - 200) / 2;
			div_el.scrollTop(pos);
		}
	}
}

function getRowDetail(el){
	// console.log('> getRowDetail', el[0]);
  // http://localhost/bms3/report/vst/01-01-2022
	bms.TREND_ENABLE = false;
	$("#dialog-data").dialog("option", "position", {my:"center", at:"center", of:window});
  var tr = el.parent();
  var time = tr.attr('data-time');
  var timeStart = tr.prev().attr('data-time');
  var timeEnd = tr.next().attr('data-time');

  if(!timeStart){
    timeStart = getTimeModif(time, -30);
  }
  if(!timeEnd){
    timeEnd = getTimeModif(time, +30);
  }

  console.log(' > getRowDetail', el[0], `\ntime:"${time}" time-start:"${timeStart}" time-end:"${timeEnd}"`);
  getHistorian(
		{'trend':true, 'unit':bms.REPORT.AREA, 'time_marker':time, 'startTime':timeStart, 'endTime':timeEnd, 'interval':'1m'}, 
		function(){renderDialog(el, time, timeStart, timeEnd);}
	);
}

function getTimeModif(date, modif){ console.log('getTimeModif:', date, modif, (modif == +30));
  var date = new Date(date);
  date.setMinutes(date.getMinutes() + modif);
  if(modif == +30){
    if(date > new Date()) date = new Date();
  }
  return formatDate(date);
}

// Get Format time from unix timestamp
function formatDate(date) {   console.log('formatDate:', date, date.getHours());
  if(! date instanceof Date){
    date = new Date(date);
  }
  var month_str = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var month_num = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
  var year = date.getFullYear();
  var monthstr = month_str[date.getMonth()];
  var monthNum = month_num[date.getMonth()];
  var dt = date.getDate();
  var hour = date.getHours();
  var min = date.getMinutes();
  var sec = date.getSeconds();
  //var d = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec;
  return year +'-'+monthNum+'-'+dt+' '+hour+':'+min;
}
