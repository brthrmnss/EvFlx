package  org.syncon.evernote.panic.view
{
	import flashx.textLayout.elements.TextFlow;
	
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
 
	public class MessageWidgetMediator extends WidgetMediatorBase
	{
		[Inject] public function set ui  ( i :  MessageWidget) : void 
		{	this.widgetUI = i  }
		public function get ui () : MessageWidget
		{ return this.widgetUI as MessageWidget;  }
		
		public function MessageWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			this.editPopupName = 'MessageWidgetEditorPopup'; 		
		}
 
		override public function automateWidget(  settings : WidgetVO )  : void
		{
			this.source( settings.source, this, 'message',  null , settings.test.source );
			//this.model.source( settings.source, this, 'message', null , settings.test.source )
		}
		
		/**
		 * Surpess messages
		 * */
		private var oldMessage : String = ''; 
		public function set message( m : String ) : void{
			var ee : HtmlConvertor = new HtmlConvertor()
			var x : Object = ee.convert2( m, this.model.color, 34 )
			if ( m == oldMessage  && this.supressTweens ) 
			{
				return; 
			}
			oldMessage = m 
			//this.ui.message = m; 
			this.ui.messageTF =x as TextFlow;
			//this.ui.lblMessage2.textFlow = x as TextFlow
		}
		 
	}
}