package  org.syncon.evernote.panic.view
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;

	public interface IWidget  
	{
		/**
		 * Stores the widget
		 * */
		function get widgetData () : WidgetVO
		function set widgetData ( w : WidgetVO )  : void		
		 //function getConfig () : Object
		 //public function convert
		//reisze?
		function onImportConfig(e:  WidgetEvent) : void
			
		function onEditModeChanged( e : PanicModelEvent )  : void
	}
}