package  org.syncon.evernote.panic.view.popup.editors
{
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.view.MessageWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	import org.syncon.popups.controller.ShowPopupEvent;
	
	public class MessageWidgetEditorPopupMediator extends 
		WidgetEditorPopupMediatorBase
	{
		[Inject] public function set ui  ( i : MessageWidgetEditorPopup) : void 
		{	this.editor = i  }
		public function get ui () : MessageWidgetEditorPopup
		{ return this.editor as MessageWidgetEditorPopup;  }
		
		public function MessageWidgetEditorPopupMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			mediatorMap.createMediator(this.ui.widget);
			this.ui.widget.removeElement( this.ui.widget.editBorder );
			this.ui.addEventListener( MessageWidgetEditorPopup.EDIT_FORE, this.onEditTLF ) 			
		}
		
		override public function onImportEditConfig(e:WidgetEvent) : void
		{
			super.onImportEditConfig( e ) 
			
			this.ui.timer.dataX = this.data ; 
			this.ui.txtMessage.text = this.data.source; 		
			this.ui.txtHeight.text = this.data.height.toString();
			if ( isNaN( this.data.height ) ) 
				this.ui.txtHeight.text = '' 
			this.onImportIntoPreviewWidget()
		}	
		
			private function onImportIntoPreviewWidget () : void
			{
				var d : WidgetVO = this.currentConfig() 
				d.editing = true; 
				this.ui.widget.height = this.data.ui.height; 
				this.ui.widget.width = 
					this.ui.widget.lblMessage3.width = this.ui.widget.lblMessage4.width = 
					this.ui.widget.ticker.width = 
					this.data.ui.width;
				this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) ) 
			}
		
		/**
		 * Read settings for text value
		 * */
		override public function currentConfig()  :   WidgetVO
		{ 
			var height : Number = Number( this.ui.txtHeight.text )  
			if ( this.ui.txtHeight.text == null || this.ui.txtHeight.text == '' ) 
				height = NaN
			var d : WidgetVO = MessageWidget.importData( this.data.name, 
				this.data.description, 
				this.ui.txtMessage.text, this.ui.timer.time, height).widgetData;	
			return d; 
		}
		
		
		private function onEditTLF(e:CustomEvent):void
		{
			this.dispatch( new ShowPopupEvent(ShowPopupEvent.SHOW_POPUP,
				'TLFEditorPopup',
				[this.ui,    e.data.toString(), 
					fxAdjust2, fxAccept2 , 'Edit the text', 34 ] , 'open6'
			)  )  			
		}
			//this.ui.txtMessageBg.text = this.data.background; 
			public function fxAdjust2(e:String):void
			{
				var d : WidgetVO = this.currentConfig() 
				d.source = e; 
				d.editing = true; 
				this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.IMPORT_CONFIG, null, d ) )
				this.ui.widget.dispatchEvent( new WidgetEvent( WidgetEvent.AUTOMATE_WIDGET, null, d ) )
				
			}
			public function fxAccept2(e: String):void
			{
				//don't set this value, this imples you will keep it ...
				//this.data.source = e
				this.ui.txtMessage.text = e;//this.data.source; 		
				//if user presses cancel, you must return to the original, hence y we don't change it like this 
				this.ui.changed(null)
			}				
		
		
	}
}