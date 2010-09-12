package org.syncon.utils
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import mx.controls.CheckBox;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class EntodoHolders
	{
		public function EntodoHolders()
		{
		}
			private var tf : TextFlow
			public var inlineElements : Array = [];
			public var addTo : Object ; 
			public var chkBoxes : Array = []; 
			private var inlineElementToCheckBoxDic : Dictionary = new Dictionary(true);
			private var checkBoxToInlineElementDic : Dictionary; 
			public function loadUp(arr : Array , tf : TextFlow, addTo  :  Object )  : void
			{
				this.inlineElements = arr ;
				this.inlineElementToCheckBoxDic = new Dictionary(true);
				this.checkBoxToInlineElementDic = new Dictionary(true)
				if ( chkBoxes.length == 0 ) 
				{
					for ( var i : int = 0; i < 10; i++ )
					{
						var chk : CheckBox = new  CheckBox()
						chkBoxes.push( chk ) 
						chk.addEventListener( 'change', this.onChanged ) 
				 		addTo.addElement( chk ) 
					}
				}
					for (  i = 0; i < chkBoxes.length ; i++ )
					{
						chk = chkBoxes[i]
						chk.visible = false; 		
					 	chk.selected = false; 
					}					
				
				for ( i = 0; i < arr.length; i++ )
				{
					var inlineGraphicElement_  : Object = arr[i]
					 chk = chkBoxes[i]
					var a : Array =  inlineGraphicElement_.id.split('|')
				//	 inlineGraphicElement_.id = a[0]
						var selected : Boolean = false
						if  ( a[1] == 'true' ) 
							selected = true;  
					chk.selected =  selected
					inlineElementToCheckBoxDic[inlineGraphicElement_]= chk
					checkBoxToInlineElementDic[chk]= inlineGraphicElement_
					
				}
				this.tf = tf; 
				this.addTo = addTo
				/*	
				tf.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,
					this.onRecomposed )
					*/
				//this.onRecomposed(null)
				tf.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE,
					this.onRecomposed )
				addTo.callLater( this.onRecomposed, [null] ) 
			}
			
			public function onRecomposed(e:Event, wait : Boolean = true):void
			{
				if ( wait ) 
				{
					addTo.callLater( this.onRecomposed, [e,false] )
					return
				}
				
				for (  var i : int = 0; i < chkBoxes.length ; i++ )
				{
					chk = chkBoxes[i]
					chk.visible = false; 			
				}						
				
				//tf.flowComposer.updateAllControllers(); 
				for each ( var pHolder :  InlineGraphicElement in this.inlineElements )
				{
					
					var chk : CheckBox = inlineElementToCheckBoxDic[pHolder]
					var xx : Boolean = chk.selected ; 
					chk.visible = true; 
						var x : Point = pHolder.graphic.localToGlobal( new  Point() ) 
					var aaa : Array =  [pHolder.graphic.localToGlobal(new Point(0,0)).x + 10, pHolder.graphic.localToGlobal(new Point(0,0)).y]	
					aaa.push( x ) 
					var pt2 : Point = this.addTo.globalToLocal( new Point(aaa[0], aaa[1]) )
					  pt2   = this.addTo.globalToLocal( x   )
					trace( 'moved to ' + pt2.x+ ' ' +  pt2.y ) 
					chk.move(pt2.x  , pt2.y);    
					//this.addTo.implicitHeight; 
					var ddbg : Array = [this.addTo.parent.height] 
					if ( pt2.y > this.addTo.height ) 
					{
						trace('hide me');
					}
					if ( pt2.x < 0  ) 
					{
						chk.visible = false; 
					}					
				}
			}
			public static var CheckedIndicator : String = '|true'
			private function onChanged(e:Event):void
			{
				var id : String = this.checkBoxToInlineElementDic[e.currentTarget].id
				var split : Array = id.split('|'); 
				this.checkBoxToInlineElementDic[e.currentTarget].id =split[0] + '|' + e.currentTarget.selected
				//e.currentTarget.id 
				
				tf.flowComposer.updateAllControllers(); 
			}
	}
}