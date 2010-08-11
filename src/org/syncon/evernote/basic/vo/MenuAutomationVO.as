package  org.syncon.evernote.basic.vo
{
	public class MenuAutomationVO  
	{
		public var menuItems : Array = new Array();
		/**
		 * Function to send data to if data set, else 
		 * send name
		 * */
		public var fx : Function; 
/*		public function MenuVO( name_ : String='', tooltip_ : String = '', 
								data_ : Object=null, fx_ :  Function = null)
		{
			this.name = name_
			this.toolTip = tooltip_
			this.data = data_
			this.fx = fx_
			super();
		}
		*/
		public function onClickIndex(index:int)  : void
		{
			var menu : MenuVO = this.menuItems[ index ] as MenuVO
			if ( menu.fx != null ) menu.fx();
			if ( fx != null ) 
				if ( menu.data != null ) 
					fx(menu.data)			
				else
					fx(menu.name)
		}
 
		
		public function setupFlat( names:Array, tooltips:Array=null,
								   fxs:Array=null, data:Array=null, enabled:Array=null )  : void
		{
			for ( var i  : int = 0; i < names.length; i++ )
			{
				var menu : MenuVO = new MenuVO( names[i])
				//if ( tooltips != null ) menu.toolTip = tooltips[i]
				if ( tooltips != null ) menu.toolTip = tooltips[i]
				if ( fxs != null ) menu.fx = fxs[i]
				if ( data != null ) menu.data = data[i]
				if ( enabled != null ) menu.enabled = enabled[i]	
				this.menuItems.push( menu )
			}
		}
		
		public function updatePropOnMenuVOs( prop : String, values : Array )  : void
		{
			if ( menuItems.length != values.length ) 
				trace( 'incorrect' );
			
			for ( var i  : int = 0; i < this.menuItems.length; i++ )
			{
				var menu : MenuVO = this.menuItems[i]
				menu[prop] = values[i]
			}			
		}
		
		public function disableAll( )  : void
		{
			for ( var i  : int = 0; i < this.menuItems.length; i++ )
			{
				var menu : MenuVO = this.menuItems[i]
				menu.enabled = false
			}
		}
		public function enableAll( )  : void
		{
			for ( var i  : int = 0; i < this.menuItems.length; i++ )
			{
				var menu : MenuVO = this.menuItems[i]
				menu.enabled = true
			}
		}		
		public function enableIndexes( indexs : Array , enable :  Boolean = true )  : void
		{
			for each ( var i  : int  in indexs )
			{
				var index : int = indexs[i]
				var menu : MenuVO = this.menuItems[i]
				menu.enabled = enable
			}
		}
		public function disableIndexes( indexs : Array  )  : void
		{
			enableIndexes(indexs, false)
		}					
		
		
		public function menuOption(index:int):MenuVO
		{
			return this.menuItems[index] as MenuVO
		}
		
		public function toArray() :  Array
		{
			return this.menuItems
		}
		
		/***
		 * Selection
		 * */
		
		public var disableIfNoneSelected : Array = []; 
		public var disableIf1Selected : Array = []; 
		public var disableIfMoreThan1Selected : Array = []; 
		
		public function selectionChanged(selectedItems:Array )  : void
		{
			this.enableAll()	
			if ( selectedItems.length == 0 ) 
			{
				this.disableIndexes( this.disableIfNoneSelected ) 
			}
			else if ( selectedItems.length == 1 ) 
			{
				this.disableIndexes( this.disableIf1Selected ) 
			}
			else if ( selectedItems.length > 1 ) 
			{
				this.disableIndexes( this.disableIfMoreThan1Selected ) 
			}			
		}
	}
}