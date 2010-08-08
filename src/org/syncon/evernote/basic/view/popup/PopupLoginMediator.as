package  org.syncon.evernote.basic.view.popup
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.services.EvernoteService;
	
	public class PopupLoginMediator extends Mediator
	{
		[Inject] public var ui:PopupLogin;
		[Inject] public var model : EvernoteAPIModel;
		[Inject] public var service :  EvernoteService;
		
		
		
		public function PopupLoginMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 this.model.eventDispatcher.addEventListener( EvernoteAPIModelEvent.PREFERENCES_CHANGED, onPreferencesChanged ); 
			 this.ui.addEventListener( 'onLogin', this.onLogin ) 
			 this.ui.addEventListener( 'onForgotPassword', this.onLogin ) 
			 this.ui.addEventListener( 'onRegister', this.onLogin ) 				
			 this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTH_GET, this.onAuthenticated )
			if ( this.service.auth != null ) 
				this.ui.hide()
				import flash.utils.setTimeout; 
				setTimeout( this.creationComplete, 10000, null )
					this.ui.callLater( this.creationComplete, [null] )
			//if ( ui.creationComplete == false ) 
				ui.addEventListener(FlexEvent.CREATION_COMPLETE, this.creationComplete ) 
		}
		public function creationComplete(e:Event):void
		{
			if ( this.service.auth != null ) 
				this.ui.hide()			
		}
		
		private function onPreferencesChanged(e:Event) : void
		{
			this.ui.txtUsername.text = this.model.preferences.username
			 this.ui.txtPassword.text = ''; 
		}		
 
		public function onLogin(e: Event):void
		{	
		}
		
		public function onAuthenticated(e:EvernoteServiceEvent):void
		{
			this.ui.hide();
		}
		
	}
}