package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	
	public class RightSideMediator extends Mediator
	{
		[Inject] public var ui:right_side;
		
		public function RightSideMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( 'clickedNote', this.onNoteClicked ) 
			/*
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.SHOW_POPUP, onShowPopup );
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.HIDE_POPUP, onHidePopup);
			*/
		}
		
		private function onNoteClicked(e:CustomEvent): void
		{
			ui.currentState = 'view'
			ui.view.note = e.data as Note
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