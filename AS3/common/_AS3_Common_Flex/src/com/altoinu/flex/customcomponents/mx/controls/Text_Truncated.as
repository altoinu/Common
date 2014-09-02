/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls
{
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	
	import mx.controls.Text;
	
	/**
	 * By default, Flex Text control does not truncate text like Label control does.  Use this class instead of normal Text
	 * to have the text truncated with "..." at the end.
	 *  
	 * @author kaoru.kawashima
	 * 
	 */	
	public class Text_Truncated extends Text
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		public static function isWholeWordDelimiter(character:String):Boolean
		{
			
			if (character.length != 1)
				return false;
			
			if ((character == " ") ||
				(character == "\n") ||
				(character == String.fromCharCode(10)) ||
				(character == String.fromCharCode(13)) ||
				(character == "\r") ||
				(character == "\t"))
				return true;
			
			return false;			
		}

		public static function isLineDelimiter(character:String):Boolean
		{
			
			if (character.length != 1)
				return false;
			
			if ((character == "\n") ||
				(character == String.fromCharCode(10)) ||
				(character == String.fromCharCode(13)))
				return true;
			
			return false;			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function Text_Truncated()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * If true, then do not truncate in the middle of a word. 
		 */		
		private var _keepWholeWords:Boolean = true;
		
		private var _keepWholeLines:Boolean = false;
		
		/**
		 * Minimum text height to display all texts. 
		 */		
		private var _minTextHeight:Number = 0;
		
		private var _truncated:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Truncated text shown in the textfield.
		 */		
		protected var _text_Truncated:String = "";
		
		/**
		 * @private
		 * Text dropped from truncated textfield.
		 */
		protected var _droppedText:String = "";
		
		/**
		 * @private
		 */
		protected var dontdispatchpropertyChangeEventInupdateDisplayList:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Don't use this property.  Text_Truncate cannot handle htmlText because it checks each character by character
		 * to see when text needs to be truncated.
		 */
		override public function get htmlText():String
		{
			
			return super.htmlText;
			
		}
		
		/**
		 * @private
		 */
		override public function set htmlText(value:String):void
		{
			
			throw new Error("htmlText propery for Text_Truncated is currently not supported.  Sorry...");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable]
		/**
		 * Text to be added at the end of truncated text.  Default is "..." so the truncated text would appear as
		 * "Long text line...". 
		 */		
		public var ellipsis:String = "...";
		
		[Bindable(event="propertyChange")]
		[Inspectable(category="Other", enumeration="true,false", defaultValue="true")]
		/**
		 * If true, then do not truncate in the middle of a word. 
		 */
		public function get keepWholeWords():Boolean
		{
			
			return _keepWholeWords;
			
		}
		
		/**
		 * @private
		 */
		public function set keepWholeWords(value:Boolean):void
		{
			
			_keepWholeWords = value;
			
			if (initialized)
			{
				
				// Any better way to trigger view update???
				var originalText:String = text;
				text = "";
				text = originalText;
				
			}
			
			dispatchEvent(new Event("propertyChange"));
			
		}
		
		[Bindable(event="propertyChange")]
		[Inspectable(category="Other", enumeration="true,false", defaultValue="true")]
		/**
		 * If true, then do not truncate in the middle of a line. 
		 */
		public function get keepWholeLines():Boolean
		{
			
			return _keepWholeLines;
			
		}
		
		/**
		 * @private
		 */
		public function set keepWholeLines(value:Boolean):void
		{
			
			_keepWholeLines = value;
			
			if (initialized)
			{
				
				// Any better way to trigger view update???
				var originalText:String = text;
				text = "";
				text = originalText;
				
			}
			
			dispatchEvent(new Event("propertyChange"));
			
		}
		
		[Bindable(event="propertyChange")]
		/**
		 * Truncated text shown in the textfield.
		 */	
		public function get text_Truncated():String
		{
			
			return _text_Truncated;
			
			/*
			if (_truncated)
				return textField.text.substring(0, textField.text.length - (ellipsis.length > 0 ? ellipsis.length + 1 : 0));
			else
				return textField.text;
			*/
			
		}
		
		[Bindable(event="propertyChange")]
		/**
		 * String dropped from textfield when truncated.  if this is empty string "", then it means 
		 * Text_Truncated did not truncate text.
		 */
		public function get droppedText():String
		{
			
			return _droppedText;
			
		}
		
		[Bindable(event="propertyChange")]
		/**
		 * Minimum text height to display all text.
		 * @return
		 * 
		 */	
		public function get minTextHeight():Number
		{
			
			return _minTextHeight;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Deprecated properties
		//
		//--------------------------------------------------------------------------
		
		[Deprecated(replacement="ellipsis")]
		/**
		 * Text to be added at the end of truncated text.  Default is "..." so the truncated text would appear as
		 * "Long text line...". 
		 */		
		public function get truncatedReplacementText():String
		{
			
			return ellipsis;
			
		}
		
		[Deprecated(replacement="ellipsis")]
		/**
		 * @private
		 */
		public function set truncatedReplacementText(value:String):void
		{
			
			ellipsis = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Updates view and truncates text.
		 *  
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			const TEXT_HEIGHT_PADDING:int = 2;
			
			// First, assign the full text to text field
			_text_Truncated = text;
			_droppedText = "";
			
			_minTextHeight = textField.textHeight;
			_truncated = false;
			
			/*
			if (textField.text != text)
				textField.text = text;
			*/
			
			if ((width <= 0) || (height <= 0))
			{
				
				_truncated = true;
				_text_Truncated = "";
				_droppedText = text;
				
			}
			else if (textField.maxScrollV > 1)
			{
				
				// There is too much text to be fit
				
				//var fullText:String = text;
				var fullText:String = textField.text;
				
				// Check from character 1 to see how much will fit
				var fullTextLength:int = textField.length;
				var currentTextY:Number = 0;
				var _traceON:Boolean = false;
				
				for (var i:int = 0; i < fullTextLength; i++)
				{
					
					// Temporarily insert part of the text plus ellipsis
					var ellipsis_withspace:String = (ellipsis.length > 0 ? " " + ellipsis : "");
					textField.text = fullText.substring(0, i + 1) + ellipsis_withspace;
					if (i + 1 < fullText.length - 1)
					{
						
						_droppedText = fullText.substring(i + 1);
						_truncated = true;
						
					}
					else
					{
						
						_droppedText = "";
						_truncated = false;
						
					}
					
					// Check where the last character is now (after adding ellipsis if necessary)
					var currentTextLength:int = (i + 1) + ellipsis_withspace.length;
					var currentCharBoundaries:Rectangle = textField.getCharBoundaries(currentTextLength - 1);
					
					if (currentCharBoundaries != null)
					{
						
						// Is last character within the displayable area of the textfield?
						
						var nextCharLineIndex:int = textField.getLineIndexOfChar(currentTextLength - 1);
						var nextCharLineMetrics:TextLineMetrics = textField.getLineMetrics(nextCharLineIndex);
						
						var previousTextY:Number = currentTextY;
						currentTextY = Math.ceil(currentCharBoundaries.y + currentCharBoundaries.height + (nextCharLineMetrics.leading + 2));
						
						if (textField.height <= currentTextY)
						{
							
							// No...
							
							// Let's keep just the characters (0 - i-1) that appear inside
							do
							{
								
								_text_Truncated = fullText.substring(0, i);
								i--;
								
							}
							while ((i > 0) &&
								((_keepWholeWords && !isWholeWordDelimiter(fullText.charAt(i + 1))) || 
								(_keepWholeLines && !isLineDelimiter(fullText.charAt(i + 1))))); // Loop until it is cut at whole word
							
							textField.text = _text_Truncated + ellipsis_withspace;
							_droppedText = fullText.substring(_text_Truncated.length);
							while(isWholeWordDelimiter(_droppedText.charAt(0)))
								_droppedText = _droppedText.substr(1);
							
							//trace("-------------------droppedText");
							//trace(_droppedText);	
							
							_truncated = true;
							
							// Give extra leading + 2 pixel gutter height so last line will fit.
							// Sometimes this is necessary to display the last line.
							var currentCharLineIndex:int = textField.getLineIndexOfChar(textField.text.length - 1);
							var currentCharLineMetrics:TextLineMetrics = textField.getLineMetrics(currentCharLineIndex);
							textField.height += (currentCharLineMetrics.leading + 2);
							
							break;
							
						}
						
					}
					
				}
				
			}
			
			if (!dontdispatchpropertyChangeEventInupdateDisplayList)
				dispatchEvent(new Event("propertyChange"));
			
		}
		
	}
	
}