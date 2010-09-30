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
	
	public class PopupEditProjectMediator extends Mediator
	{
		[Inject] public var ui:  PopupEditProject;
		[Inject] public var model :  PanicModel;
		
		public function PopupEditProjectMediator()
		{
		} 
		
		override public function onRegister():void
		{
			this.ui.addEventListener( 'editMembers', this.onEditProject) 
		}
		
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PeopleManagementPopup', [this.ui.project.ppl, this.peopleSelected] )  )  				
		}			
		
		private function peopleSelected(newPeople:Array )  : void
		{
			//maybe only if neccesary , ... 
			//now it will always update when changed ... but who really cares 
			this.ui.project.ppl = newPeople; 
			
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