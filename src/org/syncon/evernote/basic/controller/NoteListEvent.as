package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;

	public class NoteListEvent extends  Event
	{
		public static const VIEW_NOTE:String = 'viewNote';
		public static const SWITCH_TO_NOTE : String = 'switchToNote'; 
		public var data :Object
		public function NoteListEvent( type : String , data_ : Object= null)  
		{	
			this.data = data_
			super(type, true);
		}
	 
		
	}
}