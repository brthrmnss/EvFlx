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
		}
		 
		private function onBoardRefreshed(e:CustomEvent): void
		{
			/*var link : String = 'http://www.evernote.com/about/trunk/?lang=en'
			Js.goToUrl(link)		*/		
			//put is command? 
			ui.removeAllElements();
			for each ( var row : Array in this.model.board.ppl ) 
			{
				var hgroup : HGroup = new HGroup()
				hgroup.percentWidth = 100; 
				ui.addElement( hgroup ) 
				for each ( var j :   WidgetVO in row ) 
				{
					if ( j.type == WidgetVO.ALERT ) 
					{
						var messageWidget : MessageWidget = new MessageWidget()
						messageWidget.importConfig( j ) 
						messageWidget.percentWidth = 100* 1/row.length
						hgroup.addElement( messageWidget ) 
					}
					if ( j.type == WidgetVO.GRAPH ) 
					{
						var  graphWidget :  GraphWidget = new GraphWidget()
						graphWidget.importConfig( j ) 
						graphWidget.percentWidth = 100* 1/row.length
						hgroup.addElement( graphWidget ) 
					}					
					if ( j.type == WidgetVO.SPACER ) 
					{
						var  spacer :   Spacer = new Spacer()
						spacer.height = 15
						hgroup.addElement( spacer ) 
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