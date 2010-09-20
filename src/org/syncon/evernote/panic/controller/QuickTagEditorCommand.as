package  org.syncon.evernote.basic.controller
{
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
 
		public var base : QuickTagEditorCommand_base = new QuickTagEditorCommand_base(); 
		
		override public function execute():void
		{
		 	
			if ( event.type == QuickTagEditorCommandTriggerEvent.GET_TAGS ) 
			{
				this.dispatch( EvernoteAPICommandTriggerEvent.ListTags( this.onListTags ) ); //( filter , false, onGetTrashCounts) ) 
			}				
			if ( event.type == QuickTagEditorCommandTriggerEvent.PROCESS_TAGS ) 
			{
				this.base.dispatchEvent = this.dispatch; 
				base.fxDone = event.fxSuccess
				var output : Array  = this.base.onProcess(event.instructions, event.tags, true )
			}		
			if ( event.type == QuickTagEditorCommandTriggerEvent.DELETE_ALL_TAGS ) 
			{
				for each ( var tag_ : Tag2 in this.event.tags )
				{
					this.dispatch( EvernoteAPICommandTriggerEvent.ExpungeTag( tag_.guid ) )
				 }
			}					
			 
			
				
		}
 
	 
		public function onListTags( tags : Array ) : void
		{
			tags = this.apiModel.convert( tags, Tag2 ) 
			event.fxSuccess( tags ) 
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
			commandMap.mapEvent(QuickTagEditorCommandTriggerEvent.DELETE_ALL_TAGS, 
				QuickTagEditorCommand, QuickTagEditorCommandTriggerEvent, false );					
		}
		 
			
	}
}