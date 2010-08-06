/**
* Main Model for Application 
*/
package org.syncon.evernote.basic.model
{
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
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
			_savedSearches = new ArrayCollection();			
		}		
 
		private var _notes :  ArrayCollection ; public function get notes () : ArrayCollection { return this._notes }
		private var _searchResult: ArrayCollection 
		private var _notebooks :  ArrayCollection ; public function get notebooks () : ArrayCollection { return this._notebooks }
		private var _tags :  ArrayCollection ; public function get tags () : ArrayCollection { return this._tags }
		private var tagDict : Dictionary = new Dictionary(false)
		private var tagGuidDict : Dictionary = new Dictionary(false)			
		
		private var _savedSearches :  ArrayCollection ; public function get savedSearches () : ArrayCollection { return this._savedSearches }				
		
		public function loadNotes(e:Array)  : void
		{
			/*for each ( var n : Object in e ) 
			{
				trace( n.title + '||' + n.content )
			}*/
			e = convert( e,  Note2 ) 
			this.addAllTo( this._notes,  e  ) 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTES_RESULT, this._notes ) )
		}
		
		public function loadSearch(e:Array)  : void
		{
			this.addAllTo( this._searchResult,  e  ) 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.SEARCH_RESULT, e ) ) 
		}		
		
		private function convert( r : Array, class_  : Class )  :  Array 
		{
			var arr: Array = []; 
			var cf : ClassFactory = new ClassFactory(class_)
			var ee : ObjectUtil
			var props : Object = ObjectUtil.getClassInfo( r[0] ) 
				
			for each ( var o : Object in r ) 
			{
				var o2 :  Object =  cf.newInstance();
				
				for  each ( var prop :   QName in props.properties ) 
				{
					o2[prop.localName] = o[prop.localName] 
				}
				arr.push( o2 ) 
			}
			return arr; 
		}
		
		public function clone( to:Object, from :Object)  : void
		{
			var props : Object = ObjectUtil.getClassInfo( from ) 
			for  each ( var prop :   QName in props.properties ) 
			{
				to[prop.localName] = from[prop.localName] 
			}			
		}
		
		public function loadNotebooks(e:Array)  : void
		{
			var e2 : Array = convert( e, Notebook2 ) 
			this.addAllTo( this._notebooks,  e2  ) 
			for each ( var n : Notebook2 in e2 ) 
			{
				if ( n.defaultNotebook ) this._defaultNotebook = n; 
			}
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, e ) ) 
		}	
		
		public function loadTags(e:Array)  : void
		{
			this.addAllTo( this._tags,  e  ) 
			this.tagDict = new Dictionary(true) 
			tagGuidDict = new Dictionary(false)
			for each ( var tag : Tag in this.tags ) 
			{
				this.tagDict[tag.name] = tag
				this.tagGuidDict[tag.guid] = tag; 
			}				
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.RECIEVED_TAGS, e ) ) 
		}			
		
		public function loadSavedSearches(e:Array)  : void
		{
			this.addAllTo( this._savedSearches,  e  ) 
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
		
		public var notebook : Notebook2 = new Notebook2();
		public var _defaultNotebook : Notebook2 = new Notebook2();public function get defaultNotebook()  :  Notebook2 { return this._defaultNotebook }
		
		public function currentNotebook( n : Notebook2 )  : void
		{
			this.notebook = n; 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.CURRENT_NOTEBOOK_CHANGED, n ) ) 
		}
		
		public function createNewNote()  :  Note2
		{
			var note :  Note2 = new Note2();
			note.title = 'Note Title'
			note.notebookGuid = this.defaultNotebook.guid
			
			return note 	
		}
		
		public function convertTagNamesToTags( names :  Array )  : Array
		{
			var tags :  Array = []; 
			for each ( var tagName : String in names ) 
			{
				if (  this.tagDict[tagName] != null ) 
				tags.push( this.tagDict[tagName] ) 
			}
			return tags 
		}
		public function convertTagGuidsToTags( guids :  Array )  : Array
		{
			var tags :  Array = []; 
			for each ( var tagGuid : String in guids ) 
			{
				if (  this.tagGuidDict[tagGuid] != null ) 
					tags.push( this.tagGuidDict[tagGuid] ) 
			}
			return tags 
		}		
		
		private var _trashSize : int =0; 
		public function get trashSize()  : int { return this._trashSize } 
		public function set  trashCount( n : int )  : void
		{
			this._trashSize = n; 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.TRASH_SIZE_CHANGED, n ) ) 
		}
		
	}
}