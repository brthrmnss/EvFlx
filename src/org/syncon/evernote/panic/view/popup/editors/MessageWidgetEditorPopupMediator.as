package  org.syncon.evernote.panic.view.popup.editors
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class MessageWidgetEditorPopupMediator extends 
		WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i : MessageWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : MessageWidgetEditorPopup
		{ return this.editor as MessageWidgetEditorPopup;  }
		
		public function MessageWidgetEditorPopupMediator()
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
			this.ui.txtMessage.text = this.data.source; 				
		}		
		
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = MessageWidget.importData( this.data.name, 
				this.data.description, 
				this.ui.txtMessage.text,  this.data.refreshTime ).widgetData;	
			return d; 
		}
		
		
	}
}