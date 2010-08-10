package  org.syncon.comps {
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.graphics.SolidColor;
	import mx.states.Transition;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.effects.Move;
	import spark.primitives.Rect;

	//[Style(name="backgroundColor", type="uint", format="Color", inherit="yes")]
	[Style(name="headerBackgroundSkin", type="Class", inherit="no")]
	[SkinState("opened")]
	public class Drawer extends SkinnableContainer {
		private var _opened:Boolean = false;

		[SkinPart(required="false")]
		public var openButton:Button;

		[SkinPart(required="false")]
		public var bgRect:SolidColor;		
		
		[SkinPart(required="false")]
		public var lblTitle:Label;		
		
		[SkinPart(required="false")]
		public var lblTitleRight:Label;				
		
		[SkinPart(required="false")]
		public var headerBar:UIComponent;					
		
		[SkinPart(required="false")]
		public var bg:Rect;			
		
		[SkinPart(required="false")]
		public var transitionx:Move;					
		
		public function Drawer()  
		{
			this.setStyle('backgroundColor', 0xE6E6E6)
			this.label = this._label; 
			this.rightLabel = this._rightLabel;
			this.minHeight = 20
				
			this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver ) 
			this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut ) 			
			 
			this.addEventListener(MouseEvent.CLICK, clickBgHandler);
			this.useHandCursor = true; 
			this.buttonMode = true; 	
			
		}
		
		public function onRollOver(e : MouseEvent): void
		{
			//if ( this.transitionx != null ) this.transitionx.play()
			//nderlnie if less than header value 
			if ( this.headerBar != null && e.localY < (this.headerBar.y+this.headerBar.height)  ) //only on the header bar
				this.lblTitle.setStyle('textDecoration', 'underline' ) ; 
		}
		public function onRollOut(e:Event) : void
		{
			//if ( this.transitionx != null ) this.transitionx.play(null, true)
			//this.currentState = 'normal'
			this.lblTitle.setStyle('textDecoration', 'none' ) ; 
		}
		
		
		public function get opened():Boolean {
			return _opened;
		}

		public function set opened(value:Boolean):void {
			if (_opened != value) {
				_opened = value;
				invalidateSkinState();
			}
		}

		
		private function clickBgHandler(event:MouseEvent):void {
			//if ( event.bubbles ) return;
			var items : Array =   [openButton,  this.lblTitleRight,  this.bg, this.skin]; 
			var found : int = 0 
			found = items.indexOf( event.target )
			var found2 : int = 0 
			found2 = items.indexOf( event.currentTarget )				
			/*
			if ( found == -1 )
			return ;
			*/
			/*	
			if ( found2 == -1 )
			return ;
			*/
			/*	if ( event.eventPhase == EventPhase.BUBBLING_PHASE) 
			return; */
			if ( event.target == this.skin && event.localY > this.headerBar.height ) 
				return;
		/*	if ( event.currentTarget != this ) 
				return;*/
			/*	if ( found == -1 )
			return ;	*/	
			//if not in group above, ignore it
			if ( found  == -1 )
				return ;						
			opened = !opened;
		}		
		private function clickHandler(event:MouseEvent):void {
			opened = !opened;
		}

		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);

			if (instance == openButton) {
				(instance as Button).addEventListener(MouseEvent.CLICK, clickHandler);
			}
			if ( instance == this.lblTitle ) 
				this.label = this._label; 
			if ( instance == this.headerBar ) 
			{
				this.headerBar.addEventListener(MouseEvent.CLICK, clickHandler);
				this.headerBar.useHandCursor = true; 
				this.headerBar.buttonMode = true; 
			}
		}

		override protected function partRemoved(partName:String, instance:Object):void {
			if (instance == openButton) {
				(instance as Button).removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			if ( instance == this.headerBar ) 
			{
				this.headerBar.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			super.partRemoved(partName, instance);
		}

		override protected function getCurrentSkinState():String {
			return (opened ? 'opened' : super.getCurrentSkinState());
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if ( this.bgRect != null ) 
				this.bgRect.color = this.getStyle('backgroundColor' )
			super.updateDisplayList( unscaledWidth, unscaledHeight) 
		}
		
		private var _label : String = ''; 
		public function set label( s : String ) : void
		{
			this._label = s
			if ( this.lblTitle != null ) 
				this.lblTitle.text = s 
		}
		
		private var _rightLabel : String = ''; 
		public function set rightLabel( s : String ) : void
		{
			this._rightLabel = s
			if ( this.lblTitleRight != null ) 
				this.lblTitleRight.text = s 
		}		
	}
}