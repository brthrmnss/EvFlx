package  org.syncon.evernote.panic.view
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.WidgetVO;
 
	public class TwitterScrollerWidgetMediator extends WidgetMediatorBase
	{
		[Inject] public function set ui  ( i :  TwitterScrollerTest2) : void 
		{	this.widgetUI = i  }
		public function get ui () : TwitterScrollerTest2
		{ return this.widgetUI as TwitterScrollerTest2;  }		
		
		public function TwitterScrollerWidgetMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			this.editPopupName = 'TwitterWidgetEditorPopup'; 				
		}
		
		override public function onSkinChanged(e:PanicModelEvent): void
		{
			this.ui.fontColor = this.model.color; 
			this.ui.colorBg = this.model.backgroundColor; 
		}		
				
		
		override public function automateWidget( settings : WidgetVO )  : void
		{
			this.ui.searcher.query =  settings.source
		}
 	
		
	}
}