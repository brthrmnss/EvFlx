package  org.syncon.evernote.panic.view.popup.editors
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEditEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;

	public interface IWidgetEditorMediator  
	{
		/**
		 * Stores the widget
		 * */
		/*
		function get widgetData () : WidgetVO
		function set widgetData ( w : WidgetVO )  : void		
		 //function getConfig () : Object
		 //public function convert
		//reisze?
		function onImportConfig(e:  WidgetEvent) : void
			
		function onEditModeChanged( e : PanicModelEvent )  : void
		*/
		/**
		 * Terrible name, 
		 * load in widgetVO, vo -> gui
		 * */
		function onImportEditConfig( e : WidgetEvent )  : void	
			
		//use edit widget events 
			
		/**
		 * Returns a WidgetVO that contains gui settings 
		 * gui -> vo
		 * */
		function currentConfig()  : WidgetVO	
			
		/**
		 * Loads current config into the editedqidget
		 * gui's vo --> widget
		 * */
		function onTestWidget(e : CustomEvent)  : void	
			
			
		/**
		 * Loads current config into the editedqidget
		 * gui's vo --> widget
		 * */
		//function onSaveWidgetConfig(e : WidgetEvent)  : void	
				
			
		/**
		 * Revert to original config 
		 * */
		//function onCloseWidthoutSaving(e :  WidgetEditEvent)  : void	
						
	}
}