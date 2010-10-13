package org.syncon.evernote.panic.view.utils
{
 
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.view.ProjectListWidget;
	import org.syncon.evernote.panic.view.TwitterScrollerTest2;
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
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000).widgetData,
			])	
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			return arr; 
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
		
				
	}
}