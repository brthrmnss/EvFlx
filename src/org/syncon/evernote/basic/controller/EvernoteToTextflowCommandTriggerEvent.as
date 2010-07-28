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
		public function EvernoteToTextflowCommandTriggerEvent(type:String, 
															  txt_: String, fxResult_ :  Function)  
		{	
			this.txt = txt_
			this.fxResult = fxResult_
			super(type, true);
		}
		
		
	}
}