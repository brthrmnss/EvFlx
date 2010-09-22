/**
* Main Model for Application 
*/
package org.syncon.evernote.panic.model
{
	import com.evernote.edam.notestore.SyncState;
	import com.evernote.edam.type.Tag;
	import com.evernote.edam.type.User;
	import com.evernote.edam.userstore.AuthenticationResult;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Actor;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Notebook2;
	import org.syncon.evernote.model.Tag2;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class   PanicModel   extends Actor 
	{
 		public function PanicModel()
		{
		}
		
		private var _board :  BoardVO = new BoardVO();
		public function set board ( p : BoardVO )  : void
		{
			this._board = p; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.BOARD_CHANGED, this._board ) )
		}
		public function get  board ( ) : BoardVO  { return this._board   }		
				
		public function refreshBoard()  : void
		{
			this.dispatch( new PanicModelEvent( PanicModelEvent.REFRESH_BOARD, this._board ) )
		}
			
	}
}