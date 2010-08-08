package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.SearchEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class LeftTagMediator extends Mediator
	{
		[Inject] public var ui:left_tag;
		[Inject] public var model : EvernoteAPIModel;
			
		public function LeftTagMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( left_tag.NEW_TAG, this.onNewTag )
			ui.addEventListener( left_tag.SELECTED_TAG, this.onSelectedTag )	
		}
	 
		private function onNewTag(e:Event):void
		{
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'popup_new_tag'  ) )  			
		}
		
		private function onSelectedTag(e:CustomEvent):void
		{
			this.dispatch( new SearchEvent( SearchEvent.SEARCH_TAGS_UPDATED, '', e.data as Array  ) ) 
		}
		
	}
}