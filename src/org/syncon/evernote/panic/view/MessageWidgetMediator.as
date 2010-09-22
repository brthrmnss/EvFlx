package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
 
	public class MessageWidgetMediator extends Mediator implements IWidget
	{
		[Inject] public var ui:MessageWidget;
		[Inject] public var model : PanicModel;
			
		public function MessageWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( 'importConfig', onImportConfig ) 				
			/*ui.addEventListener( top_links.HELP, onHelpClickedHandler ) 						
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);	*/		
		}
		 
		public function onImportConfig(e:CustomEvent): void
		{
			/*this.model.logOut();*/
		}		
		 
	}
}