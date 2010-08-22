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
			ui.addEventListener(search_bar.CHANGED_NOTEBOOK, this.onChangedcurrentNotebook ) 
			ui.addEventListener(search_bar.REMOVED_TAG, this.onRemovedTag ) 			
			ui.addEventListener(search_bar.CHANGED_ALL_OR_ANY, this.onChangeAnyOrAllHandler )
			ui.addEventListener(search_bar.CLEAR_SEARCH, this.onClearSearchHandler ) 						
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
				this.currentNotebook = this.model.notebook; //(
		}
		public 	var nf : NoteFilter = new NoteFilter()
		public var currentNotebook : Notebook2; 
		private function onChangedcurrentNotebook(e:CustomEvent): void
		{
			this.currentNotebook = e.data as Notebook2
			
			this.doSearch(); 
			this.model.currentNotebook( this.currentNotebook ) ; 
			
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
			this.doSearch()
		}
			
		private function onClearSearchHandler(e:CustomEvent):void
		{
			//456 jgh kjg hhjgjh  ghghg h hg jhhjjjjjjjjjjj gggggg ggg456 jgh kjg hhjgjh  ghghg h hg jhhjjjjjjjjjjj gggggg ggg456 jgh kjg hhjgjh  ghghg h hg jhhjjjjjjjjjjj gggggg ggg
			this.clearSearch();
		}
		
		
		private function doSearch()  : void
		{
			//var nf : NoteFilter = new NoteFilter()
			nf.notebookGuid = this.currentNotebook.guid;
			if ( this.currentNotebook.guid == '-1' ) 
				nf.unsetNotebookGuid();
			
			//trace( this.currentNotebook.name + ' ' + this.currentNotebook.guid  ) 
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
			this.doSearch(); 
			this.updateSearch()
		}
		
		public var tags : ArrayCollection = new ArrayCollection();
		public function onSearchTagsUpdatedHandler(e:SearchEvent):void
		{
			this.tags.removeAll()
			this.tags.addAll( new  ArrayCollection(e.objs)  ) 
			this.doSearch(); 
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
				if ( option != ' ' && option != ''  ) 
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
			
		
			this.doSearch(); 
		}
		
		/**
		 * In the future potential adjust search, but this is coming form teh left side
		 * */
		private function onCurrentNotebookChanged(e:EvernoteAPIModelEvent): void
		{
			//do not repeat search if nb the same
			if ( this.currentNotebook == e.data )
				return; 
			this.currentNotebook = e.data as Notebook2; 
			this.ui.selectNotebook(this.currentNotebook); 
			
			this.doSearch()
			//this.clearSearch()
		}
		
		private function clearSearch()  : void
		{
			this.tags.removeAll()
			this.ui.clearSearch();
			//this.currentNotebook = null; 
			this.nf = new NoteFilter();
			if ( this.currentNotebook != null ) 
				this.nf.notebookGuid = currentNotebook.guid
			this.dispatch( new SearchEvent(SearchEvent.SEARCH_UPDATED, this.nf.words ) ) 
			this.doSearch()
		}
		
		
		/**
		 * When notebooks changed regenerate drop 
		 * */
		private function onRecievedNotebookList(e:EvernoteAPIModelEvent=null) : void
		{
			this.ui.loadNotebooks(  this.model.notebooksAndAll() ); 
			this.ui.selectNotebook( this.currentNotebook ); 
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
			
			if ( this.tags.getItemIndex( e.data ) != -1 ) 
			{
				this.tags.removeItemAt( this.tags.getItemIndex( e.data ) ) 
			}
			
		//	nf.tagGuids
			/*if ( clipped.length == 0 ) 
				nf.words = ''; */
			//this.model.currentNotebook( e.data as Notebook ) 
			e.stopImmediatePropagation();
			this.doSearch()
			this.updateSearch()
		}
				
		private function onSearchChanged(e:EvernoteAPIModelEvent) : void
		{
			this.ui.resultCount(  int( e.data.length )  )
		}		
 
	}
}