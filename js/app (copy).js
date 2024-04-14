if( ! window.console ) console = { log: function(){} };

function bms(){
	this.getUrl = function (){
		var arr =window.location.pathname.split('/');
		return {script:arr.pop(),path:arr.join('/')};
	},
	this.ajaxCall = function(loc, dataType, data, fn,noani){		console.log('ajax call loc: '+ loc, 'script : '+url.script)
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
        var msg
        if(xhr.status==0){
          /*msg='Retrying connect to server..';*/
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
	this.qreport=function(pv,print,e){ console.log('SUBMIT qreport pv:'+pv+' print:'+print+' URL SCRIPT:'+url.script+'e:', e);
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
		$('#msg-con').removeClass('ui-state-error ui-state-highlight');
		$('#msg-con').addClass(cls).fadeIn().find('.msg').html(msg);
		if(fokus)$(fokus).focus();  console.log('done set msg');
	},
  this.dismisMsg=function(){ 
    if(!$('#msg-con').is(':hidden')){ $('#msg-con').fadeOut(); }
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
		var colCount=$('table tr#firstTr td').length, rowCount=$('table.report tbody tr').length, x=0, size; 
		console.log('Syncronize table..', $('table.report:first').width()-16, colCount, ($('table.report:first').width()-16)/colCount);
		$('.head').each(function(i, td){
			if(x < colCount){		
				size=(colCount==x+1) ? $('#table_div td:eq('+x+')').width()+((rowCount>12)?16:0) : $('#table_div td:eq('+x+')').width(); 
				//$(this).css('width',size);
				$(td).parent().width(size);
			}
			x++; console.log('=>', i, x, size, $(this), td); //alert(size);
		});
		//console.log('HAS-SCROLL:', $('.box-bdr')[0].offsetWidth < $('.box-bdr')[0].scrollWidth, $('.box-bdr').is(':hidden'));
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
		//minDate:'04/28/2017',
		onSelect:function(){
			if(url.script=='reporting.php'){
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
		//dateFormat: "dd/M/yy", //"mm/dd/yy",
		showAnim:'show', //blind
		changeMonth: true,
		changeYear: true,
		minDate:'04/28/2015',
		onSelect:function(x){ $('#dt').val('');  $(btnReset).hide(); $(btnSubmit).show('swing');}
	});
	$("#de").datepicker({
		//dateFormat: "dd/M/yy", //"mm/dd/yy",
		showAnim:'show', //blind
		changeMonth: true,
		changeYear: true,
		minDate:'04/28/2015',
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
