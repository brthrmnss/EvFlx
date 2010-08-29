/**
* Main Model for Application 
*/
package org.syncon.evernote.basic.model
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
	import org.syncon.evernote.basic.vo.PreferencesVO;
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Notebook2;
	import org.syncon.evernote.model.Tag2;
	import org.syncon.popups.controller.ShowPopupEvent;

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
	 * Dispatched when ...
	 */
	[Event(name="preferencesChanged", type="org.syncon.evernote.basic.model.EvernoteAPIModelEvent")]
		
	/**
	* keeps track of all popups cleans up
	 * ensures stacking order respected
	*/
	public class   EvernoteAPIModel   extends Actor 
	{
		static public var EvernoteUrl : String = 'sandbox.evernote.com'
		public function EvernoteAPIModel()
		{
			_notes = new ArrayCollection();
			_searchResult = new ArrayCollection();
			_notebooks =  new ArrayCollection();
			_tags = new ArrayCollection();
			_savedSearches = new ArrayCollection();			
			this.allNotebooks = new Notebook2()
			this.allNotebooks.name = 'All Notebooks'
			this.allNotebooks.guid = '-1'
			this.timerRefreshToken.addEventListener(TimerEvent.TIMER, this.refreshToken ) 
		}		
 
		private var timerRefreshToken : Timer = new Timer(0); 
	
		
		private var _notes :  ArrayCollection ; public function get notes () : ArrayCollection { return this._notes }
		private var _searchResult: ArrayCollection 
		private var _notebooks :  ArrayCollection ; public function get notebooks () : ArrayCollection { return this._notebooks }
		private var _tags :  ArrayCollection ; public function get tags () : ArrayCollection { return this._tags }
		private var tagDict : Dictionary = new Dictionary(false)
		private var tagGuidDict : Dictionary = new Dictionary(false)			
		
		private var _savedSearches :  ArrayCollection ; public function get savedSearches () : ArrayCollection { return this._savedSearches }				
		
		/**
		 * All notebook option, guid is -1
		 * */
		private var allNotebooks : Notebook2 = new Notebook2(); 
		public function get allNotebooksGuid ()  :  String { return '-1' } 
		private var _noteCount : int =0; 
		public function get noteCount()  : int { return this._noteCount } 
		public function set  noteCount( n : int )  : void
		{
			this._noteCount = n; 
			this.allNotebooks.noteCount = n; 
			this.allNotebooks.notebookUpdated()
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTE_COUNT_CHANGED, n ) ) 
		}
		
		private var _preferences :  PreferencesVO = new PreferencesVO();
		public function set preferences ( p : PreferencesVO )  : void
		{
			this._preferences = p; 
			this.dispatch( new EvernoteAPIModelEvent( EvernoteAPIModelEvent.PREFERENCES_CHANGED, this._preferences ) )
		}
		public function get  preferences ( ) : PreferencesVO  { return this._preferences   }		
		
		private var _user : User = new User();
		public function set user ( p : User )  : void
		{
			this._user = p; 
			this.dispatch( new EvernoteAPIModelEvent( EvernoteAPIModelEvent.USER_CHANGED, this._user ) )
		}
		public function get  user ( ) : User  { return this._user   }	
		
		public var auth : AuthenticationResult;
		
		private var _syncState :  SyncState = new SyncState();
		public function set acctSyncState ( p : SyncState )  : void
		{
			this._syncState = p; 
			this.dispatch( new EvernoteAPIModelEvent( EvernoteAPIModelEvent.SYNC_STATE_CHANGED, this._syncState ) )
		}		
		
		public function get  acctSyncState ( ) : SyncState  { return this._syncState   }		
	
		public function notebooksAndAll()  :  ArrayCollection
		{
			var arr :  ArrayCollection =new ArrayCollection( this.notebooks.toArray() )
			arr.addItem( this.allNotebooks ) 
			return arr; 
		}
	
		public function loadNotes(e:Array)  : void
		{
			/*for each ( var n : Object in e ) 
			{
				trace( n.title + '||' + n.content )
			}*/
			e = convert( e,  Note2 ) 
			for each ( var n : Note2 in e ) 
			{
				n.thumb = 'http://'+EvernoteUrl+'/shard/'+this.user.shardId +'/thumb/'+n.guid +'?seq='+n.updateSequenceNum
				//http://www.evernote.com/shard/s26/thumb/e30e9d50-1698-4e37-a891-ff05f703d24f?seq=65
				//http://sandbox.evernote.com/shard/s1/thumb/941f07d2-6b0a-4fdd-8e75-75260425477f?=414
				//http://sandbox.evernote.com/shard/s1/thumb/88a1680e-29e5-4b20-813f-cbe6341d3b05?seq=385
				if ( this.auth != null ) 
				n.auth = this.auth.authenticationToken
			}		
			this.addAllTo( this._notes,  e  ) 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTES_RESULT, this._notes ) )
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTES_CHANGED, this._notes ) )
		}
		
		public function addNote(n:Note2):void
		{
			this._notes.addItemAt( n,0)
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTES_CHANGED, this._notes ) )
		}
		
		public function changedNoteNotebook(note : Note2, oldNotebook : Notebook2 )  : void
		{
			for each ( var nb : Notebook2 in this.notebooks )
			{
				if ( nb.guid == note.notebookGuid ) 
				{
					nb.noteCount++; nb.notebookUpdated()
					this.noteCount++
				}
				if ( nb.guid == oldNotebook.guid ) 
				{
					nb.noteCount--; nb.notebookUpdated()
					this.noteCount--
				}				
			}
			//return; ... 
		}
		
		public function removeNotes(notes : Array )  : void
		{
			for each ( var note :  Note2 in notes ) 
			{
				if ( this._notes.getItemIndex( note ) != -1 ) 
					this._notes.removeItemAt( this._notes.getItemIndex( note ) ) 
			}
			this.noteCount -= notes.length
			this.trashCount +=  notes.length
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.NOTES_CHANGED, this._notes ) )
		}
		
		public function loadSearch(e:Array)  : void
		{
			this.addAllTo( this._searchResult,  e  ) 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.SEARCH_RESULT, e ) ) 
		}		
		
		public function convert( r : Array, class_  : Class )  :  Array 
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
					if ( o.hasOwnProperty( prop.localName ) )
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
			var e : Array = convert( e, Notebook2 ) 
			this.addAllTo( this._notebooks,  e  ) 
			for each ( var n : Notebook2 in e ) 
			{
				if ( n.defaultNotebook ){
					this._defaultNotebook = n; 
				//	this.currentNotebook(  n ) ; //do not set the current notebook to be teh default, it is 'all' by default 
				}
			}
			
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, e ) ) 
		}	
		/*
		public function loadNotebookCounts( notebookCounts : Dictionary, trashCounts : Dictionary ) : void
		{
			
		}
		*/
		public function loadTags(e:Array)  : void
		{
			var e : Array = convert( e, Tag2 ) 
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
			note.active = true; 
			note.content = ''; 
			note.lastRetrievedTime = new Date();
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
		
		private var _trashCount : int =0; 
		public function get trashCount()  : int { return this._trashCount } 
		public function set  trashCount( n : int )  : void
		{
			this._trashCount = n; 
			this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.TRASH_SIZE_CHANGED, n ) ) 
		}
		
		public var blocking :  ArrayCollection = new ArrayCollection()
		public var calls :  Dictionary = new Dictionary(true);
		public function    loadingAdd( index : Object, name : String, blockingP : Boolean = false )  : void
		{
			calls[index] = name
			if ( blockingP ) 
				blocking.addItem( index ) 
			 this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.LOADING_CHANGED  ) ) 
		}
		public function    loadingRemove( index : Object )  : void
		{
			delete calls[index] 
			if ( this.blocking.getItemIndex( index) != -1 )
				{ 
					if ( this.blocking.length > 0 ) 
						blocking.removeItemAt(  this.blocking.getItemIndex( index) )
					
				}
			 this.dispatch( new  EvernoteAPIModelEvent( EvernoteAPIModelEvent.LOADING_CHANGED  ) ) 
		}				
		
		public function authenticated(auth :  AuthenticationResult):void
		{
			this.preferences.username = auth.user.username; 
			this.user = auth.user; 
			this.auth = auth; 
			this.authenticationRefreshed( auth, false ) 
			this.dispatch( new EvernoteAPIModelEvent(EvernoteAPIModelEvent.AUTHENTICATED ) )
		}

		private function refreshToken(e:Event) : void
		{
			this.timerRefreshToken.stop()	
			import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
			this.dispatch(  EvernoteAPICommandTriggerEvent.RefreshAuthentication() ) 
		}			
		
		/**
		 * Called when authtnetcaion refreshed, user  not supplied */
		public function authenticationRefreshed(auth :  AuthenticationResult, dispatchEvt : Boolean = true):void
		{
			var expirationMs : Number = auth.expiration  - auth.currentTime;  
			this.timerRefreshToken.stop(); 
			if ( isNaN( expirationMs ) ) 
				return; 
			this.timerRefreshToken.delay = expirationMs-1000
			//this.timerRefreshToken.delay = 1000; 
			this.timerRefreshToken.start()
			if ( dispatchEvt ) 
			this.dispatch( new EvernoteAPIModelEvent(EvernoteAPIModelEvent.AUTHENTICATION_REFRESHED ) )
		}		
		
		public function map( objs : Array, prop : String  ) : Array
		{
			var arr : Array = []; 
			for each ( var j : Object in objs ) 
			{
				arr.push( j[prop] ) 
			}
			return arr 
		}
		
		public function logOut() : void
		{
			this.loadNotebooks([])
			this.loadNotes( [] )
			this.loadSavedSearches( [] )
			this.loadSearch( [] )
			this.loadTags( [] )
				
			this.trashCount = 0 
			//this.trashCount = 0; 
			
			var blankAuth :  AuthenticationResult = new AuthenticationResult()
			blankAuth.user = new User()
			this.authenticated( blankAuth ) 
				
			this.dispatch( new ShowPopupEvent( 
				ShowPopupEvent.SHOW_POPUP, 
				'popup_login' ) );	
		}
			
		
		
		public function moreThanXMinutesAgo(mins : Number, date : Date )  :  Boolean
		{
			var currentTime : Date = new Date();
			var ms : Number = mins*60*1000
			if ( date == null ) 
				return true
			if ( date.getTime() + ms < currentTime.getTime() ) 
			{
				return true
			}
			
			return false
		}
		
		public function set status( s : String )  : void
		{
			return;
		}
			
			
		
	}
}