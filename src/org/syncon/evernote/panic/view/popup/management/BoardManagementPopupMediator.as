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
	import org.syncon.evernote.panic.test.context.utils.MD5Helper;
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
			this.ui.addEventListener( BoardManagementPopup.CHANGE_BOARD_PASSWORD, this.onChangeBoardPassword) 
			this.ui.addEventListener( BoardManagementPopup.CHANGE_ADMIN_PASSWORD, this.onChangeAdminPassword) 				
		}
 
		private function onChangeBoardPassword(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'ChangePasswordPopup', ['Change Board Password', 
					'', '',  this.validateExistingAdminPass, this.boardPasswordChanged, false] )  )  				
		}		
			private function boardPasswordChanged(e:String) : void
			{
				this.ui.txtAlert.text = 'Password Changed...'
				this.model.board.board_password =  MD5Helper.toHash( e )
				this.model.saveConfigOnly()
			}		
		private function onChangeAdminPassword(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'ChangePasswordPopup', ['Change Admin Password', 
					'', 'x', this.validateExistingAdminPass, this.adminPasswordChanged] )  )  				
		}		
			private function validateExistingAdminPass(e:String) :  Boolean
			{
				var ee : MD5Helper
				var found : Boolean =  this.model.board.board_admin_password.indexOf( MD5Helper.toHashSearch( e ) ) != -1  
				return found; 
			}				
			private function adminPasswordChanged(e:String) : void
			{
				this.ui.txtAlert.text = 'Admin Password Changed...'
				this.model.board.board_admin_password =  MD5Helper.toHash( e )
				this.model.saveConfigOnly()
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
/*			if ( this.ui.txtAdminPassword.text.length > 0 ) 
			{
				var adminPass : String = this.ui.txtAdminPassword.text
				if ( adminPass != this.ui.txtAdminPassword2.text ) 
				{
					this.ui.txtAlert.text = 'Admin passwords do not match'
					return; 
				}					
				if ( adminPass.length < 6 ) 
				{
					this.ui.txtAlert.text = 'Admin password too short'
					return; 
				}
			}
			if ( this.ui.txtPassword.text.length > 0 ) 
			{
				var pass : String = this.ui.txtPassword.text
				if ( pass != this.ui.txtPassword2.text ) 
				{
					this.ui.txtAlert.text = 'Board passwords do not match'
					return; 
				}	 		
 
			}	
		*/
			this.board.desc = this.ui.txtDesc.text 
		/*	this.board.board_password = this.ui.txtPassword.text; 		
			this.board.board_admin_password = this.ui.txtAdminPassword.text; 		*/
			this.dispatch( new PanicModelEvent(PanicModelEvent.CHANGED_PROJECTS ) ) 
			this.model.saveBoard()			
				
			this.ui.hide()
		}		
		 
		private function onOpenedPopup(e:CustomEvent) : void
		{
			var o : Object =  this.model.board
			this.board = this.model.board
				
			this.ui.txtName.text = this.board.name; 
			this.ui.txtName.editable = this.board.name != null 
			this.ui.txtDesc.text = this.board.desc
			/*
			this.ui.txtPassword.text ='';// this.board.board_password; 
			this.ui.txtPassword2.text ='';// this.board.board_password; 			
			this.ui.txtAdminPassword.text = '';//this.board.board_admin_password; 		
			this.ui.txtAdminPassword2.text = '';//this.board.board_admin_password; 	*/				
			this.ui.txtAlert.text = ''; 
		}		
		
		private function onClosedPopup(e:CustomEvent) : void
		{

		}			
 
	}
}