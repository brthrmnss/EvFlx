package  org.syncon.evernote.panic.view.popup.management
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.vo.PersonVO;
	import org.syncon.evernote.panic.vo.ProjectVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class RosterPopupMediator extends Mediator
	{
		[Inject] public var ui: RosterPopup;
		[Inject] public var model :  PanicModel;
		
		private var changed : Boolean = false; 
		
		public function RosterPopupMediator()
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
			if ( this.model.adminMode == false ) 
				return; 
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
			this.ui.admin = this.model.adminMode; 
			this.ui.allPeople = new ArrayCollection(   this.model.board.people ) 
			//this.ui.allPeople.filterFunction = null
			this.ui.txtSearch.text = ''; 
			this.ui.txtLength.text = ''; 
			
			this.ui.filteredItems.filterFunction = null
			this.ui.filteredItems.refresh()
			this.ui.filteredItems.removeAll()
			//this.ui.filteredItems = new ArrayCollection(this.model.board.people ); 
		 	for each ( var xo :  Object in this.model.board.people  ) 
			{
				this.ui.filteredItems.addItem( xo ) ; 
			} 
			
			trace( 'legnth ' + 	this.ui.filteredItems.length ); 
			this.ui.filteredItems.filterFunction = this.ui.filter
			trace( 'legnth ' + 	this.ui.filteredItems.length ); 
			this.ui.txtSearch_changeHandler()
			trace( 'legnth ' + 	this.ui.filteredItems.length ); 	
			/*
			this.ui.list1.dataProvider = this.ui.allPeople
				*/
			this.ui.list1.dataProvider = this.ui.filteredItems			
			this.ui.lblHeader.label = 'Company Roster ' + '('+this.ui.allPeople.length+')'
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