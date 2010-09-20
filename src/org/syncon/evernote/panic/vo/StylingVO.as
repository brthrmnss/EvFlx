package  org.syncon.evernote.basic.vo
{
	import org.syncon.evernote.model.Tag2;

	public class StylingVO  
	{
		 public var font :  String = ''; 
		 public var color :  String = ''; 
		 public var alignment :  String = ''; 
		 public var fontWeight : String = ''; 
		 public var fontSize :  int = -1; // = ''; 
		 
		 public function clone()  : StylingVO
		 {
			 var s :  StylingVO = new StylingVO()
			s.font = this.font; 
			s.color = this.color; 
			s.alignment = this.alignment
			s.fontSize = this.fontSize
			 return s
		 }
	}
}