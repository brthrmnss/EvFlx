package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	
	public class ListEditorMediator extends Mediator
	{
		[Inject] public var ui:list_editor;
		[Inject] public var model : EvernoteAPIModel;
			
		public function ListEditorMediator()
		{
		} 
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, this.onNotebookResult);
			this.ui.dropdownNotebook.dataProvider = this.model.notebooks 
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_TAGS, this.onTagsRecieved);
			this.ui.tags  = this.model.tags 				
		}
	 
		private function onNotebookResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.dropdownNotebook.dataProvider = new ArrayCollection( e.data as Array )
			//this.ui.dropdownNotebook.
		}
		
		private function onTagsRecieved(e:EvernoteAPIModelEvent) : void
		{
			this.ui.tags = new ArrayCollection( e.data as Array )
		}
				
	 
		
	}
}