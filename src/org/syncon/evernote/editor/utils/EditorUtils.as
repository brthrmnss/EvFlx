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
			return clear 
		}
	}
}