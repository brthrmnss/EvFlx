package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.BoardVO;
 
	public class CreateBoardCommandTriggerEvent extends  Event
	{
		static public var CREATE_BOARD : String = 'createBoard'
		
		public var board : BoardVO; 
		public var goIntoAdmin : Boolean = false; 
		public var fxComplete : Function
		public var fxFault : Function 
		
		public function CreateBoardCommandTriggerEvent(type:String,  
													   board_ :  BoardVO , 
													   fxComplete_ : Function = null, 
													   fxFault_ : Function = null, 
													   goIntoAdmin_ : Boolean = true )  
		{	
			this.board = board_
			this.goIntoAdmin = goIntoAdmin_;
			this.fxComplete = fxComplete_
			this.fxFault = fxFault_
			super(type, true);
		}
		
		
	}
}