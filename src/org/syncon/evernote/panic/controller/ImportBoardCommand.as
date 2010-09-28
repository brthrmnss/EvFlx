package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	
	public class ImportBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event:  ImportBoardCommandTriggerEvent;
		override public function execute():void
		{
			 if ( event.data is   String ) {}
			 var json :   Object = JSON.decode( event.data.toString() ) 
			
			 var b : BoardVO = new BoardVO()
			 var people : Array = [];
			 for each ( var obj :   Object in json.people )
			 {
				 var person :  PersonVO = new PersonVO()
				 person.importX( obj ) 
				 people.push( person )				 
			 }
			 b.people = people
			 var projects : Array = []; 
			 for each (   obj   in json.projects )
			 {
				 var project : ProjectVO = new ProjectVO()
				project.importX( obj ) 
				 projects.push( project )
			 }					 
			 b.projects = projects  
				 
			
			b.importX( json.board ); 
			this.model.board = b; 
			this.model.refreshBoard(); 
		}
		
	}
}