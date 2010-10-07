package  org.syncon.evernote.panic.view.utils
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.filters.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class SmoothImage extends Image {
		
		public function SmoothImage():void {
			super();
		}
		
		override mx_internal function contentLoaderInfo_completeEventHandler(evObj:Event):void {
			
			var currTarget:LoaderInfo = evObj.currentTarget as LoaderInfo;
			
			// create a copy of original bitmap
			var originalImage:BitmapData = new BitmapData(currTarget.width, currTarget.height);
			originalImage.draw(evObj.target.loader as IBitmapDrawable);
			
			// blur values are arbitrary - for me 7 worked fine - you can experiment with these
			var blurXValue:Number = 7;
			var blurYValue:Number = 7;
			
			// setting up the blur filter
			var blurFilter:BlurFilter = new BlurFilter(blurXValue, blurYValue, int(BitmapFilterQuality.LOW));
			
			// applying the blur filter to the copy of the original image
			originalImage.applyFilter(originalImage,
				new Rectangle(0, 0, originalImage.width, originalImage.height),
				new Point(0, 0),
				blurFilter);
			
			// resizing the original image
			var rbd:BitmapData = resizeImageBD(originalImage, this.width, this.height);
			
			// assigining the resized version of the image to the Image component
			this.source = new Bitmap(rbd, PixelSnapping.AUTO, true);
			
			super.contentLoaderInfo_completeEventHandler(evObj);
		}
		
		public static function resizeImageBD( bitmapData:BitmapData, width:Number, height:Number ):BitmapData {
			var newBitmapData:BitmapData = new BitmapData( width, height, true, 0x000000 );
			var matrix:Matrix = new Matrix();
			matrix.identity();
			matrix.createBox( width / bitmapData.width, height / bitmapData.height );
			newBitmapData.draw( bitmapData, matrix, null, null, null, true );
			return newBitmapData;
		}
	}
}