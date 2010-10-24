package  org.syncon.evernote.panic.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.ExportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.popups.controller.HidePopupEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class UserControlsMediator extends Mediator  
	{
		[Inject] public var ui:   UserControls;
		[Inject] public var model : PanicModel;
			
		public function UserControlsMediator()
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
 
				 ui.addEventListener('clickedRoster', onClickedRosterHandler ) 	
 					 
		}
		 
		private function onBoardRefreshed(e:PanicModelEvent): void
		{
			this.onAdminModeChanged(null)
		}
		private function onAdminModeChanged(e:PanicModelEvent): void
		{
			//why was added, find a better solution 
			/*if ( this.model.boardLoaded == false  ) 
			{
					this.ui.hide()
					return 
			}*/
			if ( this.model.adminMode ) 
				this.ui.hide()
			else
				this.ui.show()
				
		}		
 
 
		private function onClickedRosterHandler(e:CustomEvent): void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'RosterPopup' )  )   
		}			
		
		 
	}
}