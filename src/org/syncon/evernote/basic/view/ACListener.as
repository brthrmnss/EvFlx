package org.syncon.evernote.basic.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class ACListener 
	{
		[Inject] public var ui:util_left_side_extra_options;
			
		public function ACListener()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( 'openMenu' , this.onOpenMenu)
		}
		
		private function onOpenMenu(e: CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'utilsExtraOptionsPopup',[ e.data, this.ui.lblTxt]  ) )  
		}		
 
 
		
	}
}