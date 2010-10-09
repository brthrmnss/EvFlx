package org.syncon.evernote.panic.test.context.utils
{
	import com.adobe.crypto.MD5;
	
	import org.syncon.utils.StringUtils2;

	public class MD5Helper
	{
		public function MD5Helper()
		{
		}
		/**
		 * appended befor eevery string , shojld be reandom, 
		 * but evernote does not support this yet
		 * */
		static public var preabmle : String = ''
		static public function toHash( str : String )  : String
		{
		var ee : MD5
		var eee : StringUtils2
		var preable : String = '15a48a5'
			var str : String =  preable + MD5.hash( str ) + 'c8'+ StringUtils2.generateRandomString( 10 ) 
			return str
		}
		
		static public function toHashSearch( str : String )  : String
		{
			var ee : MD5
			var eee : StringUtils2
			var preable : String = '15a48a5'
			var str : String =  preable + MD5.hash( str ) + 'c8'//+ StringUtils2.generateRandomString( 10 ) 
			return str
		}		
		
	}
}