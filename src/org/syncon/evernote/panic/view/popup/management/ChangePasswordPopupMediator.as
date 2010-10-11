package  org.syncon.evernote.panic.view.popup.management
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class ChangePasswordPopupMediator extends Mediator
	{
		[Inject] public var ui:   ChangePasswordPopup;
		[Inject] public var model :  PanicModel;
		
		public function ChangePasswordPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( 		ChangePasswordPopup.OPENED_POPUP , this.onOpenPopup) 
			this.ui.addEventListener(ChangePasswordPopup.CHANGE, this.onChangePopup) 				
		}
		
		private function onOpenPopup(e:CustomEvent) : void
		{
		
			this.ui.txtCurrentPassword.text = '';
			this.ui.txtPassword.text = '' 
			this.ui.txtPassword2.text = '' ; 
		}					
		
		private function onChangePopup(e:CustomEvent) : void
		{
			if ( this.ui.currentState == 'pre' ) 
			{
				if ( this.ui.fxValidate( this.ui.txtCurrentPassword.text ) == false ) 
				{
					this.ui.txtAlert.text = 'Problem with your current password' 
					return; 
				}
			}
			 
			if ( this.ui.txtPassword.text.length < 6  )
			{
				if ( this.ui.passwordCanBeEmpty && this.ui.txtPassword.text.length == 0 ) 
				{
					
				}
				else
				{
					this.ui.txtAlert.text = 'Password too short' 
					return 
				}
			}
			
			if ( this.ui.txtPassword.text != this.ui.txtPassword2.text ) 
			{
				this.ui.txtAlert.text = 'Passwords do not match ' 
				return; 
			}
			
			
			this.ui.fxComplete( this.ui.txtPassword.text ) 
			this.ui.hide()
		}					
				
		
	}
}