package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class ImportBoardCommandTriggerEvent extends  Event
	{
		static public var IMPORT_BOARD : String = 'importBoard'
		public var data : Object; 
		public function ImportBoardCommandTriggerEvent(type:String,  data_ : Object)  
		{	
			this.data = data_
			super(type, true);
		}
		
		
	}
}