package org.syncon.utils
{
	import com.evernote.edam.type.Resource;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import mx.controls.CheckBox;
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.syncon.evernote.basic.controller.LoadImageCommandTriggerEvent;

	public class EnMediaHolders
	{
		public function EnMediaHolders()
		{
		}
			private var tf : TextFlow
			public var inlineElements : Array = [];
			public var addTo : Object ; 
			public var images : Array = []; 
			private var inlineElementToCheckBoxDic : Dictionary = new Dictionary(true);
			private var dictImgToResource : Dictionary = new Dictionary(true); 
			private var checkBoxToInlineElementDic : Dictionary; 
			public function loadUp(arr : Array , tf : TextFlow, addTo  :  Object )  : void
			{
				//return; 
				if ( arr.length == 0 ) 
					return; 
				this.inlineElements = arr ;
				this.inlineElementToCheckBoxDic = new Dictionary(true);
				this.checkBoxToInlineElementDic = new Dictionary(true)
				if ( images.length == 0 ) 
				{
					for ( var i : int = 0; i < 10; i++ )
					{
						var img :  Image = new  Image()
						images.push( img ) 
						img.addEventListener( 'change', this.onChanged ) 
				 		addTo.addElement( img ) 
					//		var ee : FlexGlobals
					//	FlexGlobals.topLevelApplication.addElement( img ) ;			
					}
				}
				//create more images, or delete extra ones 
				
				//ese how may need to be loaded 
				//see how many created
				//if more than 16, make addiction 
				//i fless than 10, leave 10 around 
				
			
					for (  i = 0; i < images.length ; i++ )
					{
						img = images[i]
						//img.visible = false; 		
					}					
				
					//find the component i nthe tlf flow 
				for ( i = 0; i < arr.length; i++ )
				{
					var inlineGraphicElement_  :  InlineGraphicElement = arr[i].img
					 img = images[i]
					var r : Resource = arr[i].resource
					inlineElementToCheckBoxDic[inlineGraphicElement_]= img
					dictImgToResource[img]= r						
					checkBoxToInlineElementDic[img]= inlineGraphicElement_
					//continue
					var e  : LoadImageCommandTriggerEvent = new LoadImageCommandTriggerEvent( 
						LoadImageCommandTriggerEvent.LOAD_IMAGE, '', inlineGraphicElement_.id, inlineGraphicElement_, i , r, img ) 
					LoadImageCommandTriggerEvent.dispatch(  e )  						
				}
				this.tf = tf; 
				this.addTo = addTo
			 	return;
				tf.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE,
					this.onRecomposed )
				addTo.callLater( this.onRecomposed, [null] ) 
			}
			
			public function onRecomposed( e:Event, wait : Boolean = true):void
			{
				return; //
				if ( wait ) 
				{
					addTo.callLater( this.onRecomposed, [e,false] )
					return
				}
				
				for (  var i : int = 0; i < images.length ; i++ )
				{
					img = images[i]
					img.visible = false; 			
				}						
				
				//tf.flowComposer.updateAllControllers(); 
				for each ( var pHolder :  InlineGraphicElement in this.inlineElements )
				{
					
					var img :  Image = inlineElementToCheckBoxDic[pHolder]
					img.visible = true; 
						var x : Point = pHolder.graphic.localToGlobal( new  Point() ) 
					var aaa : Array =  [pHolder.graphic.localToGlobal(new Point(0,0)).x + 10, pHolder.graphic.localToGlobal(new Point(0,0)).y]	
					aaa.push( x ) 
					var pt2 : Point = this.addTo.globalToLocal( new Point(aaa[0], aaa[1]) )
					  pt2   = this.addTo.globalToLocal( x   )
					trace( 'moved to ' + pt2.x+ ' ' +  pt2.y ) 
					img.move(pt2.x  , pt2.y);    
					//this.addTo.implicitHeight; 
					var ddbg : Array = [this.addTo.parent.height] 
					if ( pt2.y > this.addTo.height ) 
					{
						trace('hide me');
					}
					if ( pt2.x < 0  ) 
					{
						img.visible = false; 
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