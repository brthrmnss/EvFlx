package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class LoadDefaultDataTriggerEvent extends  Event
	{
		static public var SETUP_BOARD : String = 'setupBoard'
		static public var START : String = 'LoadDefaultDataCommand.START'
		static public var SETUP : String = 'LoadDefaultDataCommand.SETUP'			
		static public var LIVE_DATA : String = 'LoadDefaultDataCommand.LIVE_DATA'
		static public var AUTHENTICATE : String = 'LoadDefaultDataCommand.AUTHENTICATE'			
						
		public var data : Object; 
		public var preferredLayout :  Array; 
		public function LoadDefaultDataTriggerEvent(type:String,
													data : Object=null, preferredLayout: Array = null)  
		{	
			this.data = data
			this.preferredLayout = preferredLayout; 
			super(type, true);
		}
		
		
	}
}