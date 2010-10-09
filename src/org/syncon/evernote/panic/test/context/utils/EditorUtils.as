package org.syncon.evernote.editor.utils
{
	public class EditorUtils
	{
		public function EditorUtils()
		{
		}
		static public var blankNoteContent: String = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><br/></en-note>'
			
		static public function linkBreakTLF()  : String
		{
			var imp  : String = '' ; 
			for(var i:int=0;i<200;i++){ 
				imp += 'aaaa';
			}
			/*
			bug .... won't work until you type a wrapping text
			*/
			var clear : String  = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><p><span style="color: #003399;">'+imp+'vbdfbdfb</span></p><p><span style="color: #00ff00;">dfgdfgdfgdfg</span></p><p><span style="color: #003399;">fgdfg</span></p><p><span style="color: #cc0000;">dfgdfgfggdf</span></p><p><span style="color: #cc0000;"><en-todo/>wt<br clear="none"/></span></p></en-note>'
			
			clear = '<TextFlow columnCount="inherit" columnGap="inherit" columnWidth="inherit" lineBreak="inherit" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" paddingTop="inherit" verticalAlign="inherit" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008"><p><span> '+imp+'</span><img id="e43ff460e7645dc9748bd936d3389763"/><span></span></p></TextFlow>'
				
			return clear 
		}
	}
}