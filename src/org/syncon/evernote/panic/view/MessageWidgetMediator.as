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
			//this.ui.height = settings.height ; */
			//this.model.source( settings.source, this, 'message', null , settings.test.source )
		}
		
		/**
		 * Surpess messages
		 * */
		private var oldMessage : String = ''; 
		public function set message( m : String ) : void{
			var ee : HtmlConvertor = new HtmlConvertor()
			var x : Object = ee.convert2( m, this.model.color, 34 )
			if ( this.automateSettings.editing  ) 
			{
				//this.ui.messageTF =x as TextFlow;
				//this.ui.messageTF =x as TextFlow;
				//this.ui.currentState = 'State1' 
				this.ui.currentState = 'State2' 
				//this.ui.lblMessage3.textFlow =x as TextFlow;
				this.ui.lblMessage4.textFlow =x as TextFlow;
				return;
			}				
			if ( m == oldMessage  && this.supressTweens ) 
			{
				return; 
			}
			oldMessage = m 
			//this.ui.message = m; 
			if ( this.automateSettings.editing == false ) 
				this.ui.messageTF =x as TextFlow;
			else
			{
				this.ui.messageTF =x as TextFlow;
				this.ui.messageTF =x as TextFlow;
				//this.ui.lblMessage4.textFlow = x as TextFlow;
				//this.ui.lblMessage3.textFlow = x as TextFlow;
			}
			//this.ui.lblMessage2.textFlow = x as TextFlow
		}
		 
	}
}