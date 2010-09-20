package   org.syncon.evernote.editor.vo
{
	import com.evernote.edam.type.Note;
	
	import flashx.textLayout.elements.TextFlow;
	
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommandTriggerEvent;
	import org.syncon.utils.EvernoteConvertors;

	public class EditorTestCaseVO  
	{
		public function EditorTestCaseVO ( name : String = '' ) 
		{
			this.name = name; 
		}
		public var name :  String = ''
	 
		private var _importing   : Boolean = true
		private var _exporting : Boolean = false; 
		
		
		public var associatedNote : Note = new Note(); //
		
		public function set  importing  ( b  : Boolean ) : void
		{
			this._importing = b; 
			this._exporting = ! b 
		}
		public function get   importing  ()  : Boolean  
		{
			 return this._importing
		}		
		public function set  exporting  ( b  : Boolean ) : void
		{
			this._importing = ! b; 
			this._exporting =  b 
		}
		public function get   exporting  ()  : Boolean  
		{
			return this._exporting
		}				
				
		
		public var evernoteXML : String = ''; 
		public var convertedTLFString : String = ''; 
		public var tlf : TextFlow ; 
		public var tlf_toString : String = ''; 
		public var entodos : Array = []; 
		public var enmedias : Array = []; 
		
		public var description : String = ''; 
		
		/**
		 * If set goes no where 
		 * */
		public var result : String = null; 
		
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
			if ( this.exporting ) 
			{
				this.onExport( this.tlf ) ; 
			}			
				
		}
		
		protected function onImport( ):void  
		{  
			EvernoteConvertors.convertEvernoteXMLtoTLF(
				this.evernoteXML, this.onEvernoteConverted, true , this.associatedNote)
		}
		protected function onEvernoteConverted( e : EvernoteToTextflowCommandTriggerEvent ):void
		{ 
			
			this.tlf  = e.tf
			this.entodos = e.checkboxes
			this.enmedias = e.images
			tlf_toString = EvernoteConvertors.exportTLF( e.tf  )
			return;
		}
		
		
		protected function onExport( tf :  TextFlow):void  
		{  
			EvernoteConvertors.convertTLFtoEvernoteXML( 
				tf ,  this.onExported, true )
		}  				
		
		public function onExported(exportresult:String)  : void
		{
			this.exportedBackToEvernoteXML = exportresult
			return;
		}

		public function importXML( body : String, result_ : String = null )  : void
		{
			if ( body.indexOf( '</en-note>' ) != -1   ) 
				throw 'do not include end tags' 
			if ( body.indexOf( '<en-note>' ) != -1   ) 
				throw 'do not include end tags' 	
			if ( result_ != null ) 
			{
				if ( result_.indexOf( '</en-note>' ) != -1   ) 
					throw 'result_ do not include end tags' 
				if ( result_.indexOf( '<en-note>' ) != -1   ) 
					throw 'result_ do not include end tags' 							
			}
			this.importing = true
			var head : String = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note>'
			var foot : String ='</en-note>';  
			this.evernoteXML = head + body  + foot
				
			if ( result_ != null ) 
				this.result = head + result_  + foot
			this.process()
		}
		
		public function exportTLF( body :  TextFlow )  : void
		{
			this.exporting = true
			this.tlf = body; 
			this.process()
			tlf_toString 	=EvernoteConvertors.exportTLF( body  )
		}		
		
	}
}