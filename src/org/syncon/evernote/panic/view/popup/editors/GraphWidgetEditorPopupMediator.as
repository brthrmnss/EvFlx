package  org.syncon.evernote.panic.view.popup.editors
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
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
			this.ui.addEventListener( GraphWidgetEditorPopup.TEST_WIDGET, this.onTestWidget) 
			this.ui.addEventListener( GraphWidgetEditorPopup.UPDATE_WIDGET_CONFIG, this.onUpdateWidgetConfig ) 
		}
		
		private function onUpdateWidgetConfig(e:CustomEvent) : void
		{
			
			this.onTestWidget(null)
			//import it actually sets the data , test is unnecsary
			ui.ui.importConfig( this.currentConfig() ) ; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.BOARD_CHANGED ) ) 
			this.ui.hide()
		}			
		
		private function onEditWidget(e:CustomEvent) : void
		{
		 	this.data = e.data as WidgetVO
			//this.ui.txtTop = this.data
			
		}		
 
		private function onTestWidget(e:CustomEvent) : void
		{
			var d : WidgetVO  = this.currentConfig() 
			this.ui.ui.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
			/*this.ui.ui.textTop = this.ui.txtTop.text; 
			this.ui.ui.textBottom = this.ui.txtBottom.text; 
			this.dispatch( new LoadDataSourceCommandTriggerEvent ( LoadDataSourceCommandTriggerEvent.LOAD_SOURCE,
					this.ui.txtTop.text, this.ui.ui, 'textTop', null )  )
			this.dispatch( new LoadDataSourceCommandTriggerEvent ( LoadDataSourceCommandTriggerEvent.LOAD_SOURCE,
				this.ui.txtBottom.text, this.ui.ui, 'textBottom', null )  )	*/		
			//this.ui.hide()
			
		}		
				
		/**
		 * Read settings for text value
		 * */
		public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = GraphWidget.importData( this.data.name, this.data.description, 
				this.ui.txtTop.text, this.ui.txtBottom.text, this.ui.txtValue.text,
				this.ui.txtMaximum.text,  this.ui.colorPicker.selectedColor,  this.data.refreshTime ).widgetData;
			return d ; 	
		}
		
		
		 
		
	}
}