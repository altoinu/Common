/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents
{
	
	import com.altoinu.flash.customcomponents.events.AutoScrollTextTickerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when texts in the ticker change.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.events.AutoScrollTextTickerEvent.TEXT_CHANGE
	 */
	[Event(name="textChange", type="com.altoinu.flash.customcomponents.events.AutoScrollTextTickerEvent")]
	
	/**
	 * Scrolling text ticker (like the one you see on the bottom of the screen on CNN Headline News).
	 * 
	 * <p>Since AutoScrollTickerContainer uses mask to display contents in the specified scroll area, make
	 * sure font specified for <code>tickerTextFormat</code> is embedded.</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AutoScrollTextTicker extends AutoScrollTickerContainer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param texts Array of Strings to display in the news ticker.
		 * @param textFormat TextFormat used for each text field.  Make sure font is embedded, otherwise
		 * text will not display.
		 * @param frameRate
		 * 
		 */
		public function AutoScrollTextTicker(texts:Array = null, textFormat:TextFormat = null, frameRate:Number = 30)
		{
			
			super(frameRate);
			
			if (texts != null)
				this.texts = texts;
			
			if (textFormat != null)
				this.textFormat = textFormat;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var textFields:Array;
		private var logos:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  embedFonts
		//----------------------------------
		
		private var _embedFonts:Boolean = false;
		
		public function get embedFonts():Boolean
		{
			
			return _embedFonts;
			
		}
		
		/**
		 * @private
		 */
		public function set embedFonts(value:Boolean):void
		{
			
			_embedFonts = value;
			
		}
		
		//----------------------------------
		//  texts
		//----------------------------------
		
		private var _texts:Array = [];
		
		/**
		 * Array of Strings to display in the news ticker.
		 */
		public function get texts():Array
		{
			
			return _texts;
			
		}
		
		/**
		 * @private
		 */
		public function set texts(newTexts:Array):void
		{
			
			if (_texts != newTexts)
			{
				
				_texts = newTexts;
				
				updateView();
				
				dispatchEvent(new AutoScrollTextTickerEvent(AutoScrollTextTickerEvent.TEXT_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  textFieldPaddingLeft
		//----------------------------------
		
		private var _textFieldPaddingLeft:Number = 0;
		
		public function get textFieldPaddingLeft():Number
		{
			
			return _textFieldPaddingLeft;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingLeft(value:Number):void
		{
			
			if (_textFieldPaddingLeft != value)
			{
				
				_textFieldPaddingLeft = value;
				
				updateView();
				
			}
			
		}
		
		//----------------------------------
		//  textFieldPaddingRight
		//----------------------------------
		
		private var _textFieldPaddingRight:Number = 0;
		
		public function get textFieldPaddingRight():Number
		{
			
			return _textFieldPaddingRight;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingRight(value:Number):void
		{
			
			if (_textFieldPaddingRight != value)
			{
				
				_textFieldPaddingRight = value;
				
				updateView();
				
			}
			
		}
		
		//----------------------------------
		//  textFieldPaddingTop
		//----------------------------------
		
		private var _textFieldPaddingTop:Number = 0;
		
		public function get textFieldPaddingTop():Number
		{
			
			return _textFieldPaddingTop;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingTop(value:Number):void
		{
			
			if (_textFieldPaddingTop != value)
			{
				
				_textFieldPaddingTop = value;
				
				updateView();
				
			}
			
		}
		
		//----------------------------------
		//  textFieldPaddingBottom
		//----------------------------------
		
		private var _textFieldPaddingBottom:Number = 0;
		
		public function get textFieldPaddingBottom():Number
		{
			
			return _textFieldPaddingBottom;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingBottom(value:Number):void
		{
			
			if (_textFieldPaddingBottom != value)
			{
				
				_textFieldPaddingBottom = value;
				
				updateView();
				
			}
			
		}
		
		//----------------------------------
		//  textFormat
		//----------------------------------
		
		private var _textFormat:TextFormat = new TextFormat();
		
		/**
		 * TextFormat used for each text field.  Make sure font is embedded, otherwise text will not display.
		 */
		public function get textFormat():TextFormat
		{
			
			return _textFormat;
			
		}
		
		/**
		 * @private
		 */
		public function set textFormat(newFormat:TextFormat):void
		{
			
			if (_textFormat != newFormat)
			{
				
				_textFormat = newFormat;
				
				updateView();
				
				dispatchEvent(new AutoScrollTextTickerEvent(AutoScrollTextTickerEvent.TEXT_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  inBetweenLogo
		//----------------------------------
		
		[Deprecated(replacement="inBetweenLogos")]
		/**
		 * Sprite object automatically inserted in between texts.  The actual instance of Sprite referenced
		 * will not be inserted into the ticker, but its copies will be.
		 * 
		 */
		public function get inBetweenLogo():Sprite
		{
			
			if (inBetweenLogos.length > 0)
				return inBetweenLogos[0] as Sprite;
			else
				return null;
			
		}
		
		/**
		 * @private
		 */
		public function set inBetweenLogo(newLogo:Sprite):void
		{
			
			this.inBetweenLogos = [newLogo];
			
		}
		
		//----------------------------------
		//  inBetweenLogos
		//----------------------------------
		
		private var _inBetweenLogos:Array;
		
		/**
		 * Array of Sprite objects/URLs to images automatically inserted in between texts.  The actual
		 * instance of Sprite referenced will not be inserted into the ticker, but its copies will be.
		 * 
		 */
		public function get inBetweenLogos():Array
		{
			
			return _inBetweenLogos;
			
		}
		
		/**
		 * @private
		 */
		public function set inBetweenLogos(value:Array):void
		{
			
			if (_inBetweenLogos != value)
			{
				
				_inBetweenLogos = value;
				
				updateView();
				
				dispatchEvent(new AutoScrollTextTickerEvent(AutoScrollTextTickerEvent.TEXT_CHANGE, false, false));
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Updates view by removing existing text fields and logos, then creating new ones
		 * using Strings in <code>texts</code> Array, <code>textFormat</code>, and <code>inBetweenLogo</code>.
		 * 
		 * <p>This method is automatically called when any of these properties are updated; however,
		 * this may have to be called manually if properties of <code>textFormat</code> and
		 * <code>inBetweenLogos</code> are updated directly.</p>
		 * 
		 */
		public function updateView():void
		{
			
			if (textFields != null)
			{
				
				// First remove all text fields
				var numTextFields:int = textFields.length;
				for (var i:int = 0; i < numTextFields; i++)
				{
					
					removeChild(textFields[i]);
					
				}
				
			}
			
			if (logos != null)
			{
				
				// Remove all logos
				var numLogos:int = logos.length;
				for (var j:int = 0; j < numLogos; j++)
				{
					
					removeChild(logos[j]);
					
				}
				
			}
			
			// Create new text fields
			textFields = [];
			logos = [];
			
			var logoOriginal:Sprite;
			var inBetweenLogoClass:Class;
			var currentLogoIndex:int = 0;
			var newLogoInstance:DisplayObject;
			var newTextField:TextField;
			var numTexts:int = texts.length;
			for (var textIndex:int = 0; textIndex < numTexts; textIndex++)
			{
				
				if ((inBetweenLogos != null) && (inBetweenLogos.length > 0) &&
					((inBetweenLogos[currentLogoIndex] is Sprite) || (inBetweenLogos[currentLogoIndex] is String)))
				{
					
					if (inBetweenLogos[currentLogoIndex] is Sprite)
					{
						
						// Copy of this Sprite will be inserted before next text
						logoOriginal = inBetweenLogos[currentLogoIndex] as Sprite;
						inBetweenLogoClass = getDefinitionByName(getQualifiedClassName(logoOriginal)) as Class;
						
						newLogoInstance = new inBetweenLogoClass();
						newLogoInstance.transform.matrix = logoOriginal.transform.matrix;
						
					}
					else if (inBetweenLogos[currentLogoIndex] is String)
					{
						
						// If String, then assume it is URL of an image to be inserted before next text
						// Load it
						var logoLoader:Loader = new Loader();
						var onLogoLoad:Function = function(event:Event):void
						{
							
							var contentInfo:LoaderInfo = event.currentTarget as LoaderInfo;
							contentInfo.removeEventListener(Event.COMPLETE, arguments.callee);
							contentInfo.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
							
							if (event.type == Event.COMPLETE)
							{
								
								setChildDimensions(contentInfo.loader); // Set its dimensions
								orderChildItems(); // and reorder
								
							}
							
						};
						logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLogoLoad);
						logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLogoLoad);
						
						var logoURLReq:URLRequest = new URLRequest(inBetweenLogos[currentLogoIndex] as String);
						logoLoader.load(logoURLReq);
						newLogoInstance = logoLoader;
						
					}
					else
					{
						
						// Unrecognized type (should not reach here, though)
						logoOriginal = null;
						inBetweenLogoClass = null;
						
					}
					
					// Insert a logo Sprite before next text
					addChild(newLogoInstance);
					logos.push(newLogoInstance); // Remember it
					
					// Remember next index number of logo to be used
					currentLogoIndex++;
					if (inBetweenLogos.length <= currentLogoIndex)
						currentLogoIndex = 0;
					
				}
				else
				{
					
					// No logo to be inserted
					logoOriginal = null;
					inBetweenLogoClass = null;
					
				}
				
				// Next text field
				newTextField = new TextField();
				newTextField.selectable = false;
				newTextField.multiline = false;
				newTextField.embedFonts = _embedFonts;
				newTextField.defaultTextFormat = textFormat;
				
				newTextField.htmlText = texts[textIndex] ? texts[textIndex] : "";
				newTextField.width = newTextField.textWidth + 4;
				newTextField.height = newTextField.textHeight + 4;
				
				var newTextFieldContainer:Sprite = new Sprite();
				var containerTotalWidth:Number = newTextField.width + textFieldPaddingLeft + textFieldPaddingRight;
				var containerTotalHeight:Number = newTextField.height + textFieldPaddingTop + textFieldPaddingBottom;
				var tfContainerG:Graphics = newTextFieldContainer.graphics;
				
				tfContainerG.moveTo(0, 0);
				tfContainerG.beginFill(0xFF0000, 0);
				tfContainerG.drawRect(0, 0, containerTotalWidth, containerTotalHeight);
				tfContainerG.endFill();
				
				newTextField.x = containerTotalWidth / 2 - newTextField.width / 2;
				newTextField.y = containerTotalHeight / 2 - newTextField.height / 2;
				
				newTextFieldContainer.addChild(newTextField);
				addChild(newTextFieldContainer);
				textFields.push(newTextFieldContainer); // Remember it
				
			}
			
			resetPosition();
			
		}
		
	}
	
}