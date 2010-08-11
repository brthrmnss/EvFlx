package org.syncon.utils
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;  	

	public class Js
	{
		public function Js()
		{}
		
		static public function goToUrl(u:String):void
		{
			var homeLink:URLRequest = new URLRequest(u);
			navigateToURL(homeLink);
		}
	}
}