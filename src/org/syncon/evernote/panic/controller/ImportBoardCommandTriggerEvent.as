package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class ImportBoardCommandTriggerEvent extends  Event
	{
		static public var IMPORT_BOARD : String = 'importBoard'
		static public var LOAD_BOARD : String = 'loadBoard'
		static public var IMPORT_FROM_GUID_BOARD : String = 'IMPORT_FROM_GUID_BOARD'			
		
		public var data : Object; 
		public var boardName : String = ''; 
		public var goIntoAdmin : Boolean = false; 
		public var createBoardIfNotFound : Boolean = false; 
		public function ImportBoardCommandTriggerEvent(type:String,  
													   data_ : Object = null, board_name : String = '', goIntoAdmin_ : Boolean = false )  
		{	
			this.data = data_
			this.boardName = board_name  
			this.goIntoAdmin = goIntoAdmin_;
			super(type, true);
		}
		
		
	}
}