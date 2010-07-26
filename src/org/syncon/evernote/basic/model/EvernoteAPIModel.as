/**
* Main Model for Application 
*/
package org.syncon.evernote.basic.model
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.UIComponent;
	
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Actor;

	/**
	 * Dispatched when ...
	 */
	[Event(name="notesRecieved", type="org.syncon.evernote.basic.model.EvernoteAPIModelEvent")]
	
	/**
	 * Dispatched when ...
	 */
	[Event(name="searchResult", type="org.syncon.evernote.basic.model.EvernoteAPIModelEvent")]
	
	/**
	 * Dispatched when ...
	 */
	[Event(name="notebookResult", type="org.syncon.evernote.basic.model.EvernoteAPIModelEvent")]
	
	/**
	 * Dispatched when ...
	 */
	[Event(name="currentNotebookChanged", type="org.syncon.evernote.basic.model.EvernoteAPIModelEvent")]
	
	/**
	* keeps track of all popups cleans up
	 * ensures stacking order respected
	*/
	public class   EvernoteAPIModel   extends Actor 
	{
		public function EvernoteAPIModel()
		{
			_notes = new ArrayCollection();
			_searchResult = new ArrayCollection();
			_notebooks =  new ArrayCollection();
			_tags = new ArrayCollection();
		}		
 
		private var _notes :  ArrayCollection ; public function get notes () : ArrayCollection { return this._notes }
		private var _searchResult: ArrayCollection 
		private var _notebooks :  ArrayCollection ; public function get notebooks () : ArrayCollection { return this._notebooks }
		private var _tags :  ArrayCollection ; public function get tags () : ArrayCollection { return this._tags }		
		
		public function loadNotes(e:Array)  : void
		{
			this.addAllTo( this._notes,  e  ) 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTES_RESULT, e ) )
		}
		
		
		public function loadSearch(e:Array)  : void
		{
			this.addAllTo( this._searchResult,  e  ) 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.SEARCH_RESULT, e ) ) 
		}		
		
		public function loadNotebooks(e:Array)  : void
		{
			this.addAllTo( this._notebooks,  e  ) 
			for each ( var n : Notebook in e ) 
			{
				if ( n.defaultNotebook ) this._defaultNotebook = n; 
			}
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTEBOOK_RESULT, e ) ) 
		}	
		
		public function loadTags(e:Array)  : void
		{
			this.addAllTo( this._tags,  e  ) 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.RECIEVED_TAGS, e ) ) 
		}			
		
		private function addAllTo( e:ArrayCollection, arr : Array )  : void
		{
			e.source = arr; 
			e.refresh()
			/*e.disableAutoUpdate()
			e.removeAll()
			e.
			e.enableAutoUpdate()*/
		}
		
		public var notebook : Notebook = new Notebook();
		public var _defaultNotebook : Notebook = new Notebook();public function get defaultNotebook()  :  Notebook { return this._defaultNotebook }
		
		public function currentNotebook( n : Notebook )  : void
		{
			this.notebook = n; 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.CURRENT_NOTEBOOK_CHANGED, n ) ) 
		}
		
		public function createNewNote()  :   Note
		{
			var note :  Note = new Note();
			note.title = 'Note Title'
			note.notebookGuid = this.defaultNotebook.guid
			
			return note 	
		}
	}
}