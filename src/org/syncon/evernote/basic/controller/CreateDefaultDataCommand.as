package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.type.Note;
	
	import mx.controls.DateField;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	
	public class CreateDefaultDataCommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		
		//[Inject] public var event:ShowPopupEvent;
		static public var START : String = 'CreateDefaultDataCommand.START'
		
		override public function execute():void
		{
			var notes : Array = []; 
			var note : Note = new Note()
			note.title = 'Note 1' 
			note.tagNames = ['Tag1', 'Tag2', 'Tag3']
			note.createdAt = this.newDate( '04/05/1992' )
			note.updatedAt = this.newDate( '09/05/2005' )
			notes.push( note ); note = new Note(); 
			note.title = 'Note 2' 
			note.tagNames = ['Tag1', 'Tag2', 'Tag3']
			note.createdAt = this.newDate( '04/05/1992' )
			note.updatedAt = this.newDate( '09/05/2005' )
			notes.push( note ); note = new Note(); 	
			note.title = 'Note 3' 
			note.tagNames = ['Tag1', 'Tag2', 'Tag3']
			note.createdAt = this.newDate( '04/05/1992' )
			note.updatedAt = this.newDate( '09/05/2005' )		
			notes.push( note ); note = new Note(); 
			this.apiModel.loadNotes( notes ) 
		}
		
		private function  newDate( str :String )  : Date
		{
			var newDate : Date = DateField.stringToDate( str, 'MM/DD/YYYY' ) 
			return newDate;
		}
		
	}
}