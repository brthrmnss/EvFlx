package  org.syncon.evernote.panic.model
{
	import flash.events.Event;
	
	public class BoardModelEvent extends Event
	{
		public static const HIGHLIGHT_ROWS : String = 'highlightRows' ; 
		public static const HIGHLIGHT_CERTAIN_ITEMS : String = 'highlightCertainItems' ; 		
		public static const HIGHLIGHT_CERTAIN_ITEMS_SELECTED : String = 'highlightItemSelected' ; 
		
		public var data: Object;
		
		public function BoardModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}