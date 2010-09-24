package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import mx.controls.Spacer;
	import mx.core.UIComponent;
	
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
			var target :  Group = ui.parentApplication.boardGroup
			for each ( var   row :    HGroup  in target.mxmlContent ) 
			{
				var rowExport : Array = []; 
				output.push( rowExport ) 
					
				for each ( var j :   UIComponent in row ) 
				{
					if ( j is IUIWidget ) 
					{
						rowExport.push( ( j as IUIWidget ).exportConfig() ) 
					}
					if ( j is Spacer )  
					{
						rowExport.push( new WidgetVO( WidgetVO.SPACER )  ) 
					}
					
				}
			}	
			var ee : JSON
			var result : String = JSON.encode( export ) 
			//export to json 
			//event.type = ExportBoardCommandTriggerEvent.EXPORT_BOARD_RESULT
			//this.dispatch( event ) 
				return; 
		}
		
		public function createStartData() : void
		{
			var arr : Array = []; 
			var board : BoardVO = new BoardVO()
			arr.push( [
				new WidgetVO( WidgetVO.GRAPH, GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl', 4, 100, '0xFCBF17',15000).widgetData.data ),
				new WidgetVO( WidgetVO.GRAPH, GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl2', 4, 100, '0x47C816',15000).widgetData.data ),
				new WidgetVO( WidgetVO.GRAPH, GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl3', 4, 100, '0xFF3D19', 15000).widgetData.data ),
				new WidgetVO( WidgetVO.GRAPH, GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl4', 4, 100, '0x7652C0' , 15000).widgetData.data )
				])
			arr.push( [
				new WidgetVO( WidgetVO.PROJECT_LIST, ProjectList.importData('Eccles lister', '', '89/6', 'Eccl', 4, 100, '', '', 15000).widgetData.data ),
			])			
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])						
			arr.push( [
				new WidgetVO( WidgetVO.MESSAGE, MessageWidget.importData('Global Alert', '', '25 Days until twitter launch', '', 15000).widgetData.data ),
			])	
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])					
			arr.push( [
				new WidgetVO( WidgetVO.PANE, PaneWidget.importData('Global Alert', '', 'Something1', '', 15000).widgetData.data ),
				new WidgetVO( WidgetVO.PANE, PaneWidget.importData('Global Alert', '', '2Something1', '', 15000).widgetData.data ),
				new WidgetVO( WidgetVO.PANE, PaneWidget.importData('Global Alert', '', '3Something1', '', 15000).widgetData.data ),				
			])	
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				new WidgetVO( WidgetVO.TWITTER_SCROLLER, TwitterScrollerTest2.importData('Global Alert', '', '25 Days until twitter launch', '', 15000).widgetData.data ),
			])					
			board.ppl = arr
			this.model.board = board; 
			this.model.refreshBoard()
		}
		
	}
}