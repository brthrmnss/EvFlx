package  org.syncon.evernote.panic.view
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.engine.FontLookup;
	import flash.text.engine.RenderingMode;
	import flash.utils.Timer;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.graphics.GradientEntry;
	
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
		
		public var supressTweens : Boolean = true; 
		public var animate : Boolean = true ;
		
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
			
			eventMap.mapListener(eventDispatcher, PanicModelEvent.SUPRESS_TWEENS_CHANGED, 
				this.onSurpressTweensChanged);				
			this.onSurpressTweensChanged(null)				
		}
		
		private function onSurpressTweensChanged(e:PanicModelEvent) : void
		{
			this.supressTweens = this.model.surpressTweens
		}
		
		
		public function onAutomateWidget( e : WidgetEvent )  : void
		{
			
			var useSettings : WidgetVO = this.widgetData; 
			if ( e != null && e.data != null) 
				useSettings = e.data; 
			if ( useSettings.data == null ) 
				return; 
			//this.ui.loadedHiehgt = useSettings.height 
			//this.ui.colorThing = this.convertColorString(useSettings.data.colorString)
			//save this 
			//this.ui.text_ = 
			//this.updateText(  useSettings.source )  
			this.model.source( useSettings.source, this, 'updateText', null , useSettings.test.source )
			this.ui.height = widgetData.height
			if ( useSettings.data.hasOwnProperty( 'color1' ) )
				this.ui.color1.color = useSettings.data.color1; 
			if ( useSettings.data.hasOwnProperty( 'color2' ) )
				this.ui.color2.color = useSettings.data.color2; 		
			this.setupGetter()
			
		}
		private var timer :  Timer ;//= new Timer()
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
		/**
		 * color
		 * graident stops
		 * {stops:[{ratio:0.0, color:2344233, alpha:1},{ratio:0.2, color:2344233, alpha:1}]}
		 * */
		/*
		private function convertColorString(a : String ) : String
		{
			var str : String = ''; 
			if ( a.length < 7 && a.indexOf( 'stops') == -1 ) 
				str = a 
			else
			{
				var stops : Object = JSON.decode( a ) 
				var gr : Array = stops.stops; 
				var gra : Array = []; 
				for each ( var o :  Object in gr ) 
				{
					var ee :   GradientEntry = new GradientEntry(o.color, o.ratio, o.alpha ) 
					gra.push(ee)
				}
			}
			return a
		}
		
		private function GradientToStopStri()  : String
		{
			var strops :  String = ''; 
			var gra : Array = []; 
			for each ( var o :   GradientEntry in this.ui.gradientBg ) 
			{
				var ee :    Object = {color:o.color, ration:o.ratio, alpha:o.alpha }
				gra.push(ee)
			}
			var obj : Object = {}
			obj.stops = gra
			return JSON.encode( obj )  
		}
		*/
		public var oldTextString: String = ''; 
		/**
		 * convert html to text flow
		 * plain text wrap as textflow? 
		 * just use existing thing 
		 * */
		public function set updateText(a : String ) : void
		{
			if ( a != this.oldTextString && supressTweens ) 
				return  
				oldTextString = a; 	
			this.ui.animateHover(this.ui)
			var str : String = ''; 
			str = a
			var ee : HtmlConvertor = new HtmlConvertor()
			textFlow= ee.convert2( a, 0xFFFFFF, 15 ) 
			this.ui.txt.textFlow = textFlow
			return  ; 
				//var dd : Object = ee.convert( a ) 
				textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
				textFlow.renderingMode = RenderingMode.CFF;
				textFlow.fontFamily = 'ACaslonProRegularEmbedded'
				textFlow.fontSize = '13'
				textFlow.mxmlChildren[0].fontFamily = 'ACaslonProRegularEmbedded'
				for each ( var c : Object in textFlow.mxmlChildren ) 
				{
					c.fontFamily =  'ACaslonProRegularEmbedded'
					c.fontWeight =  'normal'
					for each ( var c2 : Object in c.mxmlChildren ) 
					{
						var dee :  FlowElement
						if ( c2 is FlowElement == false ) 
							continue; 
						c2.fontFamily =  'ACaslonProRegularEmbedded'
						c2.fontWeight =  'normal'							
						for each ( var c3 : Object in c2.mxmlChildren ) 
						{
							if ( c3 is FlowElement == false ) 
								continue; 							
							c3.fontFamily =  'ACaslonProRegularEmbedded'
							c3.fontWeight =  'normal'								
						}
					}
				}
				this.ui.txt.textFlow= textFlow
				var bb : Object	=	textFlow//.toString()
			var g :  Object = this.ui.txt.textFlow.mxmlChildren[0]
			var xx : Object = 	 ee.export(textFlow ) 
	/*	 textFlow = TextConverter.importToFlow(xx, TextConverter.TEXT_LAYOUT_FORMAT);
			this.ui.txt.textFlow = textFlow*/
				return  
			var xml2:XML =<TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit" 
fontFamily="ACaslonProRegularEmbedded" fontLookup="embeddedCFF" fontSize="13" lineBreak="inherit" 
paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" paddingTop="inherit" renderingMode="cff" 
verticalAlign="inherit" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008">
<p fontFamily="ACaslonProRegularEmbedded">
<span fontFamily="ACaslonProRegularEmbedded">2Something1</span>
</p></TextFlow>	
				xml2 = <TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit"
fontFamily="ACaslonProRegularEmbedded" fontLookup="embeddedCFF" fontSize="13"
lineBreak="inherit" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" 
paddingTop="inherit" renderingMode="cff" verticalAlign="inherit" whiteSpaceCollapse="preserve"
xmlns="http://ns.adobe.com/textLayout/2008"><p fontFamily="ACaslonProRegularEmbedded">
<span fontFamily="ACaslonProRegularEmbedded" fontWeight="bold">
•Custom Flex and ColdFusion Web Application Development</span></p>
<p fontFamily="ACaslonProRegularEmbedded">
<span fontFamily="ACaslonProRegularEmbedded" fontWeight="bold">
• Custom AIR Desktop Application Development</span></p><p fontFamily="ACaslonProRegularEmbedded">
<span fontFamily="ACaslonProRegularEmbedded" fontWeight="bold">
•Business Systems Analysis and Implementation</span>
</p></TextFlow>
				xml2 = <TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit"
fontFamily="ACaslonProRegularEmbedded" fontLookup="embeddedCFF" fontSize="13"
lineBreak="inherit" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" 
paddingTop="inherit" renderingMode="cff" verticalAlign="inherit" whiteSpaceCollapse="preserve"
xmlns="http://ns.adobe.com/textLayout/2008"><p fontFamily="ACaslonProRegularEmbedded">
<span fontFamily="ACaslonProRegularEmbedded" fontWeight="bold">
•Custom Flex and ColdFusion Web Application Development</span></p>
<p fontFamily="ACaslonProRegularEmbedded">
<span fontFamily="ACaslonProRegularEmbedded" fontWeight="bold">
• Custom AIR Desktop Application Development</span></p><p fontFamily="ACaslonProRegularEmbedded">
<span fontFamily="ACaslonProRegularEmbedded" fontWeight="normal">
•Business Systems Analysis and Implementation</span>
</p></TextFlow>
				//http://forums.adobe.com/message/3112952
			//return '' 
			var xml:XML = <TextFlow fontFamily="ACaslonProRegularEmbedded"
fontLookup="embeddedCFF" fontSize="13" renderingMode="cff" 
whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008">
<p   fontFamily="ACaslonProRegularEmbedded"  >
<span>Ein kritischer Blick in die Nachbarschaft:</span>
</p></TextFlow>;
			
			
			var textFlow: TextFlow = new TextFlow();
			textFlow = TextConverter.importToFlow(xml, TextConverter.TEXT_LAYOUT_FORMAT);
		//	textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
		//	textFlow.renderingMode = RenderingMode.CFF;
			textFlow = TextConverter.importToFlow(xml2, TextConverter.TEXT_LAYOUT_FORMAT);
			this.ui.txt.textFlow = textFlow
			
				return  
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
			this.widgetData.ui = this.ui; 
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PaneWidgetEditorPopup', [this.widgetData] )  )  
		}			
		
	}
}