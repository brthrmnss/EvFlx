package   org.syncon.evernote.panic.controller
{
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	
	public class ImportBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event:  ImportBoardCommandTriggerEvent;
		override public function execute():void
		{
			 
		}
		
	}
}