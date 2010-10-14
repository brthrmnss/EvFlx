package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.SetIncrementorVO;
 
	public class LoadDataSourceCommandTriggerEvent extends  Event
	{
		static public var LOAD_SOURCE : String = 'loadSource'
		public var src : String; 			
		public var host : Object; 
		public var property : String; 
		public var fxSet : Function; 
		public var test : Array = []; 
		
		public var index :  SetIncrementorVO ; 
		
		public function LoadDataSourceCommandTriggerEvent(type:String, src : String, 
														  host : Object, property : String, index_ : SetIncrementorVO = null, fxSet : Function = null,
														test : Array = null)  
		{	
			this.src = src
			this.host = host
			this.property = property
			this.fxSet = fxSet
			this.test = test; 
			this.index = index_
			super(type, true);
		}
		
		
	}
}