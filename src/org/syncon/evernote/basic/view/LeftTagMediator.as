package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	
	public class LeftTagMediator extends Mediator
	{
		[Inject] public var ui:left_tag;
		[Inject] public var model : EvernoteAPIModel;
			
		public function LeftTagMediator()
		{
		} 
		
		override public function onRegister():void
		{
			//ui.addEventListener( 'changedNotebook', this.onChangeSearchBar ) 
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.RECIEVED_TAGS,
				this.onRecievedTags);	
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_SAVED_SEARCHES, this.onRecievedSearches);		
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, this.onRecievedNotebookList);		
			//ui.list.notes = this.model.notes; 
			if ( this.ui.tags != null )
			this.ui.tags.tags = this.model.tags;
			this.ui.listSavedSearches.dataProvider = this.model.savedSearches; 
			if ( this.ui.listNotebooks != null )			
			this.ui.listNotebooks.notebooks = this.model.notebooks		
		}
		
		private function onRecievedTags(e:EvernoteAPIModelEvent) : void
		{
			this.ui.tags.tags = this.model.tags;
		}		
 
		private function onRecievedSearches(e:EvernoteAPIModelEvent) : void
		{
			this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
		
		private function onRecievedNotebookList(e:EvernoteAPIModelEvent) : void
		{
			this.ui.listNotebooks.notebooks = this.model.notebooks; //s	  = e.data as ArrayCollection
		}				
		
		
	}
}