package  org.syncon.evernote.panic.view.popup.utils
{
	import flash.events.Event;
	
	import flashx.textLayout.elements.TextFlow;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	
	public class TLFEditorPopupMediator extends Mediator
	{
		[Inject] public var ui :TLFEditorPopup
		
		[Inject] public var model : PanicModel;		
		
		private var initialTLF :  TextFlow;
		private var fxChangedTLF : Function; 
		private var fxAcceptTLF : Function
		public function TLFEditorPopupMediator()
		{
		} 
		
		 override public function onRegister():void
		{
			 this.ui.addEventListener( 'openPopup', this.onOpenedPopup ) 
			 this.ui.addEventListener( TLFEditorPopup.ACCEPT_FLOW, this.onOpenedPopup ) 
			 this.ui.addEventListener( TLFEditorPopup.REJECT_FLOW, this.onOpenedPopup ) 
			 this.ui.addEventListener( TLFEditorPopup.CHANGED_FLOW, this.onOpenedPopup ) 
			 eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_SKIN, 
				 this.onSkinChanged );						
			 this.onSkinChanged(null)					 
		 }
		 
		 public function onSkinChanged(e:PanicModelEvent): void
		 {
			 //change bg color And that text color for that message
			 this.ui.edit.setStyle('contentBackgroundColor', this.model.backgroundColor ) 
			 //this.ui.txtInstructions.setStyle( 'color', this.model.color ); 
				this.ui.color.color = this.model.backgroundColor 
		 }			
		 public function onOpenedPopup(e:CustomEvent):void
		 {
			 initialTLF = this.ui.initialTLF; 
			 fxChangedTLF = this.ui.fxChangedTLF
			fxAcceptTLF = this.ui.fxAcceptTLF
		 }
		 public function onClosedPopup(e:CustomEvent):void
		 {
			 
		 }		 
		 
		 public function onAcceptFlow(e:CustomEvent):void
		 {
			 this.fxAcceptTLF( e.data ) 
		 }
		 /**
		 * Send changes back 
		 * */
		 public function onRejectFlow(e:CustomEvent):void
		 {
			 this.fxChangedTLF( this.initialTLF ) 
		 }
		 
		 public function onChangedFlow(e:CustomEvent):void
		 {
			 this.fxChangedTLF( e.data ) 
		 }
		 
		 
		

		
		
	}
}