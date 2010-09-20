package   org.syncon.evernote.basic.controller
{
	import com.evernote.edam.type.Note;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.elements.TextFlow;

	/**
	 * */
	public class EvernoteToTextflowCommandTriggerEvent extends Event
	{
		public static const IMPORT:String = 'importEvernoteXML';
		public static const EXPORT:String = 'exportTextFlow'
		public var fxResult : Function; 
		public var txt :  String
		public var debug : Boolean = false;
		
		public var tf : TextFlow = new TextFlow()
		public var images : Array = []; 
		public var checkboxes : Array = []; 
		public var associatedNote : Note
		public function EvernoteToTextflowCommandTriggerEvent(type:String, 
					  txt_: String, fxResult_ :  Function, debug_ : Boolean = false , 
					  associatedNote_ : Note = null)  
		{	
			this.txt = txt_
			this.fxResult = fxResult_
			this.debug = debug_
			this.associatedNote = associatedNote_
			super(type, true);
		}
		
		
	}
}