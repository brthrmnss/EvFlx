package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.WidgetVO;
 
	public class WidgetEvent extends Event
	{
		static public var IMPORT_CONFIG : String = 'importConfig'
		static public var AUTOMATE_WIDGET : String = 'automateWidget'
		static public var UPDATE_CONFIG : String = 'updateConfig'
			
		
		static public var EDIT_WIDGET : String = 'editWidget'; 
		static public var UPDATE_WIDGET_CONFIG  : String = 'updateWdigetConfig'; 
		static public var TEST_WIDGET : String = 'testWidget'; 
					
			
		public var ui :  Object; 
		public var data : WidgetVO; 
		public function WidgetEvent(type:String, ui : Object =null, data : WidgetVO=null)  
		{	
			this.ui = ui
			this.data = data; 
			super(type, true);
		}
		
		
	}
}