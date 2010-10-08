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
	
	public class GraphWidgetEditorPopupMediator extends 
				WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i : GraphWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : GraphWidgetEditorPopup
		{ return this.editor as GraphWidgetEditorPopup;  }

		public function GraphWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onImportEditConfig(e:WidgetEvent) : void
		{
			super.onImportEditConfig( e ) 

			this.ui.timer.dataX = this.data ; 
			this.ui.txtTop.text = this.data.data.labelTop; 
			this.ui.txtBottom.text =  this.data.data.labelBottom; 
			this.ui.txtValue.text = this.data.source; 
			this.ui.txtMaximum.text = this.data.data.max
			this.ui.colorPicker.selectedColor = this.data.data.fillColor; 
			this.ui.txtBackground.text = this.data.background; 
		}		
 	
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = GraphWidget.importData( this.data.name, this.data.description, 
				this.ui.txtTop.text, this.ui.txtBottom.text, this.ui.txtValue.text,
				this.ui.txtMaximum.text,  this.ui.colorPicker.selectedColor,
				this.ui.txtBackground.text, this.ui.timer.time ).widgetData;
			return d ; 	
		}
		 
		
	}
}