package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.elements.TextFlow;
	
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Tag2;

	/**
	 * */
	public class SaveNoteCommandTriggerEvent extends Event
	{
		public static const SAVE_NOTE:String = 'saveNote';
		public static const SAVE_NOTE_CHANGE_NOTEBOOK:String = 'saveNoteChangeNotebook';
		public static const SAVE_NOTE_TAGS:String = 'saveNoteTags';		
		//public static const EXPORT:String = 'exportTextFlow'
		public var fxResult : Function; 
		public var fxFault : Function; 		
		public var note :  Note2
		public var tf : TextFlow
		public var updateNote : Boolean = true; 
		public var associatedData : Object = null; 
		
		public var tagRemove :  Tag2; 
		public var tagAdd : Tag2;
		
		public function SaveNoteCommandTriggerEvent(type:String, 
															  note_:  Note2, tf_ : TextFlow, fxResult_ :  Function,
															  fxFault_ : Function, updateNote_ : Boolean = true, 
															  associatedData_ : Object = null, 
																tagAdd_ : Tag2=null, tagRemove_ : Tag2 = null)  
		{	
			this.note = note_
			this.tf = tf_		
			this.fxResult = fxResult_
			this.fxFault = fxFault_				
			this.updateNote = updateNote_
			this.associatedData = associatedData_
			this.tagAdd = tagAdd_
			this.tagRemove = tagRemove_
			super(type, true);
		}
		
		
	}
}