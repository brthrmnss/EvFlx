package   org.syncon.evernote.basic.controller
{
	import com.evernote.edam.notestore.*;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteStore;
	import com.evernote.edam.notestore.NoteStoreImpl;
	import com.evernote.edam.type.*;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.User;
	import com.evernote.edam.userstore.AuthenticationResult;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.syncon.evernote.model.Note2;

	/**
	 * Maps note store of Evernote API
	 * ui --> [ (model-->) command-trigger --> command  --> service 
	 * <wait/response> 
	 * service --> command --> model ]--> ui
	 * */
	public class EvernoteAPICommandTriggerEvent extends Event
	{
		public static const SHOW_POPUP:String = 'showPopup';
		public static const CREATE_LINKED_NOTEBOOK_TRIGGER:String = 'CREATE_LINKED_NOTEBOOK_TRIGGER'
		public static const AUTHENTICATE:String = 'authenticate'
		
		public static const GET_SYNC_STATE:String = "getSyncStateTriggerEvent";
		public static const GET_SYNC_CHUNK:String = "getSyncChunkTriggerEvent";
		public static const LIST_NOTEBOOKS:String = "listNotebooksTriggerEvent";
		public static const GET_NOTEBOOK:String = "getNotebookTriggerEvent";
		public static const GET_DEFAULT_NOTEBOOK:String = "getDefaultNotebookTriggerEvent";
		public static const CREATE_NOTEBOOK:String = "createNotebookTriggerEvent";
		public static const UPDATE_NOTEBOOK:String = "updateNotebookTriggerEvent";
		public static const EXPUNGE_NOTEBOOK:String = "expungeNotebookTriggerEvent";
		public static const LIST_TAGS:String = "listTagsTriggerEvent";
		public static const LIST_TAGS_BY_NOTEBOOK:String = "listTagsByNotebookTriggerEvent";
		public static const GET_TAG:String = "getTagTriggerEvent";
		public static const CREATE_TAG:String = "createTagTriggerEvent";
		public static const UPDATE_TAG:String = "updateTagTriggerEvent";
		public static const UNTAG_ALL:String = "untagAllTriggerEvent";
		public static const EXPUNGE_TAG:String = "expungeTagTriggerEvent";
		public static const LIST_SEARCHES:String = "listSearchesTriggerEvent";
		public static const GET_SEARCH:String = "getSearchTriggerEvent";
		public static const CREATE_SEARCH:String = "createSearchTriggerEvent";
		public static const UPDATE_SEARCH:String = "updateSearchTriggerEvent";
		public static const EXPUNGE_SEARCH:String = "expungeSearchTriggerEvent";
		public static const FIND_NOTES:String = "findNotesTriggerEvent";
		public static const FIND_NOTE_COUNTS:String = "findNoteCountsTriggerEvent";
		public static const GET_NOTE:String = "getNoteTriggerEvent";
		public static const GET_NOTE_CONTENT:String = "getNoteContentTriggerEvent";
		public static const GET_NOTE_SEARCH_TEXT:String = "getNoteSearchTextTriggerEvent";
		public static const GET_NOTE_TAG_NAMES:String = "getNoteTagNamesTriggerEvent";
		public static const CREATE_NOTE:String = "createNoteTriggerEvent";
		public static const UPDATE_NOTE:String = "updateNoteTriggerEvent";
		public static const DELETE_NOTE:String = "deleteNoteTriggerEvent";
		public static const EXPUNGE_NOTE:String = "expungeNoteTriggerEvent";
		public static const EXPUNGE_NOTES:String = "expungeNotesTriggerEvent";
		public static const EXPUNGE_INACTIVE_NOTES:String = "expungeInactiveNotesTriggerEvent";
		public static const COPY_NOTE:String = "copyNoteTriggerEvent";
		public static const LIST_NOTE_VERSIONS:String = "listNoteVersionsTriggerEvent";
		public static const GET_NOTE_VERSION:String = "getNoteVersionTriggerEvent";
		public static const GET_RESOURCE:String = "getResourceTriggerEvent";
		public static const UPDATE_RESOURCE:String = "updateResourceTriggerEvent";
		public static const GET_RESOURCE_DATA:String = "getResourceDataTriggerEvent";
		public static const GET_RESOURCE_BY_HASH:String = "getResourceByHashTriggerEvent";
		public static const GET_RESOURCE_RECOGNITION:String = "getResourceRecognitionTriggerEvent";
		public static const GET_RESOURCE_ALTERNATE_DATA:String = "getResourceAlternateDataTriggerEvent";
		public static const GET_RESOURCE_ATTRIBUTES:String = "getResourceAttributesTriggerEvent";
		public static const GET_ACCOUNT_SIZE:String = "getAccountSizeTriggerEvent";
		public static const GET_ADS:String = "getAdsTriggerEvent";
		public static const GET_RANDOM_AD:String = "getRandomAdTriggerEvent";
		public static const GET_PUBLIC_NOTEBOOK:String = "getPublicNotebookTriggerEvent";
		public static const CREATE_SHARED_NOTEBOOK:String = "createSharedNotebookTriggerEvent";
		public static const LIST_SHARED_NOTEBOOKS:String = "listSharedNotebooksTriggerEvent";
		public static const EXPUNGE_SHARED_NOTEBOOKS:String = "expungeSharedNotebooksTriggerEvent";
		public static const CREATE_LINKED_NOTEBOOK:String = "createLinkedNotebookTriggerEvent";
		public static const UPDATE_LINKED_NOTEBOOK:String = "updateLinkedNotebookTriggerEvent";
		public static const LIST_LINKED_NOTEBOOKS:String = "listLinkedNotebooksTriggerEvent";
		public static const EXPUNGE_LINKED_NOTEBOOK:String = "expungeLinkedNotebookTriggerEvent";
		public static const AUTHENTICATE_TO_SHARED_NOTEBOOK:String = "authenticateToSharedNotebookTriggerEvent";
		public static const GET_SHARED_NOTEBOOK_BY_AUTH:String = "getSharedNotebookByAuthTriggerEvent";
		public static const EMAIL_NOTE:String = "emailNoteTriggerEvent";
		
		public var login : String;
		public var password : String;		
		
		public var tokenData : Object; 
		public var tokenDate : Number;
				
		public var authenticationToken : String;
		public var afterUSN : int;
		public var maxEntries : int;
		public var fullSyncOnly : Boolean;
		public var guid : String;
		public var notebook : Notebook;
		public var notebookGuid : String;
		public var tag : Tag;
		public var search : SavedSearch;
		public var filter : NoteFilter;
		public var offset : int;
		public var maxNotes : int;
		public var withTrash : Boolean;
		public var withContent : Boolean;
		public var withResourcesData : Boolean;
		public var withResourcesRecognition : Boolean;
		public var withResourcesAlternateData : Boolean;
		public var note :  Note2;
		public var noteGuids : Array;
		public var noteGuid : String;
		public var toNotebookGuid : String;
		public var updateSequenceNum : int;
		public var withData : Boolean;
		public var withRecognition : Boolean;
		public var withAttributes : Boolean;
		public var withAlternateData : Boolean;
		public var resource : Resource;
		public var contentHash : ByteArray;
		public var adParameters : AdParameters;
		public var userId : int;
		public var publicUri : String;
		public var sharedNotebook : SharedNotebook;
		public var sharedNotebookIds : Array;
		public var linkedNotebook : LinkedNotebook;
		public var linkedNotebookId : Number;
		public var shareKey : String;
		public var parameters : NoteEmailParameters;		
		/*
		public var class_ : Class; 
		public var name : String; 
		public var popup : Object; 
		public var args : Object; 
		public var fx : String = 'open';
		*/
		public var fxSuccess : Function;
		public var fxFault : Function; 
		public var alert : Boolean = false
		public var alertMessage : String  = ''; 
		public var args : Object; 
		
		public function EvernoteAPICommandTriggerEvent(type:String,    args_ : Object = null )  
		{	
			this.args = args_
			super(type, true);
		}
		
		/** Event method that can create the event 
		 * all params are considered optional**/
		
		
		static public function Authenticate( username : String, password :  String, fxSuccess : Function=null,
											 fxFault: Function=null, alert:Boolean=false, alertMessage : String = '' ) :  EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.AUTHENTICATE )
			e.login = username; e.password = password; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage )
			return e; 
		}		
		
		static public function CreadteLinkedNotebook( args : Array, fxSuccess : Function=null,
													  fxFault: Function=null, alert:Boolean=false, alertMessage : String = '' ) :  EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK_TRIGGER )
			//e.x = x; e.y=y;
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage )
			return e; 
		}
		
		public function optionalParameters(   fxSuccess_:  Function = null ,
											  fxFault_ : Function = null, alert_ : Boolean = false , 
											  alertMessage_ :  String = '' ) : void
		{	
			this.fxSuccess = fxSuccess_
			this.fxFault = fxFault_		
			alert = alert_
			alertMessage = alertMessage_
		}		
		
		/**
		 * Static Class Factory for Trigger Events, do not modify
		 * */
		static public function GetSyncState( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_SYNC_STATE )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetSyncChunk(afterUSN:int, maxEntries:int=0, fullSyncOnly:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_SYNC_CHUNK )
			e.afterUSN=afterUSN; e.maxEntries=maxEntries; e.fullSyncOnly=fullSyncOnly; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ListNotebooks( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.LIST_NOTEBOOKS )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetNotebook(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_NOTEBOOK )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetDefaultNotebook( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_DEFAULT_NOTEBOOK )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function CreateNotebook(notebook:Notebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_NOTEBOOK )
			e.notebook=notebook; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UpdateNotebook(notebook:Notebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.UPDATE_NOTEBOOK )
			e.notebook=notebook; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeNotebook(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_NOTEBOOK )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ListTags( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.LIST_TAGS )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ListTagsByNotebook(notebookGuid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.LIST_TAGS_BY_NOTEBOOK )
			e.notebookGuid=notebookGuid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetTag(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_TAG )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function CreateTag(tag:Tag, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_TAG )
			e.tag=tag; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UpdateTag(tag:Tag, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.UPDATE_TAG )
			e.tag=tag; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UntagAll(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.UNTAG_ALL )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeTag(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_TAG )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ListSearches( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.LIST_SEARCHES )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetSearch(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_SEARCH )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function CreateSearch(search:SavedSearch, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_SEARCH )
			e.search=search; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UpdateSearch(search:SavedSearch, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.UPDATE_SEARCH )
			e.search=search; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeSearch(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_SEARCH )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function FindNotes(filter:NoteFilter, offset:int=0, maxNotes:int=0, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.FIND_NOTES )
			e.filter=filter; e.offset=offset; e.maxNotes=maxNotes; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function FindNoteCounts(filter:NoteFilter, withTrash:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.FIND_NOTE_COUNTS )
			e.filter=filter; e.withTrash=withTrash; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetNote(guid:String, withContent:Boolean=false, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_NOTE )
			e.guid=guid; e.withContent=withContent; e.withResourcesData=withResourcesData; e.withResourcesRecognition=withResourcesRecognition; e.withResourcesAlternateData=withResourcesAlternateData; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetNoteContent(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_NOTE_CONTENT )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetNoteSearchText(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_NOTE_SEARCH_TEXT )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetNoteTagNames(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_NOTE_TAG_NAMES )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function CreateNote(note:Note2, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_NOTE )
			e.note=note; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UpdateNote(note:Note2, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.UPDATE_NOTE )
			e.note=note; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function DeleteNote(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.DELETE_NOTE )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeNote(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_NOTE )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeNotes(noteGuids:Array, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_NOTES )
			e.noteGuids=noteGuids; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeInactiveNotes( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_INACTIVE_NOTES )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function CopyNote(noteGuid:String, toNotebookGuid:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.COPY_NOTE )
			e.noteGuid=noteGuid; e.toNotebookGuid=toNotebookGuid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ListNoteVersions(noteGuid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.LIST_NOTE_VERSIONS )
			e.noteGuid=noteGuid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetNoteVersion(noteGuid:String, updateSequenceNum:int=0, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_NOTE_VERSION )
			e.noteGuid=noteGuid; e.updateSequenceNum=updateSequenceNum; e.withResourcesData=withResourcesData; e.withResourcesRecognition=withResourcesRecognition; e.withResourcesAlternateData=withResourcesAlternateData; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetResource(guid:String, withData:Boolean=false, withRecognition:Boolean=false, withAttributes:Boolean=false, withAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_RESOURCE )
			e.guid=guid; e.withData=withData; e.withRecognition=withRecognition; e.withAttributes=withAttributes; e.withAlternateData=withAlternateData; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UpdateResource(resource:Resource, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.UPDATE_RESOURCE )
			e.resource=resource; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetResourceData(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_RESOURCE_DATA )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetResourceByHash(noteGuid:String, contentHash:ByteArray=null, withData:Boolean=false, withRecognition:Boolean=false, withAlternateData:Boolean=false, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_RESOURCE_BY_HASH )
			e.noteGuid=noteGuid; e.contentHash=contentHash; e.withData=withData; e.withRecognition=withRecognition; e.withAlternateData=withAlternateData; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetResourceRecognition(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_RESOURCE_RECOGNITION )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetResourceAlternateData(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_RESOURCE_ALTERNATE_DATA )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetResourceAttributes(guid:String, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_RESOURCE_ATTRIBUTES )
			e.guid=guid; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetAccountSize( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_ACCOUNT_SIZE )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetAds(adParameters:AdParameters, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_ADS )
			e.adParameters=adParameters; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetRandomAd(adParameters:AdParameters, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_RANDOM_AD )
			e.adParameters=adParameters; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetPublicNotebook(userId: Number, publicUri:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_PUBLIC_NOTEBOOK )
			e.userId=userId; e.publicUri=publicUri; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function CreateSharedNotebook(sharedNotebook:SharedNotebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_SHARED_NOTEBOOK )
			e.sharedNotebook=sharedNotebook; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ListSharedNotebooks( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.LIST_SHARED_NOTEBOOKS )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeSharedNotebooks(sharedNotebookIds:Array, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_SHARED_NOTEBOOKS )
			e.sharedNotebookIds=sharedNotebookIds; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function CreateLinkedNotebook(linkedNotebook:LinkedNotebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK )
			e.linkedNotebook=linkedNotebook; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UpdateLinkedNotebook(linkedNotebook:LinkedNotebook, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.UPDATE_LINKED_NOTEBOOK )
			e.linkedNotebook=linkedNotebook; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ListLinkedNotebooks( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.LIST_LINKED_NOTEBOOKS )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function ExpungeLinkedNotebook(linkedNotebookId:Number, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_LINKED_NOTEBOOK )
			e.linkedNotebookId=linkedNotebookId; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function AuthenticateToSharedNotebook(shareKey:String, authenticationToken:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK )
			e.shareKey=shareKey; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function GetSharedNotebookByAuth( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_SHARED_NOTEBOOK_BY_AUTH )
				; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function EmailNote(parameters:NoteEmailParameters, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EMAIL_NOTE )
			e.parameters=parameters; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		/**
		 * Modified version that can dispatch events to note
		 * */
		static public function GetNoteTagNames2(note:Note2, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_NOTE_TAG_NAMES )
			e.guid=note.guid; e.note = note; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}				
		
		
	}
}