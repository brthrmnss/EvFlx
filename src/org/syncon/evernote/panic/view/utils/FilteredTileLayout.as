package  org.syncon.evernote.panic.view.utils
{
	import mx.collections.ICollectionView;
	import mx.core.ILayoutElement;
	import mx.effects.Parallel;
	import mx.events.EffectEvent;
	
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.ItemRenderer;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class FilteredTileLayout extends LayoutBase
	{
		private var debug : Boolean = true; 
		public var filteredItems:ICollectionView;
		
		public var fadeOutDuration:Number = 400;
		
		public var moveDuration:Number = 400;
		
		public var fadeInDuration:Number = 400;
		
		private var _target:GroupBase;
		
		private var _containerWidth:Number;
		
		private var fadeOutEffects:Parallel;
		private var fadeInEffects:Parallel;
		private var moveEffects:Parallel;
		
		private var _horizontalGap:Number = 10;
		
		private var _verticalGap:Number = 10;
		
		private var _tileWidth:Number = 100;
		
		private var _tileHeight:Number = 100;
		
		public function set    horizontalGap(value:Number):void
		{
			_horizontalGap = value;
			if (target)    target.invalidateDisplayList();
		}
		
		public function set    verticalGap(value:Number):void
		{
			_verticalGap = value;
			if (target)    target.invalidateDisplayList();
		}
		
		public function set    tileWidth(value:Number):void
		{
			_tileWidth = value;
			if (target)    target.invalidateDisplayList();
		}
		
		public function set    tileHeight(value:Number):void
		{
			_tileHeight = value;
			if (target)    target.invalidateDisplayList();
		}
		
		public function filter():void
		{
			// Prevent updateDisplayList() from being executed while we are animating tiles
			_target.autoLayout = false;
			
			// No filter has been applied. Keep showing all the items in the dataProvider
			if (filteredItems == null) return;
			
			var count:int = _target.numElements;
			
			// No items in the dataProvider: Nothing to show.
			if (count == 0) return;
			
			var x:int = 0;
			var y:int = 0;
			if ( this.fadeInEffects != null ) 
			{
				this.fadeOutEffects.stop()
				this.fadeInEffects.stop()
				this.moveEffects.stop()
			}	
			fadeOutEffects = new Parallel();
			fadeInEffects = new Parallel();
			moveEffects = new Parallel();
			var layoutTarget:GroupBase = target;
			var maxHeight:Number = 0;
			
			for (var i:int = 0; i < count; i++)
			{
				//var itemRenderer:ItemRenderer = _target.getElementAt(i) as ItemRenderer;
				 var element: ILayoutElement = useVirtualLayout ?
					 layoutTarget.getVirtualElementAt(i) :
					 layoutTarget.getElementAt(i);
				
				var itemRenderer:ItemRenderer = element as ItemRenderer;
			 	if ( itemRenderer == null ) continue; 
				if (filteredItems.contains(itemRenderer.data))
				{
					// The element is part of the selection: calculate its x and y values
					if (x + _tileWidth > _containerWidth)
					{
						x = 0;
						y += _tileHeight + _verticalGap;
					} 
					maxHeight = Math.max(maxHeight, y + _tileHeight);
					if (itemRenderer.visible == false)
					{
						if ( debug ) trace("FadeIn: " + itemRenderer.data.name);
						// if the element was hidden, set its new x and y values (without Move animation) and register it for FadeIn animation
						itemRenderer.visible = true;
						itemRenderer.setLayoutBoundsPosition(x, y);
						var fadeIn:Fade = new Fade(itemRenderer);
						fadeIn.alphaTo = 1;
						fadeInEffects.addChild(fadeIn);
					}  
					else
					{
						if ( debug ) trace("Move: " + itemRenderer.data.name);
						// the element was already visible: register it for Move animation
						if (itemRenderer.x != x || itemRenderer.y != y)
						{
							var move:Move = new Move(itemRenderer);
							move.xTo = x;
							move.yTo = y;
							moveEffects.addChild(move);
						}
					}
					x += _tileWidth + _horizontalGap;
				}                    
				else
				{
					if (itemRenderer.alpha == 1)
					{
						if ( debug ) trace("FadeOut: " + itemRenderer.data.name);
						// the element is filtered out: register it for FadeOut animation
						var fadeOut:Fade = new Fade(itemRenderer);
						fadeOut.alphaTo = 0;
						fadeOutEffects.addChild(fadeOut);
					}
				}
			}
			target.setContentSize(this.target.contentWidth, maxHeight + 0);
			fadeOutTiles();            
		}
		
		private function fadeOutTiles(event:EffectEvent = null):void
		{
			if ( debug ) trace("fadeOutTiles");
			if (fadeOutEffects.children.length > 0) {
				fadeOutEffects.duration = fadeOutDuration;
				fadeOutEffects.addEventListener(EffectEvent.EFFECT_END, moveTiles)
				fadeOutEffects.play();
			}
			else
			{
				moveTiles();    
			}
		}
		
		private function moveTiles(event:EffectEvent = null):void
		{
			// Undesired behaviors may happen if we leave tiles with alpha=0 in the display list while performing other animations 
			setInvisibleTiles();
			
			if ( debug ) trace("moveTiles");
			if (moveEffects.children.length > 0) {
				moveEffects.duration = moveDuration;
				moveEffects.addEventListener(EffectEvent.EFFECT_END, fadeInTiles)
				moveEffects.play();
			}
			else
			{
				fadeInTiles();    
			}
		}
		
		private function fadeInTiles(event:EffectEvent = null):void
		{
			//this.adjustLayoutSize();
			if ( debug ) trace("fadeInTiles");
			if (fadeInEffects.children.length > 0) {
				fadeInEffects.duration = fadeInDuration;
				moveEffects.addEventListener(EffectEvent.EFFECT_END, fadeInTilesEnd)
				fadeInEffects.play();
			}
			else
			{
				fadeInTilesEnd();    
			}
		}
		
		private function fadeInTilesEnd(event:EffectEvent = null):void
		{
			_target.autoLayout = true; 
			
		}
		
		private function adjustLayoutSize() : void
		{
			var count:int = target.numElements;
			if (count == 0) return;
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var x:int=0;
			var y:int=0;
			var layoutTarget:GroupBase = target;
			for (var i:int = 0; i < count; i++)
			{
				//var o : Object = _target.getElementAt(i) 
				var element: ILayoutElement = useVirtualLayout ?
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);
				
				var itemRenderer:ItemRenderer = element as ItemRenderer;
				
				if (filteredItems && filteredItems.contains(itemRenderer.data))
				{
					// The element is part of the selection: calculate its x and y values
					if (x + _tileWidth > _containerWidth && i != 0 )
					{
						x = 0;
						y += _tileHeight + _verticalGap;
					} 
					x += _tileWidth + _horizontalGap;
					maxWidth = Math.max(maxWidth, x + _tileWidth);
					maxHeight = Math.max(maxHeight, y + _tileHeight);
				}                    
			}
			//set final content size (needed for scrolling)
			//layoutTarget.setContentSize(this.target.contentWidth, maxHeight + 0);
			//if ( this.setLayoutTargetHeight ) 
			//layoutTarget.height = this.target.height;
		}
		
		private function setInvisibleTiles():void
		{
			var count:int = _target.numElements;
			
			if (count == 0) return;
			var layoutTarget:GroupBase = target;
			for (var i:int = 0; i < count; i++)
			{
				var element: ILayoutElement = useVirtualLayout ?
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);				
				var itemRenderer:ItemRenderer = element as ItemRenderer;
				if ( itemRenderer == null ) continue; 
				if (!filteredItems.contains(itemRenderer.data))
				{    
					if ( debug ) trace("Removing from layout: " + itemRenderer.data.name);                    
					itemRenderer.visible = false;
				}        
			}
		}
		
		override public function updateDisplayList(containerWidth:Number, containerHeight:Number):void
		{
			
			if ( debug ) trace("updateDisplaylist");
			
			_target = target;
			_containerWidth = containerWidth;
			
			var count:int = target.numElements;
			if (count == 0) return;
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var x:int=0;
			var y:int=0;
			//var layoutTarget:GroupBase = target;
			for (var i:int = 0; i < count; i++)
			{
				//var o : Object = _target.getElementAt(i) 
				var element: ILayoutElement = useVirtualLayout ?
					target.getVirtualElementAt(i) :
					target.getElementAt(i);
				
				var itemRenderer:ItemRenderer = element as ItemRenderer;
				
			 	//itemRenderer.setLayoutBoundsSize(_tileWidth, _tileHeight);
				element.setLayoutBoundsSize(NaN, NaN);
				
				if (filteredItems && filteredItems.contains(itemRenderer.data))
				{
					// The element is part of the selection: calculate its x and y values
					if (x + _tileWidth > containerWidth && i != 0 )
					{
						x = 0;
						y += _tileHeight + _verticalGap;
					} 
					itemRenderer.setLayoutBoundsPosition(x, y);    
					itemRenderer.alpha = 1;
					x += _tileWidth + _horizontalGap;
					
					//update max dimensions (needed for scrolling)
					maxWidth = Math.max(maxWidth, x + _tileWidth);
					maxHeight = Math.max(maxHeight, y + _tileHeight);
										
				}                    
				else
				{
					itemRenderer.alpha = 0;
				}
				
			}
			
			//set final content size (needed for scrolling)
			target.setContentSize(this.target.width, maxHeight + 0);
			//if ( this.setLayoutTargetHeight ) 
			target.height = this.target.height;
			if ( maxHeight == 0 ) 
			{
				trace();
			}
			trace('height ' + target.height  + 'max height ' + maxHeight )
		}
		
	}
}