package org.syncon.evernote.panic.view.utils
{
 
	import com.adobe.serialization.json.JSON;
	
	import flashx.textLayout.elements.DivElement;
	
	import mx.formatters.DateFormatter;
	
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.view.ProjectListWidget;
	import org.syncon.evernote.panic.view.SpacerWidget;
	import org.syncon.evernote.panic.view.TwitterScrollerTest2;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class PanicLayouts 
	{
		/**
		 * Performance is awful 
		 * */
		static public function oneTwitter( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board Status',  15000).widgetData,
			])	
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			return arr; 
		}
			
			static public function panicExtension( ) :  Array
			{
				var arr : Array = []
			arr.push( [
				
				GraphWidget.importData('Eccles lister', 'Initial Stats', '89/6', 'Eccl1', 56, 100, 0xFCBF17,'', 3000).widgetData,
				GraphWidget.importData('Eccles lister', 'Brickman Stats', '89/6', 'Eccl2', 99, 100, 0x47C816,'', 15000).widgetData,
				
				GraphWidget.importData('Eccles lister', '', 
					'{http://city-21.com/php/random_number.php}/100',
					'Ec3 - {http://city-21.com/php/random_string.php?f=8}',
					'{http://city-21.com/php/random_number.php}', 100, 0xFF3D19, '', 15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '12/100', 'Eccl4', 12, 100, 0x7652C0 , '', 15000).widgetData
			])
			/*arr[arr.length-1][0].test.background = [ 
			'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
			'<img  width="64" height="64" source="http://1.bp.blogspot.com/_TXuSIB9pJ-w/SG1MF_8aAlI/AAAAAAAAAAc/AqZh74YD2cw/s1600-R/tux-fal-64x64-transparent.png"/>'+
			'</TextFlow>',
			]	*/
			
			arr.push( [
				GraphWidget.importData('Eccles lister', 'Initial Stats', '89/6', 'Eccl1', 56, 100, 0xFCBF17,'', 3000).widgetData,
			])
			
			var fields : Array = [
				{name:'Key1', value:89, color:'#FF3D19', tooltip:'Key1 thing'},
				{name:'Key2', value:3, color:'#47C816', tooltip:'Key1 thing'},
				{name:'Key3', value:50, color:'#7652C0', tooltip:'Key1 thing'}
			]
			var pie : Object = {pie:fields}				
			
			
			
			var fields2 : Array = [
				{name:'Key1', value:89, color:'#FCBF17', tooltip:'Key1 thing'},
				{name:'Key2', value:3, color:'#47C816', tooltip:'Key1 thing'},
				{name:'Key1', value:89, color:'#FF3D19', tooltip:'Key1 thing'},
				{name:'Key2', value:3, color:'#666666', tooltip:'Key1 thing'},				
				{name:'Key3', value:50, color:'#7652C0', tooltip:'Key1 thing'}
			]
			var pie2 : Object = {pie:fields2}				
			
			
			var series : Array = [
				{name:'Profit',  color:'#FCBF17', tooltip:'Key1 thing'},
				{name:'Expenses',  color:'#47C816', tooltip:'Key1 thing'},
				{name:'Amount',   color:'#FF3D19', tooltip:'Key1 thing'}
			]
			Math.random()
			var data : Array = [
				{ Month: "Jan", Profit: 2000, Expenses: Math.random()*1500, Amount: 450 },
				{ Month: "Feb", Profit:Math.random()* 1000, Expenses: Math.random()*200, Amount: 600 },
				{ Month: "Mar", Profit: 1500, Expenses: Math.random()*1500, Amount: 300 },
				{ Month: "Apr", Profit: Math.random()* 1800, Expenses: Math.random()*1200, Amount: 900 },
				{ Month: "May", Profit: 2400, Expenses: Math.random()*575, Amount: 500 }
			]				
			var lineChart : Object = {line:{'data':data,'series':series}}						
			var ee : JSON
			//55,
			//JSON.encode( lineChart ),
			arr[arr.length-1][0].test.source = [ 
				JSON.encode( lineChart ) , 
				JSON.encode( pie ),
				JSON.encode( pie2 )
			]	
			arr[arr.length-2][0].test.source = [ 
				JSON.encode( lineChart ) , 
				JSON.encode( pie ),
				JSON.encode( pie2 )
			]						
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])		
			arr.push( [
				ProjectListWidget.importData('Project Lister', '', 355, 3000*10).widgetData,
			])			
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])			
			
			/*	 */
			
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img y="20"  paddingTop="10" width="32" height="32" source="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#EEE9E5"> 25 DAYS </span>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span></TextFlow>',
			]
			
			
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000, NaN).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = ['loveless', '<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">Satisfaction<img width="300" height="300" source="gif/A01 copy.gif"/></TextFlow>',
				'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">Have you seen this person? <img width="300" height="300" source="gif/A02 copy.gif"/><p/>If so, call security x2929</TextFlow>',
			]
			
			/*	*/
			
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])		
			
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', '',  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', '',  15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
				PaneWidget.importData('Global Alert', '', '<b>•Custom Flex and ColdFusion Web Application Development</b><br/><b>• Custom AIR Desktop Application Development</b><br/><b>•Business Systems Analysis and Implementation</b>', '',  3000,  '0', '0x3D3F3C'  ).widgetData,				
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="180" height="180" source="bus1.png"/>'+
				'</TextFlow>',
			]				
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000).widgetData,
			])
		return arr		
		}
			
			
			static public function original( ) :  Array
			{
				var arr : Array = []
				arr.push( [
					
					GraphWidget.importData('Eccles lister', 'Initial Stats', '89/6', 'Transmit', 56, 100, 0xFCBF17,'', 10*1000).widgetData,
					GraphWidget.importData('Eccles lister', 'Brickman Stats', '89/6', 'Coda', 50, 100, 0x47C816,'', 15000).widgetData,
					
					GraphWidget.importData('Eccles lister', '', 
						'{http://city-21.com/php/random_number.php}/100',
						'Unison',
						'{http://city-21.com/php/random_number.php}', 100, 0xFF3D19, '', 15*1000).widgetData,
					GraphWidget.importData('Eccles lister', '', 
						'{http://city-21.com/php/random_number.php}/100',
						'candybar',
						'{http://city-21.com/php/random_number.php}', 100, 0x7652C0 , '', 17*1000).widgetData,
					GraphWidget.importData('Eccles lister', '', '12/100', 'general', 12, 100, 0x117CFA , '', 15000).widgetData
				])
				/*arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="64" height="64" source="http://1.bp.blogspot.com/_TXuSIB9pJ-w/SG1MF_8aAlI/AAAAAAAAAAc/AqZh74YD2cw/s1600-R/tux-fal-64x64-transparent.png"/>'+
				'</TextFlow>',
				]	*/
 
				var fields : Array = [
					{name:'Coda', value:89, color:'#FF3D19', tooltip:'Key1 thing'},
					{name:'Transmit', value:3, color:'#47C816', tooltip:'Key1 thing'},
					{name:'Other', value:50, color:'#7652C0', tooltip:'Key1 thing'}
				]
				var pie : Object = {pie:fields}				
				
				
				
				var fields2 : Array = [
					{name:'New', value:89, color:'#FCBF17', tooltip:'Key1 thing'},
					{name:'Upgrades', value:3, color:'#47C816', tooltip:'Key1 thing'},
					{name:'Downgrades', value:89, color:'#FF3D19', tooltip:'Key1 thing'},
					{name:'Conversions', value:3, color:'#666666', tooltip:'Key1 thing'},				
					{name:'Abandon', value:50, color:'#7652C0', tooltip:'Key1 thing'}
				]
				var pie2 : Object = {pie:fields2}				
				
				
				var series : Array = [
					{name:'Profit',  color:'#FCBF17', tooltip:'Key1 thing'},
					{name:'Expenses',  color:'#47C816', tooltip:'Key1 thing'},
					{name:'Amount',   color:'#FF3D19', tooltip:'Key1 thing'}
				]
				Math.random()
				var data : Array = [
					{ Month: "Jan", Profit: 2000, Expenses: Math.random()*1500, Amount: 450 },
					{ Month: "Feb", Profit:Math.random()* 1000, Expenses: Math.random()*200, Amount: 600 },
					{ Month: "Mar", Profit: 1500, Expenses: Math.random()*1500, Amount: 300 },
					{ Month: "Apr", Profit: Math.random()* 1800, Expenses: Math.random()*1200, Amount: 900 },
					{ Month: "May", Profit: 2400, Expenses: Math.random()*575, Amount: 500 }
				]				
				var lineChart : Object = {line:{'data':data,'series':series}}						
				var ee : JSON
				//55,
				//JSON.encode( lineChart ),
				arr[arr.length-1][0].test.source = [ 
					JSON.encode( lineChart ) , 
					JSON.encode( pie ),
					JSON.encode( pie2 ),
					30
				]	
	 			/*	
				arr.push( [
					  SpacerWidget.importData( '', '', 5 ).widgetData 
				])		*/
				arr.push( [
					ProjectListWidget.importData('Project Lister', '', 355, 33*1000).widgetData,
				])			
				arr.push( [
					new WidgetVO( WidgetVO.SPACER )
				])			
				
				/*	 */
				
				arr.push( [
					MessageWidget.importData('Global Alert', '',  
						'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
						'<img y="20"  paddingTop="10" width="32" height="32" source="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
						'<span color="#EEE9E5"> 25 DAYS </span>'+
						'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span></TextFlow>',
						 5000).widgetData,
				])	
  
				arr.push( [
					new WidgetVO( WidgetVO.SPACER )
				])		
				
				arr.push( [
					PaneWidget.importData('Global Alert', '', percentageMaker(3, ''),'', 20*1000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
					PaneWidget.importData('Global Alert', '', 
						makeBus(),
						getImg('bus1.png', 512, 512),  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
					PaneWidget.importData('Global Alert', '', makeCalendar(6),'', 3000,  
						'0x3D3F3C', '0x3D3F3C', NaN,  customGradient(0,0xA73131,0xA73131,0x3E3F3A,0x3E3F3A,0,0.16,0.16,1,1,1,1,1)   ).widgetData,
					
				])	
			 
				arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
				arr.push( [
					TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000).widgetData,
				])
				return arr		
			}
						
			
		
		 /**
		 * Performance is awful 
		 * */
		static public function tooMuchTwitter( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				MessageWidget.importData('Too Much Twitter', '', 'Is this too Much Twitter?'.toUpperCase() , 5000).widgetData,
			])	
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000).widgetData,
			])		
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Money',  15000).widgetData,
			])		
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'True Blood',  15000).widgetData,
			])		
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Coda',  15000).widgetData,
			])		
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Rip Off',  15000).widgetData,
			])		
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Copycats',  15000).widgetData,
			])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Theft',  15000).widgetData,
			])					
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'True Blood',  15000).widgetData,
			])		
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Coda',  15000).widgetData,
			])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Rip Off',  15000).widgetData,
			])	
			arr.push( [				
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Steal',  15000).widgetData,
			])
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				MessageWidget.importData('Global Alert', '', 'Now Get Back To Work'.toUpperCase() , 5000 ).widgetData,
			])			
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])		
			arr.push( [
				GraphWidget.importData('Eccles lister', 'Initial Stats', '56/100', 'Money In', 56, 100, 0x7652C0,'', 3000).widgetData,
				GraphWidget.importData('Eccles lister', 'Brickman Stats', '99/100', 'DDC', 99, 100, 0x7652C0,'', 15000).widgetData,
				GraphWidget.importData('Eccles lister', '', 
					'{http://city-21.com/php/random_number.php}/100',
					'CONAN',// - {http://city-21.com/php/random_string.php?f=8}',
					'{http://city-21.com/php/random_number.php}', 100, 0x7652C0, '', 15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '12/100', 'YYY', 12, 100, 0x7652C0 , '', 15000).widgetData
			])		
				
				return arr; 
		}			
		
		/**
		 * Panes 
		 * */
		static public function panesX( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img y="20"  paddingTop="10" width="32" height="32" source="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#EEE9E5"> 25 DAYS </span>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span></TextFlow>',
			]
			
			return arr; 
				
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000, 400).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = ['loveless', '<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">ThiAdded <a>link</a> fo.<img width="300" height="300" source="gif/A01 copy.gif"/></TextFlow>',
				'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">Have you seen this person? <a>link</a><img width="300" height="300" source="gif/A02 copy.gif"/><p/>If so, call security x2929</TextFlow>',
			]
				
			
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', '',  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', '',  15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
				PaneWidget.importData('Global Alert', '', '<b>•Custom Flex and ColdFusion Web Application Development</b><br/><b>• Custom AIR Desktop Application Development</b><br/><b>•Business Systems Analysis and Implementation</b>', '',  3000,  '0', '0x3D3F3C'  ).widgetData,				
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="180" height="180" source="bus1.png"/>'+
				'</TextFlow>',
			]	
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', '',  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', '',  15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
				PaneWidget.importData('Global Alert', '', '<b>•Custom Flex and ColdFusion Web Application Development</b><br/><b>• Custom AIR Desktop Application Development</b><br/><b>•Business Systems Analysis and Implementation</b>', '',  3000,  '0', '0x3D3F3C'  ).widgetData,				
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="180" height="180" source="bus1.png"/>'+
				'</TextFlow>',
			]					
			
			return arr; 
		}			
		
		static public function testArraySourcing( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			
			var arrc : Array = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img y="20"  paddingTop="10" width="32" height="32" source="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#EEE9E5"> 25 DAYS </span>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span></TextFlow>',
				//'ok', 'ok???', 
				'<span color="#ff0000"> UNTIL IPAD LAUNCH</span>' +
				'<img y="20"  paddingTop="10" width="32" height="32" src="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span>'
			]
			var ee : JSON
			var sourcedArray : String = JSON.encode( arrc ) 
			arr.push( [
				MessageWidget.importData('Global Alert', '',  sourcedArray , 5000).widgetData,
			])	
			/*arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img y="20"  paddingTop="10" width="32" height="32" source="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#EEE9E5"> 25 DAYS </span>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span></TextFlow>',
			]*/
				
			arr.push( [
				MessageWidget.importData('Global Alert', '',  sourcedArray , 5000, NaN).widgetData,
			])	
			arr[arr.length-1][0].test.source =  arrc
			
			arr = []; 	
			
			
			arrc  = [ 
				'<TextFlow verticalAlign="top" textAlign="left" ' +
				' lineHeight="16"  paddingLeft="10" paddingBottom="10" ' +
				'xmlns="http://ns.adobe.com/textLayout/2008" >'+
				''+
				'<span color="#EEE9E5"  fontSize="64">SPANISH DESIGNS </span><p />'+
				'<span color="#A39F9C">STATUS BOARD, LTD</span></TextFlow>',
				//'ok', 'ok???', 
				/*	'<span color="#ff0000"> UNTIL IPAD LAUNCH</span>' +
				'<img y="20"  paddingTop="10" width="32" height="32" src="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span>'*/
			]
			arr.push( [
				MessageWidget.importData('Global Alert', '',  JSON.encode( arrc) , 5000, 300).widgetData,
			])	
				
			arr.push( [
				ProjectListWidget.importData('Project Lister', '', 355, 3000*10/10).widgetData,
			])	
			arr.push( [
				SpacerWidget.importData( '', '' , 30 ).widgetData,
			])	
			arr.push( [
				//GraphWidget.importData('Eccles lister', 'Initial Stats', '89/6', 'Eccl1', 56, 100, 0xFCBF17,'', 3000).widgetData,
				//GraphWidget.importData('Eccles lister', 'Brickman Stats', '89/6', 'Eccl2', 99, 100, 0x47C816,'', 15000).widgetData,
				
				GraphWidget.importData('Eccles lister', '', 
					'{http://city-21.com/php/random_number.php}/100',
					'Ec3 - {http://city-21.com/php/random_string.php?f=8}',
					'{http://city-21.com/php/random_number.php}', 100, 0xFF3D19, '', 15000).widgetData,
				//GraphWidget.importData('Eccles lister', '', '12/100', 'Eccl4', 12, 100, 0x7652C0 , '', 15000).widgetData
			])
				
				
			return arr
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000, 400).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = ['loveless', '<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">ThiAdded <a>link</a> fo.<img width="300" height="300" source="gif/A01 copy.gif"/></TextFlow>',
				'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">Have you seen this person? <a>link</a><img width="300" height="300" source="gif/A02 copy.gif"/><p/>If so, call security x2929</TextFlow>',
			]
			
			
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', '',  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', '',  15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
				PaneWidget.importData('Global Alert', '', '<b>•Custom Flex and ColdFusion Web Application Development</b><br/><b>• Custom AIR Desktop Application Development</b><br/><b>•Business Systems Analysis and Implementation</b>', '',  3000,  '0', '0x3D3F3C'  ).widgetData,				
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="180" height="180" source="bus1.png"/>'+
				'</TextFlow>',
			]	
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', '',  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', '',  15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
				PaneWidget.importData('Global Alert', '', '<b>•Custom Flex and ColdFusion Web Application Development</b><br/><b>• Custom AIR Desktop Application Development</b><br/><b>•Business Systems Analysis and Implementation</b>', '',  3000,  '0', '0x3D3F3C'  ).widgetData,				
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="180" height="180" source="bus1.png"/>'+
				'</TextFlow>',
			]					
			return arr; 
		}
		
		static public function percentageMaker( x : int, title : String = ''  ) :  String
		{
			var str : String = ''; 
			
			var sets : Array = [] ; 
			for ( var i : int = 0; i < x; i++ ) 
			{
				var set : String = '<TextFlow verticalAlign="middle"  textAlign="center" ' +
					' fontSize="56"  paddingTop="-10"  paddingBottom="20" ' +
				'xmlns="http://ns.adobe.com/textLayout/2008" >' 
			
				var value :  Number = (Math.random()*100)//.toFixed(2)
				if ( Math.random() < 0.6 ) 
					value *= -1
				if ( value > 0 ) 
					var pic : String =  '<img   height="128"  width="128" source="appicons/up.png"/>'
				else
					pic = '<img   height="128"  width="128" source="appicons/down.png"/>'
				
				var busStuff : Array = []; 
				busStuff.push(title)
				busStuff.push('<br />')	
				busStuff.push(pic)
				busStuff.push('<br />')		
				busStuff.push(value.toFixed(2) + '%')		
				set += busStuff.join( '' ) + '</TextFlow>'
				sets.push( set ) 
			}
					
			return JSON.encode( sets )
		}		
		
		static public function customGradient( x : int = 6, ...args ) :  String
		{
			var str : String = ''; 
			
			var sets : Array = [] ; 
			x = Math.random()*x
			x = Math.max( x, 2 )
				var ratio : Number = 0 
				var alpha : Number =1 ; 
			for ( var i : int = 0; i < x; i++ ) 
			{
				
				var o : Object = {}
				alpha= Math.random()*3
				o.color = uint( 0xFFFFFF*Math.random() )
				o.ratio = ratio
				o.alpha = Math.min( 1, alpha )	
				ratio += 1/(x)
				 sets.push( o )
			}
			if ( o != null  ) 
				o.ratio = 1
			
			if ( args.length != 0 ) 
			{
				sets =[]; 
				for (  i  = 0; i < args.length; i++ ) 
				{
					  o  = {}
					alpha= Math.random()*3
					o.color =args[i]
					o.ratio = args[i+(args.length/3)]
					o.alpha =args[i+(2*args.length/3)]
					sets.push( o )
				}
			}
	/*		sets = [
				{"color":"#ffffff", "alpha":1, "ratio":0},
				{"color":"#d2d2d2", "alpha":1, "ratio":0.5},
				{"color":"#666666", "alpha":1, "ratio":1},
			]*/
			return JSON.encode( {colors:sets} )
		}			
		static public function makeBus( x : int=0 ) :  String
		{
		var busStuff : Array = [] ; 
		var max : int = 5 
		for ( var i : int = 0; i < max; i++ ) 
		{
			var busNumber : String =  '<img   height="32"  width="32" source="'+randomPic()+'"/>' 
			busStuff.push(busNumber)
			var busWaitTime : String = '<span> ' 
			if ( Math.random() < 0.7 )
			{
				var mins : Number = int((Math.random()*60)) 
				busWaitTime += int((Math.random()*5)).toString() + ':'
				if ( mins < 10 ) busWaitTime += '0' 
				busWaitTime += int(mins).toString()  
				
			}
			else
			{
				busWaitTime += int((Math.random()*60)).toString() + ' Min'
			}
			busWaitTime += '</span>'
			busStuff.push(busWaitTime )
			
			if ( i < max-1 ) 
				busStuff.push('<br />')					
		}
		var busString : String = '<TextFlow verticalAlign="middle"  textAlign="left" ' +
			' fontSize="36" paddingLeft="100" ' +
			'xmlns="http://ns.adobe.com/textLayout/2008" >'+ 
			busStuff.join( '' ) + '</TextFlow>' 
			
		return busString; 
	}
		static public function makeCalendar( x : int ) :  String
		{
			var str : String = ''; 
			
			var sets : Array = [] ; 
			var date : Date = new Date()
			var df : DateFormatter = new DateFormatter()
				df.formatString = 'EEEE MM/DD'
			
			sets.push('<TextFlow verticalAlign="top"  textAlign="center" ' +
					' fontSize="24" paddingTop="10"  ' +
				'xmlns="http://ns.adobe.com/textLayout/2008" >' 
				)
			
			sets.push('<div' +
				' fontSize="30">'+df.format( date )+' </div>' ) 
			sets.push('<br />')		
			/*sets.push('<br />')		*/
				
				for ( var y : int = 0; y < 6; y++ ) 
				{	
					date.setTime( date.getTime()+
						(24*60*60*1000)*Math.random() ) 
					//add milliseconds 
					//format date
					df.formatString = 'M/D'
						//fixed with here
					sets.push( '<span width="100">'+df.format( date ) +' </span>')
					 
					//
					var options :  Array = [
					'Ned Out',
					'Julie Out',
					'Scrum Mtg',
					'Status Mtg',
					'Meet Client',
					'Marc tele (awa)' 
					 ]
					
					sets.push( '<span width="100">'+randomX(options) +'</span>')
					sets.push('<br />')	
			}
			sets.push( '</TextFlow>' )
			return sets.join( '' ); //JSON.encode( sets )
		}				
		
		static public function superheroPanes(b:BoardVO ) :  Array
		{
			b.horizontalGap = 20; 
			b.verticalGap = 20; 
			var arr : Array = []
			arr = []; 
			
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0', '0'  ).widgetData,
				PaneWidget.importData('Global Alert', '', getImg('appicons/theoffice_steve.jpg', 500, 512 ) ,  '' ,  15000,  '0', '0'  ).widgetData,
				PaneWidget.importData('Global Alert', '', percentageMaker(3, 'Sign ups'), '',   30000,  '0x4D4844', '0x0E0E0E'   ).widgetData,	
			])	
			arr[arr.length-1][0].test.source = [' ', '', '  ']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				getImg( 'appicons/bat_logo.png', 
					320, 302 )
				 ,
			]			
			/*	
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0', '0',NaN, customGradient(), 12   ).widgetData,
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0', '0',NaN, customGradient(), 12   ).widgetData,
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0', '0',NaN, customGradient(0,0xA73131,0xA73131,0x3E3F3A,0x3E3F3A,0,0.14,0.14,1,1,1,1,1), 0   ).widgetData,
			])					
			*/	
			
				var busString : String = makeBus(); 
			arr.push( [
				PaneWidget.importData('Global Alert', '', makeCalendar(6),'', 3000,  
					'0x3D3F3C', '0x3D3F3C', NaN,  customGradient(0,0xA73131,0xA73131,0x3E3F3A,0x3E3F3A,0,0.16,0.16,1,1,1,1,1)   ).widgetData,
				PaneWidget.importData('Global Alert',  '', 
					busString, 
					 
					//'http://www.tvjab.com/wp-content/uploads/2008/04/theoffice_logo.jpg'+
					getImg('bus1.png', 512, 512),  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', percentageMaker(3, 'Income'), '',   30000,  '0x4D4844', '0x0E0E0E'   ).widgetData,	
			])	
	 	//3
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', '',  15000,  '0', '0'  ).widgetData,
				PaneWidget.importData('Global Alert', '', percentageMaker(3, 'Yield'), '',  30000,  '0x4D4844', '0x0E0E0E'  ).widgetData,	
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = []
			return arr; 
		}
		
		
		static public function allWidgets( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			
			arr.push( [
				GraphWidget.importData('Eccles lister', 'Initial Stats', '89/6', 'Eccl1', 56, 100, 0xFCBF17,'', 3000).widgetData,
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img y="20"  paddingTop="10" width="32" height="32" source="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#EEE9E5"> 25 DAYS </span>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span></TextFlow>',
			]
			arr.push( [
				ProjectListWidget.importData('Project Lister', '', 355, 3000*10).widgetData,
			])		
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="180" height="180" source="bus1.png"/>'+
				'</TextFlow>',
			]					
			
			return arr; 
		}				
		
		public static var randomPic: Function; 
		public static var randomX : Function; 
		
		static public function getImg( s :  String, w : int=-1, h : int=-1 )  : String
		{
			var str : String = ''; 
			
			str ='<TextFlow verticalAlign="top:" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img   source="'+s+'" '
				if ( w != -1 ) 
					str += ' width="'+w+'" '
				if ( h != -1 ) 
					str += ' height="'+h+'" '						
			str += '/>'+
				'</TextFlow>' 
			
			return str
		}
		
		static public function getText( s :  String, w : int=-1, h : int=-1 )  : String
		{
			var str : String = ''; 
			
			str ='<TextFlow verticalAlign="top:" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img   source="'+s+'" '
			if ( w != -1 ) 
				str += ' width="'+w+'" '
			if ( h != -1 ) 
				str += ' height="'+h+'" '						
			str += '/>'+
				'</TextFlow>' 
			
			return str
		}		
	}
}