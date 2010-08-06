package  org.syncon.evernote.basic.view.popup
{
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
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
		
		private function onSave(e:Event) : void
		{
			var tag :   Tag = new Tag()
			tag.name = this.ui.txtTagName.text
			var ee :  EvernoteAPICommandTriggerEvent
			this.dispatch( 
				EvernoteAPICommandTriggerEvent.CreateTag( tag, this.onTagCreateResult, this.onTagCreateFault )
				)
			//this.ui.treeControl.dataProvider = e.data as ArrayCollection
		}		
 
		public function onTagCreateResult(e:Tag):void
		{	
			
			this.ui.hide();
			return;
		}
		
		
		public function onTagCreateFault(e:Tag):void
		{
			
		}		
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
	 
		
	}
}