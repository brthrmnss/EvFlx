package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flashx.textLayout.elements.TextFlow;
	
	import mx.graphics.GradientEntry;
	
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
			
			this.ui.height = settings.height
		 
			if ( settings.data.hasOwnProperty( 'color1' ) )
				this.ui.color1.color = settings.data.color1; 
			if ( settings.data.hasOwnProperty( 'color2' ) )
				this.ui.color2.color = settings.data.color2; 		
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