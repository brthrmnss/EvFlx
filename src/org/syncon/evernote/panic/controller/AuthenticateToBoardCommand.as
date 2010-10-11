package   org.syncon.evernote.panic.controller
{
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteList;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.vo.PreferencesVO;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.test.context.utils.MD5Helper;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.view.ProjectListWidget;
	import org.syncon.evernote.panic.view.TwitterScrollerTest2;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.evernote.services.EvernoteService;
	
	public class AuthenticateToBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var apiModel:EvernoteAPIModel;		
		[Inject] public var event:   AuthenticateToBoardCommandTriggerEvent;
		override public function execute():void
		{
			if ( event.type == AuthenticateToBoardCommandTriggerEvent.METH1 ) 
			{
				this.meth1()				
			}
			if ( event.type == AuthenticateToBoardCommandTriggerEvent.METH2 ) 
			{
				this.liveData()
			}
		 
		}
		
		import flash.utils.setTimeout
		
			public function onGoToEditMode()  : void
			{
				this.model.editMode = true; 
			}
		
		public function meth1() : void
		{
			
			var nf :  NoteFilter = new NoteFilter()
			nf.words = '' 
			//nf.words = this.model.createBoardTitle( this.model.
			if ( this.event.boardName != '' ) 
				nf.words += '"name":"'+this.event.boardName+'"'
				//comebin into 1 string .... 
			if ( this.event.username != '' && this.event.username != null  ) 
			{
				nf.words += '"username":"'+this.event.boardName+'"'
				if ( this.event.password != '' && this.event.password != null  ) 
					nf.words += '"password":"'+this.event.password+'"'					
			}
			if ( this.event.admin == false ) 
			{
				//pass is required for admin mode 
				/*if ( this.event.password != '' && this.event.password != null  ) 
				{*/
					//nf.words += ' board_password:'+this.event.password
					var ee : MD5Helper
					nf.words += ' '+'"board_password":"'+MD5Helper.toHashSearch(this.event.password) + '*'
				/*}*/
			}
			else
			{
				if ( this.event.password != '' && this.event.password != null  ) 
				{
					//nf.words += ' board_admin_password:'+this.event.password			
					nf.words += ' '+'"board_admin_password":"'+MD5Helper.toHashSearch(this.event.password) + '*'
				}
			}
					/*	
			if ( this.event.mode == METH1 ) 
			{
				nf.words = '' 
				if ( this.event.password != '' && this.event.password != null  ) 
					nf.words += '"board_password":"'+this.event.boardName+'|'+this.event.password+'"'					
			}*/
			this.dispatch(  EvernoteAPICommandTriggerEvent.FindNotes(
				nf , 0, 0, foundNotes, step1_Fault ) ) 		
		}
		
			private function step1_Fault(e:Object):void
			{
				if ( this.event.fxFault != null ) this.event.fxFault()
			}					
			
			private function foundNotes(e: NoteList ) : void
			{
				
				if ( e.notes.length == 0 ) 
				{
				//	this.alert( 'could not find that board' )
					this.fault()
					return;
				}
				
				var note : Note = e.notes[0] as Note
				this.note = e.notes[0] as Note
				
				this.checkNoteForPasswordLiteral()
			}
			
 			public var note : Note
			
			/**
			 * limtation fo edam does not allow it to conviently search for wild cards .... 
			 * */
			
				private function  checkNoteForPasswordLiteral  ( ) : void
				{
					this.dispatch( 
						new ImportBoardCommandTriggerEvent(
							ImportBoardCommandTriggerEvent.IMPORT_FROM_GUID_BOARD,this.note,
							null, false, false, this.noteContents, 
						this.failedToLoadNoteContents, false ) 
					)					
 
					
				}
			
				private function failedToLoadNoteContents(e:Object=null):void
				{
					this.fault(); //this.alert( e.parameter )
				}	 
				
				private function noteContents( e : ImportBoardCommandTriggerEvent ) : void
				{
					var str : String =e.output_BoardString;
					if ( str == '' ) 
					{
						this.alert('board was empty...'); 
						this.fault();
					}
					
					var s : String = '';
					var fault : Boolean = false; 
					//make sure that exact phrase was foun d
					if ( this.event.username != '' && this.event.username != null  ) 
					{
						s =  '"name":"'+this.event.boardName+'"' 
						if ( str.indexOf(s) == -1 ) 
							fault = true
						if ( this.event.password != '' && this.event.password != null  ) 
						{
							 s = '"password":"'+this.event.password+'"'		
							if ( str.indexOf( s ) == -1 )
								fault  = true
						}
					}
					if ( this.event.admin == false ) 
					{
						s = '"board_password":"'+MD5Helper.toHashSearch(this.event.password)  
						if ( str.indexOf( s ) == -1 )
							fault  = true							
					}
					else
					{
						if ( this.event.password != '' && this.event.password != null  ) 
						{
							s = '"board_admin_password":"'+MD5Helper.toHashSearch(this.event.password) 
							if ( str.indexOf( s ) == -1 )
								fault  = true										
						}
					}
										
					
					if ( fault ) 
					{
						 this.alert( 'did not pass vertification' )
						if ( this.event.fxFault != null ) this.event.fxFault(null)
						return;
					}
					
					if ( this.event.fxComplete != null ) this.event.fxComplete(note)
					
						//should probably just use the string here
					this.dispatch( new ImportBoardCommandTriggerEvent( 
						ImportBoardCommandTriggerEvent.IMPORT_FROM_GUID_BOARD, note, null, this.event.admin ))						
				}
 
	 
		public function liveData() : void
		{
			var ee : EvernoteAPIModel
			this.authenticate()
			EvernoteAPIModel.EvernoteUrl = 'sandbox.evernote.com';
			EvernoteService.edamBaseUrl = "https://sandbox.evernote.com";
			
			this.model.boardName = 'mercy';
			var eed  :  ImportBoardCommandTriggerEvent
			this.dispatch( new ImportBoardCommandTriggerEvent( 
				ImportBoardCommandTriggerEvent.LOAD_BOARD, null, 'mercy' ))		
		}
		
		private function authenticate()  : void
		{
			this.dispatch( EvernoteAPICommandTriggerEvent.Authenticate('brthrmnss', '12121212' ) )
		}
		
		
		
		public function alert(s : String )  : void
		{
			trace( 'Authenticate To Board Command failed: ' + s );  
		}
		
		
		private function fault() : void
		{
			if ( this.event.fxFault != null ) this.event.fxFault(null)
		}		
		
	}
}