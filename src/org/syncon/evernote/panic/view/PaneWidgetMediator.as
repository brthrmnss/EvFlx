package  org.syncon.evernote.panic.view
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.events.Event;
	import flash.text.engine.FontLookup;
	import flash.text.engine.RenderingMode;
	
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
			//this.ui.colorThing = this.convertColorString(useSettings.data.colorString)
			//save this 
			//this.ui.text_ = 
			this.updateText(  useSettings.source )  
			this.ui.height = widgetData.height
			if ( useSettings.data.hasOwnProperty( 'color1' ) )
				this.ui.color1.color = useSettings.data.color1; 
			if ( useSettings.data.hasOwnProperty( 'color2' ) )
				this.ui.color2.color = useSettings.data.color2; 		
			
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
		/**
		 * convert html to text flow
		 * plain text wrap as textflow? 
		 * just use existing thing 
		 * */
		private function updateText(a : String ) : String
		{
			var str : String = ''; 
			str = a
			var ee : HtmlConvertor = new HtmlConvertor()
			textFlow= ee.convert( a ) 
				//var dd : Object = ee.convert( a ) 
				textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
				textFlow.renderingMode = RenderingMode.CFF;
				textFlow.fontFamily = 'ACaslonProRegularEmbedded'
				textFlow.fontSize = '13'
				textFlow.mxmlChildren[0].fontFamily = 'ACaslonProRegularEmbedded'
				for each ( var c : Object in textFlow.mxmlChildren ) 
				{
					c.fontFamily =  'ACaslonProRegularEmbedded'
					for each ( var c2 : Object in c.mxmlChildren ) 
					{
						var dee :  FlowElement
						if ( c2 is FlowElement == false ) 
							continue; 
						c2.fontFamily =  'ACaslonProRegularEmbedded'
						for each ( var c3 : Object in c2.mxmlChildren ) 
						{
							if ( c3 is FlowElement == false ) 
								continue; 							
							c3.fontFamily =  'ACaslonProRegularEmbedded'
						}
					}
				}
				this.ui.txt.textFlow= textFlow
				var bb : Object	=	textFlow//.toString()
			var g :  Object = this.ui.txt.textFlow.mxmlChildren[0]
				
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
			
			this.ui.txt.textFlow = textFlow
			
				return str
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