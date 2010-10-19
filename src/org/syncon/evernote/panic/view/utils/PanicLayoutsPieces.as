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
		 
	}
}