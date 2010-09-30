package  org.syncon.evernote.panic.view
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
	/**
	 * All wdigets must store a widgetVO
	 * all components must be able to import an VO
	 * all components must be able to export a VO
	 * all componenets must be able to take striict typed parameters and make a vo outof them
	 * ...thenically that is the widgets problem, but for testing . there exists no widgets 
	 * */
	public interface IUIWidget  
	{
		/**
		 * Stores the widget
		 * */
		function get widgetData () : WidgetVO
		function set widgetData ( w : WidgetVO )  : void
			
		 //function getConfig () : Object
		 //public function convert
		//reisze?
		/**
		 * Imports config, widget should redraw self as necessary
		 * */
		function importConfig(e:WidgetVO) : void
		/**
		 * Essentially returns widgetData, but gives change for additional processing if necesary
		 * likely grap all class properties and recreate data object on VO
		 * */
		function exportConfig( ) :  WidgetVO
		/**
		 * Create a static function that take strict arguments of internal Data object on widget. 
		 * Likely will deserialize parameters and store on component directly
		 * */
		function importData_(e: Object) : void

			
		function showEdit() : void
		function hideEdit() : void
	}
}