package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;

	public class NoteListEvent extends  Event
	{
		public static const VIEW_NOTE:String = 'viewNote';
		public static const SWITCH_TO_NOTE : String = 'switchToNote'; 
		public static const CLEARED_NOTES : String = 'clearedNotes'; 
		public static const DESELECTED : String = 'deselectedNotes' 
		public var data :Object
		public function NoteListEvent( type : String , data_ : Object= null)  
		{	
			this.data = data_
			super(type, true);
		}
	 
		
	}
}