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
	
	public class PanicLayoutsPieces
	{
 
		static public function largeHeader( ) :  Array
		{
			var arr : Array = []
			arr = []; 
 
			var arrc :Array  = [ 
				'<TextFlow verticalAlign="top" textAlign="left" ' +
				' lineHeight="16"  paddingLeft="10" paddingBottom="10" ' +
				'xmlns="http://ns.adobe.com/textLayout/2008" >'+
				''+
				'<span color="#EEE9E5"  fontSize="64">[[SPANISH DESIGNS ]]</span><p />'+
				'<span color="#A39F9C">[[STATUS BOARD, LTD]]</span></TextFlow>',
				//'ok', 'ok???', 
				/*	'<span color="#ff0000"> UNTIL IPAD LAUNCH</span>' +
				'<img y="20"  paddingTop="10" width="32" height="32" src="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span>'*/
			]
			arr.push( [
				MessageWidget.importData('Global Alert', '',  JSON.encode( arrc) , 5000, 300).widgetData,
			])	
			 
					
			return arr
		}		
		
		
		
		
		static public function tooMuchTwitter( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			
			for ( var i : int = 0; i < 10; i++ ) 
			{
				arr.push( [
					TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  60000).widgetData,
				])		
			}
			
			return arr
		}				
		
		
		static public function random3ColorPane( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			
			for ( var i : int = 0; i < 3; i++ ) 
			{
				
				arr.push( 
					PaneWidget.importData('Global Alert', '', '','', 3000,  '0', '0',NaN, PanicLayouts.customGradient(), 12   ).widgetData
				)		
			}
			
			return [arr]
		}				
		
		
		
		static public function barGraph5Row( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			var colors : Array = [0xFCBF17,0x47C816,0xFF3D19,0x7652C0,0x117CFA]; 
			for ( var i : int = 0; i < 5; i++ ) 
			{
				var val : int = 100*Math.random()
				arr.push( 
					GraphWidget.importData('Graph', 'Desc', val.toString()+'/100', 'Graph', val, 100, colors[i],'', 60*1000).widgetData 
				)		
			}
			
			return [arr]
		}			
		
		static public function pane3x3( ) :  Array
		{
			var arr : Array = []
			arr = []; 
			var colors : Array = [0xFCBF17,0x47C816,0xFF3D19,0x7652C0,0x117CFA]; 
			for ( var i : int = 0; i < 3; i++ ) 
			{
				var row : Array = [] 
				arr.push( row ) 
				for ( var y: int = 0; y< 3; y++ ) 
				{
					row.push( 
						PaneWidget.importData('', '', '','', 60*1000,  '0x4D4844', '0x0E0E0E'  ).widgetData 
					)		
				}
			}
			
			return  arr 
		}			
		
		 
	}
}