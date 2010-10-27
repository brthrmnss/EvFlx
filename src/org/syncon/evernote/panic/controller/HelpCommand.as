package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * Some alterations to the board can only take plac eo na idfferent context  
	 * @author user3
	 * 
	 */
	public class HelpCommand extends Command
	{
		//[Inject] public var model:PanicModel;
		 [Inject] public var event:  HelpCommandTriggerEvent;
		 
		override public function execute():void
		{
		   if ( event.type_ == 'sources' ) 
		   {
			   
		   }
		   else if ( event.type_ == 'graph source' ) 
		   {
			   
		   }
		   else if ( event.type_ == 'graph source' ) 
		   {
			   
		   }		   
		   else
		   {
			   throw ' help type not defined ' + event.type_  
		   }
			   
		}
			
 
		
	}
}