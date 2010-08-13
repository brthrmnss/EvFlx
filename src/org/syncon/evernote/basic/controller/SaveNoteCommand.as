package  org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Tag2;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;

	/**
	 * 
	 * On a seperate path, enabmles multie threading
	 * will return on success
	 * */
	public class SaveNoteCommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;		
		[Inject] public var event: SaveNoteCommandTriggerEvent;
		private var note : Note2 
		private var createdNew : Boolean = false; 
		override public function execute():void
		{
	 		if ( event.type == SaveNoteCommandTriggerEvent.SAVE_NOTE ) 
			{
				this.note = event.note; 
				//this.note.title = e.data.tempTitle; 
				if ( this.note.tags == null ) 
				{
					throw ( ' need tags to be set first' ) 
				}
				//this.note.tags = this.ui.edit.editor.listTags.tags
				this.note.tagNames = []
				this.note.tagGuids = []
				for each ( var tag :   Tag2 in this.note.tags  )
				{
					//if ( guid != tag.guid ) 
					//	noteCopy.tagGuids.push( guid ) 
					this.note.tagGuids.push( tag.guid )
				}		
				var xml : XML = TextConverter.export(  event.tf ,  
					TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE ) as XML//..toString()
			/*	if ( e.data.hasOwnProperty('save') && e.data.save == false ) 
					return; 
				*/
				this.dispatch( new EvernoteToTextflowCommandTriggerEvent( 
					EvernoteToTextflowCommandTriggerEvent.EXPORT, 
					xml.children().toXMLString(),
					onNoteContentConverted ) )				
			}
		}
		
		
		private function onNoteContentConverted(str: String):void
		{
			//var note_ : Note = e.data as Note
			this.note.content = str
			var tempSaveNote : Note2 = new Note2()
			tempSaveNote.guid = this.note.guid
			tempSaveNote.content = str; 
			tempSaveNote.active = true; 
			tempSaveNote.title = this.note.titleOrTempTitle()
			if ( this.note.newNote() )
			{ 
				this.createdNew = true
				this.dispatch(   EvernoteAPICommandTriggerEvent.CreateNote( tempSaveNote,
					onNoteSaved, onNoteSavedFault  ) )				
			}
			else
			{
				this.dispatch(   EvernoteAPICommandTriggerEvent.UpdateNote( tempSaveNote,
				onNoteSaved, onNoteSavedFault  ) )
			}
		}				
		
		
		private function onNoteSaved( o:Object):void
		{

			if ( this.createdNew ) 
			{
				var oldContent : String = this.note.content
				//remove temp content....
				this.apiModel.clone(  this.note, o )				
				this.apiModel.addNote(this.note) 
				this.note.content = oldContent; 
			}
			else
			{
				this.note.title = this.note.titleOrTempTitle()
			}
			this.note.tempContent = ''; this.note.tempTitle = ''; 
			updatedNote()
			if ( this.event.fxResult != null ) this.event.fxResult(null); //send note , or token? 
			return;
		}					
		private function onNoteSavedFault( o:Object):void
		{
			this.dispatch( new   ShowAlertMessageTriggerEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 'Could not save note') )  
			//ui.currentState = StateView;
			return;
		}				
		
		
		
		/**
		 * Notifies lists that note has changed
		 * */
		private function updatedNote() : void
		{
			this.note.noteUpdated() 
			this.note.tagsUpdated()
		}		
		
		
	 
 
	}
}