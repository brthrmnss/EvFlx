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
	import org.syncon.evernote.model.Notebook2;
	
	public class HeaderMediator extends Mediator
	{
		[Inject] public var ui:header;
		[Inject] public var model : EvernoteAPIModel;
		
		public function HeaderMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED,
				this.onAuthenticated);	
			ui.addEventListener(header.SEARCH, this.onSearch ) 
			
			eventMap.mapListener(eventDispatcher, SearchEvent.SEARCH_UPDATED,
				this.onSearchUpdatedHandler);				
		/*	
			if ( this.ui.tags != null )
			this.ui.tags.tags = this.model.tags;
			this.ui.listSavedSearches.dataProvider = this.model.savedSearches; 
			if ( this.ui.listNotebooks != null )			
			this.ui.listNotebooks.notebooks = this.model.notebooks		*/
		}
		
		
		
		private function onAuthenticated(e:EvernoteAPIModelEvent): void
		{
		/*	if ( this.ui.listNotebooks != null ) 
				this.ui.listNotebooks.selectedNotebook = e.data as Notebook2*/
		}		
	 
		private function onSearch(e:CustomEvent) : void
		{
			this.dispatch( new SearchEvent( SearchEvent.SEARCHED, e.data.toString() ) ) 
		}		
		
		private function onSearchUpdatedHandler(e:SearchEvent) : void
		{
			this.ui.txtQuery.text = e.query; 
			//move t oend ..
			//this.ui.txtQuery.selectRange( 
		}				
  
	}
}