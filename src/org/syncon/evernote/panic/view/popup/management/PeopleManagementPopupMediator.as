package  org.syncon.evernote.panic.view.popup.management
{
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class PeopleManagementPopupMediator extends Mediator
	{
		[Inject] public var ui: PeopleManagementPopup;
		[Inject] public var model :  PanicModel;
		
		private var changed : Boolean = false; 
		
		public function PeopleManagementPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
	 		this.ui.addEventListener( PeopleManagementPopup.ADD_PERSON, this.onAddPerson) 
			this.ui.addEventListener( PeopleManagementPopup.ADD_PERSON_TO_SELECTION, this.onEditPerson) 
			this.ui.addEventListener( PeopleManagementPopup.OPENED_POPUP, this.onOpenedPopup) 
			this.ui.addEventListener( PeopleManagementPopup.CLOSED_POPUP, this.onClosedPopup) 				
			this.ui.addEventListener( PeopleManagementPopup.EDIT_PERSON, this.onEditPerson)
		
			this.ui.addEventListener( PeopleManagementPopup.PEOPLE_SELECTED, this.onPeopleSelected ) 		
			this.ui.addEventListener( 'deletePerson', this.onDeletePerson )
				
		}
 
		private function onAddPerson(e:CustomEvent) : void
		{
		 	//this.data = e.data as WidgetVO
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditPerson', [null, this.projectAdded] )  )  				
		}		
		
		private function onEditPerson(e:CustomEvent) : void
		{
			if ( this.ui.selectorMode == false ) 
			{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP, 
				'PopupEditPerson', [e.data, this.projectsChanged] )  )  				
			}
			else
			{
				
				if ( this.ui.dp.getItemIndex( e.data ) == -1   )
				{
					this.changed = true
					this.ui.dp.addItem( e.data ) ;
				}
			}
		}				
 
		private function onPeopleSelected(e:CustomEvent)  : void
		{
			if ( this.changed )
			{
				if ( this.ui.fxSelected != null ) this.ui.fxSelected(this.ui.dp.toArray())
			}
			this.ui.hide()			
		}
			
		
		private function onDeletePerson(e:CustomEvent) : void
		{
				this.ui.dp.removeItemAt( this.ui.dp.getItemIndex( e.data ) ) 
		}			
		
		
		private function onOpenedPopup(e:CustomEvent) : void
		{
			this.changed = false; 
			var o : Object =  this.model.board.projects
			this.ui.list1.dataProvider = new ArrayList( this.model.board.people ) 
		}		
		
		private function onClosedPopup(e:CustomEvent) : void
		{
			if ( this.changed ) 
			{
				this.dispatch( new PanicModelEvent(PanicModelEvent.CHANGED_PEOPLE ) ) 
				this.model.saveBoard()
			}
		}		
				
		/**
		 * Called when user presses add, add this to the list
		 * */
		private function projectAdded(a: PersonVO) : void
		{
			this.model.board.people.push( a ) ; 
			projectsChanged()
		}
		
		private function projectsChanged(a: PersonVO=null) : void
		{
			this.onOpenedPopup( null )
			this.changed = true; 
		}		
	}
}