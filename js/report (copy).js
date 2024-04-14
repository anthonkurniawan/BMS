$(document).ready(function(){
	var preport_con=$('#pending-report'), msg_con=$('#msg-con'), url=bms.getUrl().path, nImages = $(".pic-banner img").length,c = 0; //alert(url+ preport_con+ msg_con);

  $(".pic-banner img").on("load", function(){
    c++; /*console.log(c+' loaded..');*/
    if(nImages == c) {
      $('#menu').show('fadeIn');
      $('#welcome').css('margin-top','50px');
      $('#content').css('min-height','0px');
      pendingReport(url, preport_con, msg_con);
    }
  }).each(function(){
    if(this.complete) $(this).trigger("load");
  });

	setInterval(function(){ 
	  //if(isConnect){ pendingReport(url, preport_con, msg_con, 1); }
	  pendingReport(url, preport_con, msg_con, 1);
	}, 7000);
	//setTimeout(function(){ alert('expired'); /*window.location.reload();*/ },1000*600);
});

var titleV=document.title, preport=[], pcount=null;
	
function pendingReport(url, preport_con, msg_con, intv){  			console.log('isAdmin', isAdmin);//console.log(url,'\n-------------------------------------------CHECKING PENDING REPORT..\nTITLE:'+titleV, '\npreport_con:'+preport_con, ' pcount:'+pcount+'\npreport:'+preport);
	if(isAdmin) return;
	bms.ajaxCall(url+'/api.php?q=timeline','json',null, function(rs){  console.log('RS :', rs);
		if(isConnect==0){
			isConnect=1;
			if(rs.isAdmin){ 
				isAdmin = rs.isAdmin; return;
			}
      bms.setMsg('Connected','ui-state-highlight','ui-icon-info');
      setTimeout(function(){ msg_con.fadeOut(); }, 2000);
    }
    if(pcount!=rs.length){  console.log('pcount:'+pcount+' rs.len:'+rs.length);
      bms.setMsg(((rs.length)?'You have '+rs.length : 'You don\'t have any')+' pending reports', 'ui-state-highlight','ui-icon-info');
			if(rs.length>0){
				document.title='BMS-Home ('+rs.length+')'; console.log('set title');
			}else{document.title=titleV; console.log('set normal title'); }
			pcount=rs.length;
      if(!msg_con.is(':hidden')){ setTimeout(function(){ msg_con.fadeOut(); }, 5000); console.log('set timeout msg_con'); }
		}
		if(rs.length || preport.length){
			if(preport.length==0)
				preport_con.fadeIn(1000).html(getTimeLine(rs, preport_con));  // FIRSTTIME
			else
				preport_con.fadeIn(1000).append(getTimeLine(rs, preport_con));
		}
	},intv);   //console.log('AJAX CALL: ', ajax);
}
	
function getTimeLine(obj, preport_con){											console.log('getTimeLine obj length :', obj.length, obj); console.log('EXISTING P-REPORT : ',  preport, preport.length);
	var rcount, head, lComment, tpl, id;
	rcount = obj.length;
		
	if(preport.length > rcount){  // remove pending item if another user has take action
		var preport_tmp = []; //preport;		 console.log('1-EXISTING P-REPORT TO  REMOVE: ',  preport_tmp, 'P-REPORT:',preport);
		$.each(obj, function(i, v){
			var index = preport.indexOf(v.id);
			if(index !=-1){
				preport_tmp.push(preport.splice(index, 1).toString());
			}         
		}); console.log('P-REPORT-TMP:', preport_tmp, 'P-REPORT TO REMOVE:',preport);
			
		$.each(preport, function(i,v){  //console.log('3-EXISTING P-REPORT TO  REMOVE: ',  preport_tmp, 'P-REPORT:',preport);
			var el = $('#'+v);
			el.prev('hr').remove(); 
			el.remove();
		});        
		preport = preport_tmp;
		if(preport.length==0) preport_con.fadeOut();
	}

	if(rcount==0) return;
		
	var notif=[];
	if(rcount > 1){			//console.log('a');
		$.each(obj, function(i, v){													//console.log('index:'+i, 'value:'+typeof v, v, 'count comments :'+typeof v.comment, v.comment.length);
			if($.inArray(v.id, preport)==-1){ // check pending list if exits
				preport.push(v.id);
				notif.push(((i!=0)?'<hr>':'')+'<div id="'+v.id+'" class="notif box-bdr2">'+ getHeader(v.dept, v.unit_lbl, v.date, v.status) );
				tpl= buildComment(notif, v.comment, v.id, v.link);
			}
		});	
	}
	else{   									//console.log('count comments :'+ obj[0].comment.length);
		if($.inArray(obj[0].id, preport)==-1){
			preport.push(obj[0].id);
			notif.push('<div id="'+obj[0].id+'" class="notif box-bdr2">'+ getHeader(obj[0].dept, obj[0].unit_lbl, obj[0].date, obj[0].status) );
			tpl= buildComment(notif, obj[0].comment, obj[0].id, obj[0].link);
		}
	} 	//console.log('RESULT :', tpl)
	return tpl;
}
	
function getHeader(dept,unit,dt,st){
	return '<div class="panel3 ui-helper-clearfix">'+
		'<span class="left">'+dept+' - '+unit+'</span>'+
		'<span class="left" style="margin-left:10px">'+dt+'</span>'+
		'<span class="right">'+((st==1)?'No Deviasi':'Deviasi')+'</span>'+
	'</div>';
}
	
function buildComment(notif, cmts, id, link){
	var count = (typeof cmts=='object') ? cmts.length : 1;
	if(count > 1){
		lComment = cmts.pop();		//console.log('last comment', lcomment, 'comments : ', cmts);
		notif.push( getLastComment(lComment, id, count, link) );
		notif.push( getComments(cmts, id) );
	}else{
		notif.push( getLastComment((typeof cmts=='object')? cmts[0] : cmts, id, count, link) );
	}
	notif.push('</div>');
	tpl = notif.join("");  console.log('ADD NEW ELEMENT - id:'+id, 'P-REPORT:',preport);//console.log(notif, tpl);
	return tpl;
}
	
function getLastComment(c, id, count, link){   //console.log('getLastComment id:'+id+' count:'+ count+' link:'+link+' c:'+typeof c,c);  // moment('2016-01-20 15:40:00','YYYY-MM-DD HH:mm:ss').fromNow()
	var btn = (count > 1) ? '<a class="right" style="margin-right:10px;" title="show/hide comments" onclick="toggleCmnt($(this),'+id+','+count+');">'+count+' Comments</a>' : '';
	return '<div>'+ ((typeof c=='object')? '<div class="cmt-txt">'+ c.comment+'</div>' : '<div style="padding:5px;color:red">'+ c+'</div>')+
		'<div class="footer ui-helper-clearfix">'+(
			(typeof c=='object') ?'<span class="left" style="color:#413d3d">'+getPosLabel(c.position)+', '+c.fullname+'</span>'+
			'<span class="left" style="margin:0px 10px;">'+isReject(c.isReject,c.position)+'</span><span>'+c.submit_date+'</span>':'')+
			'<a class="right btn btn-xs btn-primary" href='+link+((typeof c=='object') ?'>Take action now</a>':'>View Report</a>')+ btn +
		'</div></div>';
}
	
function getComments(cmts, id){   console.log('comments : ', cmts.length); // $( this ).toggleClass( "highlight" );
	var arr =[];
	var colors =['white','#FDFDFD'], clr, bdr;
	$.each(cmts, function(i, c){							//console.log(i)
		clr=colors.shift(); 
		bdr=(i==0) ? ";border-top:none" : "";
		colors.push(clr);
		arr.push('<div class="comments" style="background-color:'+clr+bdr+'">'+
			'<div class="cmt-txt">'+c.comment+'</div>'+
			'<div class="footer ui-helper-clearfix">'+
				'<span>'+getPosLabel(c.position)+', '+c.fullname+'</span>'+
				'<span style="margin:0px 10px;">'+isReject(c.isReject,c.position)+'</span><span>'+c.submit_date+'</span>'+
			'</div>'+
		'</div>');
	});
	return '<div class="box-bdr2 comments-con '+id+'">'+ arr.join("") +'</div>';
}
function getPosLabel(pos){
	if(pos==='int') return "Initiator";
	else if(pos==='spv_int') return "Initiator Spv";
	else if(pos==='spv_eng') return "Engineering Spv";
	else if(pos==='spv_qa') return "QA Spv";
}
function isReject(v,p){  console.log("IS-REJECT:"+v, typeof v);
	if(v==null)return 'submited';
  else if(v!=null&&p!='int'){return (v=='1') ?'rejected':'approved';}
	else return 'revision';
}
function toggleCmnt(el,id,sum){
	var t = $('.comments-con.'+id);  console.log(el, t.css('display'), t[0].style.display)
	t.slideToggle(function(){	
		if(t[0].style.display=='block')
			el.text('Hide Comments');
		else
			el.text(sum+' Comments');
	});
}
