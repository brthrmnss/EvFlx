package org.syncon.evernote.basic.view
{
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.controller.SearchEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.model.Notebook2;
	
	public class SearchBarMediator extends Mediator
	{
		[Inject] public var ui:search_bar;
		[Inject] public var model : EvernoteAPIModel;
			
		public function SearchBarMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener(search_bar.CHANGED_NOTEBOOK, this.onChangedNotebookFilter ) 
			ui.addEventListener(search_bar.REMOVED_TAG, this.onRemovedTag ) 			
			ui.addEventListener(search_bar.CHANGED_ALL_OR_ANY, this.onChangeAnyOrAllHandler ) 							
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
			
	/*		eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTEBOOK_RESULT, this.onNotebookResult);
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchChanged);			
			ui.list.notes = this.model.notes; 
			*/
			this.onRecievedNotebookList()
		}
		public 	var nf : NoteFilter = new NoteFilter()
		public var notebookFilter : Notebook2; 
		private function onChangedNotebookFilter(e:CustomEvent): void
		{
			this.notebookFilter = e.data as Notebook2
			if ( this.notebookFilter.guid == '' ) //replace for 'all' notebook
				this.notebookFilter = null; 
			nf.notebookGuid = this.notebookFilter.guid;
			this.loadSearch(); 
			this.model.currentNotebook( this.notebookFilter ) ; 
			
			//this.ui.selectNotebook( e.data as Notebook2 ); 
		}
		
		private function onChangeAnyOrAllHandler(e:CustomEvent): void
		{
			if ( e.data.toString().toLowerCase() == 'any' ) 
			{
				//this.nf.	
			}
			else
			{
				
			}
			this.loadSearch()
		}
			
		
		
		private function loadSearch()  : void
		{
			this.nf.tagGuids = this.model.map( this.tags.toArray(), 'guid' ); 
			this.dispatch( EvernoteAPICommandTriggerEvent.FindNotes( nf )  )
		}
		
		private function onNotesRecieved(e:EvernoteAPIModelEvent): void
		{
			this.ui.resultCount(e.data.length ) 
		}		
		
		private function onSearchHandler(e:SearchEvent):void
		{
			this.nf.words = e.query; 
			this.loadSearch(); 
			this.updateSearch()
		}
		
		public var tags : ArrayCollection = new ArrayCollection();
		public function onSearchTagsUpdatedHandler(e:SearchEvent):void
		{
			this.tags.removeAll()
			this.tags.addAll( new  ArrayCollection(e.objs)  ) 
			this.loadSearch(); 
			this.updateSearch()
		}
		
		
		/**
		 * Use notefilter update display 
		 * */
		public function updateSearch()  : void
		{
			var options : Array =[]; 
			if ( this.nf.words == null ) this.nf.words = ''; 
			var split  :  Array = this.nf.words.split(' '); 
			if ( this.nf.words == '' ) 
				split = []; 
			for each ( var option : String in split ) 
			{
				if ( option != ' ' ) 
				{
					options.push( option ) 
				}
			}
			
			if ( this.tags.length > 0 ) 
			{
				options.push( '***tagged with:' )
					
				for each ( var tag :  Object in this.tags ) 
				{
					options.push( tag.name ) 
				}			
			}
			
			this.dispatch( new SearchEvent(SearchEvent.SEARCH_UPDATED, this.nf.words ) ) 
			this.ui.updateQueryParts( options ); 
			if ( options.length == 0 ) 
				this.clearSearch(); 
			
		
			this.loadSearch(); 
		}
		
		/**
		 * In the future potential adjust search, but this is coming form teh left side
		 * */
		private function onCurrentNotebookChanged(e:EvernoteAPIModelEvent): void
		{
			
			this.notebookFilter = e.data as Notebook2; 
			this.ui.selectNotebook(this.notebookFilter); 
			this.clearSearch()
		}
		
		private function clearSearch()  : void
		{
			this.tags.removeAll()
			this.ui.clearSearch();
			//this.notebookFilter = null; 
			this.nf = new NoteFilter();
			if ( this.notebookFilter != null ) 
				this.nf.notebookGuid = notebookFilter.guid
			this.dispatch( new SearchEvent(SearchEvent.SEARCH_UPDATED, this.nf.words ) ) 
		}
		
		
		/**
		 * When notebooks changed regenerate drop 
		 * */
		private function onRecievedNotebookList(e:EvernoteAPIModelEvent=null) : void
		{
			this.ui.loadNotebooks(  this.model.notebooks); 
			this.ui.selectNotebook( this.notebookFilter ); 
		}				
				
		
		private function onRemovedTag(e:CustomEvent): void
		{
			
			var clipped : Array = []; 
			//some type of check if this was a word portion
				var options : Array = nf.words.split(' '); 
				for each ( var option :  String in options ) 
				{
					if ( option != e.data.name.toString() )
						clipped.push( option ) 
				}
			nf.words = clipped.join(' '); 
			/*if ( clipped.length == 0 ) 
				nf.words = ''; */
			//this.model.currentNotebook( e.data as Notebook ) 
			e.stopImmediatePropagation();
			this.loadSearch()
			this.updateSearch()
		}
				
		
		private function onNotebookResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.loadNotebooks(   e.data as ArrayCollection )
		}
		
		
		private function onSearchChanged(e:EvernoteAPIModelEvent) : void
		{
			this.ui.resultCount(  int( e.data.length )  )
		}		
 
	}
}