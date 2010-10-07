package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteList;
	import com.evernote.edam.type.Note;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	
	public class CreateBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var apiModel:EvernoteAPIModel;		
		[Inject] public var event:  CreateBoardCommandTriggerEvent;
		override public function execute():void
		{
			if ( event.type == CreateBoardCommandTriggerEvent.CREATE_BOARD )
			{
				this.tryToFindDuplicateName()
			}
		}
		
		 
		public function tryToFindDuplicateName() : void
		{
			var nf :  NoteFilter = new NoteFilter()
			nf.words = this.noteTitle()
			this.dispatch(  EvernoteAPICommandTriggerEvent.FindNotes(
				nf , 0, 0, foundNotes, step1_Fault ) ) 				
		}
			private function step1_Fault(e:Object):void
			{
			}		
			
			private function foundNotes(e:NoteList ) : void
			{
				if ( e.notes.length == 0 ) 
				{
					this.alert( 'success: could not find that board' )
					this.step2_createNote()
					return;
				}
				if ( this.event.fxFault != null ) 
					this.event.fxFault('similiar name exists, quitting')				
			}
		
		private function step2_createNote()  : void
		{
			var note :  Note2 =  apiModel.createNewNote() 
			note.title = this.noteTitle()
			note.content = this.apiModel.wrapContent( '' ) 
			this.dispatch( 
			EvernoteAPICommandTriggerEvent.CreateNote( note, noteMade, noteNoteMade ) 
				)
		}
			private function noteNoteMade(e:Object):void
			{
				this.alert('could not create new board layout');
				if ( this.event.fxFault != null ) 
				this.event.fxFault('could not create new board layout')
			}	 
			private function noteMade(e: Note):void
			{
				this.findNote(e)
			}
			
		
		
		public function findNote ( n : Note ) : void
		{
			var note :   Note2 = this.apiModel.createNewNote()
			note.content = n.content ; 
			note.title = n.title
			note.guid = n.guid
			
			this.model.configNote = note
			this.dispatch(  
				EvernoteAPICommandTriggerEvent.GetNoteContent( n.guid,
				this.noteContents, this.step4_Fault )  
			)	
		}
			private function step4_Fault(e:Object):void
			{
				this.alert( e.parameter )
			}	 
			/**
			 * Load and then save board
			 * */
			private function noteContents(s : String ) : void
			{
				this.model.board = event.board; 
				this.model.refreshBoard(); 
				if ( event.goIntoAdmin ) 
					this.model.adminMode = true; 
				
				this.event.fxComplete()
				import flash.utils.setTimeout
				setTimeout( this.model.saveBoard , 2000   ) 
				
			}
			
		
		public function alert(s : String )  : void
		{
			trace( s )
		}
		
		private function noteTitle( ) :   String
		{
			return this.model.createBoardTitle(   event.board.name )
		}
		
	}
}