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
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon.popups.controller.default_commands.ShowConfirmDialogTriggerEvent;
	
	public class LeftTagMediator extends Mediator
	{
		[Inject] public var ui:left_tag;
		[Inject] public var model : EvernoteAPIModel;
			
		public function LeftTagMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( left_tag.NEW_TAG, this.onNewTag )
			ui.addEventListener( left_tag.TAGS_SELECTED, this.onSelectedTag )	
			ui.addEventListener( left_tag.DELETE_TAG, this.onDeleteTag )	
			ui.addEventListener( left_tag.REMOVE_TAG_FROM_ALL_NOTES, this.onDeTag )	
			ui.addEventListener( left_tag.RENAME_TAG, this.onRenameTag )					
		}
	 
		private function onNewTag(e:Event):void
		{
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'popup_tag_form'  ) )  			
		}
		
		private function onRenameTag(e:CustomEvent):void
		{
			this.dispatch( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP, 'popup_tag_form' , [e.data]  ) )  			
		}
		
		private function onDeTag (e:CustomEvent):void
		{
			var ee : ShowConfirmDialogTriggerEvent
			ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP
			var msg : String = 'Remove the tag "'+e.data.name+
				'" from all notes? This operation cannot be undone.'
			ee =  	new ShowConfirmDialogTriggerEvent(
			ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, msg,
			this.onDeTagConfirmed, null, 'UnTag notes?', 'Remove', 'Cancel' ) 
			this.dispatch( ee  )  			
		}
			private function onDeTagConfirmed()  : void
			{
				
			}		
		
		private function onDeleteTag(e:CustomEvent):void
		{
			var ee : ShowConfirmDialogTriggerEvent
			ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP
			var msg : String = 'Are you sure you want to permanently delete the tag "'+
				e.data.name+'", and all of its sub-tags? This operation cannot be undone.'
			ee = new ShowConfirmDialogTriggerEvent( 
			ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, msg, 
			this.onDeleteTagConfirmed, null, 'Delete Tag', 'Delete', 'Cancel' ) 
			this.dispatch( ee  )  			
		}
			private function onDeleteTagConfirmed()  : void
			{
				
			}
		
		private function onSelectedTag(e:CustomEvent):void
		{
			var same :  Boolean = true
			if ( e.data.length != this.ui.dragging.length ) 
			{
				same = false; 
			}
			else
			{
				for each ( var obj : Object in e.data ) 
				{
					if ( this.ui.dragging.indexOf( obj ) == -1 ) 
						same = false; 
				}				
			}
			
			if ( same )
				return ; 
			
			this.dispatch( new SearchEvent( SearchEvent.SEARCH_TAGS_UPDATED, '', e.data as Array  ) ) 
		}
		
	}
}