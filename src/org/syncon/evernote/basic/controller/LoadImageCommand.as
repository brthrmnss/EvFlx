package  org.syncon.evernote.basic.controller
{
	import com.evernote.edam.type.Resource;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.controls.CheckBox;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Command;

	/**
	 * 
	 * http://stackoverflow.com/questions/906791/how-to-convert-bytearray-to-image-or-image-to-bytearray
	 * */
	public class LoadImageCommand extends Command
	{
		//[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var event:LoadImageCommandTriggerEvent;
		 public var txt :  String = '' 
		override public function execute():void
		{
		 	var ee :   EvernoteAPICommandTriggerEvent
			this.dispatch( 
				EvernoteAPICommandTriggerEvent.GetResource( event.resource.guid, true, false, true, true,
					this.onResourceLoaded, this.onResourceLoaded_Fault)
			)
				
			this.dispatch( 
				EvernoteAPICommandTriggerEvent.GetResourceData( event.resource.guid,  
					this.onResourceLoaded2, onResourceLoaded_Fault2 )
			)	
				var b : ByteArray = new ByteArray()
					b.writeObject( event.resoureGuid ) 
			this.dispatch( 
				EvernoteAPICommandTriggerEvent.GetResourceByHash( event.resource.guid, 
				 b,   false, false, false, this.onResourceLoaded2, onResourceLoaded_Fault2 )
			)						
				
		}
		public static var IMAGE : Image;   
		private function onResourceLoaded (e:   Resource):void
		{
			
			
			//load image 
			//load Image into loadInto 
			
			if ( event.image == null ) 
			{
				var img : Image = new Image()
				img.source =  e.data.body;
				event.loadInto.source = img; 
				event.loadInto.width = e.width; 
				event.loadInto.height = e.height; 				
				FlexGlobals.topLevelApplication.addElement( img ) ;						
			}
			else
			{
				 
				event.image.source = e.data.body;
				event.loadInto.source =  event.image; 
				event.loadInto.width = e.width; 
				event.loadInto.height = e.height; 							
				//FlexGlobals.topLevelApplication.addElement( event.image ) ;	
				//create a new image ... 
				
				
		
			}
			/*
			//create a new image ... 
			var img : Image = new Image()
			img.source =  e.data.body;
			event.loadInto.source = img; 
			FlexGlobals.topLevelApplication.addElement( img ) ;
			
			event.loadInto.source = imageLoader
			event.loadInto.source = IMAGE; 	
			*/
			/*
			//does checkboxes work? yes they do 
			var chk : CheckBox = new CheckBox()
			event.loadInto.source = chk; 
			chk.id = 'boom'
			FlexGlobals.topLevelApplication.addElement( chk ) ;			
			*/
			var s : Object = event.loadInto; 
			/*
			works nneds to be added to the stage
			IMAGE.source = e.data.body
			event.loadInto.source = imageLoader
			event.loadInto.source = IMAGE; 
			*/
			//event.loadInto
			var ee : FlexGlobals
			/*
			event.loadInto.width = e.width; 
			event.loadInto.height = e.height; 
			*/
			trace();
		}
		
		public function drawRect(by : ByteArray = null): Sprite
		{
			var redRect:Sprite = new Sprite();
			redRect.graphics.beginFill(0xff0000);    // red
			redRect.graphics.drawRect(0,0,30, 30);
			redRect.graphics.endFill();
			
			if ( by != null ) 
			{
				/*
				imageLoader = new Loader();
				imageLoader.loadBytes(imageArray);
				
				var imageToLoad = mainMC;
				imageToLoad.x = xPosition;
				imageToLoad.y = yPosition;
				imageToLoad.width = imageWidth;
				imageToLoad.scaleY < imageToLoad.scaleX ? imageToLoad.scaleX = imageToLoad.scaleY : imageToLoad.scaleY = imageToLoad.scaleX;
				imageToLoad.addChild(imageLoader);
				*/
			}
			return redRect;
		}

		
		private function onResourceLoaded2 (e:Object):void
		{
			trace();
		}
				
		private function onResourceLoaded_Fault (e:  Object):void
		{
			trace();
		}
		
		private function onResourceLoaded_Fault2 (e:Object):void
		{
			trace();
		}
		 
	}
}