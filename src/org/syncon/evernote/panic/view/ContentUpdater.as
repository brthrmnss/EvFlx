package org.syncon.evernote.basic.view
{
	import flash.events.Event;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class ContentUpdater 
	{
		 
		public function ContentUpdater()
		{ 
		} 
		
		static public var dataRecieved : String = 'dataRecieved'
		
		public var location : String
		public var useProxy: String = ''; 
		public var timer : Timer = new Timer()
			
		public function onRecieved() : void
		{
			
		}
		
		public function callNow() : void 
		{
			
		}
		
 
		
	}
}