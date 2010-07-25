package org.syncon.evernote.basic.model
{
	import flash.events.Event;
	
	public class EvernoteBasicModelEvent extends Event
	{
		public static const FOUND_POPUP:String = 'FOUND_POPUP';
		public static const MODAL_SHOW : String = 'MODAL_SHOW';
		public static const MODAL_CLOSED : String = 'MODAL_CLOSED'		;
		
		
		public var data: Object;
		
		public function EvernoteBasicModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
	
	}
}