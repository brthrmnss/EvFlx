package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class WidgetEvent extends Event
	{
		static public var IMPORT_CONFIG : String = 'importConfig'
		public var ui :  Object; 
		
		public function WidgetEvent(type:String, ui : Object )  
		{	
			this.ui = ui
			super(type, true);
		}
		
		
	}
}