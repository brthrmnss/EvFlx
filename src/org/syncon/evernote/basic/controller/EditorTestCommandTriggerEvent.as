package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	/**
	 * Helper Class, enables calling ofmethods that are not user friendly 
	 * */
	public class EditorTestCommandTriggerEvent extends Event
	{
		public static const EXPORT_NOTE:String = 'editorTestCommandTrigger_ExportNote';
		
		public var fxSuccess : Function;
		public var fxFault : Function; 
		public var alert : Boolean = false
		public var alertMessage : String  = ''; 
		public var args : Object; 
		public var index : int = -1; 
		public var contents : String = ''; 
		
		public var url : String = ''; 
		
		public function EditorTestCommandTriggerEvent(type:String, args_ : Object = null )  
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
		 
		static public function ExportNote(contents_  : String, 	index_:int, 
										  fxSuccess:Function=null, fxFault:Function=null,
										  alert:Boolean=false, alertMessage : String = '' ) : 
			EditorTestCommandTriggerEvent
		{
			var e : EditorTestCommandTriggerEvent = 
				new EditorTestCommandTriggerEvent( 
					EditorTestCommandTriggerEvent.EXPORT_NOTE	)	; 
			
			e.contents = contents_
			e.index = index_				
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
			return e; 
		}		
		/*
		static public function Process(instructions : String, tags : Array,  fxSuccess:Function=null, fxFault:Function=null, alert:Boolean=false, alertMessage : String = '' ) : QuickTagEditorCommandTriggerEvent
		{
			var e : QuickTagEditorCommandTriggerEvent = 
				new QuickTagEditorCommandTriggerEvent( 
					QuickTagEditorCommandTriggerEvent.PROCESS_TAGS	 
					);
			e.optionalParameters( fxSuccess, fxFault, alert, alertMessage );
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
*/
	}
}