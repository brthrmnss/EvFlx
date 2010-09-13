package   org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.elements.TextFlow;

	/**
	 * */
	public class LoadImageCommandTriggerEvent extends Event
	{
		public static const LOAD_IMAGE:String = 'loadImage';
		static public var dispatch : Function; 
		public var loadInto : Object; 
		public var resoureGuid :  String
		public var guidNote :  String		
		
		public var debug : Boolean = false;
		
		public var tf : TextFlow = new TextFlow()
		public var images : Array = []; 
		public var checkboxes : Array = []; 
		
		public function LoadImageCommandTriggerEvent(type:String, guidNote_ : String , 
													 resoureGuid_ : String, loadInto_ : Object, debug_ : Boolean = false )  
		{	
			this.guidNote = guidNote_
			this.resoureGuid = resoureGuid_
			this.loadInto = loadInto_
			this.debug = debug_
			super(type, true);
		}
		
		
	}
}