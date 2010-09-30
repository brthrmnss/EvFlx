package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class StatusUpdateEvent extends  Event
	{
		static public var UPDATE_STATUS : String = 'updateState'
		public var message : String; 			
		public function StatusUpdateEvent(type:String, message : String )  
		{	
			this.message = message
			super(type, true);
		}
		static public function ChangeStatus( str : String, fx : Function = null )  : StatusUpdateEvent
		{
			var e : StatusUpdateEvent = new StatusUpdateEvent(UPDATE_STATUS, str)
				return e; 
		}
		
	}
}