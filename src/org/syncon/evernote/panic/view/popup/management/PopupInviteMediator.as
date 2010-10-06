package  org.syncon.evernote.panic.view.popup.management
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class PopupInviteMediator extends Mediator
	{
		[Inject] public var ui: PopupInvite;
		[Inject] public var model :  PanicModel;
		
		public function PopupInviteMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( 'openedPopup', this.onOpenPopup) 
		}
		
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupPeople', true )  )  				
		}		
		
		private function onOpenPopup(e:CustomEvent) : void
		{
			this.ui.txtInput.text = this.model.baseUrl //+ this.model.boardUrl()		
			
			this.ui.txtMsg2.text = 'You have a no password set, so no one else will be able to login'; 
			
		}					
		
	}
}