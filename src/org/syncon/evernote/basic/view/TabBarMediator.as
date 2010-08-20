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
	import org.syncon.evernote.model.Note2;
	import org.syncon.evernote.model.Notebook2;
	
	public class TabBarMediator extends Mediator
	{
		[Inject] public var ui:tab_bar;
		[Inject] public var model : EvernoteAPIModel;
			
		public var notes : ArrayCollection = new ArrayCollection();
		private var firstTime : Boolean = true
		public var _selectedNote : Note2;
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
			eventMap.mapListener(eventDispatcher, 
				NoteListEvent.DESELECTED, onDeselectNotes );					
			
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
			 selectedNote = selectedNote 
		 }
		 public function set selectedNote(n:Note2):void
		 {
			 if ( this.ui.listNotes != null ) 
			 this.ui.listNotes.selectedItem = n
			/*	if ( n == null ) 
					this.ui.listNotes.selectedIndex = -1; */
			this._selectedNote= n; 
		 }
		 public function get selectedNote() : Note2
		 {
			 return this._selectedNote
		 }
		private function onViewNote(e:NoteListEvent):void
		{
			/*if ( this.firstTime )
			{
				this.firstTime = false
				this.onCreationComplete2()
			}*/
			//check for duplicates 
			var dupe : Boolean = false; 
			for each ( var j : Note2 in this.notes )
			{
				if ( j.guid == e.data.guid && j.newNote() == false ) 
					dupe = true; 
			}
			if ( dupe == false ) 
				this.notes.addItem( e.data ) ; 
			this.ui.currentState = 'active'
			this.selectedNote = e.data as Note2; 
			//this.ui.listNotes.selectedItem = e.data; 
			this.dispatch( new NoteListEvent( NoteListEvent.SWITCH_TO_NOTE, e.data ) ) ; 
		}
		
		private function onRemoveNote(e:CustomEvent):void
		{
			var index : int = this.notes.getItemIndex( e.data ) ;
			if ( index != -1 ) 
				this.notes.removeItemAt( index ) ; 
			if ( this.notes.length == 0 ) 
			{	this.ui.currentState = ''
				//go back to list state
				this.dispatch( new NoteListEvent( NoteListEvent.CLEARED_NOTES ) ) ; 
			}
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
			this.ui.currentState = ''; 
			this.dispatch( new NoteListEvent( NoteListEvent.CLEARED_NOTES   ) ) ; 
		}
		
		public function onDeselectNotes(e:NoteListEvent):void
		{
			//how to handle this ... just stop showing it as seleceted ... i don't care about this being in sync
			if ( this.selectedNote != null ) 
			{
			this.selectedNote.selected = false; 
			this.selectedNote.selectionChanged()
			}
			//this.selectedNote = null
			//this.dispatch( new NoteListEvent( NoteListEvent.SWITCH_TO_NOTE, e.data ) ) ; 
		}
 	
 
	}
}