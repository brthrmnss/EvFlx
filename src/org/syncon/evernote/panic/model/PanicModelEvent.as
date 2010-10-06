package  org.syncon.evernote.panic.model
{
	import flash.events.Event;
	
	public class PanicModelEvent extends Event
	{
		public static const NOTES_RESULT:String = 'notesRecieved';
		public static const NOTES_CHANGED:String = 'notesChanged';		
		
		public static const SEARCH_RESULT : String = 'searchResult';
		//public static const NOTEBOOK_RESULT : String = 'notebookResult';
		public static const CURRENT_NOTEBOOK_CHANGED : String = 'currentNotebookChanged';
		public static const RECIEVED_TAGS : String = 'recievedTags';		
		public static const RECIEVED_SAVED_SEARCHES : String = 'recievedSavedSearches';		
		public static const RECIEVED_NOTEBOOK_LIST : String = 'recievedNotebookList';				
		
		public static const TRASH_SIZE_CHANGED : String = 'trashSizeChanged';
		public static const BOARD_CHANGED : String = 'boardChanged'
		public static const REFRESH_BOARD : String = 'refreshBoard'			
		public static const USER_CHANGED : String = ' userChanged'
			
		public static const SYNC_STATE_CHANGED : String = ' syncStateChanged'			
		
			
		public static const LOADING_CHANGED : String = 'loadingChanged'
		/**
		 * Where was this supposed to be hooked up? on the notebooks? for ALL NOTEBOOKS?
		 * */
		public static const NOTE_COUNT_CHANGED : String = 'noteCountChanged'			
			
		public static const AUTHENTICATED : String = 'authenticated' 
		public static const AUTHENTICATION_REFRESHED : String = 'AUTHENTICATION_REFRESHED' 			
		
		public static const LOGOUT : String = 'logout'		
			
		public static const EDIT_MODE_CHANGED : String = 'editModeChanged' ; 
		public static const ADMIN_MODE_CHANGED : String = 'adminModeChanged' ; 
		
		public static const HIGHLIGHT_ROWS : String = 'highlightRows' ; 
		public static const HIGHLIGHT_CERTAIN_ITEMS : String = 'highlightCertainItems' ; 		
		public static const HIGHLIGHT_CERTAIN_ITEMS_SELECTED : String = 'highlightItemSelected' ; 
		
		public static const CHANGED_PEOPLE : String = 'changedPeople' ; 		
		public static const CHANGED_PROJECTS : String = 'changedProjects' ; 
		
		public static const SUPRESS_TWEENS_CHANGED : String = 'surpressTweensChanged' ; 
		
		public var data: Object;
		
		public function PanicModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}