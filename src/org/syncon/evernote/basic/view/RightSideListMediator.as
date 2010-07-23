package org.syncon.evernote.basic.view
{
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.view.basic.right_side;
	
	public class RightSideListMediator extends Mediator
	{
		[Inject] public var ui:right_side;
		
		public function RightSideListMediator()
		{
		} 
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.SHOW_POPUP, onShowPopup );
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.HIDE_POPUP, onHidePopup);
			*/
		}
 		/*
		private function onShowPopup(e:Event):void
		{
			this.popup.show()
		}			
		
		private function onHidePopup(e:Event):void
		{
			this.popup.hide()
		}					
		*/
		
	}
}