package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.BoardVO;
 
	public class ExportBoardCommandTriggerEvent extends  Event
	{
		static public var EXPORT_BOARD : String = 'exportBoard'
		public var board : BoardVO; 
		public function ExportBoardCommandTriggerEvent(type:String, board_ : BoardVO)  
		{	
			this.board = board_
			super(type, true);
		}
		
		
	}
}