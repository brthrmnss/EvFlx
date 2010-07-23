package org.syncon.evernote.basic.model
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		
		public var data: Object;
		
		public function CustomEvent(type:String, _data:Object = null)
		{
			data = _data;
			super(type, true, true );
		}
	 
	}
}