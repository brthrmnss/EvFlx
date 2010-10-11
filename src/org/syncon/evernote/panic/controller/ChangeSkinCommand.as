package   org.syncon.evernote.panic.controller
{
	import org.robotlegs.mvcs.Command;
	import org.syncon.evernote.panic.model.PanicModel;
	
	public class ChangeSkinCommand  extends Command
	{
		[Inject] public var model : PanicModel;
		[Inject] public var event : ChangeSkinCommandTriggerEvent;
		override public function execute():void
		{
			 if ( event.type == ChangeSkinCommandTriggerEvent.CHANGE_SKIN ) 
			 {
				 
				this.model.backgroundColor = event.bgColor
				this.model.color = event.color
					
				this.model.bgSkin = event.bgSkin
				this.model.refreshSkin(); //
			 }
	 
		}
		
	}
}