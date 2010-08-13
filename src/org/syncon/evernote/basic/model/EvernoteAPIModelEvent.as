package org.syncon.evernote.basic.model
{
	import flash.events.Event;
	
	public class EvernoteAPIModelEvent extends Event
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
		public static const PREFERENCES_CHANGED : String = ' preferencesChanged'
		
		public static const LOADING_CHANGED : String = 'loadingChanged'
		/**
		 * Where was this supposed to be hooked up? on the notebooks? for ALL NOTEBOOKS?
		 * */
		public static const NOTE_COUNT_CHANGED : String = 'noteCountChanged'			
			
		public static const AUTHENTICATED : String = 'authenticated' 
		public static const LOGOUT : String = 'logout'			
		public var data: Object;
		
		public function EvernoteAPIModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}