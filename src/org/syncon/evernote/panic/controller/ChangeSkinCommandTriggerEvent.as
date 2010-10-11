package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.PersonVO;
 
	public class ChangeSkinCommandTriggerEvent extends Event
	{
		static public var CHANGE_SKIN : String = 'changeSkin'
			
		public var bgColor : uint; 
		public var color : uint ; 
		public var skinName : String; 
		public var bgSkin  :String ; 
		
		public function ChangeSkinCommandTriggerEvent(type:String, bgColor : uint, 
								color : uint, bgSkin : String = '', skinName : String = '')  
		{	
			this.bgColor = bgColor
			this.color = color; 
			this.bgSkin =bgSkin; 
			super(type, true);
		}
		
		
	}
}