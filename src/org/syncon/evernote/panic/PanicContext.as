package   org.syncon.evernote.panic
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
	import org.syncon.evernote.basic.controller.EvernoteAPICommand;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.controller.EvernoteAPIHelperCommand;
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommand;
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommandTriggerEvent;
	import org.syncon.evernote.basic.controller.SaveNoteCommand;
	import org.syncon.evernote.basic.controller.SaveNoteCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.LoadDefaultDataCommand;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.*;
	import org.syncon.evernote.services.*;
 
	public class PanicContext extends Context
	{
		
		public function PanicContext()
		{
			super();
		}
		override public function startup():void
		{
			// Model
			injector.mapSingleton( PanicModel  )		
			// Controller
			commandMap.mapEvent(LoadDefaultDataCommand.START,  LoadDefaultDataCommand, null, false );
			commandMap.mapEvent(LoadDefaultDataCommand.LIVE_DATA,  LoadDefaultDataCommand, null, false );
			/*
			commandMap.mapEvent(EvernoteToTextflowCommandTriggerEvent.IMPORT,  EvernoteToTextflowCommand, null, false );
			commandMap.mapEvent(EvernoteToTextflowCommandTriggerEvent.EXPORT,  EvernoteToTextflowCommand, null, false );
			
			commandMap.mapEvent(EvernoteAPICommandTriggerEvent.SHOW_POPUP,   EvernoteAPICommand, EvernoteAPICommandTriggerEvent, false );				
			
			EvernoteAPICommand.mapCommands( commandMap )
			EvernoteAPIHelperCommand.mapCommands( commandMap )
			commandMap.mapEvent(SaveNoteCommandTriggerEvent.SAVE_NOTE,  SaveNoteCommand, null, false );
			commandMap.mapEvent(SaveNoteCommandTriggerEvent.SAVE_NOTE_CHANGE_NOTEBOOK,  SaveNoteCommand, null, false );			
			commandMap.mapEvent(SaveNoteCommandTriggerEvent.SAVE_NOTE_TAGS,  SaveNoteCommand, null, false );			
			
			injector.mapSingleton( EvernoteService )
			*/
			// View
			mediatorMap.mapView(  GraphWidget,  GraphWidgetMediator );	
			mediatorMap.mapView(  PaneWidget,  PaneWidgetMediator );	
			mediatorMap.mapView(  MessageWidget,  MessageWidgetMediator );	
			mediatorMap.mapView(  PanicBoard,  PanicBoardMediator );	
			//mediatorMap.mapView(  bandwidth_usage,  BandwidthUsageMediator );				
			
			subContext.subLoad( this, this.injector, this.commandMap, this.mediatorMap ) 				
			super.startup();
			
			 
			var wait : Boolean = false;
			if ( wait ) 
			{
				import flash.utils.setTimeout;
				setTimeout( this.onInit, 1500 )
			}
			else
				this.onInit()	
		}
		
		public var subContext : PanicPopupContext =  new PanicPopupContext()
		public function onInit()  : void
		{
			this.dispatchEvent( new Event( LoadDefaultDataCommand.START ))
			//this.dispatchEvent( new Event( LoadDefaultDataCommand.LIVE_DATA ))
			//this.subContext.onInit(); 
		}
	 

				
 
	}
}