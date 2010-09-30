package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class PaneWidgetMediator extends Mediator implements IWidgetMediator
	{
		[Inject] public var ui: PaneWidget;
		[Inject] public var model : PanicModel;
		
		private var _widgetData : WidgetVO = new  WidgetVO
		public function set  widgetData ( w : WidgetVO )  : void { this._widgetData = w }
		public function get   widgetData (  )  : WidgetVO { return this._widgetData; }	
		
		public function PaneWidgetMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( WidgetEvent.IMPORT_CONFIG, onImportConfig ) 			
			this.onImportConfig( null ) 
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.EDIT_MODE_CHANGED, 
				this.onEditModeChanged);						
			this.onEditModeChanged(null)			
				
			ui.addEventListener( EditBorder.CLICKED_EDIT, onEditClicked ) 		
			ui.addEventListener( WidgetEvent.AUTOMATE_WIDGET, onAutomateWidget ) 	
			this.onAutomateWidget(null)						
		}
		
		
		public function onAutomateWidget( e : WidgetEvent )  : void
		{
			var useSettings : WidgetVO = this.widgetData; 
			if ( e != null && e.data != null) 
				useSettings = e.data; 
			if ( useSettings.data == null ) 
				return; 
			//this.ui.loadedHiehgt = useSettings.height 
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
		
		public function onEditClicked(e: CustomEvent) : void
		{
			throw 'not implemented yet'
			this.widgetData.ui = this.ui; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'BoardRowWidgetEditorPopup', [this.widgetData] )  )  
		}			
		
	}
}