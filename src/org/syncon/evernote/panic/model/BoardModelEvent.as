package  org.syncon.evernote.panic.model
{
	import flash.events.Event;
	
	public class BoardModelEvent extends Event
	{
		public static const HIGHLIGHT_ROWS : String = 'highlightRows' ; 
		public static const HIGHLIGHT_CERTAIN_ITEMS : String = 'highlightCertainItems' ; 		
		public static const HIGHLIGHT_CERTAIN_ITEMS_SELECTED : String = 'highlightItemSelected' ; 
		
		public static const HORIZONTAL_GAP_CHANGED : String = 'horizontalGapChanged' ; 
		public static const VERTICAL_GAP_CHANGED : String = 'verticalGapChanged' ; 
		
		/**
		 * When in add mode, and user clicks board, make row for them and add 
		 * compponent for the sake of simplicity
		 * */
		public static const CLICKED_BOARD : String = 'clickedBoard' ; 
		
		
		public var data: Object;
		
		public function BoardModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}