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
	
	public class ImportBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var apiModel:EvernoteAPIModel;		
		[Inject] public var event:  ImportBoardCommandTriggerEvent;
		override public function execute():void
		{
			if ( event.type == ImportBoardCommandTriggerEvent.IMPORT_BOARD )
			{
				this.importFromString()
			}
			if ( event.type == ImportBoardCommandTriggerEvent.LOAD_BOARD )
			{
				this.importFromServer()	
			}
			if ( event.type == ImportBoardCommandTriggerEvent.IMPORT_FROM_GUID_BOARD )
			{
				this.findNote( event.data as Note ) ; ///()	
			} 
			if ( event.type == ImportBoardCommandTriggerEvent.UPDATE_PEOPLE_AND_PROJECTS ) 
			{
				if ( event.data != null ) 
				{
					this.model.board.compare( event.data as BoardVO ) 
					//refresh people only ... 
				}
				else
				{
					event.boardName = this.model.board.name;
					importFromServer()
				}
			}
		}
		
		public function importFromString () : void
		{
			if ( event.data is   String ) {}
			var info : String =  event.data.toString()

			var json :   Object = JSON.decode( info ) 
			
			var b : BoardVO = new BoardVO()
			var people : Array = [];
			for each ( var obj :   Object in json.people )
			{
				var person :  PersonVO = new PersonVO()
				person.importX( obj ) 
				people.push( person )				 
			}
			b.people = people
			var projects : Array = []; 
			for each (   obj   in json.projects )
			{
				var project : ProjectVO = new ProjectVO()
				project.importX( obj ) 
				projects.push( project )
			}					 
			b.projects = projects  
			
			
			b.importX( json.board ); 
			if ( event.fxComplete != null ) 
			{
				try {
				this.event.fxComplete( b  ) ;
				}
				catch ( e : Error ) 
				{
					if ( this.event.sendTo != null ) 
					{
						//var objToCall :  Object = this.event.sendTo[0]
						//var fx :   Function = objToCall[ this.event.sendTo[1] ]
						//fx.call(objToCall,  b,b )
					}
					trace( " could not call the function again" )
				}
				//event.fxComplete.call( this  ) 
				//this.event.fxComplete.apply( this, [ b]  ) ; 
				return;  
			}
			if ( event.compareBoards == false )
			{
				this.model.boardLoaded = true; 
				this.model.board = b; 
				//this.model.currentBoardJSON = json; 
				this.model.currentBoardLayoutJson = json.board.layout
				this.model.refreshBoard(); 
				/*if ( event.goIntoAdmin ) 
					this.model.adminMode = true; */
				//set manually so all listeners will hear
				this.model.adminMode  = event.goIntoAdmin
			}
			else
			{
				this.model.board.compare( b ) ; 
				//something ...
			}
		}
		
		public function importFromServer() : void
		{
			//find note with that name
			//get contents
			//return contents in 
			//if contents nil, use default board, display alert
			
			var nf :  NoteFilter = new NoteFilter()
			nf.words = this.noteTitle()
			this.dispatch(  EvernoteAPICommandTriggerEvent.FindNotes(
				nf , 0, 0, foundNotes, step1_Fault ) ) 				
		}
		
		
		public function step1_Fault(e:Object):void
		{
			
		}		
		
		public function foundNotes(e:NoteList ) : void
		{
			if ( e.notes.length == 0 ) 
			{
				if ( event.createBoardIfNotFound) 
				{
					this.createNote()
				}
				else
				{
					this.alert( 'could not find that board' )
				}
				return;
			}
			
			var note : Note = e.notes[0] as Note
			this.findNote( note );
		}
		
		public function createNote()  : void
		{
			var note :  Note2 =  apiModel.createNewNote() 
			note.title = this.noteTitle()
			note.content = this.apiModel.wrapContent( '' ) 
			this.dispatch( 
			EvernoteAPICommandTriggerEvent.CreateNote( note, noteMade, noteNoteMade ) 
				)
		}
			public function noteNoteMade(e:Object):void
			{
				this.alert('could not create new board layout');
			}	 
			public function noteMade(e: Note):void
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
		
		public function step4_Fault(e:Object):void
		{
			this.alert( e.parameter )
			if ( event.fxFault != null ) this.event.fxFault(   ) ; 
		}	 
		
		public function noteContents(s : String ) : void
		{
			var str : String = s; 
			if ( str == '' ) 
			{
				this.alert('board was empty...'); 
				str = this.model.defaultBoardImportString
			}
			
			str
			if ( str.indexOf( '&quot;') != -1 ) 
			{
				var searchPattern:RegExp = new RegExp('&quot;', "gi");        
				str = str.replace(searchPattern, '"')
			}	
			  searchPattern  = new RegExp('\n', "gi");        
			str = str.replace(searchPattern, '"')			
	
			str =  this.apiModel.unwrapContent( str )
				//remove anything before / after
			var split : Array = str.split('{')
			str = '{'+split.slice(1,split.length).join('{')
			split  = str.split('}')
			str = split.slice(0,split.length-1).join('}')		+'}'		
				
			if ( event.fxComplete != null ) 
			{
				event.output_BoardString = str; 
				this.event.fxComplete( event  ) ; 
				//return; 
			}
			if ( event.loadIntoModel ) 
			{
				this.dispatch( 
				new ImportBoardCommandTriggerEvent(
					ImportBoardCommandTriggerEvent.IMPORT_BOARD,str, null, event.goIntoAdmin, event.compareBoards   ) 
				)
			}
			
		}
		
		
		public function alert(s : String )  : void
		{
			
		}
		
		private function noteTitle( ) :   String
		{
			return this.model.createBoardTitle(   event.boardName )
		}
		
	}
}