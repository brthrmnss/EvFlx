package  org.syncon.evernote.basic.vo
{
	import org.syncon.evernote.model.Tag2;

	public class QuickTasksVO  
	{
		public var tag : Tag2;
		public var task_name : String = ''; 
		public var renameTo : String 
		public var changeParentTo : String
		public var guid : int = 0; 
		public var step : int = -1
		public var cmd : String = ''; 
	
		public var changeParentTo_Name : String ; 
 
	}
}