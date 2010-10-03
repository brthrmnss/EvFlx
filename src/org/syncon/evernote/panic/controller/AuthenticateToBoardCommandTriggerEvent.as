package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import org.syncon.evernote.panic.vo.BoardVO;
 
	public class AuthenticateToBoardCommandTriggerEvent extends  Event
	{
		static public var METH1 : String = 'METH1.START'
		static public var METH2 : String = 'METH2.STAR'		
		public var board : BoardVO; 
		public var fxComplete : Function; //
		public var fxFault : Function; //		
		public var result : String  = ''; 
		
		public var boardName : String  = ''; 
		public var username : String  = ''; 
		public var password : String  = ''; 
		
		public var admin : Boolean = false; 
		
		public function AuthenticateToBoardCommandTriggerEvent(type:String, 
															   boardName_ : String, username_ : String, password_ : String,
															   admin_ : Boolean = false,  fxComplete_ : Function = null , fxFault_ : Function = null)  
		{	
			this.boardName = boardName_
			this.username = username_
			this.password = password_				
			this.fxComplete = fxComplete_
			this.admin = admin_
			this.fxFault = fxFault_				
			super(type, true);
		}
		
		
	}
}