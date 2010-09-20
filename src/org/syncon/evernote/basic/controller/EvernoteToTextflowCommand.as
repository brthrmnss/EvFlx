package  org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;

	/**
	 * */
	public class EvernoteToTextflowCommand extends Command
	{
		//[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var event:EvernoteToTextflowCommandTriggerEvent;
		 public var txt :  String = '' 
		override public function execute():void
		{
			var txt_  : String = this.event.txt
			var drg : EvernoteToTextflowCommand_Base = new EvernoteToTextflowCommand_Base();
			drg.event = event
				event.debug = true; 
			//	drg.dispatchX = this.dispatch; 
				if ( this.dispatch == null || this.event.debug ) 
				{
					drg.execute();
					return;
				}
			try 
				
			{
				drg.execute();
			}
			catch ( e : Error ) 
			{
				var msg : String = 'Could not load the message '
				if ( event.type == EvernoteToTextflowCommandTriggerEvent.EXPORT) 
				{
					msg = 'Could not export that message, try the web client instead'
				}
				var evt : ShowAlertMessageTriggerEvent = new ShowAlertMessageTriggerEvent( 
					ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 
					msg, 'Alert' ) 
				this.dispatch( evt )  
				return ; 
			}				
			
			/*if ( event.type == EvernoteToTextflowCommandTriggerEvent.IMPORT ) 
				this.importEvernoteXML()
			else
				this.exportTextflow()  */
		}
 
	}
}