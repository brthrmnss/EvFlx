package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
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
			if ( ui._tagNames != null ) 
				this.lookupTagNames( this.ui._tagNames ) ; 
		}
		private function onRemoveTag(e:CustomEvent): void
		{
			if ( this.ui.updateNote == null ) 
			{
				trace( ' need a note ' ) ; 
				return
			}
			
			
			var noteCopy : Note = new Note()
			noteCopy.guid = this.ui.updateNote.guid
				
			var tag :  Tag = e.data as Tag;
			for each ( var guid :  String in  this.ui.updateNote.tagGuids )
			{
				if ( guid != tag.guid ) 
					noteCopy.tagGuids.push( guid ) 
			}
		
			this.dispatch( EvernoteAPICommandTriggerEvent.UpdateNote(noteCopy, tagRemoved, tagNoteRemoved) )
			//this.model.currentNotebook( e.data as Notebook ) 
		}		
		
		private function tagRemoved(e:Event): void
		{
			return;
		}
		private function tagNoteRemoved(e:Event): void
		{
			return; 
		}		
		
		private function onGetGuids(e:CustomEvent): void
		{
			//var tagNames : Array = e.data as Array 
			//if ( tagNames.length == 0 )
				
			this.lookupTagNames( e.data as Array )
		}
		public function lookupTagNames( tagNames : Array )  : void
		{
			var result : Array = this.model.convertTagNamesToTags(tagNames ) 
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