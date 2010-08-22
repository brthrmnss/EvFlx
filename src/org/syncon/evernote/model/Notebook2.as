package org.syncon.evernote.model
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.IEventDispatcher;
	
	[Event(name="notebookUpdated", type="flash.events.Event")] 		

	public class Notebook2 extends  Notebook implements IEventDispatcher
	{
		static public var  NOTEBOOK_UPDATED : String = 'notebookUpdated';
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
				
		
		public function Notebook2()
		{
		}

		public function notebookUpdated() : void
		{
			this.dispatchEvent( new Event( Notebook2.NOTEBOOK_UPDATED ) )		
		}
				
		public var trashCount : int  = 0; 
		public var noteCount : int = 0 ; 
		/*[Bindable] 
		public var name : String = '' ; */
	}
}