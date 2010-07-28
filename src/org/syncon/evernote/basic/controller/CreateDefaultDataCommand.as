package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	
	public class CreateDefaultDataCommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		
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
			this.dispatch(  EvernoteAPICommandTriggerEvent.FindNotes( null, 1 ) ) ;
			import flash.utils.setTimeout; 
			//setTimeout( this.authenticate, 1000 ) 
			this.authenticate()
		}
		
		private function authenticate()  : void
		{
			this.dispatch( EvernoteAPICommandTriggerEvent.Authenticate('brthrmnss', '12121212' ) )
		}
		
		public function createStartData() : void
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