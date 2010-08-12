package org.syncon.evernote.basic.view
{
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.controller.NoteListEvent;
	import org.syncon.evernote.basic.controller.SearchEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.model.Notebook2;
	
	public class TabBarMediator extends Mediator
	{
		[Inject] public var ui:tab_bar;
		[Inject] public var model : EvernoteAPIModel;
			
		public var notes : ArrayCollection = new ArrayCollection();
		private var firstTime : Boolean = true
		public function TabBarMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener(tab_bar.NOTE_LIST_ADDED, this.onCreationComplete2 ) 
			
			ui.addEventListener(tab_bar.SELECTED_NOTE, this.onChangedNote ) 
			//ui.addEventListener(tab_bar.ADD_NOTE, this.onChangedNote ) 
			ui.addEventListener(tab_bar.REMOVE_NOTE, this.onRemoveNote ) 				
			ui.addEventListener(tab_bar.CLEAR_TABS, this.onClearTabsHandler ) 						
			this.model.eventDispatcher.addEventListener(
				EvernoteAPIModelEvent.LOGOUT, this.onLogout);	
			eventMap.mapListener(eventDispatcher, 
				NoteListEvent.VIEW_NOTE, onViewNote );				
		/*
			this.model.eventDispatcher.addEventListener(
				EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, this.onRecievedNotebookList);	
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.NOTES_RESULT, this.onNotesRecieved);	
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.CURRENT_NOTEBOOK_CHANGED, this.onCurrentNotebookChanged);			
			eventMap.mapListener(eventDispatcher, 
				SearchEvent.SEARCHED, this.onSearchHandler );		
			eventMap.mapListener(eventDispatcher, 
				SearchEvent.SEARCH_TAGS_UPDATED, this.onSearchTagsUpdatedHandler );				
 */
		}
		private function onCreationComplete2(e:Event =null):void
		 {
			 ui.listNotes.dataProvider = this.notes; 
		 }
		 
		private function onViewNote(e:NoteListEvent):void
		{
			/*if ( this.firstTime )
			{
				this.firstTime = false
				this.onCreationComplete2()
			}*/
			//check for duplicates 
			this.notes.addItem( e.data ) ; 
			this.ui.currentState = 'active'
		}
		
		private function onRemoveNote(e:NoteListEvent):void
		{
			var index : int = this.notes.getItemIndex( e.data ) ;
			if ( index != -1 ) 
				this.notes.removeItemAt( index ) ; 
			if ( this.notes.length == 0 ) 
				this.ui.currentState = ''
		}		
		
	 	private function onLogout(e:Event):void
		{
			this.clearTabs()
		}
		private function onClearTabsHandler(e:CustomEvent):void
		{
			this.clearTabs();
		}
		
		 
		private function onChangedNote(e:CustomEvent): void
		{
			 this.dispatch( new NoteListEvent( NoteListEvent.SWITCH_TO_NOTE, e.data ) ) ; 
		}
		
		private function clearTabs()  : void
		{
			this.notes.removeAll();
		}
		
 	
 
	}
}