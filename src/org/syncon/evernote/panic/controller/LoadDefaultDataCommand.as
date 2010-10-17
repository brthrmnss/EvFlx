package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
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
	import org.syncon.evernote.panic.view.utils.PanicLayouts;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.evernote.services.EvernoteService;
	
	import spark.components.Group;
	
	public class LoadDefaultDataCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event:  LoadDefaultDataTriggerEvent;

		override public function execute():void
		{
			if ( event.type == LoadDefaultDataTriggerEvent.START ) 
			{
				this.createStartData()				
			}
			if ( event.type == LoadDefaultDataTriggerEvent.LIVE_DATA ) 
			{
				this.liveData()
			}
			if ( event.type == LoadDefaultDataTriggerEvent.SETUP_BOARD ) 
			{
				var pics : Array = []; 
				var items : Array = [
					"A01 copy.gif","A02 copy.gif","A03 copy.gif","A04 copy.gif","A05 copy.gif","B01 copy.gif","B02 copy.gif",
					"B03 copy.gif","B04 copy.gif","B05 copy.gif","C01 copy.gif","C02 copy.gif","C03 copy.gif","C04 copy.gif",
					"C05 copy.gif","D01 copy.gif","D02 copy.gif","D03 copy.gif","D04 copy.gif","D05 copy.gif","E01 copy.gif",
					"E02 copy.gif","E03 copy.gif","E04 copy.gif","E05 copy.gif","F01 copy.gif","F02 copy.gif","F03 copy.gif",
					"F04 copy.gif","F05 copy.gif","FA01 copy.gif","FA02 copy.gif","FA03 copy.gif","FA04 copy.gif",
					"FA05 copy.gif","FB01 copy.gif","FB02 copy.gif","FB03 copy.gif","FB04 copy.gif","FB05 copy.gif",
					"FC01 copy.gif","FC02 copy.gif","FC03 copy.gif","FC04 copy.gif","FC05 copy.gif","FD01 copy.gif",
					"FD02 copy.gif","FD03 copy.gif","FD04 copy.gif","FD05 copy.gif","FE01 copy.gif","FE02 copy.gif",
					"FE03 copy.gif","FE04 copy.gif","FE05 copy.gif","FG01 copy.gif","FG02 copy.gif","FG03 copy.gif",
					"FG04 copy.gif","FG05 copy.gif","FH01 copy.gif","FH02 copy.gif","FH03 copy.gif","FH04 copy.gif",
					"FH05 copy.gif","FI01 copy.gif","FI02 copy.gif","FI03 copy.gif","FI04 copy.gif","FI05 copy.gif",
					"G01 copy.gif","G02 copy.gif","G03 copy.gif","G04 copy.gif","G05 copy.gif","H01 copy.gif","H02 copy.gif",
					"H03 copy.gif","H04 copy.gif","H05 copy.gif","I01 copy.gif","I02 copy.gif","I03 copy.gif","I04 copy.gif",
					"I05 copy.gif","J01 copy.gif","J02 copy.gif","J03 copy.gif","J04 copy.gif","J05 copy.gif","K01 copy.gif",
					"K02 copy.gif","K03 copy.gif","K04 copy.gif","K05 copy.gif","L01 copy.gif","L02 copy.gif","L03 copy.gif",
					"L04 copy.gif","L05 copy.gif","M01 copy.gif","M02 copy.gif","M03 copy.gif","M04 copy.gif","M05 copy.gif",
					"N01 copy.gif","N02 copy.gif","N03 copy.gif","N04 copy.gif","N05 copy.gif","O01 copy.gif","O02 copy.gif",
					"O03 copy.gif","O04 copy.gif","O05 copy.gif",
				]
				for each ( var str : String in items ) 
				{
					pics.push( 'GIF'+'/'+str	)
				}
				this.model.peoplePics =  pics;
				
					pics = []
				 items = [
					'apple.png', 'bar_chart.png', 'box.png', 'briefcase.png', 'calendar.png', 'camera.png',
					'check_mark.png', 'clock.png', 'close.png', 'coffee.png', 'comment_bubble.png',
					'danger_sign.png', 'down_arrow.png', 'download.png', 'empty_calendar.png',
					'envelope.png', 'exclamanation_mark.png', 'find.png', 'folder.png',
					'forbidden_sign.png', 'full_screen.png', 'globe.png', 'green_flag.png',
					'heart.png', 'house.png', 'info.png', 'iphone.png', 'ipod.png', 'key.png',
					'left_arrow.png', 'magnet.png', 'magnifier.png', 'megaphone.png',
					'microphone.png', 'minus.png', 'mobile_phone.png', 'monitor.png',
					'news.png', 'padlock.png', 'padlock_open.png', 'page.png', 'pencil.png',
					'photo.png', 'picture.png', 'pie_chart.png', 'placemark.png', 'plus.png', 
					'print.png', 'printer.png', 'question_mark.png', 'red_flag.png',
					'right_arrow.png', 'rss.png', 'save.png', 'school_board.png',
					'shopping_cart.png', 'shut_down.png', 'smart_phone.png',
					'sms.png', 'sound.png', 'star.png', 'star_empty.png', 'star_full.png',
					'star_half_full.png', 'tag.png', 'target.png', 'telephone.png',
					'television.png', 'toolbox.png', 'tv.png', 'umbrella.png', 'up_arrow.png',
					'upload.png', 'user.png', 'video.png', 'video_camera.png'
					, 'wired.png', 'wireless.png'
					 ]
				 for each (   str  in items ) 
				 {
					 pics.push( 'appicons/'+'a/'+'32x32/'+str	)
				 }
				 items = [
					 'forbidden_sign.png', 'rss.png', 'photo.png', 'printer.png', 'monitor.png',
					 'calendar.png', 'tv.png', 'close.png', 'shopping_cart.png', 'bar_chart.png',
					 'briefcase.png', 'smart_phone.png', 'pie_chart.png', 'pencil.png', 'folder.png',
					 'clock.png', 'envelope.png', 'umbrella.png', 'user.png', 'heart.png', 'tag.png',
					 'house.png', 'padlock.png', 'star.png', 'page.png', 'magnifier.png', 'plus.png',
					 'padlock_open.png', 'check_mark.png', 'danger_sign.png', 'placemark.png',
					 'down_arrow.png', 'comment_bubble.png', 'up_arrow.png',
					 'exclamanation_mark.png', 'right_arrow.png', 'left_arrow.png',
					 'question_mark.png', 'minus.png', 'info.png'
				 ]
				 for each (   str  in items ) 
				 {
					 pics.push( 'appicons/'+'b/'+'32x32/'+str	)
				 }				 
				 this.model.projectPics =  pics;
			 				
				
				this.model.boardHolder = event.data as  Group; 
				//FlexGlobals.topLevelApplication.boardGroup;
				return;
				this.model.editMode = true; 
				this.model.adminMode = true; 
				setTimeout(  this.onGoToEditMode, 1000 ) 
			}			
			if ( event.type == LoadDefaultDataTriggerEvent.AUTHENTICATE ) 
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
				 
				GraphWidget.importData('Eccles lister', 'Initial Stats', '89/6', 'Eccl1', 56, 100, 0xFCBF17,'', 3000).widgetData,
				GraphWidget.importData('Eccles lister', 'Brickman Stats', '89/6', 'Eccl2', 99, 100, 0x47C816,'', 15000).widgetData,
			 
				GraphWidget.importData('Eccles lister', '', 
					'{http://city-21.com/php/random_number.php}/100',
					'Ec3 - {http://city-21.com/php/random_string.php?f=8}',
					'{http://city-21.com/php/random_number.php}', 100, 0xFF3D19, '', 15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '12/100', 'Eccl4', 12, 100, 0x7652C0 , '', 15000).widgetData
				])
			/*arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="64" height="64" source="http://1.bp.blogspot.com/_TXuSIB9pJ-w/SG1MF_8aAlI/AAAAAAAAAAc/AqZh74YD2cw/s1600-R/tux-fal-64x64-transparent.png"/>'+
				'</TextFlow>',
			]	*/
		 
			arr.push( [
				GraphWidget.importData('Eccles lister', 'Initial Stats', '89/6', 'Eccl1', 56, 100, 0xFCBF17,'', 3000).widgetData,
			])
		 	 
			var fields : Array = [
				{name:'Key1', value:89, color:'#FF3D19', tooltip:'Key1 thing'},
				{name:'Key2', value:3, color:'#47C816', tooltip:'Key1 thing'},
				{name:'Key3', value:50, color:'#7652C0', tooltip:'Key1 thing'}
			]
			var pie : Object = {pie:fields}				
				
			
			
			var fields2 : Array = [
				{name:'Key1', value:89, color:'#FCBF17', tooltip:'Key1 thing'},
				{name:'Key2', value:3, color:'#47C816', tooltip:'Key1 thing'},
				{name:'Key1', value:89, color:'#FF3D19', tooltip:'Key1 thing'},
				{name:'Key2', value:3, color:'#666666', tooltip:'Key1 thing'},				
				{name:'Key3', value:50, color:'#7652C0', tooltip:'Key1 thing'}
			]
			var pie2 : Object = {pie:fields2}				
								
				
			var series : Array = [
				{name:'Profit',  color:'#FCBF17', tooltip:'Key1 thing'},
				{name:'Expenses',  color:'#47C816', tooltip:'Key1 thing'},
				{name:'Amount',   color:'#FF3D19', tooltip:'Key1 thing'}
			]
				Math.random()
			var data : Array = [
				{ Month: "Jan", Profit: 2000, Expenses: Math.random()*1500, Amount: 450 },
				{ Month: "Feb", Profit:Math.random()* 1000, Expenses: Math.random()*200, Amount: 600 },
				{ Month: "Mar", Profit: 1500, Expenses: Math.random()*1500, Amount: 300 },
				{ Month: "Apr", Profit: Math.random()* 1800, Expenses: Math.random()*1200, Amount: 900 },
				{ Month: "May", Profit: 2400, Expenses: Math.random()*575, Amount: 500 }
			]				
			var lineChart : Object = {line:{'data':data,'series':series}}						
				var ee : JSON
				//55,
				//JSON.encode( lineChart ),
			arr[arr.length-1][0].test.source = [ 
				JSON.encode( lineChart ) , 
			 	JSON.encode( pie ),
			 	JSON.encode( pie2 )
			]	
			arr[arr.length-2][0].test.source = [ 
				JSON.encode( lineChart ) , 
				JSON.encode( pie ),
				JSON.encode( pie2 )
			]						
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])		
			arr.push( [
				ProjectListWidget.importData('Project Lister', '', 355, 3000*10).widgetData,
			])			
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])			
				
			/*	 */
			
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img y="20"  paddingTop="10" width="32" height="32" source="http://www.iconarchive.com/icons/icontexto/webdev/32/webdev-alert-icon.png"/>'+
				'<span color="#EEE9E5"> 25 DAYS </span>'+
				'<span color="#A39F9C"> UNTIL IPAD LAUNCH</span></TextFlow>',
			]
								
				
			arr.push( [
				MessageWidget.importData('Global Alert', '', '25 Days until tswitter launch {http://city-21.com/php/random_number.php}' , 5000, 400).widgetData,
			])	
			arr[arr.length-1][0].test.source = ['s', 'd', 'x']
			arr[arr.length-1][0].test.source = ['loveless', '<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">ThiAdded <a>link</a> fo.<img width="300" height="300" source="gif/A01 copy.gif"/></TextFlow>',
				'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">Have you seen this person? <a>link</a><img width="300" height="300" source="gif/A02 copy.gif"/><p/>If so, call security x2929</TextFlow>',
				]
		
			/*	*/
			
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])		
			
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1','', 3000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '<TextFlow  xmlns="http://ns.adobe.com/textLayout/2008"><p ><span>Ein kritischer Blick in die Nachbarschaft:</span></p></TextFlow>', '',  15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', '',  15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
				PaneWidget.importData('Global Alert', '', '<b>•Custom Flex and ColdFusion Web Application Development</b><br/><b>• Custom AIR Desktop Application Development</b><br/><b>•Business Systems Analysis and Implementation</b>', '',  3000,  '0', '0x3D3F3C'  ).widgetData,				
			])	
			arr[arr.length-1][0].test.source = ['mtg @ 5', 'Be there or be square', 'drinks provided']
			arr[arr.length-1][0].test.background = ['<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img source="'+
				'http://icons.mysitemyway.com/wp-content/gallery/magic-marker-icons-transport-travel/116455-magic-marker-icon-transport-travel-transportation-van1.png'+
				//'bus.png'+
				'"/>'+
				'</TextFlow>',]
			arr[arr.length-1][0].test.background = [ 
				'<TextFlow verticalAlign="middle" xmlns="http://ns.adobe.com/textLayout/2008" >'+
				'<img  width="180" height="180" source="bus1.png"/>'+
				'</TextFlow>',
			]				
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000).widgetData,
			])		
			PanicLayouts.randomPic = this.randomPic
			PanicLayouts.randomX  = this.model.random
			/*
			arr = PanicLayouts.tooMuchTwitter();
			arr = PanicLayouts.panesX(); 
			arr = PanicLayouts.allWidgets(); 			
			*/
			arr = PanicLayouts.oneTwitter(); 	
			arr = PanicLayouts.tooMuchTwitter();
			//arr = PanicLayouts.testArraySourcing(); 	
			//arr = PanicLayouts.superheroPanes(board)
			//test for original sub contexts, they can be set externally 
			if ( event.preferredLayout != null ) 
				arr = event.preferredLayout; 
			board.layout = arr
				
			var people : Array = [] ; 
			board.people = people
			people.push( 	new PersonVO( 'John Stewart', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Patrick O. Song', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Hazel E. Bender', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Beth O. Woodard', '', '', '', PersonVO.getRandomPic() )  ) 
				
			people.push( 	new PersonVO( 'Louis O. Rosenthal', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Shirley E. Merritt', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Glenda O. Morgan', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Leon E. Pearson', '', '', '', PersonVO.getRandomPic() )  ) 
				
			people.push( 	new PersonVO( 'Joann T. Stout', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Brandon A. James', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Faye P. Sparks', '', '', '', PersonVO.getRandomPic() )  ) 
			people.push( 	new PersonVO( 'Christina O. Bowden', '', '', '', PersonVO.getRandomPic() )  ) 				
			
			var projects : Array = []; 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'http://www.veryicon.com/icon/32/Application/Office%20Round/Microsoft%20Project.png', this.randSet( 4,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 8,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'http://www.veryicon.com/icon/32/Application/Office%20Round/Microsoft%20Project.png', this.randSet( 4,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'gif/A01 copy.gif"', this.randSet( 12,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'id' ) ) ) 
			projects.push( new ProjectVO('Coda', 'coda is coda', 'march', 'error', [], 'a.jpg', this.randSet( 4,0, people, 'id' ) ) ) 				
			board.projects = projects
				
			this.model.board = board; 
			this.model.refreshBoard()
			
			this.model.adminMode = true; 
			
			
		}
		
		
		 public function CreateBoard(peopleNames : Array, projectNames : Array) :  BoardVO
		{
			
			var arr : Array = []; 
			var board : BoardVO = new BoardVO()
			board.name = 'blickem'
			arr.push( [
				
				GraphWidget.importData('Data 1', 'Initial Stats', '89/6', 'Eccl', 56, 100, 0xFCBF17,'', 15000).widgetData,
				GraphWidget.importData('Data 2', 'Brickman Stats', '89/6', 'Eccl2', 99, 100, 0x47C816,'', 15000).widgetData,
				
				GraphWidget.importData('Data 3', '', 
					'{http://city-21.com/php/random_number.php}/100',
					'{http://city-21.com/php/random_string.php?f=8}',
					'{http://city-21.com/php/random_number.php}', 100, 0xFF3D19, '', 15000).widgetData,
				GraphWidget.importData('Date 3', '', 'RATING', 'Eccl4', 12, 100, 0x7652C0 , '', 15000).widgetData
			])
			
			arr.push( [
				ProjectListWidget.importData('Project Lister', '', 355, 15000).widgetData,
			])			
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])						
			arr.push( [
				MessageWidget.importData('Global Alert', '', 'Alert' , 15000).widgetData,
			])	
			arr.push( [
				new WidgetVO( WidgetVO.SPACER )
			])		
			
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Pane 1','',   15000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', 'Pane 2','',   15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', 'Pane 3', '',  15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,	
			])	
			arr.push( [ new WidgetVO( WidgetVO.SPACER ) ])	
			arr.push( [
				TwitterScrollerTest2.importData('Twitter Pane', '...', 'Panic Board',  15000).widgetData,
			])					
			board.layout = arr
			
			var people : Array = [] ; 
			board.people = people
			for each ( var  name : String in peopleNames ) 
			{
				people.push( 	new PersonVO( name, '', '', '', PersonVO.getRandomPic() )  ) 
			}				
			var projects : Array = []; 
			for each ( name in projectNames ) 
			{
				projects.push( new ProjectVO( name, '', '', '', [], this.model.random( this.model.projectPics ).toString(), this.randSet( 4,0, people, 'id' ) ) ) 
			}
			board.projects = projects
			
			return board
			
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
			//dont' ask formore than we can provide
			for ( var i : int = 0 ; ret.length < Math.min(max, items.length) ; i++ )
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
		
		private function randomPic()  : Object
		{
			return this.model.random(this.model.projectPics)
		}
	}
}