package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Spacer;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	import spark.components.Group;
	import spark.components.HGroup;
 
	public class PanicBoardMediator extends Mediator  
	{
		[Inject] public var ui:  PanicBoard;
		[Inject] public var model : PanicModel;
			
		public function PanicBoardMediator()
		{
		} 
		
		override public function onRegister():void
		{
				eventMap.mapListener(eventDispatcher, PanicModelEvent.REFRESH_BOARD, 
				this.onBoardRefreshed);	
			/*ui.addEventListener( top_links.HELP, onHelpClickedHandler ) 						
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);	*/		
				
				this.onBoardRefreshed(null)
		}
		 
		private function onBoardRefreshed(e:PanicModelEvent): void
		{
			/*var link : String = 'http://www.evernote.com/about/trunk/?lang=en'
			Js.goToUrl(link)		*/		
			//put is command? 
			var target : Group = ui.parentApplication.boardGroup
			target.removeAllElements()
			for each ( var row : Array in this.model.board.ppl ) 
			{
				var hgroup : HGroup = new HGroup()
				hgroup.percentWidth = 100; 
				target.addElement( hgroup ) 
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
		private function onSignoutClickedHandler(e:CustomEvent): void
		{
			/*this.model.logOut();*/
		}
		 
	}
}