package org.syncon.evernote.basic.model
{
	import flash.events.Event;
	
	public class EvernoteAPIModelEvent extends Event
	{
		public static const NOTES_RESULT:String = 'notesRecieved';
		public static const SEARCH_RESULT : String = 'searchResult';
		//public static const NOTEBOOK_RESULT : String = 'notebookResult';
		public static const CURRENT_NOTEBOOK_CHANGED : String = 'currentNotebookChanged';
		public static const RECIEVED_TAGS : String = 'recievedTags';		
		public static const RECIEVED_SAVED_SEARCHES : String = 'recievedSavedSearches';		
		public static const RECIEVED_NOTEBOOK_LIST : String = 'recievedNotebookList';				
		
		public static const TRASH_SIZE_CHANGED : String = 'trashSizeChanged';
				
		
		public var data: Object;
		
		public function EvernoteAPIModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}