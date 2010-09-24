package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import mx.controls.Spacer;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.IUIWidget;
	import org.syncon.evernote.panic.vo.BoardVO;
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
			var output : Array = []; 
			var ee : FlexGlobals
			var target :  Group = FlexGlobals.topLevelApplication.boardGroup
			for ( var i : int =0 ; i < target.numElements; i++ )
			{
				var xxx : Object = target.getElementAt( i ) 
				var   row :    HGroup  = target.getElementAt( i ) as HGroup
				var rowExport : Array = []; 
				output.push( rowExport ) 
				
					
					
				for ( var z : int =0 ; z < row.numElements; z++ )
				{
					var   j :     UIComponent  = row.getElementAt(z)  as UIComponent
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
			board_.layout = output
			var result : String = JSON.encode( board_ ) 
			//export to json 
			//event.type = ExportBoardCommandTriggerEvent.EXPORT_BOARD_RESULT
			//this.dispatch( event ) 
				return; 
		}
		 
	}
}