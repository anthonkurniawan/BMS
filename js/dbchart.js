var test;
function chart(diskUse,diskFree,diskFreeMb,dbsize,dbsizeP){
	console.log('CHART: diskUse', diskUse, 'diskFree', diskFree, 'diskFreeMb', diskFreeMb, 'dbsize', dbsize, 'dbsizeP', dbsizeP);
	var chart;
	Highcharts.setOptions({
    global:{ useUTC:false }
  });

  $('#pie').highcharts({
    chart:{
      plotBackgroundColor:null,
			plotBorderWidth:null,
			plotShadow:false
		},
		title:{ text:'Disk Storage on Drive C' },
		credits:{ enabled:false },
		tooltip:{
      pointFormat:'{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions:{
      pie:{
        allowPointSelect:true,
        cursor:'pointer',
        dataLabels:{
          enabled:true,
          color:'#000000',
          connectorColor:'#000000'
        },
				showInLegend:true
			}
		},
    series:[{
      type:'pie',
      name:'System Disk C',
      data:[
        ['Disk Use',diskUse],
        {
          name:'BMS DB',
          y:dbsizeP,
          sliced:true,
          selected:true
        },
        ['Disk Free', diskFree]
      ]
    }]
	});

  $('#gauge_db').highcharts({
    chart:{
      type:'gauge',
      plotBackgroundColor:null,
			plotBackgroundImage:null,
			plotBorderWidth:0,
			plotShadow:false
		},
		title:{ text:'Data Size at free space' },
		credits:{ enabled:false },
		pane:{
      startAngle:-150,
			endAngle:150,
			background:[{
        backgroundColor:{
          linearGradient:{ x1:0,y1:0,x2:0,y2:1 },
          stops:[
            [0.2, '#000088'],
            [0.8, '#000066']
          ]
        },
				borderWidth:5,
				borderColor:'black'
			}]
		},
		yAxis:{
			min:0,
			max:diskFreeMb,
			minorTickInterval:'auto',
			minorTickWidth:1,
			minorTickLength:10,
			minorTickPosition:'inside',
			minorTickColor:'#666',
			tickPixelInterval:30,
			tickWidth:1,
			tickPosition:'inside',
			tickLength:10,
			tickColor:'#00F',
			labels:{
				step:2,
				rotation:'auto',
				style:{
          color:'#34ABFA',
          fontWeight:'normal',
					fontSize:'11px'
        }
			},
			title:{
				text:'DB Size',
				y:15
			},
			plotBands:[{
				from:0,
				to:diskFreeMb * 0.50,
				color:'#55BF3B'
			},{
				from:diskFreeMb * 0.50,
				to :diskFreeMb * 0.75, 
				color:'#DDDF0D'
			},{
				from:diskFreeMb * 0.75,
				to:diskFreeMb,	
				color:'#DF5353'
			}]        
		},	
		series:[{
			name:'BMS Size',
			data:[dbsize],
			tooltip:{
				valueSuffix:' MBytes'
			},
			dataLabels:{
        enabled:true,
        color:'#E6F0FF',
        borderWidth:1,
				borderColor:'blue'
      }
		}]
	});
	
	$('#row_max').highcharts({
		chart:{
			type:'gauge',
			plotBackgroundColor:null,
			plotBackgroundImage:null,
			plotBorderWidth:0,
			plotShadow:false,
      events:{ 
				load:requestData 
			}
		},
		title:{
			text:'Counting Tags Data Row'
		},
		pane:{
			startAngle:-150,
			endAngle:150,
			background:[{
				backgroundColor:{
					linearGradient:{ x1:0, y1:0, x2:0, y2:1 },
					stops:[
						[0.2, '#000088'],
						[0.8, '#000066']
					]
				},
				borderWidth:5,
				borderColor:'black'
			}]
		},
		yAxis:{
			min:0,
			max:17520, /*asumsi jumlah row 1thn*/
			minorTickInterval:'auto',
			minorTickWidth:1,
			minorTickLength:10,
			minorTickPosition:'inside',
			minorTickColor:'#666',
			tickPixelInterval:30,
			tickWidth:2,
			tickPosition:'inside',
			tickLength:10,
			tickColor:'#00F',
			labels:{
				step:2,
				rotation:'auto',
				style:{
          color:'#34ABFA',
          fontWeight:'normal',
          fontSize:'11px'
        }
			},
			title:{
				text:'Rows Data ',
				y:15
			},
			plotBands:[{
				from:0,
				to:8900,
				color:'#55BF3B'
			},{
				from:8900,
				to:15000,
				color:'#DDDF0D'
			},{
				from:15000,
				to:17520,
				color:'#DF5353'
			}]        
		},
		series:[{
			name:'Row Table Tags Data',
			data:[0],
			tooltip:{
				valueSuffix:' Rows'
			},
			dataLabels:{
        enabled:true,
        color:'#E6F0FF',
				borderWidth:1,
				borderColor:'blue'
       }
		}],
		credits:{ enabled:false }
	});
  
  function requestData(){
    var series = this.series[0].points[0];
		test = series;
		console.log('>requestData series:', series );
		setInterval(function(){ getData(series); }, 5000);
	}

	function getData(series) {
    bms.ajaxCall('api.php?q=chart','json',null, function(rs){  console.log('RS :', rs, isConnect);
      if(isConnect==0){
        isConnect=1;
        bms.setMsg('Connected','ui-state-highlight','ui-icon-info');
        setTimeout(function(){ $('#msg-con').fadeOut(); }, 2000);
      }
			console.log('UPDATE POINT:', rs.nilai)
      series.update(Number(rs.nilai));	
    },1);
	}
}