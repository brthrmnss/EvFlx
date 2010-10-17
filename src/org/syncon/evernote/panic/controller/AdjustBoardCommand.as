package   org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	
	import mx.controls.Spacer;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.view.BoardRow;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.view.ProjectListWidget;
	import org.syncon.evernote.panic.view.SpacerWidget;
	import org.syncon.evernote.panic.view.TwitterScrollerTest2;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.evernote.services.EvernoteService;
	
	import spark.components.Group;
	import spark.components.HGroup;
	
	/**
	 * Some alterations to the board can only take plac eo na idfferent context  
	 * @author user3
	 * 
	 */
	public class AdjustBoardCommand extends Command
	{
		[Inject] public var model:PanicModel;
		 [Inject] public var event: AdjustBoardCommandTriggerEvent;
		 
		override public function execute():void
		{
		   if ( event.type == AdjustBoardCommandTriggerEvent.VERTICAL_GAP ) 
		   {
			  // this.board.verticalGap = verticalGap 
			  // this.dispatch( new BoardModelEvent( BoardModelEvent.VERTICAL_GAP_CHANGED ) ) 
			   var  vgroup :  Object = this.model.boardHolder.layout  
			   vgroup.gap = this.event.value; //.verticalGap;			   
		   }
		}
			
 
		
	}
}