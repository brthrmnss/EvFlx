package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	//import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.GraphWidget;
 
	public class GraphWidgetMediator extends Mediator implements IWidget
	{
		[Inject] public var ui:GraphWidget;
		[Inject] public var model : PanicModel;
			
		public function GraphWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			/*ui.addEventListener( top_links.HELP, onHelpClickedHandler ) 						
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);	*/		
		}
		 
		private function onTrunkClickedHandler(e:CustomEvent): void
		{
			/*var link : String = 'http://www.evernote.com/about/trunk/?lang=en'
			Js.goToUrl(link)		*/		
		}
		private function onSignoutClickedHandler(e:CustomEvent): void
		{
			/*this.model.logOut();*/
		}
		 
	}
}