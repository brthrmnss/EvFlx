package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import spark.components.Group;
 
	public class BuildBoardCommandTriggerEvent extends Event
	{
		static public var BUILD_BOARD : String = 'buildBoard'
		static public var ADD_TO_BOARD : String = 'addToBoard'
			
		public var board :   Group; 
		public var instructions : Array; 
		public var removeAllElements : Boolean = true; 
		public function BuildBoardCommandTriggerEvent(type:String, board : Group=null, 
					instructions : Array=null , removeAllElements : Boolean = true)  
		{	
			this.board = board
			this.instructions = instructions; 
			this.removeAllElements = removeAllElements
			super(type, true);
		}
		
	}
}