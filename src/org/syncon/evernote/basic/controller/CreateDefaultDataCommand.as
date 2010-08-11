package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.vo.PreferencesVO;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.services.EvernoteService;
	
	public class CreateDefaultDataCommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var serivce:EvernoteService;
		[Inject] public var event: Event;
		static public var START : String = 'CreateDefaultDataCommand.START'
		static public var LIVE_DATA : String = 'CreateDefaultDataCommand.LIVE_DATA'
		override public function execute():void
		{
			if ( event.type == START ) 
			{
				this.createStartData()				
			}
			if ( event.type == LIVE_DATA ) 
			{
				this.liveData()
			}
		}
		
		public function liveData() : void
		{
			//this.dispatch( EvernoteAPICommandTriggerEvent.Authenticate('brthrmnss', '234d' , null, null, true) ) 
			//this.dispatch( EvernoteAPICommandTriggerEvent.Authenticate('brthrmnss', '12121212' ) )
			this.dispatch(  EvernoteAPICommandTriggerEvent.ListTags(this.onListTags )  ) ;		
			this.dispatch(  EvernoteAPICommandTriggerEvent.ListNotebooks( this.onListNotebooks ) ) ;		
			
			//this.serivce.eventDispatcher.addEventListener( EvernoteServiceEvent.LIST_TAGS, this.onListTags ) 
				
			//this.dispatch(  EvernoteAPICommandTriggerEvent.AUTHENTICATE( this. null ) ) ;					
			//this.dispatch(  EvernoteAPICommandTriggerEvent.ListTagsByNotebook( this. null ) ) ;			
			this.dispatch(  EvernoteAPIHelperCommandTriggerEvent.GetTrash( ) ) ;	
			
			import flash.utils.setTimeout; 
			//setTimeout( this.authenticate, 1000 ) 
			this.authenticate()
		}
		
		public function onListTags(e: Object=null):void
		{
			this.recievedTags = true; 
			this.dispatch(  EvernoteAPICommandTriggerEvent.FindNotes( null, 0 ) ) ;
			
			if ( recievedTags && recievedNotebooks  ) 	
			{
				this.dispatch(  EvernoteAPIHelperCommandTriggerEvent.GetNotebookNoteCounts( )) ;		
				return;
			}			
			return; 	
		}
		
		private var recievedTags : Boolean = false; 		
		private var recievedNotebooks : Boolean = false; 
		
		
		/**
		 * when recieve notes, update their count; if both tags have been retreived
		 * */
		private function onListNotebooks(e: Array):void
		{
			this.recievedNotebooks = true; 
			if ( recievedTags && recievedNotebooks  ) 	
			{
				this.dispatch(  EvernoteAPIHelperCommandTriggerEvent.GetNotebookNoteCounts( )) ;		
				return;
			}
		}
		
		private function authenticate()  : void
		{
			var pref : PreferencesVO = new PreferencesVO()
			pref.username = 'brthrmnss' 
			pref.password = '12121212'; 
			//this.apiModel.login(); 
			this.dispatch( EvernoteAPICommandTriggerEvent.Authenticate('brthrmnss', '12121212' ) )
		}
		
		public function createStartData() : void
		{
			var notes : Array = []; 
			var note :  Note2 = new Note2()
			note.title = 'Note 1' 
			note.tagNames = ['.log', 'work', 'Tag3']
			note.createdAt = this.newDate( '04/05/1992' )
			note.updatedAt = this.newDate( '09/05/2005' )
			notes.push( note ); note = new Note2(); 
			note.title = 'Note 2' 
			note.tagNames = ['job', 'Tag2', 'Tag3']
			note.createdAt = this.newDate( '04/05/1992' )
			note.updatedAt = this.newDate( '09/05/2005' )
			notes.push( note ); note = new Note2(); 	
			note.title = 'Note 3' 
			note.tagNames = ['amazon', 'Tag2', 'Tag3']
			note.createdAt = this.newDate( '04/05/1992' )
			note.updatedAt = this.newDate( '09/05/2005' )		
			notes.push( note ); note = new Note2(); 
			this.apiModel.loadNotes( notes ) 
				
			var notebooks : Array = []
			var notebook : Notebook = new Notebook() 
			notebook.name = 'Inbox'
			notebook.defaultNotebook = true
			notebook.guid = 'n1'
			notebooks.push( notebook ) ; 
			notebook = new Notebook();
			notebook.name = 'Leger'
			notebook.defaultNotebook = false; 
			notebook.guid = 'n2'
			notebooks.push( notebook ) ; 
			
			this.apiModel.loadNotebooks( notebooks )
				
				

			var tags : Array = 	this.createSets(   Tag, ['name', 'guid'], 
				['.log, work, job, tobuy, amazon', 't1, t2, t3, t4, t5'] )
				//var t : Tag 
				
			this.apiModel.loadTags( tags ) 
		}
		
		private function createSets( ofClass_  : Class, props : Array, values : Array )  :  Array
		{
			var set : Array = [] 
			
			var propItems :  Array = [] ; 
			for ( var i : int = 0; i < values.length ; i++ )
			{
				propItems[i] = values[i].split(', ')
			}			
			var make : int = propItems[0].length;
			var cf : ClassFactory = new ClassFactory(ofClass_)
			for (  i  = 0; i < make ; i++ )
			{
				var obj : Object = cf.newInstance()
				for ( var j : int = 0; j < props.length ; j++ )
				{
					obj[props[j]] =  propItems[j][i]  
				}		
				set.push( obj ) 
			}
			
			return set; 
		}
		
		private function  newDate( str :String )  : Date
		{
			var newDate : Date = DateField.stringToDate( str, 'MM/DD/YYYY' ) 
			return newDate;
		}
		
	}
}