package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class GraphWidgetMediator extends Mediator implements IWidget
	{
		[Inject] public var ui:GraphWidget;
		[Inject] public var model : PanicModel;
		
		private var _widgetData : WidgetVO = new  WidgetVO
		public function set  widgetData ( w : WidgetVO )  : void { this._widgetData = w }
		public function get   widgetData (  )  : WidgetVO { return this._widgetData; }	
				
		
		public function GraphWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( WidgetEvent.IMPORT_CONFIG, onImportConfig ) 		
			ui.addEventListener( EditBorder.CLICKED_EDIT, onEditClicked ) 		
			this.onImportConfig( null ) 
			/*
			 eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);	*/
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
		private function onSignoutClickedHandler(e:CustomEvent): void
		{
			/*this.model.logOut();*/
		}
		 
		public function onImportConfig(e:WidgetEvent): void
		{
			if ( this.model.sourced( this.ui.labelBottom ) == false ) 
				this.ui.lblBottom.text = this.ui.labelBottom.toUpperCase()
			if ( this.model.sourced( this.ui.labelTop ) == false ) 
				this.ui.lblTop.text = this.ui.labelTop.toUpperCase()					
		}		
		
		public function onEditClicked(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 'GraphWidgetEditorPopup', [this.widgetData] )  )  
		}
	}
}