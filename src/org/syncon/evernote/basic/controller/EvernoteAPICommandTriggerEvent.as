package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	
	public class EvernoteAPICommandTriggerEvent extends Event
	{
		public static const SHOW_POPUP:String = 'showPopup';
		public static const CREATE_LINKED_NOTEBOOK_TRIGGER:String = 'CREATE_LINKED_NOTEBOOK_TRIGGER'
	
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
		static public function CreateLinkedNotebook( args : Array, fxSuccess : Function=null,
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
		
		
		
	
	}
}