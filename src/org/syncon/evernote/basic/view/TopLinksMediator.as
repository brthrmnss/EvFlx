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
	
	public class TopLinksMediator extends Mediator
	{
		[Inject] public var ui:top_links;
		[Inject] public var model : EvernoteAPIModel;
			
		public function TopLinksMediator()
		{
		} 
		
		override public function onRegister():void
		{
			/*
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTEBOOK_RESULT, this.onNotebookResult);
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchChanged);			
			ui.list.notes = this.model.notes; 
			*/
		}
		/*
		private function onChangeSearchBar(e:CustomEvent): void
		{
			this.model.currentNotebook( e.data as Notebook ) 
		}
 
		private function onNotebookResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.loadNotebooks(   e.data as ArrayCollection )
		}
		
		
		private function onSearchChanged(e:EvernoteAPIModelEvent) : void
		{
			this.ui.resultCount(  int( e.data.length )  )
		}		
 */
	}
}