package  org.syncon.evernote.basic
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Context;
	import org.syncon.evernote.basic.controller.CreateDefaultDataCommand;
	
	import org.syncon.evernote.basic.controller.EvernoteAPICommand;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.view.*;
	import org.syncon.evernote.services.*;
 
	public class EvernoteBasicContext extends Context
	{
		
		public function EvernoteBasicContext()
		{
			super();
		}
		override public function startup():void
		{
			
			// Model
			injector.mapSingleton( EvernoteAPIModel  )		
			// Controller
			//commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand);				
			commandMap.mapEvent(CreateDefaultDataCommand.START,  CreateDefaultDataCommand, null, false );				
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.SHOW_POPUP,   EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );				
			// Services
			injector.mapSingletonOf( EvernoteService, IEvernoteService  )		
			// View
			mediatorMap.mapView(  right_side, RightSideMediator );		
			mediatorMap.mapView(  list_editor, ListEditorMediator );		
			/*
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_SYNC_CHUNK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_TAGS_BY_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UNTAG_ALL, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_TAG, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_SEARCH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.FIND_NOTES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.FIND_NOTE_COUNTS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_CONTENT, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_SEARCH_TEXT, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_TAG_NAMES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.DELETE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_NOTES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.COPY_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.LIST_NOTE_VERSIONS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_NOTE_VERSION, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_RESOURCE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_DATA, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_BY_HASH, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_RECOGNITION, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_ALTERNATE_DATA, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RESOURCE_ATTRIBUTES, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_ADS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_RANDOM_AD, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.GET_PUBLIC_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_SHARED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_SHARED_NOTEBOOKS, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.CREATE_LINKED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.UPDATE_LINKED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EXPUNGE_LINKED_NOTEBOOK, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.STRING, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.EMAIL_NOTE, EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );			
			*/
			
			super.startup();
			
			
			var wait : Boolean = false;
			if ( wait ) 
			{
				import flash.utils.setTimeout;
				//setTimeout( this.onInit, 1500 )
			}
			else
				this.onInit()	
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
			//this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP,  popup_modal_bg, 'popup_modal_bg', true ) );
				
			
		}
		
		public function onInit()  : void
		{
			this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
		}
	 
 
	}
}