package org.syncon.evernote.panic.view.utils
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.view.utils.AvatarEdit;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class AvatarEditMediator extends Mediator
	{
		[Inject] public var ui:    AvatarEdit;
		
		public function AvatarEditMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( AvatarEdit.EditAvatar, this.onEditAvatar) 
		}
		
		private function onEditAvatar(e:CustomEvent) : void
		{
			avatar = e.data as AvatarEdit; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PictureChooser',  [this.ui.sources, this.pickedPicture, this.avatar,
				this.avatar.source] )  )  				
		}			
			
		private var avatar : AvatarEdit; 
		
		private function pickedPicture(s: String) : void
		{
			this.ui.source = s; 				
			this.ui.dispatchEvent( new CustomEvent( AvatarEdit.ChangedAvatar, s ) ) 
		}			
				
	}
}