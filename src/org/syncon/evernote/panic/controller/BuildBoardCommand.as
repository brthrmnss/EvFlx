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
	import org.syncon.evernote.panic.view.ProjectListWidget;
	import org.syncon.evernote.panic.view.SpacerWidget;
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
		 [Inject] public var event:  BuildBoardCommandTriggerEvent;

		//static public var LIVE_DATA : String = 'LoadDefaultDataCommand.LIVE_DATA'
		override public function execute():void
		{
			 
			if ( event.type == BuildBoardCommandTriggerEvent.BUILD_BOARD ) 
			{
		  		this.onBoardRefreshed()
			}
			if ( event.type == BuildBoardCommandTriggerEvent.ADD_TO_BOARD ) 
			{
				this.onBoardRefreshed()
			}
			 
			//this.onBoardRefreshed()			
		}
		private function onBoardRefreshed(): void
		{
			
			var target :  Group = this.model.boardHolder; // ui.parentApplication.boardGroup
			if ( event.board != null ) 
				target = event.board; 			
			var instructions : Array = this.model.board.layout
			if ( event.instructions != null ) 
				instructions = event.instructions; 
			if ( event.removeAllElements )
				target.removeAllElements()
			for each ( var row : Array in instructions ) 
			{
				var rowC :  BoardRow = new BoardRow()
				rowC.percentWidth = 100; 
				target.addElement( rowC ) 
				rowC.content.gap = this.model.board.horizontalGap;
				var hgroup : HGroup = rowC.content 
				hgroup.percentWidth = 100; 
				var percentWidth : Number = 100* 1/row.length
				for each ( var j :   WidgetVO in row ) 
				{
					addWidgetToStageBasedOnConfig( j , hgroup, percentWidth) 
				}
			}
			
				this.dispatch( new AdjustBoardCommandTriggerEvent( AdjustBoardCommandTriggerEvent.VERTICAL_GAP,
					this.model.board, this.model.board.verticalGap) ) 			
			
		}
 		/**
		 * Bad implenetation, tranform to events 
		 * */
		static public function addWidgetToStageBasedOnConfig( j :  WidgetVO, hgroup : HGroup, percentWidth : Number) : void
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
				var  projectList : ProjectListWidget = new ProjectListWidget()
				projectList.importConfig( j ) 
				projectList.percentWidth = percentWidth
				hgroup.addElement( projectList ) 
			}	
			if ( j.type == WidgetVO.SPACER ) 
			{
				var  spacer :    SpacerWidget = new SpacerWidget()
				spacer.height = 15
				spacer.percentWidth = percentWidth
				spacer.importConfig( j ); 
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