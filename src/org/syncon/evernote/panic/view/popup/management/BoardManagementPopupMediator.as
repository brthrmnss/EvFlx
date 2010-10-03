package  org.syncon.evernote.panic.view.popup.management
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class BoardManagementPopupMediator extends Mediator
	{
		[Inject] public var ui: BoardManagementPopup;
		[Inject] public var model :  PanicModel;
		
		private var board :  BoardVO = new BoardVO();
		
		public function BoardManagementPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
	 		this.ui.addEventListener( BoardManagementPopup.SAVE_BOARD, this.onSaveBoard ) 
			this.ui.addEventListener( BoardManagementPopup.OPENED_POPUP, this.onOpenedPopup)
			this.ui.addEventListener( BoardManagementPopup.CLOSED_POPUP, this.onClosedPopup) 				
			this.ui.addEventListener( BoardManagementPopup.CHECK_NAME, this.onCheckName) 
		}
 
		private function onCheckName(e:CustomEvent) : void
		{
			 
		}		
		
		private function onSaveBoard(e:CustomEvent) : void
		{
		  	if ( this.board.name != null ) 
			{
				this.board.name = this.ui.txtName.text; 
			}
			else
			{
				
			}
			
			this.board.desc = this.ui.txtDesc.text 
			this.board.board_password = this.ui.txtPassword.text; 		
			this.board.board_admin_password = this.ui.txtAdminPassword.text; 		
			this.dispatch( new PanicModelEvent(PanicModelEvent.CHANGED_PROJECTS ) ) 
			this.model.saveBoard()			
		}		
		 
		private function onOpenedPopup(e:CustomEvent) : void
		{
			var o : Object =  this.model.board
			this.board = this.model.board
				
			this.ui.txtName.text = this.board.name; 
			this.ui.txtName.editable = this.board.name != null 
			this.ui.txtDesc.text = this.board.desc
			this.ui.txtPassword.text = this.board.board_password; 
			this.ui.txtAdminPassword.text = this.board.board_admin_password; 			
		}		
		
		private function onClosedPopup(e:CustomEvent) : void
		{

		}			
 
	}
}