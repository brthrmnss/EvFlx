package org.syncon.evernote.panic.test.cases
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONEncoder;
	import com.evernote.edam.notestore.NoteCollectionCounts;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteList;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.test.context.utils.MD5Helper;
	import org.syncon.evernote.services.EvernoteService;
	
	/**
	 * make note, save mmd5 example json object
	 * try to authenticate against it 
	 * 
	 * later confuse with other password
	 * */
	public class TestPanicAuthentication
	{
		static private var service:EvernoteService;
		static private var serviceDispatcher:EventDispatcher ;
		static private var TEST_NOTE_NAME  :String = 'testBasicAuth'; 
		
		private var noteCount : int = 0; 
		private var notebooks : Array  = []
		static private var note : Note; 
		private function get note()  : Note { return TestPanicAuthentication.note} 
		[BeforeClass(async, order=1)]
		static public function login():void
		{
			serviceDispatcher = new EventDispatcher();
			service = new EvernoteService();
			service.eventDispatcher = serviceDispatcher;
			service.getAuth( 'brthrmnss', '12121212' )
			Async.proceedOnEvent( TestPanicAuthentication, serviceDispatcher, EvernoteServiceEvent.AUTH_GET, 5000 );
		}
		[BeforeClass(async,  order=2)]
		static public function getInitNote():void
		{
			Async.proceedOnEvent( TestPanicAuthentication, serviceDispatcher, 'noteReady', 25000 );
			serviceDispatcher.addEventListener( 'noteReady', 
			Async.asyncHandler(TestPanicAuthentication, doneX, 8000, null, 
			null), false, 0, true);
			 
			serviceDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTES,   handleInitialNoteFound, false, 0, true);			
			
			//this.printSequence()
			var nf : NoteFilter = new NoteFilter()
			nf.inactive = false 
			nf.words = TEST_NOTE_NAME
			service.findNotes(nf)			
		} 	
			static protected function doneX(e:Event):void
			{
				return;
			}
			static protected function handleInitialNoteFound( event:EvernoteServiceEvent, o:Object=null ):void
			{
				serviceDispatcher.removeEventListener( EvernoteServiceEvent.FIND_NOTES,   handleInitialNoteFound );//, false, 0, true);			
				
				var list : NoteList = event.data as NoteList
				if ( list.notes.length == 0 )
				{
					createInitNote()
				}
				else
				{
					note = list.notes[0] as Note
					serviceReady()
				}
				return;
			}			
		
 
		static public function createInitNote():void
		{
			/*
			Async.proceedOnEvent( TestPanicAuthentication, serviceDispatcher, EvernoteServiceEvent.CREATE_NOTE, 5000 );
			serviceDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTE, 
				Async.asyncHandler(TestPanicAuthentication, handleNoteCreated, 8000, null, 
					null), false, 0, true);
			*/
			serviceDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTE, 
				  handleNoteCreated,  false, 0, true);
			
			var contents : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
				"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">" +
				"<en-note>Here's the Evernote logo:<br/>" +
				"</en-note>";
			var note :  Note =  service.newNote( 'title', contents) 
			note.active = true; 
			note.title=TEST_NOTE_NAME
			note.created = new Date().getTime()
			note.updated = note.created
			service.createNote( note ) 
			
		} 
		static protected function handleNoteCreated( event:EvernoteServiceEvent, o:Object=null ):void
		{
			trace('parse note')
			note = event.data as Note
				
			serviceReady()
			//this.updateInitNote()
		}		
		
		static private function serviceReady() : void
		{
			serviceDispatcher.dispatchEvent( new Event('noteReady' ) ) 
		}
		
		[BeforeClass(async,  order=3)]
		static public function updateInitNote():void
		{
			Async.proceedOnEvent( TestPanicAuthentication, serviceDispatcher, EvernoteServiceEvent.UPDATE_NOTE, 5000 );
			serviceDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_NOTE, 
				Async.asyncHandler(TestPanicAuthentication, handleNoteUpdated, 8000, null, 
					null), false, 0, true);
			var l : JSONEncoder
			var ee : JSON
			var body : Object = {}
			var o : Object ={}
			o.obj = body
			body.board_password = MD5Helper.toHash('12121214')
			body.board_password2 = MD5Helper.toHash('12121212')
			
			var contents : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
				"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">" +
				"<en-note>Here's the Evernote logo:<br/>" +
				JSON.encode( o ) +
				"</en-note>";

			
			note.content = contents; 
			service.updateNote( note ) 
			
		} 
			static protected function handleNoteUpdated( event:EvernoteServiceEvent, o:Object ):void
			{
				trace('updated noted')
				//note = event.data as Note
				//this.updateInitNote()
				//serviceReady()
			}			
			
		
		 
		[AfterClass]
		static public function tearDown():void
		{
			service.deleteNote( note.guid )
			serviceDispatcher = null;
			service = null;
		}
		
		
		[Test(async, order=1)]
		public function testCountNotes():void
		{
			//this.note = TestPanicAuthentication.note
			trace('test1')
			serviceDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTES, 
				Async.asyncHandler(this, handleNoteFound, 8000, null, 
					null), false, 0, true);
			var nf : NoteFilter = new NoteFilter()
				nf.inactive = false 
			//nf.words = MD5Helper.toHashSearch('12121214')+'*'
			nf.words =  '\\"board_password\\":\\"'+MD5Helper.toHashSearch('12121214')+'*' //+"\""
			nf.words =  '"\\"board_password\\":\\"'+MD5Helper.toHashSearch('12121214')+'*"' //+"\""
			trace( 'searching for ' + nf.words )
			service.findNotes(nf)
		}
		
		protected function handleNoteFound( event:EvernoteServiceEvent, o:Object ):void
		{
			var list : NoteList = event.data as NoteList
			if ( list.notes.length == 0 ) 
			{
				trace('0')
			}
			else
			{
				trace('1')
			}
 
			return;
		}		
		
		
		[Test(async, order=3)]
		public function testCountNotes2():void
		{
			serviceDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTES, 
				Async.asyncHandler(this, handleNoteFound2, 8000, null, 
					null), false, 0, true);
			var nf : NoteFilter = new NoteFilter()
			nf.inactive = false 
			//nf.words = MD5Helper.toHashSearch('12121214')+'*'
			nf.words =  "\\\"board_password2\\\":\\\""+MD5Helper.toHashSearch('12121214')+'*' //+"\""
			trace( 'searching for ' + nf.words )
			service.findNotes(nf)
		}
		
		protected function handleNoteFound2( event:EvernoteServiceEvent, o:Object ):void
		{
			var list : NoteList = event.data as NoteList
			if ( list.notes.length == 0 ) 
			{
				trace('0')
			}
			else
			{
				trace('1')
			}
			
			return;
		}	
		/*
		
		[Test(async, order=3)]
		public function testGetNote():void
		{
			trace('test3')
			serviceDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE, 
				Async.asyncHandler(this, handleGetNote, 4000, null, 
					null), false, 0, true);
			this.printSequence()
			service.getNote(    note.guid ) 
		}
		protected function handleGetNote( event:EvernoteServiceEvent, o:Object ):void
		{
			trace('Note Got');
		}					
		
		private function printSequence() : void
		{
			(service.noteStore as Object).seqid_++;
			trace ( 'calling service id ' + (service.noteStore as Object).seqid_ );
		}*/
	}
}