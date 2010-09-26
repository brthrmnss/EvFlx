package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
 
	public class TwitterScrollerWidgetMediator extends Mediator implements IWidget
	{
		[Inject] public var ui: TwitterScrollerTest2;
		[Inject] public var model : PanicModel;
		
		private var _widgetData : WidgetVO = new  WidgetVO
		public function set  widgetData ( w : WidgetVO )  : void { this._widgetData = w }
		public function get   widgetData (  )  : WidgetVO { return this._widgetData; }	
		
		public function TwitterScrollerWidgetMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( WidgetEvent.IMPORT_CONFIG, onImportConfig ) 			
			/*eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);	*/		
			this.onImportConfig( null ) 
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.EDIT_MODE_CHANGED, 
				this.onEditModeChanged);						
			this.onEditModeChanged(null)				
		}
		 
		public function onEditModeChanged(e:PanicModelEvent): void
		{
			if ( this.model.editMode ) 
				this.ui.showEdit()
			else
				this.ui.hideEdit(); 
		}		
		
		public function onImportConfig(e:WidgetEvent): void
		{
			this.widgetData = this.ui.widgetData; 
		}		
	}
}