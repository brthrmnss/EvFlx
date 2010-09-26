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
			//	eventMap.mapListener(eventDispatcher, PanicModelEvent.REFRESH_BOARD, 
			//	this.onBoardRefreshed);	
			/*ui.addEventListener( top_links.HELP, onHelpClickedHandler ) 						
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);	*/		
				
				//this.onBoardRefreshed(null)
		}
		 

		private function onSignoutClickedHandler(e:CustomEvent): void
		{
			/*this.model.logOut();*/
		}
		 
	}
}