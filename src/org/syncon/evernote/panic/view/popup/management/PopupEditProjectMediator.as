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
	
	public class PopupEditProjectMediator extends Mediator
	{
		[Inject] public var ui:  PopupEditProject;
		[Inject] public var model :  PanicModel;
		
		public function PopupEditProjectMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( 'editMembers', this.onEditProject)
			this.ui.addEventListener(PopupEditProject.SAVE_PROJECT, this.onSaveProject )
			//this.ui.addEventListener( AvatarEdit.EditAvatar, this.onEditAvatar) 
			mediatorMap.createMediator(this.ui.img);
			this.ui.img.sources = this.model.projectPics
		}
		
		private function onSaveProject(e:CustomEvent) : void
		{
			this.model.saveConfigOnly()		
		}			
		
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PeopleManagementPopup', [this.ui.project.ppl, this.peopleSelected] )  )  				
		}			
		
		private function peopleSelected(newPeople:Array )  : void
		{
			//maybe only if neccesary , ... 
			//now it will always update when changed ... but who really cares 
			this.ui.project.ppl = newPeople; 
			this.ui.memberLIst.list1.dataProvider = new ArrayList( this.ui.project.ppl ) 
		}
		 /*
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditProject', [e.data] )  )  				
		}				
 */
 
		/*
		
		private function onEditAvatar(e:CustomEvent) : void
		{
			avatar = e.data as AvatarEdit; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PictureChooser',  [this.model.projectPics, this.pickedPicture, this.avatar,
					this.avatar.source, '' ] )  )  				
		}			
		
		private var avatar : AvatarEdit; 
		
		private function pickedPicture(s: String) : void
		{
			this.avatar.source = s; 				
		}				
		*/
	}
}