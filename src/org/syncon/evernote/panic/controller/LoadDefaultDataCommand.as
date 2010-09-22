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
				new WidgetVO( WidgetVO.GRAPH, '3/5', 'Eccl', 35/10 )
				
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