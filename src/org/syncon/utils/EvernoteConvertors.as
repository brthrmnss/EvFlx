package org.syncon.utils
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import mx.controls.CheckBox;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommand;
	import org.syncon.evernote.basic.controller.EvernoteToTextflowCommandTriggerEvent;

	public class EvernoteConvertors
	{
		public function EvernoteConvertors()
		{
			
		}
		 
		static public function convertTLFtoEvernoteXML( tf : TextFlow, fxResult : Function )  : void
		{
			var ee  : EvernoteToTextflowCommandTriggerEvent;
			var xml : XML = TextConverter.export(  tf,  
				TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE ) as XML//..toString()
			
			var cmd : EvernoteToTextflowCommand = new EvernoteToTextflowCommand()
			var event : EvernoteToTextflowCommandTriggerEvent = 
				new EvernoteToTextflowCommandTriggerEvent(
					EvernoteToTextflowCommandTriggerEvent.EXPORT,
					xml.toXMLString(), fxResult )
			cmd.event = event
			cmd.execute();			
		}
		
		static public function convertEvernoteXMLtoTLF( input : String, fxResult : Function )  : void
		{
			var cmd : EvernoteToTextflowCommand = new EvernoteToTextflowCommand()
			var event : EvernoteToTextflowCommandTriggerEvent = 
				new EvernoteToTextflowCommandTriggerEvent(
					EvernoteToTextflowCommandTriggerEvent.IMPORT,
					input, fxResult  )
			cmd.event = event
			cmd.execute();			
		}		
		
		
		
		static public function exportTLF( tlf : TextFlow )  :  String
		{
			return TextConverter.export(  tlf,  
				TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.STRING_TYPE ).toString()
				
		}		
				
		
		
		
	}
}