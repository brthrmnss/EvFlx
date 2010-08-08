package   org.syncon.evernote.basic.controller
{
	
	import flash.events.Event;
	/**
	 * Helper Class, enables calling ofmethods that are not user friendly 
	 * */
	public class EvernoteAPIHelperCommandTriggerEvent extends Event
	{
		public static const GET_TRASH_ITEMS:String = 'trashItem';
		public static const REMOVE_TAG:String = 'removeTag';
		public static const ADD_TAG:String = 'addTag';
		
		public var fxSuccess : Function;
		public var fxFault : Function; 
		public var alert : Boolean = false
		public var alertMessage : String  = ''; 
		public var args : Object; 
		
		public function EvernoteAPIHelperCommandTriggerEvent(type:String,    args_ : Object = null )  
		{	
			this.args = args_
			super(type, true);
		}
		
 
		static public function GetTrash( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPIHelperCommandTriggerEvent
		{
			var e : EvernoteAPIHelperCommandTriggerEvent = new EvernoteAPIHelperCommandTriggerEvent( EvernoteAPIHelperCommandTriggerEvent.GET_TRASH_ITEMS	)			; 
			//e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}		
		
		
		static public function AddTag( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPIHelperCommandTriggerEvent
		{
			var e : EvernoteAPIHelperCommandTriggerEvent = new EvernoteAPIHelperCommandTriggerEvent( EvernoteAPIHelperCommandTriggerEvent.REMOVE_TAG	)			; 
			return e; 
		}		
		
		
		static public function RemoveTag( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPIHelperCommandTriggerEvent
		{
			var e : EvernoteAPIHelperCommandTriggerEvent = new EvernoteAPIHelperCommandTriggerEvent( EvernoteAPIHelperCommandTriggerEvent.ADD_TAG	)			; 
			return e; 
		}						
		
		
	}
}