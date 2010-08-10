package   org.syncon.evernote.basic.controller
{
	
	import com.evernote.edam.notestore.NoteFilter;
	
	import flash.events.Event;

	/**
	 * Helper Class, enables calling ofmethods that are not user friendly 
	 * */
	public class EvernoteAPIHelperCommandTriggerEvent extends Event
	{
		public static const GET_TRASH_ITEMS:String = 'trashItem';
		public static const REMOVE_TAG:String = 'removeTag';
		public static const ADD_TAG:String = 'addTag';
		public static const GET_ALL_NOTEBOOK_COUNTS:String = 'getAllNotebookCounts';
		
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
		
		public function optionalParameters(   fxSuccess_:  Function = null ,
											  fxFault_ : Function = null, alert_ : Boolean = false , 
											  alertMessage_ :  String = '' ) : void
		{	
			this.fxSuccess = fxSuccess_
			this.fxFault = fxFault_		
			alert = alert_
			alertMessage = alertMessage_
		}		 
		
		static public function GetTrash( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPIHelperCommandTriggerEvent
		{
			var e : EvernoteAPIHelperCommandTriggerEvent = new EvernoteAPIHelperCommandTriggerEvent( EvernoteAPIHelperCommandTriggerEvent.GET_TRASH_ITEMS	)			; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
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
		
		static public function GetNotebookNoteCounts( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : EvernoteAPIHelperCommandTriggerEvent
		{
			var e : EvernoteAPIHelperCommandTriggerEvent =
				new EvernoteAPIHelperCommandTriggerEvent( 
					EvernoteAPIHelperCommandTriggerEvent.GET_ALL_NOTEBOOK_COUNTS  )
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}			
		
		
	}
}