package org.syncon.evernote.model
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.IEventDispatcher;

	[Event(name="changedTags", type="flash.events.Event")] 		
	[Event(name="updated", type="flash.events.Event")] 	
	
	public class Note2 extends  Note implements IEventDispatcher
	{
		
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IEventDispatcher;   
		
		private var _eventDispatcher : IEventDispatcher;
		
		private function get eventDispatcher() : IEventDispatcher
		{
			if (!_eventDispatcher)
				_eventDispatcher = new EventDispatcher(this);
			
			return _eventDispatcher;
		} 
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
				
		
		public function Note2()
		{
		}
		
		/*[Bindable] 
		public var name : String = '' ; */
	}
}