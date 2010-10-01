package  org.syncon.evernote.panic.view.popup.editors
{
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.PaneWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class PaneWidgetEditorPopupMediator extends 
		WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i :  PaneWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : PaneWidgetEditorPopup
		{ return this.editor as PaneWidgetEditorPopup;  }
		
		public function PaneWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onImportEditConfig(e:WidgetEvent) : void
		{
			super.onImportEditConfig( e ) 
			this.data = e.data as WidgetVO
				
			this.ui.timer.dataX =  this.data; 
			this.ui.txtMessage.text = this.data.source; 
			this.ui.colorPicker1.selectedColor = this.data.data.color1; 
			this.ui.colorPicker2.selectedColor = this.data.data.color2; 
		}	
		
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = PaneWidget.importData( this.data.name, this.data.description, 
				this.ui.txtMessage.text, this.data.refreshTime,  
				this.ui.colorPicker1.selectedColor.toString(), 
				this.ui.colorPicker2.selectedColor.toString() ).widgetData;
			return d ; 	
		}
		
		
	}
}