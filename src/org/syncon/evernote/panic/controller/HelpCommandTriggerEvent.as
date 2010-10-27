package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class HelpCommandTriggerEvent extends  Event
	{
		static public var HELP : String = 'eventHelp'
		public var type_ :  String; //
		
		public function HelpCommandTriggerEvent(type:String, type_ :   String )  
		{	
			this.type_ = type_
			super(type, true);
		}
		
		
	}
}