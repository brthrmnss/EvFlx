package  org.syncon.evernote.panic.view
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
 
	public class SpacerWidgetMediator extends WidgetMediatorBase
	{
		[Inject] public function set ui  ( i :   SpacerWidget) : void 
		{	this.widgetUI = i  }
		public function get ui () : SpacerWidget 
		{ return this.widgetUI as SpacerWidget;  }
		
		public function SpacerWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			this.editPopupName = 'SpacerWidgetEditorPopup'; 		
		}
 
		override public function automateWidget(  settings : WidgetVO )  : void
		{
			//this.model.source( settings.source, this, 'message', null , settings.test.source )
		}
		 
	}
}