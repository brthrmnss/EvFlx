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
	import org.syncon.evernote.panic.controller.BuildBoardCommand;
	import org.syncon.evernote.panic.controller.ExportBoardCommand;
	import org.syncon.evernote.panic.controller.ExportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.ImportBoardCommand;
	import org.syncon.evernote.panic.controller.ImportBoardCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommand;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
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
			commandMap.mapEvent(LoadDefaultDataCommand.SETUP,  LoadDefaultDataCommand, null, false );				
			commandMap.mapEvent(LoadDefaultDataCommand.START,  LoadDefaultDataCommand, null, false );
			commandMap.mapEvent(LoadDefaultDataCommand.LIVE_DATA,  LoadDefaultDataCommand, null, false );
			commandMap.mapEvent(ImportBoardCommandTriggerEvent.IMPORT_BOARD,  ImportBoardCommand, null, false );
			commandMap.mapEvent(ExportBoardCommandTriggerEvent.EXPORT_BOARD,  ExportBoardCommand, null, false );		
			commandMap.mapEvent(BuildBoardCommand.BUILD_BOARD,  BuildBoardCommand, null, false );			
			commandMap.mapEvent(LoadDataSourceCommandTriggerEvent.LOAD_SOURCE,  LoadDataSourceCommand, null, false );						
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
			mediatorMap.mapView(  MessageWidget,  MessageWidgetMediator );	
			mediatorMap.mapView(  PaneWidget,  PaneWidgetMediator );				
			mediatorMap.mapView(  PanicBoard,  PanicBoardMediator );	
			mediatorMap.mapView(  TwitterScrollerTest2,  TwitterScrollerWidgetMediator );	
			mediatorMap.mapView(  ProjectList,  ProjectListWidgetMediator );	
			
			mediatorMap.mapView(  BoardRow,  BoardRowWidgetMediator );	
			
			mediatorMap.mapView(  EditSwitch,  EditSwitchMediator );	
			mediatorMap.mapView(  AddWidget,  AddWidgetMediator );		
			
			mediatorMap.mapView(  EditBorder2,  EditBorder2Mediator );		
			mediatorMap.mapView(  EditBorder,  EditBorderMediator );				
			//mediatorMap.mapView(  bandwidth_usage,  BandwidthUsageMediator );				
			
			subContext.subLoad( this, this.injector, this.commandMap, this.mediatorMap ) 				
			super.startup();
			
			 
			var wait : Boolean = false;
			if ( wait ) 
			{
				setTimeout( this.onInit, 1500 )
			}
			else
				this.onInit()	
					
			
		}
		import flash.utils.setTimeout;
		public var subContext : PanicPopupContext =  new PanicPopupContext()
		public function onInit()  : void
		{
			this.dispatchEvent( new Event( LoadDefaultDataCommand.SETUP ))
			this.dispatchEvent( new Event( LoadDefaultDataCommand.START ))
			setTimeout( this.dispatchEvent, 500 , new ExportBoardCommandTriggerEvent( ExportBoardCommandTriggerEvent.EXPORT_BOARD ))
			 
			//this.dispatchEvent(new ExportBoardCommandTriggerEvent( ExportBoardCommandTriggerEvent.EXPORT_BOARD ) )
			
			var exp : String = '{"layout":[[{"type":"graph","labelBottom":"Eccl","name":"Eccles lister","refreshTime":15000,"fillColor":"0xFCBF17","source":"","labelTop":"89/6"},{"type":"graph","labelBottom":"Eccl2","name":"Eccles lister","refreshTime":15000,"fillColor":"0x47C816","source":"","labelTop":"89/6"},{"type":"graph","labelBottom":"Eccl3","name":"Eccles lister","refreshTime":15000,"fillColor":"0xFF3D19","source":"","labelTop":"89/6"},{"type":"graph","labelBottom":"Eccl4","name":"Eccles lister","refreshTime":15000,"fillColor":"0x7652C0","source":"","labelTop":"89/6"}],[{"type":"projectList","labelBottom":"Eccl","name":"Eccles lister","refreshTime":-1,"labelTop":"89/6","source":"","description":""}],[{"type":"spacer"}],[{"type":"message","name":"Global Alert","source":"25 Days until tswitter launch","refreshTime":15000}],[{"type":"spacer"}],[{"type":"pane","color1":5064772,"color2":921102,"name":"Global Alert","source":"Something1","refreshTime":15000},{"type":"pane","color1":4082524,"color2":334129,"name":"Global Alert","source":"2Something1","refreshTime":15000},{"type":"pane","color1":4013884,"color2":4013884,"name":"Global Alert","source":"3Something1","refreshTime":15000}],[{"type":"spacer"}],[{"type":"twitterScroller","refreshTime":15000,"name":"Twitter Pane","source":"Panic Board","description":"..."}]],"name":""}'
			//this.dispatchEvent( new ImportBoardCommandTriggerEvent( ImportBoardCommandTriggerEvent.IMPORT_BOARD, exp ))				
			
				//this.dispatchEvent( new Event( LoadDefaultDataCommand.LIVE_DATA ))
			//this.subContext.onInit(); 
		}
	 

				
 
	}
}