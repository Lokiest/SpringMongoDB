<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::Melon Chart::</title>
<style>
	#wrap{
		padding:3em;
	}
	
	#melonList{
		width:49.5%;
		float:left;
		/* border: 1px solid red; */
	}
	
	#melonSingerCnt{
		width:48.5%;
		float:right;
		padding-left: 1em;
		/* border: 1px solid green; */
	}
	
	#melonSingerCnt ul>li{
		list-style: none;
		float: left;
		height : 30px;
		line-height: 30px;
		margin-bottom: 3px;
	}
	
	#melonSingerCnt ul>li:nth-child(2n + 1) {
		width:60%;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	
	#melonSingerCnt ul>li:nth-child(2n + 2) {
		width:40%;
	}
	
	#melonList ul.melon_chart>li{
		list-style-type: none;
		float: left;
		width: 45%;
		height: 120px;
		margin-bottom: 3px;
		
	}
	
	#melonList ul>li:nth-child(3n + 1) {
		width:10%;
	}
	
	#melonList ul>li:nth-child(3n + 2) {
		width:25%;
	}
	
	#melonList ul>li:nth-child(3n + 3) {
		width:65%
	}
	
</style>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
	$(function() {
		$('#btn1').on('click', function(){
			$.ajax({
				type:'get',
				url:'crawling',
				dataType:'xml',
				cache:false,
				success:function(res) {
					//alert(res);
					let n = $(res).find('result').text();
					//alert(n + ' data saved');
					$('#melonList').html("<h3>" + n + " data crawling success</h3>");
					getMelonList();
				},
				error:function(err) {
					alert('err : ' + err.status);
				}
			})
		})
		
		$('#btn3').click(function() {
			$.ajax({
				type:'get',
				url:'singerCnt',
				dataType:'json',
				cache:false,
				success:function(res) {
					//alert(JSON.stringify(res));
					renderCntBySinger(res);
				},
				error:function(err) {
					alert('err : ' + err.status);
				}
			})
		})
	})
	
	const getMelonList=function() {
		$.ajax({
			type:'get',
			url:'list',
			dataType:'json',
			cache:false,
			success:function(res) {
				//alert(res);
				renderMelon(res);
			},
			error:function(err) {
				alert('err : ' + err.status);
			}
		})
	}
	
	const renderCntBySinger=function(jsonArr) {
		var data = new google.visualization.DataTable();
		data.addColumn('string', 'Singer');
		data.addColumn('number', 'Song Count');
		
		let mydata = []; //2차원 배열 형태로 넣어주어야
		
		let str = '<ul class="melon_singer_cnt">';
			$.each(jsonArr, function(i, obj) {
				let arr = [];
				arr.push(obj.singer);
				arr.push(obj.cntBySinger);
				//arr = ['~', 14]
				
				mydata.push(arr);
				console.log("arr = " + arr);
				
				str+= '<li>';
				str+= obj.singer;
				str+= '</li>';
				str+= '<li>';
				str+= obj.cntBySinger;
				str+= '</li>';
			})
			console.log('mydata = ' + mydata);
			data.addRows(mydata);
			str+= '</ul>';
			$('#melonSingerCnt').html(str);
			renderBarChart(data);
	}
	
	const renderBarChart=function(data) {
		let option={
			'title':'songs by singer on melon chart',
			'width':600,
			'height':1000,
			'fontSize':11,
			'fontName':'Verdana',
			'colors':['#ff0000']
		}
		
		let option2={
				'title':'songs by singer on melon chart',
				'width':600,
				'height':1000,
				'fontSize':12,
				'fontName':'Verdana',
				'colors':['#339955', '#123123']
			}
		
		let bar_chart=new google.visualization.BarChart(document.getElementById('melonList'));
		bar_chart.draw(data, option);
		
		let pi_chart=new google.visualization.PieChart(document.getElementById('melonSingerCnt'));
		pi_chart.draw(data, option2);
	}
	
	const renderMelon=function(jsonArr) {
		//alert(jsonArr.length);
		let str = '<ul class="melon_chart">';
		$.each(jsonArr, function(i, obj) {
			str+= '<li>';
			str+= obj.ranking;
			str+= '</li>';
			str+= '<li>';
			str+= '<img src="'+obj.albumImage+'">'
			str+= '</li>';
			str+= '<li>';
			str+= '<span class="title">' + obj.songTitle + "</span><br>";
			str+= '<span class="singer">' + obj.singer + "</span>";
			str+= '</li>';
		});
			str+= '</ul>';
		
		$('#melonList').html(str);
	}
</script>
</head>
<body>
<div id="wrap" class="container">
	<div id="menu">
	<h1>Today's Melon Chart - ${today}</h1>
	<button id="btn1">Melon Chart Crawling</button>
	<button id="btn2" onclick="getMelonList()">Melon Chart list</button>
	<button id="btn3">melon chart songs by singers</button>
	</div>
	<div id="melonList">
		<!-- 멜론 차트 목록 들어옴 -->
	</div>
	<div id="melonSingerCnt">
		<!-- 멜론 가수별 노래 수 들어옴 -->
	</div>
	
</div>

 <script type="text/javascript">

      // Load the Visualization API and the corechart package.
      google.charts.load('current', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.charts.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Topping');
        data.addColumn('number', 'Slices');
        data.addRows([
          ['Mushrooms', 3],
          ['Onions', 1],
          ['Olives', 1],
          ['Zucchini', 1],
          ['Pepperoni', 2]
        ]);

        // Set chart options
        var options = {'title':'How Much Pizza I Ate Last Night',
                       'width':400,
                       'height':300};

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('melonList'));
        chart.draw(data, options);
        
        var chart2 = new google.visualization.BarChart(document.getElementById('melonSingerCnt'));
        chart2.draw(data, options);
      }
    </script>

</body>
</html>