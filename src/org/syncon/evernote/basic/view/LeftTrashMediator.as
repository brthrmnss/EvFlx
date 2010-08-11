package org.syncon.evernote.basic.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.controller.EvernoteAPICommandTriggerEvent;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.popups.controller.ShowPopupEvent;
	import org.syncon.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.syncon.popups.controller.default_commands.ShowConfirmDialogTriggerEvent;
	
	public class LeftTrashMediator extends Mediator
	{
		[Inject] public var ui:left_trash;
		[Inject] public var model : EvernoteAPIModel;
			
		public function LeftTrashMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 ui.addEventListener(left_trash.EMPTY_TRASH, this.onEmptyTrashHandler ) ;
		}
		
		 
		private function onEmptyTrashHandler(e:CustomEvent) : void
		{
				title = 'Function Not Supported'
				msg = "We don't enable the \"expunge\" permission by default so you don't accidentally cause permanent user data loss from an application that doesn't need that."
				msg = 'To prevent unintended data loss, we do not currently support the expunge function. ' +
					'Notes in the trash do not affect your account limit. If you wish ' +
					'to delete these notes please use the web or desktop client versions'
				var eventMsg: ShowAlertMessageTriggerEvent = 
				new ShowAlertMessageTriggerEvent(
					ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP,
					msg,  title)  	
				this.dispatch( eventMsg )
				return
				var event :  ShowConfirmDialogTriggerEvent
				ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP
				
				var title : String = 'Permanently delete all messages in the trash?'; 
				var msg : String = 'This operation cannot be undone.' 
				event = new ShowConfirmDialogTriggerEvent( 
					ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, msg, 
					this.onEmptyTrashConfirmed, null, title, 'OK', 'Cancel' ) 
				this.dispatch( event  )  			
		}
			private function onEmptyTrashConfirmed()  : void
			{
				var event : EvernoteAPICommandTriggerEvent = 
					EvernoteAPICommandTriggerEvent.ExpungeInactiveNotes( 
						this.expungeInactiveNotesResult, this.expungeInactiveNotesFault )  
				this.dispatch( event ) 
					
				 event  = 
					EvernoteAPICommandTriggerEvent.ExpungeNote( this.model.notes[10].guid )  
				this.dispatch( event ) 					
			}				
				private function expungeInactiveNotesResult(e:Object)  : void
				{
					 trace('status: notes removed' ) 
				}		
				private function expungeInactiveNotesFault(e:Object)  : void
				{
					var event : ShowAlertMessageTriggerEvent = 
						new ShowAlertMessageTriggerEvent( ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP,
							'Could not delete notes' )  
					this.dispatch( event ) 
				}					
 
		
	}
}