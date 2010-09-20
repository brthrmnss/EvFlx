package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * */
	public class EvernoteStatusTriggerEvent extends Event
	{
		public static const CHANGE_STATUS:String = 'changeStatus';
		public static const CLEAR_STATUS:String = 'clearStatus'
		public var displayTimeSeconds :  Number; 
		public var msg :  String
		public function EvernoteStatusTriggerEvent(type:String, 
												   msg_: String, displayTimeSeconds_ :   Number=-1)  
		{	
			this.msg = msg_
			this.displayTimeSeconds = displayTimeSeconds_
			super(type, true);
		}
		
		static public function StatusUpdate(     msg_: String, displayTimeSeconds_ :   Number = -1) : EvernoteStatusTriggerEvent
		{
			var e : EvernoteStatusTriggerEvent =
				new EvernoteStatusTriggerEvent( 
					EvernoteStatusTriggerEvent.CHANGE_STATUS, msg_,displayTimeSeconds_   )
			return e; 
		}			
		
	}
}