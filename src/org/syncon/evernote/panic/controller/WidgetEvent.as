package   org.syncon.evernote.panic.controller
{
 
	public class WidgetEvent extends Event
	{
		 
		
		public function LoadImageCommandTriggerEvent(type:String, guidNote_ : String , 
													 resoureGuid_ : String, loadInto_ : Object, 
													 imgCount_ : int, r : Resource, image_ : Image=null )  
		{	
			this.guidNote = guidNote_
			this.resoureGuid = resoureGuid_
			this.loadInto = loadInto_
			this.imgCount = imgCount_
			this.resource = r				
			this.image = image_ 
			//this.debug = debug_
			super(type, true);
		}
		
		
	}
}