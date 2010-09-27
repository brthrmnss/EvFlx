package  org.syncon.evernote.panic.view.popup.editors
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class GraphWidgetEditorPopupMediator extends Mediator
	{
		[Inject] public var ui:GraphWidgetEditorPopup;
		[Inject] public var model :  PanicModel;
		
		private var data : WidgetVO; 
		
		public function GraphWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
	 		this.ui.addEventListener( GraphWidgetEditorPopup.EDIT_WIDGET, this.onEditWidget ) 
			this.ui.addEventListener( 'testClick', this.onTest ) 
		}
		
		private function onEditWidget(e:CustomEvent) : void
		{
		 	this.data = e.data as WidgetVO
			//this.ui.txtTop = this.data
			
		}		
 
		private function onTest(e:CustomEvent) : void
		{
			this.ui.ui.textTop = this.ui.txtTop.text; 
			this.ui.ui.textBottom = this.ui.txtBottom.text; 
			this.dispatch( new LoadDataSourceCommandTriggerEvent ( LoadDataSourceCommandTriggerEvent.LOAD_SOURCE,
					this.ui.txtTop.text, this.ui.ui, 'textTop', null )  )
			this.dispatch( new LoadDataSourceCommandTriggerEvent ( LoadDataSourceCommandTriggerEvent.LOAD_SOURCE,
				this.ui.txtBottom.text, this.ui.ui, 'textBottom', null )  )				
		}		
				
		
		
		
		 
		
	}
}