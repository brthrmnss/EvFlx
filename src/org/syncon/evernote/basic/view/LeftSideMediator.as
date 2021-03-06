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
	import org.syncon.evernote.model.Notebook2;
	
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
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_SAVED_SEARCHES, this.onRecievedSearches);		
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, this.onRecievedNotebookList);	
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.CURRENT_NOTEBOOK_CHANGED, this.onCurrentNotebookChanged);				
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.TRASH_SIZE_CHANGED, this.onTrashChanged);					
		/*	eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.NOTE_COUNT_CHANGED, this.onNoteCountChanged);		*/		
			//ui.list.notes = this.model.notes; 

			if ( this.ui.listSavedSearches != null )			
			this.ui.listSavedSearches.notebooks = this.model.savedSearches; 

		}
		
		
		
		private function onCurrentNotebookChanged(e:EvernoteAPIModelEvent): void
		{
			if ( this.ui.listNotebooks != null ) 
				this.ui.listNotebooks.selectedNotebook = e.data as Notebook2
		}		

		private function onRecievedSearches(e:EvernoteAPIModelEvent) : void
		{
			this.ui.listSavedSearches.notebooks = e.data as ArrayCollection
		}				
		
		private function onRecievedNotebookList(e:EvernoteAPIModelEvent=null) : void
		{
			if ( this.ui.listNotebooks == null )return; 		
			this.ui.listNotebooks.notebooks = this.model.notebooksAndAll()
		}				
		
		private function onTrashChanged(e:EvernoteAPIModelEvent) : void
		{
			this.ui.drawer6_.rightLabel    = this.model.trashCount.toString()
			//	.notebooks = this.model.notebooks; //s	  = e.data as ArrayCollection
		}				
		/*
		private function onNoteCountChanged(e:EvernoteAPIModelEvent):void
		{
			if ( this.ui.listNotebooks == null  )
				return; 
			this.ui.listNotebooks.allNotebooksNotebok.noteCount = this.model.noteCount; 
			this.ui.listNotebooks.allNotebooksNotebok.notebookUpdated()
		}
		*/
	}
}