package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommand;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class GraphWidgetMediator extends Mediator implements IWidgetMediator
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
			this.onImportConfig( null ) 				
			ui.addEventListener( EditBorder.CLICKED_EDIT, onEditClicked ) 		
			ui.addEventListener( WidgetEvent.AUTOMATE_WIDGET, onAutomateWidget ) 	
			this.onAutomateWidget(null)				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.EDIT_MODE_CHANGED, 
				this.onEditModeChanged);						
			this.onEditModeChanged(null)
				
			this.setupGetter()
		}

		public function getSourcedValue( source : String, host : Object, property : String, 
										 fx : Function = null )  : void
		{
			this.dispatch( new LoadDataSourceCommandTriggerEvent (
				LoadDataSourceCommandTriggerEvent.LOAD_SOURCE,
				source, host ,property, fx )  )					
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
			this.widgetData = this.ui.widgetData; 
		}		
		
		public function onAutomateWidget( e : WidgetEvent )  : void
		{
			var useSettings : WidgetVO = this.widgetData; 
			if ( e != null && e.data != null) 
				useSettings = e.data; 
			if ( useSettings.data == null ) 
				return; 
			//this.ui.textTop = 'lll'
			//return;
			this.ui.fillC = uint( useSettings.data.fillColor ) 
			this.getSourcedValue( useSettings.data.labelTop, this.ui, 'textTop', null  )
			this.getSourcedValue( useSettings.data.labelBottom, this.ui, 'textBottom', null  )
			this.getSourcedValue( useSettings.source, this.ui, 'value', null  ); //this.ui.value; 
			this.getSourcedValue( useSettings.data.max, this.ui, 'maximum', null  ); //this.ui.maximum;
			this.getSourcedValue( useSettings.data.fillColor, this.ui, 'fillC', null  ); 
			this.ui.chart.toolTip = useSettings.description;
			this.setupGetter()
		}
		private var timer : Timer ;//= new Timer()
		override public function onRemove() : void
		{
			super.onRemove()
			this.timer.stop()
			this.timer.removeEventListener(TimerEvent.TIMER, this.onUpdateMeTimer )
		}
		public function setupGetter()  : void
		{
			if ( this.timer == null ) 
			{
				this.timer = new Timer( this.widgetData.refreshTime, 0 ) 
				
				this.timer.addEventListener(TimerEvent.TIMER, this.onUpdateMeTimer, false, 0, true )
				this.timer.start()
			}
		}
		
		public function onUpdateMeTimer(e:Event) : void
		{
			if ( this.widgetData.editing == false )  
			onAutomateWidget( null ) 
		}
		
		public function onEditClicked(e:CustomEvent) : void
		{
			this.widgetData.ui = this.ui; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'GraphWidgetEditorPopup', [this.widgetData] )  )  
		}
	}
}