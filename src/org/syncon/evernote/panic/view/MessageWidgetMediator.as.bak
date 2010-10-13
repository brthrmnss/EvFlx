package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flashx.textLayout.elements.TextFlow;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class MessageWidgetMediator extends Mediator implements IWidgetMediator
	{
		[Inject] public var ui:MessageWidget;
		[Inject] public var model : PanicModel;
			
		public var supressTweens : Boolean = true; 
		public var animate : Boolean = true ;		
		
		private var _widgetData : WidgetVO = new  WidgetVO
		public function set  widgetData ( w : WidgetVO )  : void { this._widgetData = w }
		public function get   widgetData (  )  : WidgetVO { return this._widgetData; }	
		
		public function MessageWidgetMediator()
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
				
			eventMap.mapListener(eventDispatcher, PanicModelEvent.SUPRESS_TWEENS_CHANGED, 
				this.onSurpressTweensChanged);				
			this.onSurpressTweensChanged(null)				
		}
		 
		private function onSurpressTweensChanged(e:PanicModelEvent) : void
		{
			this.supressTweens = this.model.surpressTweens
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
		
		public function onEditClicked(e:CustomEvent) : void
		{
			this.widgetData.ui = this.ui; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'MessageWidgetEditorPopup', [this.widgetData] )  )  
		}		
		
		public function onAutomateWidget( e : WidgetEvent )  : void
		{
			var useSettings : WidgetVO = this.widgetData; 
			if ( e != null && e.data != null) 
				useSettings = e.data; 
			if ( useSettings.data == null ) 
				return; 
			/*
			var test : Array 
			test = [//'Yo dowg', 'abc123', 
				//'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">Thided <a>link</a> for tes link.<img source="http://avatar.cnn.com/people/MsLearning/avatar/48.png"/></TextFlow>',
				//'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">This . Added <a>link</a> for testing. .<img source="http://avatar.cnn.com/people/MsLearning/avatar/48.png"/></TextFlow>',
				'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">ThiAdded <a>link</a> fo.<img width="300" height="300" source="gif/A01 copy.gif"/></TextFlow>',
				'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008">Have you seen this person? <a>link</a><img width="300" height="300" source="gif/A02 copy.gif"/><p/>If so, call security x2929</TextFlow>',
				//'<TextFlow xmlns="http://ns.adobe.com/textLayout/2008"    paragraphSpaceAfter="15" paddingTop="4" paddingLeft="4" fontFamily="Times New Roman"> <p>:<img source="http://www.google.com/intl/en_ALL/images/srpr/logo1w.png"/> Dont you agree?</p></TextFlow>' 
				//]
				//'light', 'druid', '25 days', 
				//'24 days', 
				'loveless']
				*/
			this.model.source( useSettings.source, this, 'message', null , useSettings.test.source )
			this.ui.height = useSettings.height;
			this.setupGetter()
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
		
		private var timer :  Timer ; 
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
		
		
		
		 
	}
}