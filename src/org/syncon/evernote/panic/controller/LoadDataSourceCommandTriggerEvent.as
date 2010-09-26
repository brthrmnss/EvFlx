package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
 
	public class LoadDataSourceCommandTriggerEvent extends  Event
	{
		static public var LOAD_SOURCE : String = 'loadSource'
		public var src : String; 			
		public var host : Object; 
		public var property : String; 
		public var fxSet : Function; 
		public function LoadDataSourceCommandTriggerEvent(type:String, src : String, host : Object, property : String, fxSet : Function = null )  
		{	
			this.src = src
			this.host = host
			this.property = property
			this.fxSet = fxSet
				
			super(type, true);
		}
		
		
	}
}