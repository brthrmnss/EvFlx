package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteList;
	import com.evernote.edam.type.Note;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.editor.utils.EditorUtils;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Notebook2;
	import org.syncon.evernote.model.Tag2;
	import org.syncon.evernote.services.EvernoteService;

	/**
	 * Test quing of unauthenticated commands 
	 * test defreserencing
	 * 
	 * needs to call success fx on events ... 
	 * 
	 * */
	public class EditorTestCommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var event:EditorTestCommandTriggerEvent;
		private var seqId : int = -1
		private var timerTimeout : Timer = new Timer(3000)
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryCount : int = 0 ;
		
		private var note :  Note; 
		
 		/*	
		public var base : QuickTagEditorCommand_base = new QuickTagEditorCommand_base(); 
		*/
		override public function execute():void
		{
		 	
			if ( event.type == EditorTestCommandTriggerEvent.EXPORT_NOTE ) 
			{
			
				/**
				 * Find note with name
				 * else create it
				 * save contents 
				 * return link 
				 * */
				var nf : NoteFilter = new NoteFilter()
				nf.words = this.noteName()
				this.dispatch(  EvernoteAPICommandTriggerEvent.FindNotes(
					nf , 0, 0, step2, step1_Fault ) ) 
			}
			 
			
				
		}
 
	 public function step1_Fault(e:Object):void
	 {
		 
	 }
		
	 public function step2(e: NoteList):void
	 {
		 if ( e.notes.length == 0 ) 
		 {
			 this.step3()
		 }
		 else
		 {
			 this.note = e.notes[0]
			 this.step4(null)
		 }
	 }
	 
	 public function step2_Fault(e:Object):void
	 {
		 
	 }	 
		
	 
	 public function step3( ):void
	 {
		 var newNote : Note2 = this.apiModel.createNewNote(); 
		newNote.title = this.noteName()
		newNote.content = EditorUtils.blankNoteContent
		this.dispatch(  EvernoteAPICommandTriggerEvent.CreateNote( newNote, 
			this.step4, this.step3_Fault )  )
		
	 }
	 
	 public function step3_Fault(e:Object):void
	 {
		 
	 }	 
	 
	 
	 public function step4(e:Object):void
	 {
		 //if was called from function save note ... or guid 
		 if ( e is Note ) 
			 this.note = e as Note
				 
		this.note.content = event.contents
		var ee : Note2 = Note2.convertNote( this.note ) 
		this.dispatch(  EvernoteAPICommandTriggerEvent.UpdateNote( ee, 
			 this.step5, this.step4_Fault )  )
	 }
	 
	 public function step4_Fault(e:Object):void
	 {
		 Alert.show( e.parameter )
	 }	 
	 
	 public function step5(e:Object):void
	 {
		 //http://sandbox.evernote.com/Home.action?login=true#v=t&n=9ff9e5f6-1a91-471a-8672-57ca707c3be7&b=fc8447d1-17af-45e7-a12b-90b6bc7e3429
		 event.url = 'http://'+this.note.guid;
		 event.url = 'http://sandbox.evernote.com/Home.action?login=true#v=t&n='+this.note.guid;
		event.fxSuccess( event ) 
	 }	 
 
	 
	 
		public function onListTags( tags : Array ) : void
		{
			tags = this.apiModel.convert( tags, Tag2 ) 
			event.fxSuccess( tags ) 
		}
		
		public function noteName() :  String
		{
			return 'export_editor_'+event.index.toString()
		}
			
		
		/**
		 * Maps user store commands 
		 * */
		static public function mapCommands(commandMap :  Object) : void
		{
			commandMap.mapEvent(EditorTestCommandTriggerEvent.EXPORT_NOTE, 
				EditorTestCommand, EditorTestCommandTriggerEvent, false );			
		 				
		}
		 
			
	}
}