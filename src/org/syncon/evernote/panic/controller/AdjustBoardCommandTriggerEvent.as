package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.SetIncrementorVO;
 
	public class AdjustBoardCommandTriggerEvent extends  Event
	{
		static public var VERTICAL_GAP : String = 'verticalGapAdjust'
		public var board :  Object; //
		public var value : Object ; //= []; 
		
		public function AdjustBoardCommandTriggerEvent(type:String, board :  Object, 
													   value : Object )  
		{	
			this.value = value
			this.board = board
			super(type, true);
		}
		
		
	}
}