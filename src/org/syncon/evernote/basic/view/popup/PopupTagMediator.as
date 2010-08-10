package  org.syncon.evernote.basic.view.popup
{
	import com.evernote.edam.type.Tag;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	
	public class PopupTagMediator extends Mediator
	{
		[Inject] public var ui:PopupTagForm;
		[Inject] public var model : EvernoteAPIModel;
			
		public function PopupTagMediator()
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
			if ( this.ui.tag != null ) 
			{
				tag.guid = this.ui.tag.guid;
				this.dispatch( 
					EvernoteAPICommandTriggerEvent.UpdateTag( tag, this.onTagUpdatedResult, 
						this.onTagUpdateFault )
				)				
			}
			else
			{
				this.dispatch( 
					EvernoteAPICommandTriggerEvent.CreateTag( tag, this.onTagCreateResult, 
						this.onTagCreateFault )
					)
			}
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
		
		/**
		 * Service returns numbers
		 * */
		public function onTagUpdatedResult(e: Number):void
		{	
			this.ui.tag.name = this.ui.txtTagName.text; 
			this.ui.tag.tagUpdated(); 
			this.ui.hide();
			return;
		}
		
		public function onTagUpdateFault(e:Tag):void
		{
		}			
		
		private function onCancel(e:Event) : void
		{
			this.ui.hide();
			//this.ui.listSavedSearches.dataProvider = e.data as ArrayCollection
		}				
	 
		
	}
}