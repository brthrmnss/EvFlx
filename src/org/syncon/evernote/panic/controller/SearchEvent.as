package org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	
	public class SearchEvent extends Event
	{
		
		public static const SEARCHED : String = 'searched'
		/**
		 * When search keywords are changed, notifies app and updates search query box
		 * */
		public static const SEARCH_UPDATED :  String = 'searchUpdated'
			
		public static const SEARCH_TAGS_UPDATED : String = 'searchTagsUpdated'; 
			
		public var query:  String;
		public var objs : Array;
		
		public function SearchEvent(type:String, query_: String= '', objecs : Array=null)
		{
			super(type);
			query = query_;
			objs  = objecs
		}
	
	}
}