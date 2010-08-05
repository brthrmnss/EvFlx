package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.notestore.NoteCollectionCounts;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.services.EvernoteService;

	/**
	 * Test quing of unauthenticated commands 
	 * test defreserencing
	 * 
	 * */
	public class EvernoteAPIHelperCommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var service: EvernoteService;
		[Inject] public var event:EvernoteAPIHelperCommandTriggerEvent;
		private var seqId : int = -1
		private var timerTimeout : Timer = new Timer(3000)
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryCount : int = 0 ;
 
		override public function execute():void
		{
		 	
			if ( event.type == EvernoteAPIHelperCommandTriggerEvent.GET_TRASH_ITEMS ) 
			{
				var filter : NoteFilter = new NoteFilter(); //this.service.createNoteFilter( );//0, false, null, null, null, true )
				filter.inactive = true
				this.dispatch( EvernoteAPICommandTriggerEvent.FindNoteCounts( filter , false, onGetTrashCounts) ) 
				//EvernoteAPICommandResultEvent.FIND_NOTES
				this.contextView.addEventListener( EvernoteAPICommandResultEvent.FIND_NOTES, haveNotes ) 
				//this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTH_GET, this.authenticateResultHandler )
				//this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTH_GET_FAULT, this.authenticateFaultHandler )
			}				
				
		}
 
		private function onGetTrashCounts(e: NoteCollectionCounts )  : void
		{
			
			var size : int =0  ; 
			var dict : Dictionary = e.notebookCounts
			for ( var index : Object in dict ) 
			{
				size+=dict[index] 
			}
			/*if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()		*/	
			this.apiModel.trashCount = size;
			return;
		}				
		
		private function haveNotes(e:EvernoteAPICommandResultEvent)  : void
		{
			/*if ( seqId != this.service.getSequenceNumber()) return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data);
			
			this.deReference()		*/	
			return;
		}		
		private function emailNoteFaultHandler(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber()) return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data);
			this.onFault(); this.deReference()
		}		
		
		
		
		private function onTimeout(e:TimerEvent)  : void
		{
			this.deReference()
			this.onFault()
		}
				
		
		private function onFault() : void
		{
			var msg : String = 'Error 8332: '+event.type+' call failed';
			if ( debug ) 
			{
				
			}
			if ( event.alert ) 
			{
				var ee : Alert
				Alert.show( msg , 'Error...' )
			}
		}
		
		/**
		 * Clean up event handlers
		 * */
		private function deReference() : void
		{
			this.timerTimeout.removeEventListener(TimerEvent.TIMER, this.onTimeout ) 
			//event.dereference()
				
			if ( event.type == EvernoteAPICommandTriggerEvent.AUTHENTICATE ) 
			{
				//this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTH_GET, this.authenticateResultHandler )
				//this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.AUTH_GET_FAULT, this.authenticateFaultHandler )
			}		
				
		}
		
		/**
		 * Maps user store commands 
		 * */
		static public function mapCommands(commandMap :  Object) : void
		{
			commandMap.mapEvent(EvernoteAPIHelperCommandTriggerEvent.GET_TRASH_ITEMS, EvernoteAPIHelperCommand, EvernoteAPIHelperCommandTriggerEvent, false );			
  
		}
			
	}
}