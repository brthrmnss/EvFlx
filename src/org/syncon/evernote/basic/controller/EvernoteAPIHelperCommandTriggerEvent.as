package   org.syncon.evernote.basic.controller
{
	import com.evernote.edam.notestore.*;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteStore;
	import com.evernote.edam.notestore.NoteStoreImpl;
	import com.evernote.edam.type.*;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.User;
	import com.evernote.edam.userstore.AuthenticationResult;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * Maps note store of Evernote API
	 * ui --> [ (model-->) command-trigger --> command  --> service 
	 * <wait/response> 
	 * service --> command --> model ]--> ui
	 * */
	public class EvernoteAPIHelperCommandTriggerEvent extends Event
	{
		public static const GET_TRASH_ITEMS:String = 'trashItem';

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
		
	}
}