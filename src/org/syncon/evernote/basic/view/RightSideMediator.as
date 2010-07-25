package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	
	public class RightSideMediator extends Mediator
	{
		[Inject] public var ui:right_side;
		[Inject] public var model : EvernoteAPIModel;
		static public var StateView : String = 'view'
		static public var StateList : String = ''
		static public var StateEditor : String = 'edit'
		static public var StateSearch : String = 'search'
			
		public function RightSideMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( 'clickedNote', this.onNoteClicked ) 
			ui.addEventListener( 'clicked'+'New', this.onNewClicked ) 
			ui.addEventListener( 'clicked'+'List', this.onListClicked ) 
			ui.addEventListener( 'clicked'+'Edit', this.onEditClicked ) 				
			ui.addEventListener( 'clicked'+'Email',this.onEmailClicked ) 
			ui.addEventListener( 'clicked'+'Delete',this.onDeleteClicked ) 
			ui.addEventListener( 'clicked'+'Print', this.onPrintClicked ) 
			/*
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.SHOW_POPUP, onShowPopup );
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.HIDE_POPUP, onHidePopup);
			*/
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTES_RESULT, this.onNoteResult);
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchResult);	
			
			ui.list.notes = this.model.notes; 
		}
		
		private function onNoteClicked(e:CustomEvent): void
		{
			ui.currentState = StateView
			ui.view.note = e.data as Note
		}
		private function onNewClicked(e:CustomEvent): void
		{
			ui.currentState = StateView
			ui.view.onNew(); //note = e.data as Note
		}
		private function onListClicked(e:CustomEvent): void
		{
			ui.currentState =StateList
		}
		private function onEditClicked(e:CustomEvent): void
		{
			ui.currentState = StateEditor
			//ui.edit.note = e.data as Note			
			
		}
		private function onEmailClicked(e:CustomEvent): void
		{
		}
		private function onDeleteClicked(e:CustomEvent): void
		{
		}
		private function onPrintClicked(e:CustomEvent): void
		{
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
		private function onNoteResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.currentState = StateList
			this.ui.list.notes = e.data as ArrayCollection
		}
		private function onSearchResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.currentState = StateSearch
			this.ui.search.notes = e.data as ArrayCollection			
		}		
		
	}
}