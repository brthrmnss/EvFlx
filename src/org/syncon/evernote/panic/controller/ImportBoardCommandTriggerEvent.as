package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class ImportBoardCommandTriggerEvent extends  Event
	{
		static public var IMPORT_BOARD : String = 'importBoard'
		static public var LOAD_BOARD : String = 'loadBoard'			
		public var data : Object; 
		public var boardName : String = ''; 
		public function ImportBoardCommandTriggerEvent(type:String,  
													   data_ : Object = null, board_name : String = '')  
		{	
			this.data = data_
			this.boardName = board_name  
			super(type, true);
		}
		
		
	}
}