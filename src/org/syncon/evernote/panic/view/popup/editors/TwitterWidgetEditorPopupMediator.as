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
	import org.syncon.evernote.panic.view.TwitterScrollerTest2;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	public class TwitterWidgetEditorPopupMediator extends Mediator
		implements IWidgetEditorMediator
	{
		[Inject] public var ui:TwitterWidgetEditorPopup;
		[Inject] public var model :  PanicModel;
		
		private var data : WidgetVO; 
		
		public function TwitterWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( WidgetEvent.EDIT_WIDGET, this.onImportEditConfig ) 
			this.ui.addEventListener( WidgetEvent.TEST_WIDGET, this.onTestWidget) 
			this.ui.addEventListener( WidgetEvent.UPDATE_WIDGET_CONFIG, this.onUpdateWidgetConfig ) 
		}

		public function onImportEditConfig(e:WidgetEvent) : void
		{
			this.data = e.data as WidgetVO
				this.ui.txtMessage.text = this.data.source; 
		}				
		
		public function onUpdateWidgetConfig(e:WidgetEvent) : void
		{
			this.onTestWidget(null)
			//import it actually sets the data , test is unnecsary
			this.data.ui.importConfig( this.currentConfig() ) ; 
			this.dispatch( new PanicModelEvent( PanicModelEvent.BOARD_CHANGED ) ) 
			this.ui.hide()
		}			
		
		public function onTestWidget(e: CustomEvent) : void
		{
			var d : WidgetVO  = this.currentConfig() 
			this.data.ui.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, 
				null, d ) ) 
		}		
		
		/**
		 * Read settings for text value
		 * */
		public function currentConfig()  :   WidgetVO
		{
			var d : WidgetVO = TwitterScrollerTest2.importData( this.data.name, this.data.description, 
			this.ui.txtMessage.text,  this.data.refreshTime ).widgetData;
			return d ; 	
		}
		
		
	}
}