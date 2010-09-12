package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * */
	public class EvernoteToTextflowCommandTriggerEvent extends Event
	{
		public static const IMPORT:String = 'importEvernoteXML';
		public static const EXPORT:String = 'exportTextFlow'
		public var fxResult : Function; 
		public var txt :  String
		public var debug : Boolean = false; 
		public function EvernoteToTextflowCommandTriggerEvent(type:String, 
															  txt_: String, fxResult_ :  Function, debug_ : Boolean = false )  
		{	
			this.txt = txt_
			this.fxResult = fxResult_
			this.debug = debug_
			super(type, true);
		}
		
		
	}
}