package  org.syncon.evernote.panic.view.popup.management
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.ExportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.utils.AvatarEdit;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class PopupEditPersonMediator extends Mediator
	{
		[Inject] public var ui:   PopupEditPerson;
		[Inject] public var model :  PanicModel;
		
		public function PopupEditPersonMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener(PopupEditPerson.SAVE_PERSON, this.onSavePerson) 
			//this.ui.addEventListener( AvatarEdit.EditAvatar, this.onEditAvatar) 
			this.ui.img.sources = this.model.projectPics; 
		}
		
		private function onSavePerson(e:CustomEvent) : void
		{
			this.dispatch( new ExportBoardCommandTriggerEvent(
				ExportBoardCommandTriggerEvent.SAVE_BOARD, null, null, false  )  )  				
		}			
		
	/*	
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