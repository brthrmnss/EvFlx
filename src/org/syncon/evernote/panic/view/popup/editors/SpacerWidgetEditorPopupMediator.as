package  org.syncon.evernote.panic.view.popup.editors
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.view.SpacerWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class SpacerWidgetEditorPopupMediator extends 
		WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i : SpacerWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : SpacerWidgetEditorPopup
		{ return this.editor as SpacerWidgetEditorPopup;  }
		
		public function SpacerWidgetEditorPopupMediator()
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
			this.ui.txtHeight.value = this.data.height
			//simple solution: if height is NaN copy componenet's height; 
			if ( isNaN(this.data.height) ) 
			{
				this.ui.txtHeight.value = this.data.ui.height; 
			}
			 
		}		
		
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{ 
			var d : WidgetVO = SpacerWidget.importData( this.data.name, 
				this.data.description,   ( this.ui.txtHeight.value )   ).widgetData;	
			return d; 
		}
		
		
	}
}