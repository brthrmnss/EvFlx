package org.syncon.evernote.model
{
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	[Event(name="tagUpdated", type="flash.events.Event")] 		
	[Event(name="changeParent", type="flash.events.Event")] 		
	
	public class Tag2 extends   Tag implements IEventDispatcher
	{
		static public var  TAG_UPDATED : String = 'tagUpdated';
		static public var  TAG_PARENT_CHANGED : String = 'tagParentChanged'				
			
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
				
		public var noteCount : int = 0 ; 
 
		/*
		override public  function set created(created:  Number):void {
			super.created = created
			var date :  Date = new Date()
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
*/
		//don't init this ...
		//public var tags : ArrayCollection = new ArrayCollection(); 
		
		public function tagUpdated() : void
		{
			this.dispatchEvent( new Event( TAG_UPDATED ) )		
		}
		
		public var children : Array = []; 
		
		public function clone() : Tag2
		{
			var t : Tag2 = new Tag2()
			t.children = this.children
			t.noteCount = this.noteCount; 
			t.parentGuid = this.parentGuid
			t.name = this.name ; 
			t.guid = this.guid; 
			
			return t
		}
	}
}