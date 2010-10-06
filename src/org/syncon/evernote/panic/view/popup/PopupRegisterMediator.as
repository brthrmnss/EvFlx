package   org.syncon.evernote.panic.view.popup
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.panic.controller.AuthenticateToBoardCommandTriggerEvent;
	import org.syncon.evernote.services.EvernoteService;
	
	public class PopupRegisterMediator extends Mediator
	{
		[Inject] public var ui: PopupRegister;
		[Inject] public var model : EvernoteAPIModel;
		[Inject] public var service :  EvernoteService;
		
		public function PopupRegisterMediator()
		{
		} 
		
		override public function onRegister():void
		{
		}
	 
		
	}
}