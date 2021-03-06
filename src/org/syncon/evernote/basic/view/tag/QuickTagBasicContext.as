package   org.syncon.evernote.basic.view.tag
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
	import org.syncon.evernote.basic.controller.EvernoteAPIHelperCommand;
	import org.syncon.evernote.basic.controller.QuickTagEditorCommand;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.view.QuickTagEditor;
	import org.syncon.evernote.basic.view.QuickTagEditorMediator;
	import org.syncon.evernote.services.*;
 
	public class QuickTagBasicContext extends Context
	{
		
		public function QuickTagBasicContext()
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
			
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.SHOW_POPUP,   EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );				
			
			EvernoteAPICommand.mapCommands( commandMap )
			EvernoteAPIHelperCommand.mapCommands( commandMap )
			QuickTagEditorCommand.mapCommands( commandMap ) 
			// Services
			//injector.mapSingletonOf( EvernoteService, IEvernoteService  )		
			injector.mapSingleton( EvernoteService )
			// View
			mediatorMap.mapView(  QuickTagEditor, QuickTagEditorMediator );		
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