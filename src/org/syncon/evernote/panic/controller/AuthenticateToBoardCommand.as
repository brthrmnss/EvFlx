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
				if ( this.event.password != '' && this.event.password != null  ) 
				nf.words += ' board_password:'+this.event.password
			}
			else
			{
				if ( this.event.password != '' && this.event.password != null  ) 
				nf.words += ' board_admin_password:'+this.event.password			
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
		
		

			
			public function foundNotes(e: NoteList ) : void
			{
				if ( e.notes.length == 0 ) 
				{
				//	this.alert( 'could not find that board' )
					if ( this.event.fxFault != null ) this.event.fxFault(null)
					return;
				}
				
				var note : Note = e.notes[0] as Note
			//	this.findNote( note );
				
				if ( this.event.fxComplete != null ) this.event.fxComplete(note)
					
				this.dispatch( new ImportBoardCommandTriggerEvent( 
					ImportBoardCommandTriggerEvent.IMPORT_FROM_GUID_BOARD, note, null, true ))		
			}
			
			
			public function step1_Fault(e:Object):void
			{
				if ( this.event.fxFault != null ) this.event.fxFault()
			}					
		
		
		
		private function rand( items :  Array ) : Object
		{
			var index : int = Math.round( Math.random()*items.length)
			if ( index == items.length ) 
				index -= 1
					
			return items[index]; 
		}
		
		private function randSet(  max :  int , min : int , items :  Array, returnProp : String = '' ) :  Array
		{
			var ret : Array = []; 
			for ( var i : int = 0 ; ret.length < max; i++ )
			{
				var item : Object = rand( items ) 
				if ( returnProp != '' ) 
					item = item[returnProp] 
				if ( ret.indexOf( item ) != -1 ) 
					continue; 
				ret.push( item ) 
			}
			/*if ( min != 0 ) 
			{*/
				var endIndex : int = Math.max( min, Math.round( Math.random()*max ) ) 
				ret = ret.slice( 0,	endIndex ) 
			/*}*/
			return ret;
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
		
	}
}