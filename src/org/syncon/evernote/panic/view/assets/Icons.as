package org.syncon.evernote.panic.view.assets
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.FlexGlobals;
	import mx.managers.SystemManager;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;

    public class Icons {
		/*
		[Embed (source="nicEditorIcons.gif" )]
		private static var ICONS_DATA:Class;
		
		public static function getIcon(iconNum:int):BitmapData {
			var iconsBitmap:Bitmap = new ICONS_DATA();
			var bd:BitmapData = new BitmapData(18,18);
			var rect:Rectangle = new Rectangle(iconNum*18,0,18,18);
			var point:Point = new Point();
			
			bd.copyPixels(iconsBitmap.bitmapData,rect,point);
			
			return bd;
		}
		*/
		public static function get(str:String): Object {
			/*var iconsBitmap:Bitmap = new ICONS_DATA();
			var bd:BitmapData = new BitmapData(18,18);
			var rect:Rectangle = new Rectangle(iconNum*18,0,18,18);
			var point:Point = new Point();
			
			bd.copyPixels(iconsBitmap.bitmapData,rect,point);*/
			
			return null;
		}		
		
		static public function getFormatPainter( name : String = '.trashBtn')  :  Class
		{
			var bdb : Object = getStyleManager().getStyleDeclaration( name ).getStyle( 'content')
			return  Class(bdb);
		}	
		 
		public static function getStyleManager(): IStyleManager2
		{
			return FlexGlobals.topLevelApplication.styleManager
		}
    }
}

/***package sss2.Ecloseto.Utils
 {
 import mx.controls.Button;
 import mx.styles.StyleManager;
  
[Style(name="formatPainter", type="Class", inherit="no")]

public class CustomCursor extends  Button
{
	
	public function CustomCursor()
	{
 
		
	}
	public function goAhead() : void
	{
	 
		resizeCursorS = resizeCursor = StyleManager.getStyleDeclaration(".resizeCursorIcon").getStyle( 'overSkin')
	}
	//	public  var formatPainter: IFlexDisplayObject; 
	public function getFormatPainter()  :  Class
	{
		var bb : Object = StyleManager.getStyleDeclaration("CustomCursor")//.setStyle("busyCursor",myBusyCursor)
		var bdb : Object = StyleManager.getStyleDeclaration(".formatPainterIcon").getStyle( 'overSkin')
		return  Class(bdb);
	}
	
	public var resizeCursor : Class 	 		
	static public var resizeCursorS : Class 		
	
}
}
**/