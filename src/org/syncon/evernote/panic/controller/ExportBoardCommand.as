package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import mx.controls.Spacer;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.BoardRow;
	import org.syncon.evernote.panic.view.IUIWidget;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	import spark.components.Group;
	import spark.components.HGroup;
	
	public class ExportBoardCommand extends Command
	{
		[Inject] public var model: PanicModel;
		[Inject] public var event: ExportBoardCommandTriggerEvent;
		private var board : BoardVO; 
		override public function execute():void
		{
			this.board = this.model.board; 
			var layoutExport : Array = []; 
			var target :  Group = this.model.boardHolder
			for ( var i : int =0 ; i < target.numElements; i++ )
			{
				var xxx : Object = target.getElementAt( i ) 
				var   row :     BoardRow  = target.getElementAt( i ) as BoardRow
				var rowExport : Array = []; 
				layoutExport.push( rowExport ) 
				
				var hgroup : HGroup = row.content
				for ( var z : int =0 ; z < hgroup.numElements; z++ )
				{
					var   j :     UIComponent  = hgroup.getElementAt(z)  as UIComponent
					if ( j is IUIWidget ) 
					{
						rowExport.push( ( j as IUIWidget ).exportConfig().export() ) 
					}
					else if ( j is Spacer )  
					{
						rowExport.push( new WidgetVO( WidgetVO.SPACER ).export()  ) 
					}
					
				}
			}	
			var board_ : Object = this.board.export()
			board_.layout =  layoutExport  
			
			var output : Object = {}
			var people : Array = [];
			
			
			for each ( var p : PersonVO in this.model.board.people )
			{
				people.push( p.export() )
			}
			var projects : Array = []; 
			for each ( var project :  ProjectVO  in this.model.board.projects )
			{
				projects.push( project.export() )
			}	
			
			output.board = board_
			output.people = people
			output.projects = projects
				
			var result : String = JSON.encode( output  ) 
				
				
			//export to json 
			//event.type = ExportBoardCommandTriggerEvent.EXPORT_BOARD_RESULT
			//this.dispatch( event ) 
				return; 
		}
		 
	}
}