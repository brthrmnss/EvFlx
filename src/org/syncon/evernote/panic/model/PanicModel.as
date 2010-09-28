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
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Notebook2;
	import org.syncon.evernote.model.Tag2;
	import org.syncon.evernote.panic.controller.BuildBoardCommand;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	import spark.components.Group;
 
	public class   PanicModel   extends Actor 
	{
 		public function PanicModel()
		{
		}
		
		/**
		 * Used for new layouts ... updated by live command
		 * */
		public var defaultBoardImportString : String = '{"board":{"name":"mercy","layout":[[{"type":"graph","labelTop":"89/6","refreshTime":15000,"name":"Eccles lister","fillColor":16563991,"max":100,"source":"56","labelBottom":"Eccl"},{"type":"graph","labelTop":"89/6","refreshTime":15000,"name":"Eccles lister","fillColor":4704278,"max":100,"source":"99","labelBottom":"Eccl2"},{"type":"graph","labelTop":"{http://city-21.com/php/random_number.php}/100","refreshTime":15000,"name":"Eccles lister","fillColor":16727321,"max":100,"source":"{http://city-21.com/php/random_number.php}","labelBottom":"Ec3 - {http://city-21.com/php/random_string.php?f=8}"},{"type":"graph","labelTop":"12/100","refreshTime":15000,"name":"Eccles lister","fillColor":7754432,"max":100,"source":"12","labelBottom":"Eccl4"}],[{"height":355,"type":"projectList","refreshTime":15000,"name":"Project Lister","source":""}],[{"type":"spacer"}],[{"type":"message","refreshTime":15000,"name":"Global Alert","source":"25 Days until tswitter launch"}],[{"type":"spacer"}],[{"type":"pane","color2":921102,"color1":5064772,"refreshTime":15000,"name":"Global Alert","source":"Something1"},{"type":"pane","color2":334129,"color1":4082524,"refreshTime":15000,"name":"Global Alert","source":"2Something1"},{"type":"pane","color2":4013884,"color1":4013884,"refreshTime":15000,"name":"Global Alert","source":"3Something1"}],[{"type":"spacer"}],[{"refreshTime":15000,"type":"twitterScroller","name":"Twitter Pane","source":"Panic Board","description":"..."}]]},"projects":[{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["bA d","A c"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["bA c","bA b","A d"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["cA d","bA c"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":[],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["A d","cd Y"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":[],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["bA b","A d","cd Y"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["A d","bA d","cA b","d Y"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["A d","cA d","A c"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["cA c","cA d"],"desc":"coda is coda","ppl":[]}],"people":[{"name":"A b","src":"GIF/D03 copy.gif","desc":"","email":"","twitter":""},{"name":"A c","src":"GIF/E03 copy.gif","desc":"","email":"","twitter":""},{"name":"A d","src":"GIF/E02 copy.gif","desc":"","email":"","twitter":""},{"name":"d Y","src":"GIF/A04 copy.gif","desc":"","email":"","twitter":""},{"name":"bA b","src":"GIF/I02 copy.gif","desc":"","email":"","twitter":""},{"name":"bA c","src":"GIF/FC01 copy.gif","desc":"","email":"","twitter":""},{"name":"bA d","src":"GIF/D01 copy.gif","desc":"","email":"","twitter":""},{"name":"bd Y","src":"GIF/N02 copy.gif","desc":"","email":"","twitter":""},{"name":"cA b","src":"GIF/A03 copy.gif","desc":"","email":"","twitter":""},{"name":"cA c","src":"GIF/A05 copy.gif","desc":"","email":"","twitter":""},{"name":"cA d","src":"GIF/N02 copy.gif","desc":"","email":"","twitter":""},{"name":"cd Y","src":"GIF/E05 copy.gif","desc":"","email":"","twitter":""}]}'; 
		public var configNote : Note2;
		
		private var _board :  BoardVO = new BoardVO();
		public function set board ( p : BoardVO )  : void
		{
			this._board = p; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.BOARD_CHANGED, this._board ) )
		}
		public function get  board ( ) : BoardVO  { return this._board   }		
				
		private var _editMode : Boolean = false
		public function set editMode ( p : Boolean )  : void
		{
			this._editMode = p; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.EDIT_MODE_CHANGED, this._editMode ) )
		}
		public function get  editMode ( ) : Boolean  { return this._editMode   }		
		
		private var _adminMode : Boolean = false
		public function set adminMode ( p : Boolean )  : void
		{
			this._adminMode = p; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.ADMIN_MODE_CHANGED, this._adminMode ) )
		}
		public function get  adminMode ( ) : Boolean  { return this._adminMode   }		
				
		public function refreshBoard()  : void
		{
			//this.editMode = false; 
			this.dispatch( new Event(  BuildBoardCommand.BUILD_BOARD  ) ) 
			this.dispatch( new PanicModelEvent( PanicModelEvent.REFRESH_BOARD, this._board ) )
			
		}
			
		public var boardHolder : Group
		
		
		
		
		
		
		
		
		
		public var boardName : String = ''; 
		
		/**
		 * Tells us if binding is used
		 * */
		public function sourced( s : String )  :  Boolean
		{
			var sourced :  Boolean = false
			if ( s.indexOf('{') != -1  ) //that is non espaced?  
				sourced = true
				//if index before example is not escaped ... still no goo
			return sourced
		}
		
		
	}
}