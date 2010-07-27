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
			
		public static const GET_SYNC_CHUNK:String = "getSyncChunkTrigger";
		public static const GET_NOTEBOOK:String = "getNotebookTrigger";
		public static const CREATE_NOTEBOOK:String = "createNotebookTrigger";
		public static const UPDATE_NOTEBOOK:String = "updateNotebookTrigger";
		public static const EXPUNGE_NOTEBOOK:String = "expungeNotebookTrigger";
		public static const LIST_TAGS_BY_NOTEBOOK:String = "listTagsByNotebookTrigger";
		public static const GET_TAG:String = "getTagTrigger";
		public static const CREATE_TAG:String = "createTagTrigger";
		public static const UPDATE_TAG:String = "updateTagTrigger";
		public static const UNTAG_ALL:String = "untagAllTrigger";
		public static const EXPUNGE_TAG:String = "expungeTagTrigger";
		public static const GET_SEARCH:String = "getSearchTrigger";
		public static const CREATE_SEARCH:String = "createSearchTrigger";
		public static const UPDATE_SEARCH:String = "updateSearchTrigger";
		public static const EXPUNGE_SEARCH:String = "expungeSearchTrigger";
		public static const FIND_NOTES:String = "findNotesTrigger";
		public static const FIND_NOTE_COUNTS:String = "findNoteCountsTrigger";
		public static const GET_NOTE:String = "getNoteTrigger";
		public static const GET_NOTE_CONTENT:String = "getNoteContentTrigger";
		public static const GET_NOTE_SEARCH_TEXT:String = "getNoteSearchTextTrigger";
		public static const GET_NOTE_TAG_NAMES:String = "getNoteTagNamesTrigger";
		public static const CREATE_NOTE:String = "createNoteTrigger";
		public static const UPDATE_NOTE:String = "updateNoteTrigger";
		public static const DELETE_NOTE:String = "deleteNoteTrigger";
		public static const EXPUNGE_NOTE:String = "expungeNoteTrigger";
		public static const EXPUNGE_NOTES:String = "expungeNotesTrigger";
		public static const COPY_NOTE:String = "copyNoteTrigger";
		public static const LIST_NOTE_VERSIONS:String = "listNoteVersionsTrigger";
		public static const GET_NOTE_VERSION:String = "getNoteVersionTrigger";
		public static const GET_RESOURCE:String = "getResourceTrigger";
		public static const UPDATE_RESOURCE:String = "updateResourceTrigger";
		public static const GET_RESOURCE_DATA:String = "getResourceDataTrigger";
		public static const GET_RESOURCE_BY_HASH:String = "getResourceByHashTrigger";
		public static const GET_RESOURCE_RECOGNITION:String = "getResourceRecognitionTrigger";
		public static const GET_RESOURCE_ALTERNATE_DATA:String = "getResourceAlternateDataTrigger";
		public static const GET_RESOURCE_ATTRIBUTES:String = "getResourceAttributesTrigger";
		public static const GET_ADS:String = "getAdsTrigger";
		public static const GET_RANDOM_AD:String = "getRandomAdTrigger";
		public static const GET_PUBLIC_NOTEBOOK:String = "getPublicNotebookTrigger";
		public static const CREATE_SHARED_NOTEBOOK:String = "createSharedNotebookTrigger";
		public static const EXPUNGE_SHARED_NOTEBOOKS:String = "expungeSharedNotebooksTrigger";
		public static const CREATE_LINKED_NOTEBOOK:String = "createLinkedNotebookTrigger";
		public static const UPDATE_LINKED_NOTEBOOK:String = "updateLinkedNotebookTrigger";
		public static const EXPUNGE_LINKED_NOTEBOOK:String = "expungeLinkedNotebookTrigger";
		public static const STRING:String = "stringTrigger";
		public static const EMAIL_NOTE:String = "emailNoteTrigger";
			
		public var login : String;
		public var password : String;		
		
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
		public var note : Note;
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
		
		
		static public function GetSyncChunk(afterUSN:int, maxEntries:int=0, fullSyncOnly:Boolean=false,
											fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage:String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.GET_SYNC_CHUNK )
			e.afterUSN=afterUSN; e.maxEntries=maxEntries; e.fullSyncOnly=fullSyncOnly; 
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
		
		static public function FindNotes(filter:NoteFilter, offset:int=0, maxNotes:int=1000, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
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
		
		static public function CreateNote(note:Note, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.CREATE_NOTE )
			e.note=note; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		static public function UpdateNote(note:Note, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
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
		//sca
		static public function GetPublicNotebook(userId:int, publicUri:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
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
		
		static public function ExpungeLinkedNotebook(linkedNotebookId:Number, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EXPUNGE_LINKED_NOTEBOOK )
			e.linkedNotebookId=linkedNotebookId; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
	 /*
		static public function String(shareKey:String, authenticationToken:String="", fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.STRING )
			e.shareKey=shareKey; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		*/
		static public function EmailNote(parameters:NoteEmailParameters, fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPICommandTriggerEvent
		{
			var e : EvernoteAPICommandTriggerEvent = new EvernoteAPICommandTriggerEvent( EvernoteAPICommandTriggerEvent.EMAIL_NOTE )
			e.parameters=parameters; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}
		
		 
		
	
	}
}