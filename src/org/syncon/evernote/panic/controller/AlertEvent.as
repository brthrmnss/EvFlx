package   org.syncon.evernote.panic.controller
{
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
 
	public class AlertEvent  
	{
 
		
		static public function Alert( msg : String, title : String ) : ShowAlertMessageTriggerEvent
		{
			return new ShowAlertMessageTriggerEvent ( ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 
					msg, title ) 
		}
		
	}
}