package  org.syncon.evernote.panic.view.popup.utils
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class TestDataSourceMediator extends Mediator
	{
		[Inject] public var ui:  TestDataSourcePopup;
		[Inject] public var model :  PanicModel;
		
		public function TestDataSourceMediator()
		{
			
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( TestDataSourcePopup.OPENED_POPUP, this.onOpenedPopup) 
			this.ui.addEventListener( TestDataSourcePopup.TEST_AGAIN, this.onTest) 
				
		}
 
		private function onOpenedPopup(e: Event) : void
		{
		 	 this.onTest(null) 				
		}		
		
		private function onTest(e:CustomEvent):void
		{
			this.model.source( this.ui.value, this, 'result', null )
		}
		
		public function set result (str : String) : void
		{
		 	this.ui.txtResult.text = str; 
		}				
 
		 
	}
}