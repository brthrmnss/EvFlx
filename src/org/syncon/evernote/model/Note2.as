package org.syncon.evernote.model
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	
	[Event(name="changedTags", type="flash.events.Event")] 		
	[Event(name="updated", type="flash.events.Event")] 	
	
	
	[Event(name="noteUpdated", type="flash.events.Event")] 		
	[Event(name="noteTagsUpdated", type="flash.events.Event")] 		
	
	public class Note2 extends  Note implements IEventDispatcher
	{
		
		static public var  NOTE_UPDATED : String = 'noteUpdated';
		static public var  NOTE_TAGS_UPDATED : String = 'noteTagsUpdated'				
		
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
				
 
		override public  function set created(created:  Number):void {
			super.created = created
			var date : Date = new Date()
			date.setTime(   created )
			//trace( 'created Note ' + created ) 
			//var dbg : Array = [ date.date, date.month, date.fullYear];
			this.createdAt = date; 
		}		
	 
 		public var createdAt : Date;
		public var updatedAt : Date;		
		 
		
		override public  function set updated(updated:  Number):void {
			super.updated = updated
			var date : Date = new Date()
			date.setTime(   updated )
			//trace( 'created Note ' + created ) 
			//var dbg : Array = [ date.date, date.month, date.fullYear];
			this.updatedAt = date; 
		}		
				
		
		public function Note2()
		{
		}
		
		//don't init this ...
		public var tags : ArrayCollection = new ArrayCollection(); 
		
		public function noteUpdated() : void
		{
			this.dispatchEvent( new Event( NOTE_UPDATED ) )
			this.dispatchEvent( new PropertyChangeEvent(PropertyChangeEventKind.UPDATE) ) 
			dispatchEvent(new PropertyChangeEvent('nameChanged', 
				false, false, PropertyChangeEventKind.UPDATE, 
				'title', 'l', this.title, this));				
		}
		public function tagsUpdated() : void
		{
			this.dispatchEvent( new Event( NOTE_TAGS_UPDATED ) ) 
			this.dispatchEvent( new PropertyChangeEvent(PropertyChangeEventKind.UPDATE) ) 
		}		
	}
}