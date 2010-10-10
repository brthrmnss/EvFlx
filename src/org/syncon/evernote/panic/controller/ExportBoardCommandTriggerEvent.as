package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.BoardVO;
 
	public class ExportBoardCommandTriggerEvent extends  Event
	{
		static public var EXPORT_BOARD_TO_STIRNG : String = 'exportBoardToString'
		static public var SAVE_BOARD : String = 'saveBoard'
		public var board : BoardVO; 
		public var fxComplete : Function; //
		public var result : String  = ''; 
		public var useUILayout : Boolean = false; 
		
		public function ExportBoardCommandTriggerEvent(type:String, 
													   fxCompelte : Function = null, 
													   board_ : BoardVO = null, 
													   useUILayout_ : Boolean = true)  
		{	
			this.board = board_
			this.fxComplete = fxCompelte
			this.useUILayout = useUILayout_
			super(type, true);
		}
		
		
	}
}