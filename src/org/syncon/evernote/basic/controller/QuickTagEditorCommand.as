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
	public class QuickTagEditorCommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var event:QuickTagEditorCommandTriggerEvent;
		private var seqId : int = -1
		private var timerTimeout : Timer = new Timer(3000)
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		private var notAuthenticatedRetryTimer : Timer;
		private var retryCount : int = 0 ;
 
		override public function execute():void
		{
		 	
			if ( event.type == QuickTagEditorCommandTriggerEvent.GET_TAGS ) 
			{
				this.dispatch( EvernoteAPICommandTriggerEvent.ListTags( this.onListTags ) ); //( filter , false, onGetTrashCounts) ) 
			}				
			if ( event.type == QuickTagEditorCommandTriggerEvent.PROCESS_TAGS ) 
			{
				 this.processTags()
			}		
			
			 
			
				
		}
 
		private function onListTags(e: NoteCollectionCounts )  : void
		{
			 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e);
			return;
		}				
 
		private function processTags( ) : void
		{
			//if ( this.event.fxSuccess != null ) this.event.fxSuccess(e);
			return;
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
			commandMap.mapEvent(QuickTagEditorCommandTriggerEvent.GET_TAGS, 
				QuickTagEditorCommand, QuickTagEditorCommandTriggerEvent, false );			
			commandMap.mapEvent(QuickTagEditorCommandTriggerEvent.PROCESS_TAGS, 
				QuickTagEditorCommand, QuickTagEditorCommandTriggerEvent, false );		
			
		}
		 
			
	}
}