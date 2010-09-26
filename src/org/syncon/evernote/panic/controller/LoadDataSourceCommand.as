package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.BoardVO;
	
	public class LoadDataSourceBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event:   LoadDataSourceCommandTriggerEvent;
		override public function execute():void
		{
			 if ( event.src ) 
			 {
				 
			 }
		}
		
	}
}