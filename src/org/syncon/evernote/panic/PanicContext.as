package   org.syncon.evernote.panic
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
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
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.panic.controller.*;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.*;
	import org.syncon.evernote.panic.view.utils.AvatarEdit;
	import org.syncon.evernote.panic.view.utils.AvatarEditMediator;
	import org.syncon.evernote.services.*;
	import org.syncon.popups.controller.ShowPopupEvent;
 
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
			injector.mapSingleton( EvernoteAPIModel  )						
			// Controller
			commandMap.mapEvent(LoadDefaultDataCommand.SETUP,  LoadDefaultDataCommand, null, false );				
			commandMap.mapEvent(LoadDefaultDataCommand.START,  LoadDefaultDataCommand, null, false );
			commandMap.mapEvent(LoadDefaultDataCommand.LIVE_DATA,  LoadDefaultDataCommand, null, false );
			commandMap.mapEvent(LoadDefaultDataCommand.AUTHENTICATE,  LoadDefaultDataCommand, null, false );				
			commandMap.mapEvent(ImportBoardCommandTriggerEvent.IMPORT_BOARD,  ImportBoardCommand, null, false );
			commandMap.mapEvent(ImportBoardCommandTriggerEvent.LOAD_BOARD,  ImportBoardCommand, null, false );
			commandMap.mapEvent(ImportBoardCommandTriggerEvent.IMPORT_FROM_GUID_BOARD,  ImportBoardCommand, null, false );			
			commandMap.mapEvent(ImportBoardCommandTriggerEvent.UPDATE_PEOPLE_AND_PROJECTS,  ImportBoardCommand, null, false );			
			
			
			commandMap.mapEvent(ExportBoardCommandTriggerEvent.EXPORT_BOARD_TO_STIRNG,  ExportBoardCommand, null, false );					
			commandMap.mapEvent(ExportBoardCommandTriggerEvent.SAVE_BOARD,  ExportBoardCommand, null, false );		
			commandMap.mapEvent(BuildBoardCommand.BUILD_BOARD,  BuildBoardCommand, null, false );			
			commandMap.mapEvent(LoadDataSourceCommandTriggerEvent.LOAD_SOURCE,  LoadDataSourceCommand, null, false );	

			commandMap.mapEvent(CreateBoardCommandTriggerEvent.CREATE_BOARD,  CreateBoardCommand, null, false );	
			
			
			
			commandMap.mapEvent(AuthenticateToBoardCommandTriggerEvent.METH1,  AuthenticateToBoardCommand, null, false );	
			commandMap.mapEvent(AuthenticateToBoardCommandTriggerEvent.METH2,  AuthenticateToBoardCommand, null, false );				
			commandMap.mapEvent(HoverPersonEvent.SHOW_PERSON_HOVER,  HoverPersonCommand, null, false );	
			commandMap.mapEvent(HoverPersonEvent.HIDE_PERSON_HOVER,  HoverPersonCommand, null, false );							
			
			commandMap.mapEvent(ChangeSkinCommandTriggerEvent.CHANGE_SKIN,  ChangeSkinCommand, null, false );				
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
			EvernoteAPICommand.mapCommands( commandMap )
			injector.mapSingleton( EvernoteService )
				
			// View
			mediatorMap.mapView(  GraphWidget,  GraphWidgetMediator );	
			mediatorMap.mapView(  MessageWidget,  MessageWidgetMediator );	
			mediatorMap.mapView(  PaneWidget,  PaneWidgetMediator );				
			mediatorMap.mapView(  PanicBoard,  PanicBoardMediator );	
			mediatorMap.mapView(  TwitterScrollerTest2,  TwitterScrollerWidgetMediator );	
			mediatorMap.mapView(  ProjectListWidget,  ProjectListWidgetMediator );	
			mediatorMap.mapView(  SpacerWidget,  SpacerWidgetMediator );				
			
			mediatorMap.mapView(  BoardRow,  BoardRowWidgetMediator );	
			
			mediatorMap.mapView(  AdminControls,  AdminControlsMediator );	
			mediatorMap.mapView(  UserControls,  UserControlsMediator );	
			
			mediatorMap.mapView(  AddWidget,  AddWidgetMediator );		
			
			mediatorMap.mapView(  EditBorder2,  EditBorder2Mediator );		
			mediatorMap.mapView(  EditBorder,  EditBorderMediator );		
			
			mediatorMap.mapView(  AvatarEdit,  AvatarEditMediator , null, false );					
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
			//this.dispatchEvent( new Event( LoadDefaultDataCommand.START ))
			//this.dispatchEvent( new Event( LoadDefaultDataCommand.LIVE_DATA ))
			
			 //setTimeout( this.dispatchEvent, 500 , new ExportBoardCommandTriggerEvent( ExportBoardCommandTriggerEvent.EXPORT_BOARD ))
			//this.dispatchEvent(new ExportBoardCommandTriggerEvent( ExportBoardCommandTriggerEvent.EXPORT_BOARD ) )
			
			//this.importBoardFromString()
			this.importBoardFromObjects()
			//this.importBoardFromEvernote()
			//this.authenticationMode1()
				
			//this.openPopup()
			//this.changeBoardColor()
		}
		public function importBoardFromEvernote() : void
		{
			//this.dispatchEvent( new Event( LoadDefaultDataCommand.AUTHENTICATE ))
			this.dispatchEvent( new Event( LoadDefaultDataCommand.LIVE_DATA ))
			//this.subContext.onInit(); 
		}		
		public function importBoardFromString() : void
		{
			var exp : String = '{"layout":[[{"type":"graph","labelBottom":"Eccl","name":"Eccles lister","refreshTime":15000,"fillColor":"0xFCBF17","source":"","labelTop":"89/6"},{"type":"graph","labelBottom":"Eccl2","name":"Eccles lister","refreshTime":15000,"fillColor":"0x47C816","source":"","labelTop":"89/6"},{"type":"graph","labelBottom":"Eccl3","name":"Eccles lister","refreshTime":15000,"fillColor":"0xFF3D19","source":"","labelTop":"89/6"},{"type":"graph","labelBottom":"Eccl4","name":"Eccles lister","refreshTime":15000,"fillColor":"0x7652C0","source":"","labelTop":"89/6"}],[{"type":"projectList","labelBottom":"Eccl","name":"Eccles lister","refreshTime":-1,"labelTop":"89/6","source":"","description":""}],[{"type":"spacer"}],[{"type":"message","name":"Global Alert","source":"25 Days until tswitter launch","refreshTime":15000}],[{"type":"spacer"}],[{"type":"pane","color1":5064772,"color2":921102,"name":"Global Alert","source":"Something1","refreshTime":15000},{"type":"pane","color1":4082524,"color2":334129,"name":"Global Alert","source":"2Something1","refreshTime":15000},{"type":"pane","color1":4013884,"color2":4013884,"name":"Global Alert","source":"3Something1","refreshTime":15000}],[{"type":"spacer"}],[{"type":"twitterScroller","refreshTime":15000,"name":"Twitter Pane","source":"Panic Board","description":"..."}]],"name":""}'
			exp = '{"board":{"name":"mercy","layout":[[{"type":"graph","labelTop":"89/6","refreshTime":15000,"name":"Eccles lister","fillColor":16563991,"max":100,"source":"56","labelBottom":"Eccl"},{"type":"graph","labelTop":"89/6","refreshTime":15000,"name":"Eccles lister","fillColor":4704278,"max":100,"source":"99","labelBottom":"Eccl2"},{"type":"graph","labelTop":"{http://city-21.com/php/random_number.php}/100","refreshTime":15000,"name":"Eccles lister","fillColor":16727321,"max":100,"source":"{http://city-21.com/php/random_number.php}","labelBottom":"Ec3 - {http://city-21.com/php/random_string.php?f=8}"},{"type":"graph","labelTop":"12/100","refreshTime":15000,"name":"Eccles lister","fillColor":7754432,"max":100,"source":"12","labelBottom":"Eccl4"}],[{"height":355,"type":"projectList","refreshTime":15000,"name":"Project Lister","source":""}],[{"type":"spacer"}],[{"type":"message","refreshTime":15000,"name":"Global Alert","source":"25 Days until tswitter launch"}],[{"type":"spacer"}],[{"type":"pane","color2":921102,"color1":5064772,"refreshTime":15000,"name":"Global Alert","source":"Something1"},{"type":"pane","color2":334129,"color1":4082524,"refreshTime":15000,"name":"Global Alert","source":"2Something1"},{"type":"pane","color2":4013884,"color1":4013884,"refreshTime":15000,"name":"Global Alert","source":"3Something1"}],[{"type":"spacer"}],[{"refreshTime":15000,"type":"twitterScroller","name":"Twitter Pane","source":"Panic Board","description":"..."}]]},"projects":[{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["bA d","A c"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["bA c","bA b","A d"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["cA d","bA c"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":[],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["A d","cd Y"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":[],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["bA b","A d","cd Y"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["A d","bA d","cA b","d Y"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["A d","cA d","A c"],"desc":"coda is coda","ppl":[]},{"col2":"march","name":"Coda","col3":"error","img":"a.jpg","people_names":["cA c","cA d"],"desc":"coda is coda","ppl":[]}],"people":[{"name":"A b","src":"GIF/D03 copy.gif","desc":"","email":"","twitter":""},{"name":"A c","src":"GIF/E03 copy.gif","desc":"","email":"","twitter":""},{"name":"A d","src":"GIF/E02 copy.gif","desc":"","email":"","twitter":""},{"name":"d Y","src":"GIF/A04 copy.gif","desc":"","email":"","twitter":""},{"name":"bA b","src":"GIF/I02 copy.gif","desc":"","email":"","twitter":""},{"name":"bA c","src":"GIF/FC01 copy.gif","desc":"","email":"","twitter":""},{"name":"bA d","src":"GIF/D01 copy.gif","desc":"","email":"","twitter":""},{"name":"bd Y","src":"GIF/N02 copy.gif","desc":"","email":"","twitter":""},{"name":"cA b","src":"GIF/A03 copy.gif","desc":"","email":"","twitter":""},{"name":"cA c","src":"GIF/A05 copy.gif","desc":"","email":"","twitter":""},{"name":"cA d","src":"GIF/N02 copy.gif","desc":"","email":"","twitter":""},{"name":"cd Y","src":"GIF/E05 copy.gif","desc":"","email":"","twitter":""}]}'
			this.dispatchEvent( new ImportBoardCommandTriggerEvent( 
									ImportBoardCommandTriggerEvent.IMPORT_BOARD, exp, '', true ))				
							
				//this.dispatchEvent( new Event( LoadDefaultDataCommand.LIVE_DATA ))
			//this.subContext.onInit(); 
		}
		public function importBoardFromObjects() : void
		{
			this.dispatchEvent( new Event( LoadDefaultDataCommand.START ))
		}		
	 
		public function authenticationMode1() : void
		{
			this.dispatchEvent( new Event( LoadDefaultDataCommand.AUTHENTICATE ))
			this.dispatchEvent( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,  'PopupLogin', [true] )  ) 
				var boardName : String = 'mercy' 
			if ( FlexGlobals.topLevelApplication.parameters != null ) 
			{
				if ( FlexGlobals.topLevelApplication.parameters.hasOwnProperty('board') ) 
				{
					boardName = FlexGlobals.topLevelApplication.parameters["board"];
				}
			}
			setTimeout( this.dispatchEvent, 1000, 
				new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,  'PopupLogin', [true, 'mercy1', '', '12121212', true , true] ) 
			)
			//this.dispatchEvent( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,  'PopupLogin', [true, 'mercy', '', 'mighty2', true ] )  )
			//this.dispatchEvent( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,  'PopupLogin', [true, 'mercy', '', 'mighty2', true , false] )  ) 
			/*this.dispatchEvent( new AuthenticateToBoardCommandTriggerEvent( AuthenticateToBoardCommandTriggerEvent.METH1, 
				'mercy', null, 'mighty' ))*/
		}				

		public function openPopup()  : void
		{
			this.dispatchEvent( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PeopleManagementPopup'    )  ) 
		}
				
		public function changeBoardColor()  : void
		{
			/*
			var wait : Boolean = false;
			if ( wait ) 
			{
				setTimeout( this.onInit, 1500 )
			}
			else
				this.onInit()	
			*/		
			var ev : Object  = new ChangeSkinCommandTriggerEvent(
							ChangeSkinCommandTriggerEvent.CHANGE_SKIN, 
							0xFFFFFF, 0  )
			ev =  new ChangeSkinCommandTriggerEvent(
				ChangeSkinCommandTriggerEvent.CHANGE_SKIN, 
				0xF9A5A1,  0xFFFFFF )
				
			this.dispatchEvent( ev  as Event ) ; 
			//setTimeout( this.dispatchEvent, 3000, 	ev )	
			//setTimeout( this.dispatchEvent, 6000, 	ev )	
			 this.dispatchEvent( new ChangeSkinCommandTriggerEvent(ChangeSkinCommandTriggerEvent.CHANGE_SKIN, 
				0xFFFFFF, 0  )  )  
		}
				
		
	}
}