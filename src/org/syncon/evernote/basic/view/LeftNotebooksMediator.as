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
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon.popups.controller.default_commands.ShowConfirmDialogTriggerEvent;
	
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
			 
			 ui.addEventListener( left_notebooks.NEW_NOTEBOOK, this.onNewTag )
			 ui.addEventListener( left_notebooks.DELETE_NOTEBOOK, this.onDeleteTag )	
			 ui.addEventListener( left_notebooks.VIEW_NOTEBOOK_PROPERTIES, this.onViewNotebookProperties )	
			 ui.addEventListener( left_notebooks.RENAME_NOTEBOOK, this.onRenameTag )					 
			 
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
 
		private function onNewTag(e:Event):void
		{
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'popup_notebook_form'  ) )  			
		}
		
		private function onRenameTag(e:CustomEvent):void
		{
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'popup_notebook_form' , [e.data]  ) )  			
		}
		
		private function onViewNotebookProperties(e:CustomEvent):void
		{
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'popup_notebook_form' , [e.data, true]  ) )  			
		}				
		
		private function onDeleteTag(e:CustomEvent):void
		{
			var ee : ShowConfirmDialogTriggerEvent
			ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP
			var msg : String = 'Permanently deleting "'+e.data.name+
				'". '+e.data.noteCount+' active note(s) will be moved to the trash.' +
				' This operation cannot be undone.'
			ee = new ShowConfirmDialogTriggerEvent( 
				ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, msg, 
				this.onDeleteTagConfirmed, null, 'Delete Notebook?', 'Delete', 'Cancel' ) 
			this.dispatch( ee  )  			
		}
			private function onDeleteTagConfirmed()  : void
			{
				
			}		
		
		
		
		
	}
}