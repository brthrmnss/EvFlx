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
				ProjectList.importData('Eccles lister', '', '89/6', 'Eccl', 4, 100, '', '', 15000).widgetData,
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
			board.ppl = arr
			this.model.board = board; 
			this.model.refreshBoard()
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