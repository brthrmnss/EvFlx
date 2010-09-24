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
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.basic.vo.PreferencesVO;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.view.ProjectList;
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
		static public var LIVE_DATA : String = 'LoadDefaultDataCommand.LIVE_DATA'
		override public function execute():void
		{
			if ( event.type == START ) 
			{
				this.createStartData()				
			}
			if ( event.type == LIVE_DATA ) 
			{
				//this.liveData()
			}
		}
		
		public function createStartData() : void
		{
			var arr : Array = []; 
			var board : BoardVO = new BoardVO()
			arr.push( [
				GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl', 4, 100, '0xFCBF17',15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl2', 4, 100, '0x47C816',15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl3', 4, 100, '0xFF3D19', 15000).widgetData,
				GraphWidget.importData('Eccles lister', '', '89/6', 'Eccl4', 4, 100, '0x7652C0' , 15000).widgetData
				])
			arr.push( [
				ProjectList.importData('Project Lister', '', 350, 15000).widgetData,
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
			arr.push( [
				PaneWidget.importData('Global Alert', '', 'Something1', 15000,  '0x4D4844', '0x0E0E0E'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '2Something1', 15000,  '0x3E4B5C', '0x051931'  ).widgetData,
				PaneWidget.importData('Global Alert', '', '3Something1', 15000,  '0x3D3F3C', '0x3D3F3C'  ).widgetData,				
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
		
	}
}