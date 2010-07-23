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
			/*
			// Model
			injector.mapSingleton( PopupModel  )		
			// Controller
			//commandMap.mapEvent(StockPricePopupEvent.CREATE_POPUP, CreateStockPricePopupCommand, StockPricePopupEvent);	
			commandMap.mapEvent(CreatePopupEvent.REGISTER_AND_CREATE_POPUP, CreatePopupCommand, CreatePopupEvent);		
			commandMap.mapEvent(CreatePopupEvent.REGISTER_POPUP, CreatePopupCommand, CreatePopupEvent);			
			commandMap.mapEvent(RemovePopupEvent.REMOVE_POPUP, RemovePopupCommand, RemovePopupEvent);			
			commandMap.mapEvent(ShowPopupEvent.SHOW_POPUP, ShowPopupCommand, ShowPopupEvent);			
			commandMap.mapEvent(HidePopupEvent.HIDE_POPUP, HidePopupCommand, HidePopupEvent);			
			
			//default popups
			commandMap.mapEvent(ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, ShowConfirmDialogCommand, ShowConfirmDialogTriggerEvent);			
			commandMap.mapEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, ShowAlertMessageCommand, ShowAlertMessageTriggerEvent);				
			
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand, AddKeyboardShortcutToOpenPopupEvent);	
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand);				
			
			// Services
			// View
			mediatorMap.mapView(  PopupLauncher, PopupLauncherMediator );			
			mediatorMap.mapView( stockprice_popup, StockPricePopupMediator, null, false, false );	
			mediatorMap.mapView( popup_modal_bg, PopupModalMediator, null, false, false );		
			mediatorMap.mapView( popup1, Popup1Mediator, null, false, false );		
			mediatorMap.mapView( popup2, Popup2Mediator, null, false, false );		
			mediatorMap.mapView( popup3, Popup3Mediator, null, false, false );		
			
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP,  popup_modal_bg, 'popup_modal_bg', true ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, stockprice_popup, 'stockpopup' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup1, 'popup1' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup2, 'popup2' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup3, 'popup3' ) );
			
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup_message, 'popup_alert' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup_confirm, 'popup_confirm' ) );			
			
			//this.dispatchEvent( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP,  'popup_modal_bg' ) );	
			//this.dispatchEvent( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP,  'stockpopup' ) );
			
			this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS  ) );
			this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, 
				'popup3', 89 ) ); //ctrl+Y			
			*/
		}
		
		public function onInit()  : void
		{
		}
 
	}
}