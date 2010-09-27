package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.WidgetVO;
 
	public class WidgetEvent extends Event
	{
		static public var IMPORT_CONFIG : String = 'importConfig'
		static public var AUTOMATE_WIDGET : String = 'automateWidget'
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