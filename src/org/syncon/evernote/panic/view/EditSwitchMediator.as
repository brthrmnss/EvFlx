package  org.syncon.evernote.panic.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.ExportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.popups.controller.HidePopupEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class EditSwitchMediator extends Mediator  
	{
		[Inject] public var ui:   EditSwitch;
		[Inject] public var model : PanicModel;
			
		public function EditSwitchMediator()
		{
		} 
		
		override public function onRegister():void
		{
				eventMap.mapListener(eventDispatcher, PanicModelEvent.REFRESH_BOARD, 
				this.onBoardRefreshed);	
				this.onBoardRefreshed(null)
					
				eventMap.mapListener(eventDispatcher, PanicModelEvent.ADMIN_MODE_CHANGED, 
					this.onAdminModeChanged);	
				this.onAdminModeChanged(null)
				
				 ui.addEventListener('clickedEdit', onClickedEditHandler ) 		
				 this.onClickedEditHandler(null)
					 
				 ui.addEventListener('clickedSave', onClickedSaveHandler ) 		
				 ui.addEventListener('clickedPeople', onClickedPeopleHandler ) 		
				 ui.addEventListener('clickedProjects', onClickedProjectsHandler ) 			
				 ui.addEventListener('clickedBoard', onClickedBoardHandler ) 							 
				 
		}
		 
		private function onBoardRefreshed(e:PanicModelEvent): void
		{
		}
		private function onAdminModeChanged(e:PanicModelEvent): void
		{
			if ( this.model.adminMode ) 
			this.ui.show()
			else
			this.ui.hide()
		}		
		private function onClickedSaveHandler(e:CustomEvent): void
		{
			var ee : ExportBoardCommandTriggerEvent = new ExportBoardCommandTriggerEvent(
				ExportBoardCommandTriggerEvent.SAVE_BOARD ) 
			this.dispatch( ee )
		}
		private function onClickedPeopleHandler(e:CustomEvent): void
		{
			 this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PeopleManagementPopup' )  )  
		}
		private function onClickedProjectsHandler(e:CustomEvent): void
		{
			 this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'ProjectManagementPopup' )  )   
		}		
		private function onClickedBoardHandler(e:CustomEvent): void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'BoardManagementPopup' )  )   
		}				
		
		private function onClickedEditHandler(e:CustomEvent): void
		{
			//if nto updating, just adjust words
			if ( e != null )
			{
				this.ui.editMode = ! this.ui.editMode; 
				this.model.editMode = this.ui.editMode
			}
			else
			{
				this.ui.editMode =  this.model.editMode; 
			}
			if ( this.ui.editMode )
			{
				this.ui.currentState = 'edit'
				//this.ui.btnEdit.label = 'Leave Edit Mode'
			}
			else
			{
				this.ui.currentState = 'noEdit'
					//does nto make sense modal bg should be blocking that 
				this.closeAllEditPopups()
				//this.ui.btnEdit.label = 'Edit Mode'
			}
		}
		
		private function closeAllEditPopups() : void
		{
			var popupsToClose : Array = [
				'PeopleManagementPopup', 'ProjectManagementPopup', 
				'PopupEditPerson', 'PopupEditProject'
			]; 
			for each ( var popup : String in popupsToClose ) 
			{
				this.dispatch( 
					new HidePopupEvent( HidePopupEvent.HIDE_POPUP, popup )
				)
			}
		}
		
		 
	}
}