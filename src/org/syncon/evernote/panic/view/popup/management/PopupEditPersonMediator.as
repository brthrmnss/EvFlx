package  org.syncon.evernote.panic.view.popup.management
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class PopupEditPersonMediator extends Mediator
	{
		[Inject] public var ui:   PopupEditPerson;
		[Inject] public var model :  PanicModel;
		
		public function PopupEditPersonMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( 'editMembers', this.onEditProject) 
		}
		
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupPeople', true )  )  				
		}			
		
		 /*
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditProject', [e.data] )  )  				
		}				
 */
 
	}
}