package org.syncon.evernote.basic.model
{
	import flash.events.Event;
	
	public class EvernoteAPIModelEvent extends Event
	{
		public static const NOTES_RESULT:String = 'notesRecieved';
		public static const SEARCH_RESULT : String = 'searchResult';
		
		public var data: Object;
		
		public function EvernoteAPIModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}