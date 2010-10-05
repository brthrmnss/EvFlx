package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.PersonVO;
 
	public class HoverPersonEvent extends Event
	{
		static public var SHOW_PERSON_HOVER : String = 'showPersonHover'
		static public var HIDE_PERSON_HOVER : String = 'hidePersonHover'
			
		public var ui :  Object; 
		public var person : PersonVO; 
		public function HoverPersonEvent(type:String, person : PersonVO, ui : Object=null)  
		{	
			this.ui = ui
			this.person = person; 
			super(type, true);
		}
		
		
	}
}