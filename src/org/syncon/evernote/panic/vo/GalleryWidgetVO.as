package org.syncon.evernote.panic.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.syncon.evernote.basic.model.CustomEvent;	
	[Event(name="personUpdated", type="flash.events.Event")] 		
	public class GalleryWidgetVO extends  EventDispatcher
	{
		 
		
		public var id : String = ''; 
		
		public var name :  String = ''
		public var src :  String = ''; 
		public var desc :  String = ''; 		
		public var data :    Object = null; 				
		public function GalleryWidgetVO( name_ : String='', desc : String = '', 
								     src : String = '' , data_ :  Object = null  ) 
		{
			this.name = name_
			 this.desc = desc
			this.src = src;  
			this.data = data_
			//this.id = (new Date()).getTime().toString()+'_'+(Math.random()*100000).toString()
			super();
		}
	 
	}
}