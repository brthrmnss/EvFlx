package   org.syncon.evernote.editor.vo
{
	import flashx.textLayout.elements.TextFlow;
	
	import org.syncon.utils.EvernoteConvertors;

	public class EditorTestCaseVO  
	{
		public var name :  String = ''
	 
		public var importing   : Boolean = true
		public var exporting : Boolean = false; 
		
		public var evernoteXML : String = ''; 
		public var convertedTLFString : String = ''; 
		public var tlf : TextFlow ; 
		public var tlf_toString : String = ''; 
		public var chk : Array = []; 
		
		public var exportedBackToEvernoteXML : String = '';  
		
		public var index : int = 0; 
		/*
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
		}
		
		public function onInit()  : void
		{
		}
 		*/
		
		public function process() : void
		{
			if ( this.importing ) 
			{
				this.onImport()		
				this.onExport( this.tlf ) ; 
			}
				
		}
		
		protected function onImport( ):void  
		{  
			EvernoteConvertors.convertEvernoteXMLtoTLF(
				this.evernoteXML, this.onEvernoteConverted )
		}
		protected function onEvernoteConverted( tf : TextFlow, chkbox : Array ):void
		{ 
			this.tlf  = tf
			this.chk = chkbox
			tlf_toString 	=EvernoteConvertors.exportTLF( tf  )
			return;
		}
		
		
		protected function onExport( tf :  TextFlow):void  
		{  
			EvernoteConvertors.convertTLFtoEvernoteXML( 
				tf ,  this.onExported )
		}  				
		
		public function onExported(exportresult:String)  : void
		{
			this.exportedBackToEvernoteXML = exportresult
			return;
		}

		
		
	}
}