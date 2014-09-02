/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	/**
	 * Utility function you can use on Strings.
	 */
	public class StringUtils
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Cleans HTML texts, and also adds event: in front of http link specified by &lt;a href=""&gt; tags
		 * so it works with TextEvent.
		 * 
		 * @param text_html
		 * @param removeExtraNewLineAndSpaces If set to false, then extra \n and spaces will not be removed.
		 * @return 
		 * 
		 */
		public static function cleanHTMLText(text_html:String, removeExtraNewLineAndSpaces:Boolean = true):String
		{
			
			var i:int = 0;
			
			if (removeExtraNewLineAndSpaces)
			{
				
				while (i < text_html.length)
				{
					
					if (text_html.charAt(i) == "\n")
					{
						// remove it and following spaces
						text_html = text_html.substring(0, i) + text_html.substring(i + 1);
						while (text_html.charAt(i) == " ") text_html = text_html.substring(0, i) + text_html.substring(i + 1);
						
					}
					else if ((i < text_html.length - 1) && (text_html.charAt(i) == " ") && (text_html.charAt(i + 1) == " "))
					{
						// Double space, remove one
						text_html = text_html.substring(0, i) + text_html.substring(i + 1);
						
					}
					else i++;
					
				}
				
			}
			
			// Look for <a href="">
			var currentSpot:int = 0; // check index
			while (text_html.indexOf("<a", currentSpot) != -1)
			{
				// Make sure this is the <a> tag
				var beginIndex:int = text_html.indexOf("<a", currentSpot);
				var endIndex:int = -1;
				for (var textPos:int = beginIndex + 2; textPos < text_html.length - 1; textPos++)
				{
					// Find ">" to make sure it is in fact <a> tag
					if (text_html.charAt(textPos) == ">")
					{
						// Is this a valid <a> tag?
						try
						{
							
							var testHTML:XML = new XML(text_html.substring(beginIndex, textPos + 1));
							endIndex = textPos + 1;
							break;
							
						}
						catch (error:Error)
						{
							// This is not a valid <a> tag.  Loop
							continue;
							
						}
						
					}
					
				}
				
				if (endIndex != -1)
				{
					// End index is set, which means that ">" has been found.
					var targetWebLink:String = text_html.substring(beginIndex, endIndex);
					var newTargetWebLink:String = "";
					for (var targetLinkPos:int = targetWebLink.indexOf("href") + 4; targetLinkPos < targetWebLink.length; targetLinkPos++)
					{
						// Add "event:" in front of web link
						if ((targetWebLink.charAt(targetLinkPos) == "'") || (targetWebLink.charAt(targetLinkPos) == '"'))
						{
							
							newTargetWebLink = targetWebLink.substring(0, targetLinkPos + 1) + "event:" + targetWebLink.substring(targetLinkPos + 1);
							break;
							
						}
						
					}
					
					// Replace the original link with this new one with "event:"
					text_html = text_html.substring(0, beginIndex) + newTargetWebLink + text_html.substring(endIndex);
					
					// Move the check index to the end of the link
					currentSpot = text_html.indexOf(newTargetWebLink) + newTargetWebLink.length;
					
				}
				else
				{
					// Code went through the for loop above without finding valid <a> tag.  Exit loop
					break;
					
				}
				
			}
			
			return text_html;
			
		}
		
		/**
		 * Strips HTML elements.
		 * @param value
		 * @return 
		 * 
		 */
		public static function stripHTML(value:String):String
		{
			
			return value.replace(/<.*?>/g, "");
			
		}
		
		/**
		 * Returns a string consisting of the number of words specified by wordCount starting from startIndex.
		 * If number of words available are less than specified wordCount, then the method would return
		 * all words from startIndex to String.length.
		 * 
		 * <p>If there are space characters at <code>startIndex</code>, all spaces will be ignored until the first
		 * character is found.</p>
		 * 
		 * @param textString
		 * @param startIndex
		 * @param wordCount
		 * @return 
		 * 
		 */
		public static function extractWords(textString:String, startIndex:uint = 0, wordCount:uint = 100):String
		{
			
			if ((textString == null) || (wordCount == 0))
				return "";
			
			// Convert to int.  uint was used to prevent negative numbers
			var startIndexInt:int = startIndex;
			var wordCountInt:int = wordCount;
			
			// Loop through characters to get words
			var extractedString:String = "";
			var currentWordCount:int = 0;
			var foundFirstWord:Boolean = false;
			var numChars:int = textString.length;
			for (var i:int = startIndexInt; i < numChars; i++)
			{
				
				var nextChar:String = textString.charAt(i);
				if (nextChar != " ")
				{
					
					// Found character, add it
					extractedString += nextChar;
					
					foundFirstWord = true;
					
					if ((i == startIndexInt) || (extractedString.charAt(i - 1) == " "))
						currentWordCount++; // Add word count since this is either first character or previous character was space
					
				}
				else
				{
					
					// Found space
					
					if (foundFirstWord)
					{
						
						// First word has already been found
						
						if (currentWordCount >= wordCountInt)
						{
							
							// already have enough words, end extraction
							break;
							
						}
						else
						{
							
							// More words needed
							
							//so add this space
							extractedString += nextChar;
							
						}
						
					}
					else
					{
						
						// Otherwise ignore all initial space until first characer
						
					}
					
				}
				
			}
			
			return extractedString;
			
		}
		
		/**
		 * Word count.
		 * @param textString
		 * @return 
		 * 
		 */
		public static function getWordCount(textString:String):int
		{
			
			if (textString == null)
				return 0;
			else
				return textString.match(/\b\w+\b/g).length;
			
		}
		
		/**
		 * Mixes up inputString.
		 * @param inputString
		 * @return 
		 * 
		 */
		public static function mixup(inputString:String):String
		{
			
			var mixedLetters:Array = ArrayUtils.shuffle(inputString.split(""));
			
			var mixedString:String = "";
			var numLetters:int = mixedLetters.length;
			for (var i:int = 0; i < numLetters; i++)
			{
				
				mixedString += mixedLetters[i];
				
			}
			
			return mixedString;
			
		}
		
		/**
		 * Converts following predefined characters to HTML entities:
		 * <ul>
		 * 	<li>&amp; (ampersand) becomes &amp;amp;</li>
		 * 	<li>&quot; (double quote) becomes &amp;quot;</li>
		 * 	<li>&#039; (single quote) becomes &amp;#039;</li>
		 * 	<li>&lt; (less than) becomes &amp;lt;</li>
		 * 	<li>&gt; (greater than) becomes &amp;gt;</li>
		 * </ul>
		 * 
		 * @param sourceString
		 * @return 
		 * 
		 */
		public static function replaceHTMLSpecialChars(sourceString:String):String
		{
			
			var amp:RegExp = /&/gi;
			sourceString = sourceString.replace(amp, "&amp;");
			
			var quot:RegExp = /["]/gi;
			sourceString = sourceString.replace(quot, "&quot;");
			
			var singlequot:RegExp = /[']/gi;
			sourceString = sourceString.replace(singlequot, "&#039;");
			
			var lt:RegExp = /</gi;
			sourceString = sourceString.replace(lt, "&lt;");
			
			var gt:RegExp = />/gi;
			sourceString = sourceString.replace(gt, "&gt;");
			
			return sourceString;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Constructor.  You do not create an instance of this class... just call its static functions
		 */
		public function StringUtils()
		{
			
			throw new Error("You do not create an instance of TextUtils.  Just call its static functions");
			
		}
		
	}
	
}