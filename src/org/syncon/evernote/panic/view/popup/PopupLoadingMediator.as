package  org.syncon.evernote.panic.view.popup
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.services.EvernoteService;
	
	public class PopupLoadingMediator extends Mediator
	{
		[Inject] public var ui:PopupLoading;
		[Inject] public var model : EvernoteAPIModel;
		[Inject] public var service :  EvernoteService;
		
		
		
		public function PopupLoadingMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 this.model.eventDispatcher.addEventListener( EvernoteAPIModelEvent.LOADING_CHANGED, onLoadingChanged  ); 
				this.ui.list.dataProvider = this.model.blocking
			/* this.ui.addEventListener( 'onLogin', this.onLogin ) 
			 this.ui.addEventListener( 'onForgotPassword', this.onLogin ) 
			 this.ui.addEventListener( 'onRegister', this.onLogin ) 				
			 this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTH_GET, this.onAuthenticated )
			if ( this.service.auth != null ) 
				this.ui.hide()*/
		}
		
		private function onLoadingChanged(e:Event) : void
		{
			if ( this.model.blocking.length == 0 ) 
				this.ui.hide()
			else
				this.ui.show()
		}		
 
		 
		
	}
}