package  org.syncon.evernote.basic.view.popup
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.basic.view.popup.PopupNewTag;
	
	public class PopupNewTagMediator extends Mediator
	{
		[Inject] public var ui:PopupNewTag;
		[Inject] public var model : EvernoteAPIModel;
			
		public function PopupNewTagMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 
			this.ui.addEventListener( 'save', this.onSave )
			this.ui.addEventListener( 'cancel', this.onCancel )
		}
		
		private function onSave(e:EvernoteAPIModelEvent) : void
		{
			//this.ui.treeControl.dataProvider = e.data as ArrayCollection
		}		
 
		private function onCancel(e:EvernoteAPIModelEvent) : void
		{
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
	 
		
	}
}