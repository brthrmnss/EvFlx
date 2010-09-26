package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import mx.controls.Spacer;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.BoardRow;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.view.ProjectList;
	import org.syncon.evernote.panic.view.TwitterScrollerTest2;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.evernote.services.EvernoteService;
	
	import spark.components.Group;
	import spark.components.HGroup;
	
	public class BuildBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		//[Inject] public var event: Event;
		static public var BUILD_BOARD : String = 'buildBoard'
		//static public var LIVE_DATA : String = 'LoadDefaultDataCommand.LIVE_DATA'
		override public function execute():void
		{
		  this.onBoardRefreshed()
		}
		private function onBoardRefreshed(): void
		{
			
			var target :  Group = this.model.boardHolder; // ui.parentApplication.boardGroup
			target.removeAllElements()
			for each ( var row : Array in this.model.board.layout ) 
			{
				var rowC :  BoardRow = new BoardRow()
				rowC.percentWidth = 100; 
				target.addElement( rowC ) 
				
				var hgroup : HGroup = rowC.content 
				hgroup.percentWidth = 100; 
				var percentWidth : Number = 100* 1/row.length
				for each ( var j :   WidgetVO in row ) 
				{
					if ( j.type == WidgetVO.MESSAGE ) 
					{
						var messageWidget : MessageWidget = new MessageWidget()
						messageWidget.importConfig( j ) 
						messageWidget.percentWidth = percentWidth
						hgroup.addElement( messageWidget ) 
					}
					if ( j.type == WidgetVO.GRAPH ) 
					{
						var  graphWidget :  GraphWidget = new GraphWidget()
						graphWidget.importConfig( j ) 
						//graphWidget.height = 250
						graphWidget.percentWidth = percentWidth
						hgroup.addElement( graphWidget ) 
					}					
					if ( j.type == WidgetVO.PANE ) 
					{
						var pane : PaneWidget = new PaneWidget()
						pane.importConfig( j ) 
						pane.percentWidth = percentWidth
						hgroup.addElement( pane ) 
					}							
					if ( j.type == WidgetVO.PROJECT_LIST ) 
					{
						var  projectList : ProjectList = new ProjectList()
						projectList.importConfig( j ) 
						projectList.percentWidth = percentWidth
						hgroup.addElement( projectList ) 
					}	
					if ( j.type == WidgetVO.SPACER ) 
					{
						var  spacer :   Spacer = new Spacer()
						spacer.height = 15
						hgroup.addElement( spacer ) 
					}						
					if ( j.type == WidgetVO.TWITTER_SCROLLER ) 
					{
						var  twitterScroller :  TwitterScrollerTest2 = new TwitterScrollerTest2()
						twitterScroller.importConfig( j ) 
						twitterScroller.percentWidth = percentWidth
						hgroup.addElement( twitterScroller ) 
					}							
					
					
				}
			}
			
		}
 
		
	}
}