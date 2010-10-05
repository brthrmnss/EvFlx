package  org.syncon.evernote.panic.view.popup.management
{
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	
	public class PopupPersonHoverMediator extends Mediator
	{
		[Inject] public var ui: PopupPersonHover;
		
		public function PopupPersonHoverMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( 'editMembers', this.onEditProject) 
			this.ui.addEventListener( AvatarEdit.EditAvatar, this.onEditAvatar) 
		}
		
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupPeople', true )  )  				
		}			
		
		
		private function onEditAvatar(e:CustomEvent) : void
		{
			avatar = e.data as AvatarEdit; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PictureChooser',  [this.model.peoplePics, this.pickedPicture, this.avatar,
				this.avatar.source] )  )  				
		}			
			
		private var avatar : AvatarEdit; 
		
		private function pickedPicture(s: String) : void
		{
			this.avatar.source = s; 				
			this.avatar.dispatchEvent( new CustomEvent( AvatarEdit.ChangedAvatar, s ) ) 
		}			
				
		 /*
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditProject', [e.data] )  )  				
		}				
 */
 
	}
}