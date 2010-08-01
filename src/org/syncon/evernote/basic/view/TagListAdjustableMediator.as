package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	
	public class TagListAdjustableMediator extends Mediator
	{
		[Inject] public var ui:TagListAdjustable;
		[Inject] public var model : EvernoteAPIModel;
			
		public function TagListAdjustableMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( 'removeTag', this.onRemoveTag )
				ui.addEventListener( 'getGuidsForTags', this.onGetGuids )
			/*
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTEBOOK_RESULT, this.onNotebookResult);
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchChanged);			
			ui.list.notes = this.model.notes; 
			*/
		}
		private function onRemoveTag(e:CustomEvent): void
		{
			var tag :  Tag = e.data as Tag;
			//this.model.currentNotebook( e.data as Notebook ) 
		}		
		private function onGetGuids(e:CustomEvent): void
		{
			var result : Array = this.model.convertTagNamesToTags( e.data as Array ) 
			this.ui.tags = new ArrayCollection( result )  
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