package org.syncon.evernote.basic.view
{
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	import org.syncon.utils.Js;
	
	public class TopLinksMediator extends Mediator
	{
		[Inject] public var ui:top_links;
		[Inject] public var model : EvernoteAPIModel;
			
		public function TopLinksMediator()
		{
		} 
		
		override public function onRegister():void
		{
			ui.addEventListener( top_links.TRUNK, onTrunkClickedHandler ) 
			ui.addEventListener( top_links.SETTINGS, onSettingClickedHandler ) 			
			ui.addEventListener( top_links.SIGNOUT, onSignoutClickedHandler ) 		
			ui.addEventListener( top_links.HELP, onHelpClickedHandler ) 						
			/*
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.NOTEBOOK_RESULT, this.onNotebookResult);
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SEARCH_RESULT, this.onSearchChanged);			
			ui.list.notes = this.model.notes; 
			*/
			eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.AUTHENTICATED, 
				this.onAuthenticated);			
		}
		 
		private function onTrunkClickedHandler(e:CustomEvent): void
		{
			var link : String = 'http://www.evernote.com/about/trunk/?lang=en'
			Js.goToUrl(link)				
		}
		
		private function onSettingClickedHandler(e:CustomEvent): void
		{
			var link : String = 'https://www.evernote.com/User.action'
			Js.goToUrl(link)				
		}
		
		private function onSignoutClickedHandler(e:CustomEvent): void
		{
			this.model.logOut();
		}
		
		private function onHelpClickedHandler(e:CustomEvent): void
		{
			var link : String = 'http://www.evernote.com/about/contact/support/'
			Js.goToUrl(link)
		}		
		
 
		
		private function onAuthenticated(e:EvernoteAPIModelEvent) : void
		{
			0x696969
			var username  : String = this.model.preferences.username
			this.ui.options.menuOption(2).name = 'Sign out ' + this.model.preferences.username;
			if (  username == '' || username == null  ) 
				this.ui.options.menuOption(2).name = 'Sign In'
			this.ui.update(); 
		}		
	}
}