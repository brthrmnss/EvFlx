package  org.syncon.evernote.basic.vo
{
	public class MenuVO  
	{
		public var name :  String = ''
		/**
		 * Allows for flexibility
		 * */
		public var name2 : String = ''; 
		public var toolTip : String = ''; 
		public var data : Object = null; 
		public var fx :  Function;
		public var enabled : Boolean = true; 
		public function MenuVO( name_ : String='', tooltip_ : String = '', 
								data_ : Object=null, fx_ :  Function = null)
		{
			this.name = name_
			this.toolTip = tooltip_
			this.data = data_
			this.fx = fx_
			super();
		}
		
		public function onInit()  : void
		{
		}
 
	}
}