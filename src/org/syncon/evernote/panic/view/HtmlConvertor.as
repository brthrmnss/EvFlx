package  org.syncon.evernote.panic.view
{
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;

	public class HtmlConvertor 
	{
		public function HtmlConvertor()
		{ 
		} 
		 
		public function convert ( txt : String )  :  TextFlow
		{
			return TextConverter.importToFlow(txt, TextConverter.TEXT_FIELD_HTML_FORMAT)
		}
	}
}