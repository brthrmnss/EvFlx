package   org.syncon.evernote.panic.view.popup.utils
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.utils.AvatarEdit;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class PictureChooserMediator extends Mediator
	{
		[Inject] public var ui:  PictureChooser;
		[Inject] public var model :  PanicModel;
		
		public function PictureChooserMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			//this.ui.addEventListener( AvatarEdit.EditAvatar, this.onEditAvatar) 
		}
 /*
		private function onEditAvatar(e:CustomEvent) : void
		{
			avatar = e.data as AvatarEdit; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PictureChooser', [this.model.peoplePics, this.pickedPicture] )  )  				
		}			
			
		private var avatar : AvatarEdit; 
		
		private function pickedPicture(s: String) : void
		{
			this.avatar.source = s; 				
		}			
				*/
		 /*
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditProject', [e.data] )  )  				
		}				
 */
 
	}
}