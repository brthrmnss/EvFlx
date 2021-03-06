package org.syncon.evernote.panic.controller
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class LoadDataSource
	{
		public function LoadDataSource()
		{
		}
		public var fxDone : Function ; 
			public function start(url : String, fx : Function =  null ):void
			{
				this.fxDone = fx;
				var str :  String = '6{http://city-21.com/php/random_string.php}7'
				var re : RegExp = new RegExp('{(.*?)}', 'i')
				re  = new RegExp('{([^}]*)}', 'gi')
				re.lastIndex = 0; 
				var o : Object  = re.exec( str ) 
				re.lastIndex = 0; 
				str = '6{http://city-21.com/php/random_number.php}76{http://city-21.com/php/random_sstring.php}7'
				//  str = '6{http://l.yimg.com/a/i/brand/purplelogo/uh/us/news.gif}76{http://digg.com}7'
				//	var eo : Object  = re.exec( str )  
				/* 
				var result:Object = re.exec(str);
				while (result != null) {
				trace ( result.index, "\t", result);
				result = re.exec(str);
				}						
				
				var l :  int = getXandY( str ).length 
				*/
					str = url; 
				var res : Array =  getXandY( str )
				this.url_ = str
				if ( res.length == 0 ) 
				{
					//exit
				}
				else
				{
					for each ( var url : String in res ) 
					{
						if ( this.isUrl(url ) ) 
						{
							
							this.loadUrl(url) 
						}
					}
				}
				return;
			}
			
			public function loadUrl(u : String )  : void
			{
				var loader:URLLoader= new URLLoader()
				loader.dataFormat = URLLoaderDataFormat.TEXT
				this.dictX[loader] = u; 
				this.loaders.addItem( loader ) ;  
				//	loader.addEventListener(Event.ACTIVATE, activatedListener);
				loader.addEventListener(Event.COMPLETE, completeListener);
				//	loader.addEventListener(ProgressEvent.PROGRESS, progressListener);
				//this.dictX[
				try {
					var urlfull : String = u+randomIzer()
					var header: URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
					var request:URLRequest = new URLRequest(urlfull);
					request.requestHeaders.push(header);						
					loader.load(  request );
				} catch (error:Error) {
					trace("Unable to load requested document.");
				}
				
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(Event.OPEN, openHandler);
				loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);					
			}
			
			
			private function completeHandler(event:Event):void {
				var loader:URLLoader = URLLoader(event.target);
				//trace("completeHandler: " + loader.data);
				
				//var vars:URLVariables = new URLVariables(loader.data);
				//trace("The answer is " + vars.answer);
			}
			
			private function openHandler(event:Event):void { 
				//trace("openHandler: " + event);
			}
			
			private function progressHandler(event: ProgressEvent):void {
				//trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
			}
			
			private function securityErrorHandler(event: SecurityErrorEvent):void {
				trace("securityErrorHandler: " + event);
				this.failedToLoad( event.currentTarget as URLLoader ) 
			}
			
			private function httpStatusHandler(event: HTTPStatusEvent):void {
				//trace("httpStatusHandler: " + event);
			}
			
			private function ioErrorHandler(event: IOErrorEvent):void {
				trace("ioErrorHandler: " + event);
				this.failedToLoad( event.currentTarget as URLLoader ) 
			}			
			
			
			/* 	
			private function activatedListener(event:Event):void
			{
			trace(" activated " + event.currentTarget.bytesLoaded + 
			" but nothing loaded yet ");
			}
			*/
			private function completeListener(event: Event):void
			{
				var str : String =  event.currentTarget.data 
			//	trace(" all done loading " + event.currentTarget.data + 
			//		" and here's the xml file we loaded "); 
				var urlLoaded :  String = this.dictX[event.currentTarget]
					delete this.dictX[event.currentTarget]  ; 
				this.loaders.removeItemAt( this.loaders.getItemIndex( event.currentTarget) ) 
				// this.url_.replace( urlLoaded, str ) 
				var placed :String = this.str_replace( '{'+ urlLoaded+ '}', str, this.url_ )
				this.url_ = placed
				if ( this.loaders.length == 0 ) 
					this.done() 
				return;
			}			 
			
			public function failedToLoad(loader: URLLoader )  : void
			{
				var urlLoaded :  String = this.dictX[loader]
					delete this.dictX[loader]  ; 
				this.loaders.removeItemAt( this.loaders.getItemIndex(  loader ) ) 
				var placed :String = this.str_replace( '{'+ urlLoaded+ '}', '', this.url_ )
				this.url_ = placed
				this.errors.push( urlLoaded  )
				if ( this.loaders.length == 0 ) 
					this.done() 				
			}
			
			
			public var errors : Array = []; 
			
			private function str_replace( replace_with:String, replace:String, original:String ):String
			{
				var array:Array = original.split(replace_with); 
				return array.join(replace);
			}			
			public var loaders :  ArrayCollection = new ArrayCollection(); 
			public var url_ : String = '';
			public var dictX :    Dictionary = new Dictionary(true)
			
			public function getXandY(str : String )  : Array
			{
				var re : RegExp = new RegExp('{([^}]*)}', 'gi')
				var result:Object = re.exec(str);
				var results : Array = []; 
				while (result != null) {
					//trace ( result.index, "\t", result[1]);
					results.push(  result[1] )
					result = re.exec(str);
				}	
				return results
			}
			
			public  function isUrl(s:String):Boolean {
				var regexp:RegExp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
				return regexp.test(s);
			}			
			/* 
			public function isUrlValid ( x :  String ) :  Boolean
			{
			//http://ryanswanson.com/regexp/#start
			var reg :  RegExp = /^((ht|f)tp(s?)\:\/\/)?[\w]+\.+[\w\/\_\-\#\:\?\;&]+((\.)+([\w]{2,5})){1,2}+((\/|\#|\.)+[\w]*)*+$/i
			var xxxx : Boolean = reg.test( x ) 
			var o : Object = 	[reg.exec(x)]
			return  true
			}
			*/ 
			
			public function done()  : void
			{
				if ( this.fxDone != null ) this.fxDone( this.url_, this.errors  ) ; 
				var u : String = this.url_
				//	trace( ' done ' +  this.url_ ) ; 
			}
			import flash.net.URLRequest;
			import flash.net.navigateToURL;  	
			
			static public function goToUrl(u:String):void
			{
				var homeLink:URLRequest = new URLRequest(u);
				navigateToURL(homeLink);
			}			
			/**
			 * Append random string on url o prevent caching
			 * look up cleaner solution
			 * */
			public function randomIzer() : String
			{
				//+”?time=” + new Date().getTime()
				return '?rand='+Math.round(Math.random()*120000).toString()
			}
	}
}