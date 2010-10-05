package   org.syncon.evernote.panic.controller
{
	import com.adobe.serialization.json.JSON;
	
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.BoardVO;
	import org.syncon.popups.controller.HidePopupEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class HoverPersonCommand extends Command
	{
		[Inject] public var model:PanicModel;
		[Inject] public var event:   HoverPersonEvent;
		override public function execute():void
		{
			 if ( event.type = HoverPersonEvent.SHOW_PERSON_HOVER ) 
			 {
				 this.dispatch( 
				new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'PopupPersonHover', [event.person, event.ui] )
				)
			 }
			 if ( event.type = HoverPersonEvent.HIDE_PERSON_HOVER ) 
			 {
				 this.dispatch( 
					 new HidePopupEvent( HidePopupEvent.HIDE_POPUP, 'PopupPersonHover', [event.person, event.ui]] )
					 )
			 }			 
			 
		}
		
		public function release( result  : String = null, errors : Array = null  ) : void
		{
			if ( result == null )
			{
				result = event.src; 
			}
			
			if ( event.host != null ) 
				event.host[event.property] = result
			if ( event.fxSet != null ) 
				event.fxSet( result ) 
		}
		
		
	}
}