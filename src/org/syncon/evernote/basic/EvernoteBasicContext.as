package  org.syncon.evernote.basic
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Context;
	import org.syncon.evernote.basic.view.RightSideMediator;
	import org.syncon.evernote.basic.view.right_side;
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
			injector.mapSingletonOf( EvernoteService, IEvernoteService  )			
			// Controller
			// Services
			//injector.mapSingletonOf(IAuthService, DummyAuthService);
			// View
	
			this.startupPopupSubContext()
			// Startup complete
			super.startup();
			
		}
		
		public function startupPopupSubContext()  : void
		{
			 
			// Model
			//injector.mapSingleton( PopupModel  )		
			// Controller
			//commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand);				
			
			// Services
			// View
			mediatorMap.mapView(  right_side, RightSideMediator );			
			//this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP,  popup_modal_bg, 'popup_modal_bg', true ) );
		}
		
		public function onInit()  : void
		{
		}
 
	}
}