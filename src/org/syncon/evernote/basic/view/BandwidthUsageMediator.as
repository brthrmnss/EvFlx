package org.syncon.evernote.basic.view
{
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.EvernoteAPIModel;
	import org.syncon.evernote.basic.model.EvernoteAPIModelEvent;
	
	public class BandwidthUsageMediator extends Mediator
	{
		[Inject] public var ui:bandwidth_usage;
		[Inject] public var model : EvernoteAPIModel;
		
		public function BandwidthUsageMediator()
		{
		} 
		
		override public function onRegister():void
		{
			 eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.USER_CHANGED,
				this.onUserChanged);	
			 eventMap.mapListener(eventDispatcher, EvernoteAPIModelEvent.SYNC_STATE_CHANGED,
				 this.onSyncStateChanged);				 
		}
		
		
		
		private function onUserChanged(e:EvernoteAPIModelEvent): void
		{
	 		this.updateUsage()
		}		
	 
		
		
		private function onSyncStateChanged(e:EvernoteAPIModelEvent): void
		{
			this.updateUsage(); 	
		}		
		
		
		public function updateUsage()  : void
		{
			if ( this.model.acctSyncState == null || this.model.user == null ) 
				return; 
			var percentage : Number = this.model.acctSyncState.uploaded / this.model.user.accounting.uploadLimit
			if ( isNaN( percentage ) ) 
				return; 
			this.ui.usageBar.width = Math.max( percentage * this.ui.progressBar.width, 2 ) 
			this.ui.usageBar.toolTip = (this.model.acctSyncState.uploaded/1000).toFixed(0) + ' KB out of ' +
					(this.model.user.accounting.uploadLimit/1000000).toFixed(0) + ' MBs ' 
			this.ui.toolTip = this.ui.progressBar.toolTip = this.ui.usageBar.toolTip
		}
				
	 	
  
	}
}