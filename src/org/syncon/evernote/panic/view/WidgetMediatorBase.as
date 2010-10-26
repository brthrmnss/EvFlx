package  org.syncon.evernote.panic.view
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.engine.FontLookup;
	import flash.text.engine.RenderingMode;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.core.UIComponent;
	import mx.graphics.GradientEntry;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.SetIncrementorVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class  WidgetMediatorBase extends Mediator implements IWidgetMediator
	{
		public var widgetUI:  UIComponent;
		public function get iUIWidget():IUIWidget { return this.widgetUI as IUIWidget }
		[Inject] public var model : PanicModel;
		
		public var editPopupName : String = 'SetPopupNameForEditMediator'
		
		public var supressTweens : Boolean = true; 
		public var animate : Boolean = true ;
		/**
		 * Most recently used widget settings 
		 * */
		public var automateSettings : WidgetVO; 
		
		private var _widgetData : WidgetVO = new  WidgetVO
		public function set  widgetData ( w : WidgetVO )  : void { this._widgetData = w }
		public function get   widgetData (  )  : WidgetVO { return this._widgetData; }	
		
		public function WidgetMediatorBase()
		{
			
		} 
		
		override public function onRegister():void
		{
			widgetUI.addEventListener( WidgetEvent.IMPORT_CONFIG, onImportConfig ) 			
			this.onImportConfig( null ) 
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.EDIT_MODE_CHANGED, 
				this.onEditModeChanged);						
			this.onEditModeChanged(null)			
				
			widgetUI.addEventListener( EditBorder.CLICKED_EDIT, onEditClicked ) 		
			widgetUI.addEventListener( WidgetEvent.AUTOMATE_WIDGET, onAutomateWidget ) 	
			this.onAutomateWidget(null)						
			
			eventMap.mapListener(eventDispatcher, PanicModelEvent.SUPRESS_TWEENS_CHANGED, 
				this.onSurpressTweensChanged);				
			this.onSurpressTweensChanged(null)				
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_SKIN, 
				this.onSkinChanged );						
			this.onSkinChanged(null)				
								
		}
		
		public function onSkinChanged(e:PanicModelEvent): void
		{
		}				
		
		private function onSurpressTweensChanged(e:PanicModelEvent) : void
		{
			this.supressTweens = this.model.surpressTweens
		}
		
		/**
		 * Called by timer, loadfx, or edit popup
		 * This is a dumb function, it doesn't know why it's updating, it just does 
		 * */
		public function onAutomateWidget( e : WidgetEvent )  : void
		{
			var useSettings : WidgetVO = this.widgetData; 
			if ( e != null && e.data != null) 
				useSettings = e.data; 
			if ( useSettings.data == null ) 
				return; 
			this.widgetUI.height = useSettings.height
			if ( this.timer != null ) this.timer.delay = useSettings.refreshTime; 
			this.setupGetter()
			this.automateSettings = useSettings
			this.automateWidget( useSettings ) 
			//hoping this will block during updating process, implmenet directly 
			//this.supressTweens = useSettings.editing; 
		}
		/**
		 * subclasses can override and set specific parameters
		 * */
		public function automateWidget( useSettings:  WidgetVO )  : void
		{
			 
		}		
		
		private var timer :  Timer ;//= new Timer()
		override public function onRemove() : void
		{
			super.onRemove()
			if ( this.timer != null )
			{
			this.timer.stop()
			this.timer.removeEventListener(TimerEvent.TIMER, this.onUpdateMeTimer )
			}
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
		
		public function onEditModeChanged(e:PanicModelEvent): void
		{
			if ( this.model.editMode ) 
			{
				this.iUIWidget.showEdit()
			}
			else
				this.iUIWidget.hideEdit();
			
		}		
		 
		public function onImportConfig(e:WidgetEvent): void
		{
			this.widgetData = this.iUIWidget.widgetData;
		}		
		
		public function onEditClicked(e: CustomEvent) : void
		{
			//make sure gets cancled by edit mediator
			this.widgetData.editing = true; 
			this.widgetData.ui = this.widgetUI; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				this.editPopupName, [this.widgetData] )  )  
		}			
		
		public var incrementors :  Dictionary = new Dictionary(true);
		/**
		 * Makes up source incrementors as we go along
		 * */
		public function source( source : String, host : Object, property : String, 
								fx : Function = null, test:Array=null, 
								index: SetIncrementorVO=null )  : void
		{
			//do nto allow sourcing 
			var incremantor : SetIncrementorVO = 
					this.incrementors[property] as SetIncrementorVO
			if ( incremantor == null  )
			{
				incremantor = new SetIncrementorVO()
				incremantor.name = property
				this.incrementors[property] = incremantor
			}
			this.model.source( source, host, property, fx , incremantor, test )	
		}		
		
		
	}
}