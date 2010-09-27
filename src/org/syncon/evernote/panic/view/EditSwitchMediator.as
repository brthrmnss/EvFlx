package  org.syncon.evernote.panic.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
 
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
				
				 ui.addEventListener('clickedEdit', onClickedHandler ) 		
				 //this.onClickedHandler(null)
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
		
		private function onClickedHandler(e:CustomEvent): void
		{
			this.ui.editMode = ! this.ui.editMode; 
			this.model.editMode = this.ui.editMode
			if ( this.ui.editMode )
				this.ui.btnEdit.label = 'Leave Edit Mode'
			else
				this.ui.btnEdit.label = 'Edit Mode' 
		}
		 
	}
}