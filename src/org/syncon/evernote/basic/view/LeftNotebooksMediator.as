package org.syncon.evernote.basic.view
{
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.model.Notebook2;
	
	public class LeftNotebooksMediator extends Mediator
	{
		[Inject] public var ui:left_notebooks;
		[Inject] public var model : EvernoteAPIModel;
			
		public function LeftNotebooksMediator()
		{
		} 
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.RECIEVED_TAGS,
				this.onRecievedTags);	
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_SAVED_SEARCHES, this.onRecievedSearches);		
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, this.onRecievedNotebookList);	
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.CURRENT_NOTEBOOK_CHANGED, this.onCurrentNotebookChanged);				
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.TRASH_SIZE_CHANGED, this.onTrashChanged);					
			*/
			 ui.addEventListener(left_notebooks.CHANGED_NOTEBOOK, this.onChangedNotebook ) ; 
		}
		
		/*
		
		private function onCurrentNotebookChanged(e:EvernoteAPIModelEvent): void
		{
			if ( this.ui.listNotebooks != null ) 
				this.ui.listNotebooks.selectedNotebook = e.data as Notebook2
		}		
	 */
		private var notebookFilter : Notebook2
		/**
		 * When user changes the notebook , update, and do a search 
		 * */
		private function onChangedNotebook(e:CustomEvent) : void
		{
			this.notebookFilter = e.data as Notebook2
			if ( this.notebookFilter.guid == '' ) //replace for 'all' notebook
				this.notebookFilter = null; 
			var nf : NoteFilter = new NoteFilter()
			nf.notebookGuid = this.notebookFilter.guid;
			//var ee :  EvernoteAPICommandTriggerEvent
			this.dispatch( EvernoteAPICommandTriggerEvent.FindNotes( nf )  )
			this.model.currentNotebook( this.notebookFilter ) ; 			
		}		
 
		 
		
	}
}