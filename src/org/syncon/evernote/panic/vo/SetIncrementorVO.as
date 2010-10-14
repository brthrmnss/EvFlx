package org.syncon.evernote.panic.vo
{
	import flash.utils.Dictionary;

	public class SetIncrementorVO  
	{
		public var name :  String = ''
		public var index : int = -1; 
		
		public function increment( options : Array )  :  Object
		{
			if ( options.length == 0 )
			{
				index = 0; 
				return null
			}
			else if ( options.length == 1 ) 
				index = 0
			else 
			{ 
				index++
			}
			
			if ( index >=  options.length )
			{
				index = 0;  
			}
			
			return options[index] 
		}
	}
}