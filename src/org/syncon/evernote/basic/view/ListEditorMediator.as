package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.controller.SaveNoteCommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.model.Notebook2;
	import org.syncon.evernote.model.Tag2;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	
	public class ListEditorMediator extends Mediator
	{
		[Inject] public var ui:list_editor;
		[Inject] public var model : EvernoteAPIModel;
			
		public function ListEditorMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( list_editor.NOTE_NOTEBOOK_CHANGED, this.onNotebookChanged ) 
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_NOTEBOOK_LIST, this.onNotebookResult);
			
			this.ui.addEventListener( list_editor.TAG_ADDED, this.onTagAdded ) 
			
			this.ui.dropdownNotebook.dataProvider = this.model.notebooks 
			this.ui.updateDropdownSize() 
			eventMap.mapListener(eventDispatcher, 
				EvernoteAPIModelEvent.RECIEVED_TAGS, this.onTagsRecieved);
			this.ui.tags  = this.model.tags 				
		}
	 
		private function onNotebookResult(e:EvernoteAPIModelEvent) : void
		{
			this.ui.dropdownNotebook.dataProvider = new ArrayCollection( e.data as Array )
			this.ui.updateDropdownSize() 
		}
		
		private function onTagsRecieved(e:EvernoteAPIModelEvent) : void
		{
			this.ui.tags = new ArrayCollection( e.data as Array )
			this.ui.txtTags.dataProvider = this.ui.tags; 
			//this.ui
		}
				
		private var oldNotebook : Notebook2; // = this.dropdownNotebook.dataProvider[event.oldIndex] 
		private var newNotebook : Notebook2; // = this.dropdownNotebook.dataProvider[event.newIndex] 
					
	 	public function onNotebookChanged(e:CustomEvent )  : void
		{
			this.oldNotebook = e.data.oldNb; 
			this.newNotebook = e.data.newNb; 
			//this.ui.note;
			this.dispatch( 
				new SaveNoteCommandTriggerEvent( 
					SaveNoteCommandTriggerEvent.SAVE_NOTE_CHANGE_NOTEBOOK,
					this.ui.note , 
					null, callbackFx, 
				null, false, this.oldNotebook )			
				)
		}
		
		public function onTagAdded(e:CustomEvent):void
		{
			var args : Object = this.ui.getTemp()
			this.dispatch( 
				new SaveNoteCommandTriggerEvent( 
					SaveNoteCommandTriggerEvent.SAVE_NOTE_TAGS, args.note, 
					args.tf, callbackFx, 
					this.saveEditorSwitchedOutNoteFault, true, null, e.data as Tag2 )	
			)					

		}
		private function saveEditorSwitchedOutNoteFault( o:Object):void
		{
			//var ee : ShowAlertMessageTriggerEvent
			this.dispatch( new   ShowAlertMessageTriggerEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 'Could not save note...') )  
			return;
		}					
				
		
		public function callbackFx(e:Object):void
		{
			//change notebooks ... 
		}
		
		
	}
}