package  org.syncon.evernote.panic.view
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flashx.textLayout.elements.TextFlow;
	
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
 
	public class PaneWidgetMediator extends WidgetMediatorBase
	{
		
		[Inject] public function set ui  ( i :  PaneWidget) : void 
		{	this.widgetUI = i  }
		public function get ui () : PaneWidget
		{ return this.widgetUI as PaneWidget;  }
		
		public function PaneWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			this.editPopupName = 'PaneWidgetEditorPopup'; 
		}
		
		override public function automateWidget( settings : WidgetVO )  : void
		{
			this.source( settings.source, this, 'updateText', null , settings.test.source )
			this.source( settings.background, this, 'updateBgText', null , settings.test.background )
		 
		/*	if ( settings.data.customGradient != '' ) 
				trace('gradient not null);*/
			this.source( settings.data.customGradient, this, 'customGradient', null , settings.test.customGradient )
			this.source( settings.data.cornerRadius, this, 'cornerRadius', null , settings.test.cornerRadius )				
			
			this.ui.height = settings.height
		 
			if ( settings.data.hasOwnProperty( 'color1' ) )
				this.ui.color1.color = settings.data.color1; 
			if ( settings.data.hasOwnProperty( 'color2' ) )
				this.ui.color2.color = settings.data.color2; 		
		}
		
		
		/*
		[
		{"color":"#ffffff", "alpha":1, "ratio":0},
		{"color":"#ffffff", "alpha":1, "ratio":0},
		{"color":"#ffffff", "alpha":1, "ratio":0},
		{"color":"#ffffff", "alpha":1, "ratio":0}
		]
		*/
		private var oldCustomGradient : String = ''; 
		public function set customGradient(a : String ) : void
		{
			if ( a == '' || a == null )
			{
				this.ui.bgCustomGradient.visible = false;
				return; 
			}
			if ( a == this.oldCustomGradient   ) 
				return  
			oldCustomGradient = a; 	
			try {
			var s : Object = JSON.decode( a.toString() )
			}
			catch ( e : Error ) 
			{
				trace( ' could not parse that gradient: PaneWidgetMediator ' ) 
				return; 
			}
			var colors : Array = s.colors as Array
			var gradient : LinearGradient = new LinearGradient()
				gradient.rotation = 90; 
				var entries : Array = []; //entries must all be set at once 
			for each ( var j : Object in colors ) 
			{
				
				if ( j.color.toString().charAt(0) == '#' ) 
					var color:uint = uint("0x" + j.color.toString().substr(1));
				else
					color = uint  ( j.color ) 
				var gE : GradientEntry = new GradientEntry(color, j.ratio, j.alpha )
				entries.push( gE ) 
			}
			
			/*entries.push( new  GradientEntry(0xFFFFF, 0, 1) ) 
			entries.push( new  GradientEntry(0xFF0000, 1, 1) ) */
			gradient.entries =entries ; 
			this.ui.bgCustomGradient.visible = true; 
			this.ui.bgCustomGradient.fill = gradient
			//this.ui.bgCustomGradient.fill = new SolidColor( 0xFFFF00 ) 
			//this.ui.bgCustomGradient.fill = 
			return  ; 
		}
		
		private var oldCornerRadius  : String = ''; 
		public function set cornerRadius(a : String ) : void
		{
			if ( a == this.oldCornerRadius   ) 
				return  
				oldCornerRadius = a; 	
			
			this.ui.cornerRadius = Number(a)
			
			return  ; 
		}
		
		
		
	 
		private var oldBgTextString : String = ''; 
		public function set updateBgText(a : String ) : void
		{
			 if ( a == this.oldBgTextString   ) 
				return  
				oldBgTextString = a; 	
			var ee : HtmlConvertor = new HtmlConvertor()
			var textFlow : TextFlow= ee.convert2( a, 0xFFFFFF, 15 ) 
			this.ui.txtBg.textFlow = textFlow
			return  ; 
		}
		
		
		public var oldTextString: String = ''; 
		/**
		 * convert html to text flow
		 * plain text wrap as textflow? 
		 * just use existing thing 
		 * */
		public function set updateText(a : String ) : void
		{
			this.ui.creationComplete; 
			if ( a == this.oldTextString && supressTweens ) 
				return  
				oldTextString = a; 	
			if ( this.automateSettings.editing == false ) 
				this.ui.animateHover(this.ui)
			var str : String = ''; 
			str = a
				
			var ee : HtmlConvertor = new HtmlConvertor()
			var textFlow : TextFlow = ee.convert2( a, 0xFFFFFF, 15 ) 
			this.ui.txt.textFlow = textFlow
			//return;
			if ( textFlow.verticalAlign == 'middle' ) 
			{
				this.ui.txt.percentHeight = NaN; 
				this.ui.txtBg.percentHeight = NaN; 				
				this.ui.txt.setStyle('verticalCenter', 0); 
				this.ui.txtBg.setStyle('verticalCenter',  0 ); 				
			}
			else
			{
				this.ui.txt.percentHeight = 100; 
				this.ui.txtBg.percentHeight = 100; 
				this.ui.txt.setStyle('verticalCenter', null); 
				this.ui.txtBg.setStyle('verticalCenter', null ); 			
			}
			return  
		}		
 
	}
}