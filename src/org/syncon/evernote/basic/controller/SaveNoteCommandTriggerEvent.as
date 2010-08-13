package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.elements.TextFlow;
	
	import org.syncon.evernote.model.Note2;

	/**
	 * */
	public class SaveNoteCommandTriggerEvent extends Event
	{
		public static const SAVE_NOTE:String = 'saveNote';
		//public static const EXPORT:String = 'exportTextFlow'
		public var fxResult : Function; 
		public var fxFault : Function; 		
		public var note :  Note2
		public var tf : TextFlow
		public function SaveNoteCommandTriggerEvent(type:String, 
															  note_:  Note2, tf_ : TextFlow, fxResult_ :  Function, fxFault_ : Function )  
		{	
			this.note = note_
			this.tf = tf_		
			this.fxResult = fxResult_
			this.fxFault = fxFault_				
			super(type, true);
		}
		
		
	}
}