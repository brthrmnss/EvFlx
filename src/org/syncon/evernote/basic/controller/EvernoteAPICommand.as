package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.services.EvernoteService;
	
	public class EvernoteAPICommand extends Command
	{
		[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var service: EvernoteService;
		[Inject] public var event:EvernoteAPICommandTriggerEvent;
		private var seqId : int = -1
		private var timerTimeout : Timer = new Timer(300)
		private var debug : Boolean = true
		private var alert : Boolean = false; 
		
		override public function execute():void
		{
			this.seqId = this.service.incrementSequence()
			//functionSuccess = event.fxSuccess
			//functionFault = event.fxFault; 
			this.timerTimeout.addEventListener(TimerEvent.TIMER, this.onTimeout ) 
			if ( event.type == EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK_TRIGGER ) 
			{
				this.service.createLinkedNotebook( null )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK, this.onCreatedNotebook )
				this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK_FAULT, this.onCreateLinkedNotebookFault )
			}
		}

		private function onCreatedNotebook(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber())
					return; 
			if ( this.event.fxSuccess != null ) this.event.fxSuccess(e.data)
			//this.model.x = e.data
			this.deReference()			
		}		
		
		private function onCreateLinkedNotebookFault(e:EvernoteServiceEvent)  : void
		{
			if ( seqId != this.service.getSequenceNumber())
				return; 			
			if ( this.event.fxFault != null ) this.event.fxFault(e.data)
			this.onFault()
			this.deReference()
		}

		private function onTimeout(e:TimerEvent)  : void
		{
			this.deReference()
			this.onFault()
		}
				
		
		private function onFault() : void
		{
			var msg : String = 'Error 8332:'+event.type+' call failed';
			if ( debug ) 
			{
				
			}
			if ( alert ) 
			{
				
			}
		}
		
		/**
		 * Clean up event handlers
		 * */
		private function deReference() : void
		{
			this.timerTimeout.removeEventListener(TimerEvent.TIMER, this.onTimeout ) 
			//event.dereference()
			if ( event.type == EvernoteAPICommandTriggerEvent.SHOW_POPUP ) 
			{
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK, this.onCreatedNotebook )
				this.service.eventDispatcher.removeEventListener( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK_FAULT, this.onCreateLinkedNotebookFault )
			}				
		}
		
		/**Function that can create a command event from strict params**/
		public function createLinkedNotebook( args  : Array, fxSuccess : Function=null,
											  fxFault : Function=null, alert:Boolean=false, alertMessage : String = ''  ) : void
		{
			this.dispatch( EvernoteAPICommandTriggerEvent.CreateLinkedNotebook( null ) )
		}

		
	}
}