package org.syncon.evernote.panic.vo
{
	public class PersonVO  
	{
		public var name :  String = ''
		public var desc :  String = ''
		public var email :  String = ''; 		
		public var twitter : String = ''; 
		public var src :  String = ''; 
		
		public function PersonVO( name_ : String='', desc : String = '', 
								  email : String='', twitter : String = '' , src : String = ''  ) 
								 
		{
			this.name = name_
			//this.desc = desc
			/*this.email = email
			this.twitter = twitter
			this.col3 = col3*/

		//	this.img = 	'GIF'+'/'+items[index]
			this.src = src;  
			super();
		}
		
		static public function importPeople(arr: Array)  :  Array
		{
			var  people :  Array = []; 
			for each ( var name : String in arr ) 
			{
				var p : PersonVO = new PersonVO()
				p.name = name ; 
				people.push( p ) 
			}
			return people; 
		}
		
		static public function getRandomPic()  : String 
		{
			var items : Array = [
				"A01 copy.gif","A02 copy.gif","A03 copy.gif","A04 copy.gif","A05 copy.gif","B01 copy.gif","B02 copy.gif","B03 copy.gif","B04 copy.gif","B05 copy.gif","C01 copy.gif","C02 copy.gif","C03 copy.gif","C04 copy.gif","C05 copy.gif","D01 copy.gif","D02 copy.gif","D03 copy.gif","D04 copy.gif","D05 copy.gif","E01 copy.gif","E02 copy.gif","E03 copy.gif","E04 copy.gif","E05 copy.gif","F01 copy.gif","F02 copy.gif","F03 copy.gif","F04 copy.gif","F05 copy.gif","FA01 copy.gif","FA02 copy.gif","FA03 copy.gif","FA04 copy.gif","FA05 copy.gif","FB01 copy.gif","FB02 copy.gif","FB03 copy.gif","FB04 copy.gif","FB05 copy.gif","FC01 copy.gif","FC02 copy.gif","FC03 copy.gif","FC04 copy.gif","FC05 copy.gif","FD01 copy.gif","FD02 copy.gif","FD03 copy.gif","FD04 copy.gif","FD05 copy.gif","FE01 copy.gif","FE02 copy.gif","FE03 copy.gif","FE04 copy.gif","FE05 copy.gif","FG01 copy.gif","FG02 copy.gif","FG03 copy.gif","FG04 copy.gif","FG05 copy.gif","FH01 copy.gif","FH02 copy.gif","FH03 copy.gif","FH04 copy.gif","FH05 copy.gif","FI01 copy.gif","FI02 copy.gif","FI03 copy.gif","FI04 copy.gif","FI05 copy.gif","G01 copy.gif","G02 copy.gif","G03 copy.gif","G04 copy.gif","G05 copy.gif","H01 copy.gif","H02 copy.gif","H03 copy.gif","H04 copy.gif","H05 copy.gif","I01 copy.gif","I02 copy.gif","I03 copy.gif","I04 copy.gif","I05 copy.gif","J01 copy.gif","J02 copy.gif","J03 copy.gif","J04 copy.gif","J05 copy.gif","K01 copy.gif","K02 copy.gif","K03 copy.gif","K04 copy.gif","K05 copy.gif","L01 copy.gif","L02 copy.gif","L03 copy.gif","L04 copy.gif","L05 copy.gif","M01 copy.gif","M02 copy.gif","M03 copy.gif","M04 copy.gif","M05 copy.gif","N01 copy.gif","N02 copy.gif","N03 copy.gif","N04 copy.gif","N05 copy.gif","O01 copy.gif","O02 copy.gif","O03 copy.gif","O04 copy.gif","O05 copy.gif",
			]
			var index : int = 0 
			index = Math.round( Math.random()*items.length)
			if ( index == items.length ) 
				index -= 1
			
			return 'GIF'+'/'+items[index].toString()
		}
		
		public function export() : Object
		{
			return this; 
		}
		

		public function importX( x : Object)  : void
		{
			//return x;
		}			
		
		
 
	}
}