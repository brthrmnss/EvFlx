package   org.syncon.evernote.panic.view.popup
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.CreateDefaultDataCommand;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.AuthenticateToBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.services.EvernoteService;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon.utils.Js;
	
	public class PopupLoginMediator extends Mediator
	{
		[Inject] public var ui:PopupLogin;
		[Inject] public var apiModel : EvernoteAPIModel;
		[Inject] public var model : PanicModel;
		[Inject] public var service :  EvernoteService;
		
		public function PopupLoginMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 this.model.eventDispatcher.addEventListener( 
				 EvernoteAPIModelEvent.PREFERENCES_CHANGED, onPreferencesChanged ); 
			 this.ui.addEventListener( PopupLogin.LOGIN, this.onLogin ) 
			 this.ui.addEventListener( PopupLogin.REGISTER, this.onRegisterClickedHandler ) 
			 this.ui.addEventListener( PopupLogin.FORGOT_PASSWORD, this.onForgotPassword ) 				
			 this.service.eventDispatcher.addEventListener( EvernoteServiceEvent.AUTH_GET, this.onAuthenticated )
				if ( this.service.auth != null ) 
					this.ui.hide()
				import flash.utils.setTimeout; 
				setTimeout( this.creationComplete, 10000, null )
					this.ui.callLater( this.creationComplete, [null] )
			//if ( ui.creationComplete == false ) 
				ui.addEventListener(FlexEvent.CREATION_COMPLETE, this.creationComplete ) 
		}
		private function creationComplete(e:Event):void
		{
			if ( this.ui.meth1 ) return ; 
			if ( this.service.auth != null ) 
				this.ui.hide()			
		}
		
		private function onPreferencesChanged(e:Event) : void
		{
			this.ui.txtUsername.text = this.apiModel.preferences.username
			 this.ui.txtPassword.text = ''; 
		}		
 
		private function onLogin(e: Event):void
		{	
			if ( this.ui.meth1 ) 
			{
				this.dispatch( new AuthenticateToBoardCommandTriggerEvent( AuthenticateToBoardCommandTriggerEvent.METH1, 
				this.ui.txtBoardName.text, null, this.ui.txtPassword.text, this.ui.chkAdmin.selected,  this.onLoginResult_M1, this.onLoginFault_M1 ))			
			}
				/*this.dispatch(
			EvernoteAPICommandTriggerEvent.Authenticate( this.ui.txtUsername.text, 
					this.ui.txtPassword.text, this.onLoginResult, this.onLoginFault  )
			)*/
		}
			private function onLoginResult_M1(e:Object):void
			{
				this.ui.loginOk()
				
			}
			private function onLoginFault_M1(e:Object):void
			{
				this.ui.status = 'Could not log you in, please try again'
				this.ui.show()
			}		
			private function onLoginResult(e:Object):void
			{
				this.dispatch( new Event( CreateDefaultDataCommand.LIVE_DATA ))
				this.ui.loginOk()

			}
			private function onLoginFault(e:Object):void
			{
				this.ui.status = 'Could not log you in, please try again'
				this.ui.show()
			}
			
		private function onRegisterClickedHandler(e: Event):void
		{	
			if ( this.model.authMode1 ) 
			{
				this.dispatch( new ShowPopupEvent( 
					ShowPopupEvent.SHOW_POPUP,  'PopupRegister' ) );	
			}
			
			/*var link : String = 'https://sandbox.evernote.com/Registration.action'
			Js.goToUrl(link)*/		
		}
		
		private function onForgotPassword(e: Event):void
		{	
			var link : String = 'https://sandbox.evernote.com/ForgotPassword.action'
			Js.goToUrl(link)					
		}		
		
		private function onAuthenticated(e:EvernoteServiceEvent):void
		{
			//this.ui.hide();
		}
		
	}
}