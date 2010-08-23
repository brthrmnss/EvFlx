package  org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Notebook2;
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
					this.note.tagNames.push( tag.name ) 
				}		
				var dbg : Array = [ this.note.tagGuids.join(', ' ) ]
				var xml : XML = TextConverter.export(  event.tf ,  
					TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE ) as XML//..toString()
			/*	if ( e.data.hasOwnProperty('save') && e.data.save == false ) 
					return; 
				*/
				this.dispatch( new EvernoteToTextflowCommandTriggerEvent( 
					EvernoteToTextflowCommandTriggerEvent.EXPORT, 
					xml.toXMLString(),
					onNoteContentConverted ) )				
			}
			if ( event.type == SaveNoteCommandTriggerEvent.SAVE_NOTE_CHANGE_NOTEBOOK ) 
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
				for each (   tag  in this.note.tags  )
				{
					//if ( guid != tag.guid ) 
					//	noteCopy.tagGuids.push( guid ) 
					this.note.tagGuids.push( tag.guid )
				}		
				
				this.onNoteContentConverted( this.note.content ); 
			}
						
		}
		
		
		private function onNoteContentConverted(str: String):void
		{
			str = str.replace(new RegExp("[\n\r]","g"),"");
			//str = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml.dtd"><en-note><p><span style="color: #99cc00;">_</span></p><p><span style="color: #99cc00;">testing this</span></p><p><span style="color: #99cc00;">ho ho hoasdf...sdf</span></p><p><span style="color: #800000;">asdfasdf</span></p><p><span style="color: #3399ff;">aaaaaaaaaaaaaa</span></p></en-note>'
			//str = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><p><span style="color: #99cc00;"> </span></p><p><span style="color: #99cc00;">testing this</span></p><p><span style="color: #99cc00;">ho ho hoasdf...sdf</span></p> <p><span style="color: #99cc00;"><span style="color: #800000;">asdfasdf</span><br clear="none"/></span></p></en-note>'
			//var note_ : Note = e.data as Note
			this.note.content = str
			var tempSaveNote : Note2 = new Note2()
			tempSaveNote.guid = this.note.guid
			tempSaveNote.content = str; 
			tempSaveNote.active = true; 
			tempSaveNote.title = this.note.titleOrTempTitle()
			tempSaveNote.notebookGuid = this.note.notebookGuid; 
			tempSaveNote.tagGuids = this.note.tagGuids
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
			trace( 'saving note content ' + str )
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
			
			trace( 'note content ' + o.content )
			if ( this.event.type== SaveNoteCommandTriggerEvent.SAVE_NOTE_CHANGE_NOTEBOOK ) 
			{
				this.apiModel.changedNoteNotebook( this.note, this.event.associatedData as Notebook2 ) 
			}
			else ( this.event.type== SaveNoteCommandTriggerEvent.SAVE_NOTE  )  
			{
				this.note.tempContent = ''; this.note.tempTitle = ''; 
				updatedNote()
			}
			

			
			//tell model that this note was saved.... not even model, just plast it this is for the note list 
			//use note filter on model to figure out how to move it around
			
			if ( this.event.fxResult != null ) this.event.fxResult(this.note); //send note , or token? 
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