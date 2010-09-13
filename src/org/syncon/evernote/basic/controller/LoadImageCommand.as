package  org.syncon.evernote.basic.controller
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;

	/**
	 * */
	public class LoadImageCommand extends Command
	{
		//[Inject] public var apiModel:EvernoteAPIModel;
		[Inject] public var event:LoadImageCommandTriggerEvent;
		 public var txt :  String = '' 
		override public function execute():void
		{
		 	var ee :   EvernoteAPICommandTriggerEvent
			this.dispatch( 
				EvernoteAPICommandTriggerEvent.GetResource( event.resoureGuid, true, false, true, true,
					this.onResourceLoaded, this.onResourceLoaded_Fault)
			)
				
			this.dispatch( 
				EvernoteAPICommandTriggerEvent.GetResourceData( event.resoureGuid,  
					this.onResourceLoaded2, onResourceLoaded_Fault2 )
			)	
				var b : ByteArray = new ByteArray()
					b.writeObject( event.resoureGuid ) 
			this.dispatch( 
				EvernoteAPICommandTriggerEvent.GetResourceByHash( event.guidNote, 
				 b,  
					null, false, false, this.onResourceLoaded2, onResourceLoaded_Fault2 )
			)						
				
		}
		
		private function onResourceLoaded (e:  Object):void
		{
			trace();
		}
		
		private function onResourceLoaded2 (e:Object):void
		{
			trace();
		}
				
		private function onResourceLoaded_Fault (e:  Object):void
		{
			trace();
		}
		
		private function onResourceLoaded_Fault2 (e:Object):void
		{
			trace();
		}
		 
	}
}