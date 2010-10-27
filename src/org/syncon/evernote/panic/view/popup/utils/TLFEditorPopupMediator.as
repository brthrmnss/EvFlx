package  org.syncon.evernote.panic.view.popup.utils
{
	import flash.events.Event;
	
	import flashx.textLayout.elements.TextFlow;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.AlertEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.HtmlConvertor;
	
	public class TLFEditorPopupMediator extends Mediator
	{
		[Inject] public var ui :TLFEditorPopup
		
		[Inject] public var model : PanicModel;		
		
		private var initialTLF :   String;
		private var fxChangedTLF : Function; 
		private var fxAcceptTLF : Function
		public function TLFEditorPopupMediator()
		{
		} 
		
		 override public function onRegister():void
		{
			 this.ui.addEventListener( 'openPopup', this.onOpenedPopup ) 
			 this.ui.addEventListener( 'openPopup6', this.onOpenedPopup6 ) 
			 this.ui.addEventListener( TLFEditorPopup.ACCEPT_FLOW, this.onAcceptFlow ) 
			 this.ui.addEventListener( TLFEditorPopup.REJECT_FLOW, this.onRejectFlow ) 
			 this.ui.addEventListener( TLFEditorPopup.CHANGED_FLOW, this.onChangedFlow ) 
			 eventMap.mapListener(eventDispatcher, PanicModelEvent.CHANGED_SKIN, 
				 this.onSkinChanged );						
			 this.onSkinChanged(null)					 
		 }
		 
		 public function onSkinChanged(e:PanicModelEvent): void
		 {
			 //change bg color And that text color for that message
			// this.ui.edit.setStyle('contentBackgroundColor', this.model.backgroundColor ) 
			 //this.ui.txtInstructions.setStyle( 'color', this.model.color ); 
			this.ui.color.color = this.model.backgroundColor 
		 }			
		 /**
		 * trying to siplify the work flow ... i stoo complex 
		 * */
		 public function onOpenedPopup6(e:CustomEvent):void
		 {
			 var valid : Boolean  = true
			
				 //eventually remove this and handle sourcing proplery 
				var markup : String = this.ui.initialMarkup; 
			 if (markup.length > 2 &&  markup.charAt(0) == '[' && markup.charAt(markup.length-1) == ']' )
			 {
				 var set2 : Array = [markup.charAt(1), markup.charAt(markup.length-2)]
				 if ( set2[0]== '\'' ||  set2[0]=='"' )
				 {
					 if ( set2[1]== '\'' ||  set2[1]=='"' )
					 {
						 this.dispatch( AlertEvent.Alert( 
							 'Cannot edit multiple sources, modify each source separately', 'Alert' ) )
						 return 
					 }
				 }

			 }
			 
			 var ee :   HtmlConvertor = new HtmlConvertor()
			 this.ui.initialTLF =  ee.convertTLF( markup,  0xFFFFFF, this.ui.fontSize )
			 fxChangedTLF = this.ui.fxChangedTLF
			 fxAcceptTLF = this.ui.fxAcceptTLF
			if ( valid )  
			 this.ui.popupCode.open( false,  false )
			else
				return; 
			
			this.ui.edit.textFlow = this.ui.initialTLF
		 }		 
		 
		 public function onOpenedPopup(e:CustomEvent):void
		 {
			 initialTLF = null;//this.ui.edit.textFlowMarkup
			 fxChangedTLF = this.ui.fxChangedTLF
			fxAcceptTLF = this.ui.fxAcceptTLF
		 }
		 public function onClosedPopup(e:CustomEvent):void
		 {
			 
		 }		 
		 
		 public function onAcceptFlow(e:CustomEvent):void
		 {
			 this.fxChangedTLF( e.data ) 
			 this.fxAcceptTLF( e.data ) 
			 this.ui.hide();
		 }
		 /**
		 * Send changes back 
		 * */
		 public function onRejectFlow(e:CustomEvent):void
		 {
			 this.fxChangedTLF( this.initialTLF ) 
				this.ui.hide();
		 }
		 
		 public function onChangedFlow(e:CustomEvent):void
		 {
			 if ( initialTLF == null ) 
				 initialTLF =  this.ui.edit.textFlowMarkup 
			 this.fxChangedTLF( e.data ) 
		 }
		 
		 
		

		
		
	}
}