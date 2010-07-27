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
	
	public class LeftSideMediator extends Mediator
	{
		[Inject] public var ui:left_side;
		[Inject] public var model : EvernoteAPIModel;
			
		public function LeftSideMediator()
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
		
			this.ui.treeControl.dataProvider = this.model.tags;
			this.ui.listSavedSearches.dataProvider = this.model.savedSearches; 
			this.ui.listNotebooks.list.dataProvider = this.model.notebooks		
		}
		
		private function onRecievedTags(e:EvernoteAPIModelEvent) : void
		{
			this.ui.treeControl.dataProvider = e.data as ArrayCollection
		}		
 
		private function onRecievedSearches(e:EvernoteAPIModelEvent) : void
		{
			this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
		
		private function onRecievedNotebookList(e:EvernoteAPIModelEvent) : void
		{
			this.ui.listNotebooks.list.dataProvider = e.data as ArrayCollection
		}				
		
		
	}
}