package   org.syncon.evernote.panic.view.popup
{
	import com.adobe.crypto.MD5;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteList;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.AuthenticateToBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.CreateBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.LoadDefaultDataCommand;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.services.EvernoteService;
	import org.syncon.popups.controller.HidePopupEvent;
	
	public class PopupRegisterMediator extends Mediator
	{
		[Inject] public var ui: PopupRegister;
		[Inject] public var model : EvernoteAPIModel;
		[Inject] public var panicModel : PanicModel; 	
		[Inject] public var service :  EvernoteService;
		
		public var saveBoardAfter : Boolean = false
		
		public function PopupRegisterMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( PopupRegister.OPENED_REGISTER_POPUP, onOpenPopup ) 
			this.ui.addEventListener( PopupRegister.CREATE_BOARD, onCreateBoard ) 
			this.ui.addEventListener( PopupRegister.BOARD_NAME_CHANGED, onBoardNameChanged )
				
			if ( this.panicModel.debugMode ) 
			{
				this.ui.txtBoardName.text = 'mercy'
				this.ui.txtEmail.text = 'info@m24designs.com'
				this.ui.txtPassword.text = '12121212'
				this.ui.txtPassword2.text = '12121212'
				this.ui.txtName.text = 'Ronshi'
			}
		}
		
		public function onOpenPopup(e:Event) : void
		{
			this.saveBoardAfter = false 
		}
		
		public function onCreateBoard( e: Event) : void
		{
			this.saveBoardAfter = true; 
			this.findBoard( this.ui.txtBoardName.text ) ; 
			return;
		}
	 
		private function onBoardNameChanged( e: Event) : void
		{
			this.saveBoardAfter = false 
			this.findBoard( this.ui.txtBoardName.text ) ; 
			return;
		}
		
		private function boardFoundResult( nl :  NoteList) : void
		{
			if ( nl.notes.length == 0 ) 
			{
				this.ui.txtBoardOk.text = 'Name valid'
				this.ui.txtBoardOk.text = ''; 
				if ( this.saveBoardAfter ) 
				{
					this.saveBoardAfter = false; 
					this.createBoard()
				}
			}
			else
			{
				this.ui.txtBoardOk.text = 'Name is already take, try something else'
			}
		}
		
		
		private function findBoard( name : String) : void
		{
			var nf :  NoteFilter = new NoteFilter()
			nf.words = this.panicModel.createBoardTitle(    name )
			this.dispatch(  EvernoteAPICommandTriggerEvent.FindNotes(
				nf , 0, 0, boardFoundResult, step1_Fault ) ) 				
		}
		
		
		private function step1_Fault(e:Object):void
		{
			
		}		
		
		/**
		 * make new document, use bsic settings, close popup, require user to login again 
		 * copy username and password to it
		 * */
		public function createBoard() : void
		{
			this.ui.txtStatus.text = "Creating the board..."
			var board : BoardVO = new BoardVO()
			var ee : LoadDefaultDataCommand = new LoadDefaultDataCommand()
			board = ee.CreateBoard( [this.ui.txtName.text, 'Person 2', 'Person 3'], ['Project 1', 'Create Board Project'] )
			board.name = this.ui.txtBoardName.text
			board.board_admin_password = this.ui.txtPassword.text; 
			board.board_password = this.ui.txtAccessPassword.text; 
			board.admin_name = this.ui.txtName.text; 
			//var ee : MD5
			board.admin_email = this.ui.txtEmail.text
			board.admin_name = this.ui.txtName.text; 
			this.dispatch( 
				new CreateBoardCommandTriggerEvent( 
				CreateBoardCommandTriggerEvent.CREATE_BOARD, board, this.boardCreated , this.boardCreateFault ) 
			)
		}
		
		
		public function boardCreated(e:Object=null)  : void
		{
			this.ui.txtStatus.text = "Board Created, loading..."
			import flash.utils.setTimeout
			setTimeout( this.ui.hide, 1000)
			this.dispatch( new HidePopupEvent( HidePopupEvent.HIDE_POPUP, 'PopupLogin' ) ) 
			//this.ui.hide()
		}
		
		public function boardCreateFault() : void
		{
			this.ui.txtStatus.text = "Something happened, couldn't make your board"
		}
		
	}
}