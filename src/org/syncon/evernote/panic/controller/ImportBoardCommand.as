package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.BoardVO;
	
	public class ImportBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event:  ImportBoardCommandTriggerEvent;
		override public function execute():void
		{
			 if ( event.data is   String ) {}
			 var json :   Object = JSON.decode( event.data.toString() ) 
			
			var b : BoardVO = new BoardVO()
			b.importX( json ); 
			this.model.board = b; 
			this.model.refreshBoard(); 
		}
		
	}
}