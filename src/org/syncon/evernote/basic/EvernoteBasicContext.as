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
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommand;
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommandTriggerEvent;
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
			commandMap.mapEvent(CreateDefaultDataCommand.LIVE_DATA,  CreateDefaultDataCommand, null, false );

			commandMap.mapEvent(EvernoteToTextflowCommandTriggerEvent.IMPORT,  EvernoteToTextflowCommand, null, false );
			commandMap.mapEvent(EvernoteToTextflowCommandTriggerEvent.EXPORT,  EvernoteToTextflowCommand, null, false );
			
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.SHOW_POPUP,   EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );				
			EvernoteAPICommand.mapCommands( commandMap )
			// Services
			//injector.mapSingletonOf( EvernoteService, IEvernoteService  )		
			injector.mapSingleton( EvernoteService )
			// View
			mediatorMap.mapView(  right_side, RightSideMediator );		
			mediatorMap.mapView(  list_editor, ListEditorMediator );		
			mediatorMap.mapView(  top_links, TopLinksMediator );		
			mediatorMap.mapView(  left_side, LeftSideMediator );					
			
			super.startup();
			
			
			var wait : Boolean = false;
			if ( wait ) 
			{
				import flash.utils.setTimeout;
				setTimeout( this.onInit, 1500 )
			}
			else
				this.onInit()	
			//this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
			//this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP,  popup_modal_bg, 'popup_modal_bg', true ) );
				
			
		}
		
		public function onInit()  : void
		{
			this.dispatchEvent( new Event( CreateDefaultDataCommand.START ))
			this.dispatchEvent( new Event( CreateDefaultDataCommand.LIVE_DATA ))
			
		}
	 
 
	}
}