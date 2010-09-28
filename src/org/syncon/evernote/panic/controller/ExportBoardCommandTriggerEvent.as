package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.BoardVO;
 
	public class ExportBoardCommandTriggerEvent extends  Event
	{
		static public var EXPORT_BOARD : String = 'exportBoard'
		static public var SAVE_BOARD : String = 'saveBoard'
		public var board : BoardVO; 
		public var fxComplete : Function; //
		public var result : String  = ''; 
		
		public function ExportBoardCommandTriggerEvent(type:String, 
													   fxCompelte : Function = null, 
													   board_ : BoardVO = null )  
		{	
			this.board = board_
			this.fxComplete = fxCompelte
			super(type, true);
		}
		
		
	}
}