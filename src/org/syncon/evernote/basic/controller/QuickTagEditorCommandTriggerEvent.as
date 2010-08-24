package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	/**
	 * Helper Class, enables calling ofmethods that are not user friendly 
	 * */
	public class QuickTagEditorCommandTriggerEvent extends Event
	{
		public static const GET_TAGS:String = 'getTags_QTE';
		public static const PROCESS_TAGS:String = 'processTags_QTE';
		public static const DELETE_ALL_TAGS:String = 'deleteAllTags_QTE';		
		
		public var fxSuccess : Function;
		public var fxFault : Function; 
		public var alert : Boolean = false
		public var alertMessage : String  = ''; 
		public var args : Object; 
		
		public var tags : Array = []; 
		public var instructions : String = ''; 
		public function QuickTagEditorCommandTriggerEvent(type:String,    args_ : Object = null )  
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
		
		static public function GetNotes( fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : QuickTagEditorCommandTriggerEvent
		{
			var e : QuickTagEditorCommandTriggerEvent = 
				new QuickTagEditorCommandTriggerEvent( 
					QuickTagEditorCommandTriggerEvent.GET_TAGS	)	; 
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}		
		
		static public function Process(instructions : String, tags : Array,  fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : QuickTagEditorCommandTriggerEvent
		{
			var e : QuickTagEditorCommandTriggerEvent = 
				new QuickTagEditorCommandTriggerEvent( 
					QuickTagEditorCommandTriggerEvent.PROCESS_TAGS	);
			e.tags = tags
			e.instructions = instructions
			return e; 
		}		
		
		static public function DeleteAllTags( tags : Array , fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : QuickTagEditorCommandTriggerEvent
		{
			var e : QuickTagEditorCommandTriggerEvent = 
				new QuickTagEditorCommandTriggerEvent( 
					QuickTagEditorCommandTriggerEvent.DELETE_ALL_TAGS	); 
			e.tags = tags; 			
			return e; 
		}			

	}
}