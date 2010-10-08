package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class ImportBoardCommandTriggerEvent extends  Event
	{
		static public var IMPORT_BOARD : String = 'importBoard'
		static public var LOAD_BOARD : String = 'loadBoard'
			/**
			 * 
			 * */
		static public var IMPORT_FROM_GUID_BOARD : String = 'IMPORT_FROM_GUID_BOARD'		
			
		static public var UPDATE_PEOPLE_AND_PROJECTS : String = 'updatePeopleAndProjects'
			
		public var data : Object; 
		public var boardName : String = ''; 
		public var goIntoAdmin : Boolean = false; 
		public var createBoardIfNotFound : Boolean = false;
		/**
		 * If true will not load any imported board into the model, but 
		 * will compare it to teh existing board 
		 * */
		public var compareBoards : Boolean = false; 
		public function ImportBoardCommandTriggerEvent(type:String,  
													   data_ : Object = null, board_name : String = '',
													   goIntoAdmin_ : Boolean = false, compareBoards_ : Boolean = false )  
		{	
			this.data = data_
			this.boardName = board_name  
			this.goIntoAdmin = goIntoAdmin_;
			compareBoards = compareBoards_; 
			if ( type == UPDATE_PEOPLE_AND_PROJECTS) 
				compareBoards = true; 
			super(type, true);
		}
		
		
	}
}