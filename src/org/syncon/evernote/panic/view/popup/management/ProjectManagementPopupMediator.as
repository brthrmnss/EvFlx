package  org.syncon.evernote.panic.view.popup.management
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.LoadDataSourceCommandTriggerEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class ProjectManagementPopupMediator extends Mediator
	{
		[Inject] public var ui: ProjectManagementPopup;
		[Inject] public var model :  PanicModel;
		
		private var changed : Boolean = false; 		
		
		public function ProjectManagementPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
	 		this.ui.addEventListener( ProjectManagementPopup.ADD_PROJECT, this.onAddProject ) 
			this.ui.addEventListener( ProjectManagementPopup.OPENED_POPUP, this.onOpenedPopup)
			this.ui.addEventListener( PeopleManagementPopup.CLOSED_POPUP, this.onClosedPopup) 				
			this.ui.addEventListener( ProjectManagementPopup.EDIT_PROJECT, this.onEditProject) 
			this.ui.addEventListener( ProjectManagementPopup.DELETE_PROJECT, this.onDeleteProject) 				
			
		}
 
		private function onAddProject(e:CustomEvent) : void
		{
		 	//this.data = e.data as WidgetVO
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditProject', [null, this.projectAdded] )  )  				
		}		
		
		private function onEditProject(e:CustomEvent) : void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditProject', [e.data, this.projectsChanged] )  )  				
		}				
		
		private function onDeleteProject(e:CustomEvent) : void
		{
				this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
					'popup_confirm', ['Are you sure you want to delete "' +e.data.name+ '"? '+
						'This change cannot be undone.', this.onDeleteProject_Confirmed , null,
						'Delete Project', 'Delete', 'Cancel', [e.data]  ] )  )				
		}				
			private function onDeleteProject_Confirmed (p :  ProjectVO) : void
			{
				this.ui.list1.dataProvider.removeItemAt( this.ui.list1.dataProvider.getItemIndex( p ) ) 
				for each ( var p_ :  ProjectVO in this.model.board.projects ) 
				{
					if ( p_ == p ) 
						trace('found project'); 
					this.model.board.projects.indexOf( p )
				}
				this.dispatch( new PanicModelEvent(PanicModelEvent.CHANGED_PROJECTS) ) 
			}
	 
		private function onOpenedPopup(e:CustomEvent) : void
		{
			this.changed = false; 
			var o : Object =  this.model.board.projects
			this.ui.list1.dataProvider = new ArrayList( this.model.board.projects ) 
		}		
		private function onClosedPopup(e:CustomEvent) : void
		{
			if ( this.changed ) 
			{
				this.dispatch( new PanicModelEvent(PanicModelEvent.CHANGED_PROJECTS ) ) 
				this.model.saveBoard()
			}
		}			
		/**
		 * Called when user presses add, add this to the list
		 * */
		private function projectAdded(a:  ProjectVO) : void
		{
			this.model.board.projects.push( a ) ; 
			projectsChanged()
		}
		
		private function projectsChanged( a:ProjectVO=null) : void
		{
			return;
			this.onOpenedPopup( null )
			this.changed = true; 
		}	
	}
}