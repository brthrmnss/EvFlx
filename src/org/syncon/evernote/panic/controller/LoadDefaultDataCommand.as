package   org.syncon.evernote.panic.controller
{
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.vo.PreferencesVO;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.view.ProjectListWidget;
	import org.syncon.evernote.panic.view.TwitterScrollerTest2;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.evernote.services.EvernoteService;
	
	public class LoadDefaultDataCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event: Event;
		static public var START : String = 'LoadDefaultDataCommand.START'
		static public var SETUP : String = 'LoadDefaultDataCommand.SETUP'			
		static public var LIVE_DATA : String = 'LoadDefaultDataCommand.LIVE_DATA'
		static public var AUTHENTICATE : String = 'LoadDefaultDataCommand.AUTHENTICATE'			
		
		override public function execute():void
		{
			if ( event.type == START ) 
			{
				this.createStartData()				
			}
			if ( event.type == LIVE_DATA ) 
			{
				this.liveData()
			}
			if ( event.type == SETUP ) 
			{
				var pics : Array = []; 
				var items : Array = [
					"A01 copy.gif","A02 copy.gif","A03 copy.gif","A04 copy.gif","A05 copy.gif","B01 copy.gif","B02 copy.gif","B03 copy.gif","B04 copy.gif","B05 copy.gif","C01 copy.gif","C02 copy.gif","C03 copy.gif","C04 copy.gif","C05 copy.gif","D01 copy.gif","D02 copy.gif","D03 copy.gif","D04 copy.gif","D05 copy.gif","E01 copy.gif","E02 copy.gif","E03 copy.gif","E04 copy.gif","E05 copy.gif","F01 copy.gif","F02 copy.gif","F03 copy.gif","F04 copy.gif","F05 copy.gif","FA01 copy.gif","FA02 copy.gif","FA03 copy.gif","FA04 copy.gif","FA05 copy.gif","FB01 copy.gif","FB02 copy.gif","FB03 copy.gif","FB04 copy.gif","FB05 copy.gif","FC01 copy.gif","FC02 copy.gif","FC03 copy.gif","FC04 copy.gif","FC05 copy.gif","FD01 copy.gif","FD02 copy.gif","FD03 copy.gif","FD04 copy.gif","FD05 copy.gif","FE01 copy.gif","FE02 copy.gif","FE03 copy.gif","FE04 copy.gif","FE05 copy.gif","FG01 copy.gif","FG02 copy.gif","FG03 copy.gif","FG04 copy.gif","FG05 copy.gif","FH01 copy.gif","FH02 copy.gif","FH03 copy.gif","FH04 copy.gif","FH05 copy.gif","FI01 copy.gif","FI02 copy.gif","FI03 copy.gif","FI04 copy.gif","FI05 copy.gif","G01 copy.gif","G02 copy.gif","G03 copy.gif","G04 copy.gif","G05 copy.gif","H01 copy.gif","H02 copy.gif","H03 copy.gif","H04 copy.gif","H05 copy.gif","I01 copy.gif","I02 copy.gif","I03 copy.gif","I04 copy.gif","I05 copy.gif","J01 copy.gif","J02 copy.gif","J03 copy.gif","J04 copy.gif","J05 copy.gif","K01 copy.gif","K02 copy.gif","K03 copy.gif","K04 copy.gif","K05 copy.gif","L01 copy.gif","L02 copy.gif","L03 copy.gif","L04 copy.gif","L05 copy.gif","M01 copy.gif","M02 copy.gif","M03 copy.gif","M04 copy.gif","M05 copy.gif","N01 copy.gif","N02 copy.gif","N03 copy.gif","N04 copy.gif","N05 copy.gif","O01 copy.gif","O02 copy.gif","O03 copy.gif","O04 copy.gif","O05 copy.gif",
				]
				for each ( var str : String in items ) 
				{
					pics.push( 'GIF'+'/'+str	)
				}
				this.model.peoplePics =  pics;
				this.model.boardHolder = FlexGlobals.topLevelApplication.boardGroup;
				return;
				this.model.editMode = true; 
				this.model.adminMode = true; 
				setTimeout(  this.onGoToEditMode, 1000 ) 
			}			
			if ( event.type == AUTHENTICATE ) 
			{
				this.authenticate(); 
			}				
		}
		
		import flash.utils.setTimeout
		
			public function onGoToEditMode()  : void
			{
				this.model.editMode = true; 
			}
		
		public function createStartData() : void
		{
			
			var arr : Array = []; 
			var board : BoardVO = new BoardVO()
			board.name = 'blickem'
			arr.push( [
				 
				GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl', 56, 100, 0xFCBF17,15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl2', 99, 100, 0x47C816,15000).widgetData,
			 
				GraphWidget.importData('Eccles lister', '', 
					'{http://city-21.com/php/random_number.php}/100',
					'Ec3 - {http://city-21.com/php/random_string.php?f=8}',
					'{http://city-21.com/php/random_number.php}', 100, 0xFF3D19, 15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '12/100', 'Eccl4', 12, 100, 0x7652C0 , 15000).widgetData
				])
			/*
			arr.push( [
				ProjectListWidget.importData('Project Lister', '', 355, 15000).widgetData,
			])			
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])						
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch' , 15000).widgetData,
			])	
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])		
			*/
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1', 15000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', 15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', 15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
				PaneWidget.importData('Global Alert', '', '<b>•Custom Flex and ColdFusion Web Application Development</b><br/><b>• Custom AIR Desktop Application Development</b><br/><b>•Business Systems Analysis and Implementation</b>', 15000,  '0', '0x3D3F3C'  ).widgetData,				
			])	
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000).widgetData,
			])					
			board.layout = arr
				
			var people : Array = [] ; 
			board.people = people
			people.push( 	new PersonVO( 'A b', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'A c', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'A d', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'd Y', '', '', '', PersonVO.getRandomPic() )  ) 
				
			people.push( 	new PersonVO( 'bA b', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'bA c', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'bA d', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'bd Y', '', '', '', PersonVO.getRandomPic() )  ) 
				
			people.push( 	new PersonVO( 'cA b', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'cA c', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'cA d', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'cd Y', '', '', '', PersonVO.getRandomPic() )  ) 				
			
			var projects : Array = []; 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'name' ) ) ) 				
			board.projects = projects
				
			this.model.board = board; 
			this.model.refreshBoard()
				
			
		}
		
		private function rand( items :  Array ) : Object
		{
			var index : int = Math.round( Math.random()*items.length)
			if ( index == items.length ) 
				index -= 1
					
			return items[index]; 
		}
		
		private function randSet(  max :  int , min : int , items :  Array, returnProp : String = '' ) :  Array
		{
			var ret : Array = []; 
			for ( var i : int = 0 ; ret.length < max; i++ )
			{
				var item : Object = rand( items ) 
				if ( returnProp != '' ) 
					item = item[returnProp] 
				if ( ret.indexOf( item ) != -1 ) 
					continue; 
				ret.push( item ) 
			}
			/*if ( min != 0 ) 
			{*/
				var endIndex : int = Math.max( min, Math.round( Math.random()*max ) ) 
				ret = ret.slice( 0,	endIndex ) 
			/*}*/
			return ret;
		}
				
		
		
		
		private function createSets( ofClass_  : Class, props : Array, values : Array )  :  Array
		{
			var set : Array = [] 
			
			var propItems :  Array = [] ; 
			for ( var i : int = 0; i < values.length ; i++ )
			{
				propItems[i] = values[i].split(', ')
			}			
			var make : int = propItems[0].length;
			var cf : ClassFactory = new ClassFactory(ofClass_)
			for (  i  = 0; i < make ; i++ )
			{
				var obj : Object = cf.newInstance()
				for ( var j : int = 0; j < props.length ; j++ )
				{
					obj[props[j]] =  propItems[j][i]  
				}		
				set.push( obj ) 
			}
			
			return set; 
		}
		
		private function  newDate( str :String )  : Date
		{
			var newDate : Date = DateField.stringToDate( str, 'MM/DD/YYYY' ) 
			return newDate;
		}
	
		public function liveData() : void
		{
			var ee : EvernoteAPIModel
			this.authenticate()
			EvernoteAPIModel.EvernoteUrl = 'sandbox.evernote.com';
			EvernoteService.edamBaseUrl = "https://sandbox.evernote.com";
			
			this.model.boardName = 'mercy';
			var eed  :  ImportBoardCommandTriggerEvent
			this.dispatch( new ImportBoardCommandTriggerEvent( 
				ImportBoardCommandTriggerEvent.LOAD_BOARD, null, 'mercy' ))		
		}
		
		private function authenticate()  : void
		{
			this.dispatch( EvernoteAPICommandTriggerEvent.Authenticate('brthrmnss', '12121212' ) )
		}
		
	}
}