/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.containers
{
	
	import com.altoinu.flash.customcomponents.AutoScrollTextTicker;
	import com.altoinu.flash.customcomponents.events.AutoScrollTextTickerEvent;
	import com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
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
	 *  Dispatched every time contents scroll.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent.SCROLL
	 */
	[Event(name="scroll", type="com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent")]
	
	/**
	 *  Dispatched when contents start scrolling.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent.SCROLL_START
	 */
	[Event(name="scrollStart", type="com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent")]
	
	/**
	 *  Dispatched when contents stop scrolling.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent.SCROLL_STOP
	 */
	[Event(name="scrollStop", type="com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent")]
	
	/**
	 *  Dispatched scrolling velocity changes.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE
	 */
	[Event(name="scrollVelocityChange", type="com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent")]
	
	/**
	 *  Dispatched scrolling loops.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent.SCROLL_LOOP
	 */
	[Event(name="scrollLoop", type="com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[DefaultProperty("texts")] 
	
	/**
	 * Flex component version of AutoScrollTextTicker.
	 * 
	 * @example <listing version="3.0">
	 * &lt;AutoScrollTickerContainerFlex width=&quot;100%&quot; height=&quot;100%&quot;
	 * &#xA0;scrolling=&quot;true&quot;
	 * &#xA0;textFormat=&quot;{textFormatObj}&quot;
	 * &#xA0;inBetweenLogos=&quot;{logosArray}&quot;&gt;
	 * &#xA0;&lt;fx:String&gt;Hello world&lt;/fx:String&gt;
	 * &#xA0;&lt;fx:String&gt;How are you?&lt;/fx:String&gt;
	 * &#xA0;&lt;fx:String&gt;I like curry rice&lt;/fx:String&gt;
	 * &lt;/AutoScrollTickerContainerFlex&gt;
	 * </listing>
	 * 
	 * @author Kaoru Kawashima
	 * @see com.altoinu.flash.customcomponents.AutoScrollTextTicker
	 */
	public class AutoScrollTextTickerFlex extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function AutoScrollTextTickerFlex()
		{
			
			super();
			
			this.addEventListener(ResizeEvent.RESIZE, onComponentResize, false, 0, true);
			
			// Add ticker container to display list
			tickerContainer.scrollAreaWidth = 0;
			tickerContainer.scrollAreaHeight = 0;
			tickerContainer.addEventListener(AutoScrollTextTickerEvent.TEXT_CHANGE, onTextChange, false, 0, true);
			tickerContainer.addEventListener(AutoScrollTickerContainerEvent.SCROLL, onScroll, false, 0, true);
			tickerContainer.addEventListener(AutoScrollTickerContainerEvent.SCROLL_LOOP, onScrollLoop, false, 0, true);
			tickerContainer.addEventListener(AutoScrollTickerContainerEvent.SCROLL_START, onScrollStart, false, 0, true);
			tickerContainer.addEventListener(AutoScrollTickerContainerEvent.SCROLL_STOP, onScrollStop, false, 0, true);
			tickerContainer.addEventListener(AutoScrollTickerContainerEvent.SCROLL_VELOCITY_CHANGE, onScrollVelocityChange, false, 0, true);
			super.addChild(tickerContainer);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * AutoScrollTextTicker container instance that actually does the scrolling text.
		 */
		protected var tickerContainer:AutoScrollTextTicker = new AutoScrollTextTicker();
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  embedFonts
		//----------------------------------
		
		public function get embedFonts():Boolean
		{
			
			return tickerContainer.embedFonts;
			
		}
		
		/**
		 * @private
		 */
		public function set embedFonts(value:Boolean):void
		{
			
			tickerContainer.embedFonts = value;
			
		}
		
		//----------------------------------
		//  frameRate
		//----------------------------------
		
		public function get frameRate():Number
		{
			
			return tickerContainer.frameRate;
			
		}
		
		/**
		 * @private
		 */
		public function set frameRate(value:Number):void
		{
			
			tickerContainer.frameRate = value;
			
		}
		
		//----------------------------------
		//  scrolling
		//----------------------------------
		
		[Bindable(event="scrollingChange")]
		[Inspectable(category="Other", defaultValue="true")]
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTickerContainer#scrolling
		 */
		public function get scrolling():Boolean
		{
			
			return tickerContainer.scrolling;
			
		}
		
		/**
		 * @private
		 */
		public function set scrolling(value:Boolean):void
		{
			
			tickerContainer.scrolling = value;
			
		}
		
		//----------------------------------
		//  scrollVelocityX
		//----------------------------------
		
		[Bindable(event="scrollVelocityChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTickerContainer#scrollVelocityX
		 */
		public function get scrollVelocityX():Number
		{
			
			return tickerContainer.scrollVelocityX;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollVelocityX(value:Number):void
		{
			
			tickerContainer.scrollVelocityX = value;
			
		}
		
		//----------------------------------
		//  scrollVelocityY
		//----------------------------------
		
		[Bindable(event="scrollVelocityChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTickerContainer#scrollVelocityY
		 */
		public function get scrollVelocityY():Number
		{
			
			return tickerContainer.scrollVelocityY;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollVelocityY(value:Number):void
		{
			
			tickerContainer.scrollVelocityY = value;
			
		}
		
		//----------------------------------
		//  texts
		//----------------------------------
		
		[ArrayElementType("String")]
		
		[Bindable(event="textChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTextTicker#texts
		 */
		public function get texts():Array
		{
			
			return tickerContainer.texts;
			
		}
		
		/**
		 * @private
		 */
		public function set texts(newTexts:Array):void
		{
			
			tickerContainer.texts = newTexts;
			
		}
		
		//----------------------------------
		//  textFieldPaddingLeft
		//----------------------------------
		
		[Bindable(event="textFieldPaddingLeftChange")]
		public function get textFieldPaddingLeft():Number
		{
			
			return tickerContainer.textFieldPaddingLeft;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingLeft(value:Number):void
		{
			
			if (tickerContainer.textFieldPaddingLeft != value)
			{
				
				tickerContainer.textFieldPaddingLeft = value;
				
				dispatchEvent(new Event("textFieldPaddingLeftChange"));
				
			}
			
		}
		
		//----------------------------------
		//  textFieldPaddingRight
		//----------------------------------
		
		[Bindable(event="textFieldPaddingRightChange")]
		public function get textFieldPaddingRight():Number
		{
			
			return tickerContainer.textFieldPaddingRight;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingRight(value:Number):void
		{
			
			if (tickerContainer.textFieldPaddingRight != value)
			{
				
				tickerContainer.textFieldPaddingRight = value;
				
				dispatchEvent(new Event("textFieldPaddingRightChange"));
				
			}
			
		}
		
		//----------------------------------
		//  textFieldPaddingTop
		//----------------------------------
		
		[Bindable(event="textFieldPaddingTopChange")]
		public function get textFieldPaddingTop():Number
		{
			
			return tickerContainer.textFieldPaddingTop;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingTop(value:Number):void
		{
			
			if (tickerContainer.textFieldPaddingTop != value)
			{
				
				tickerContainer.textFieldPaddingTop = value;
				
				dispatchEvent(new Event("textFieldPaddingTopChange"));
				
			}
			
		}
		
		//----------------------------------
		//  textFieldPaddingBottom
		//----------------------------------
		
		[Bindable(event="textFieldPaddingBottomChange")]
		public function get textFieldPaddingBottom():Number
		{
			
			return tickerContainer.textFieldPaddingBottom;
			
		}
		
		/**
		 * @private
		 */
		public function set textFieldPaddingBottom(value:Number):void
		{
			
			if (tickerContainer.textFieldPaddingBottom != value)
			{
				
				tickerContainer.textFieldPaddingBottom = value;
				
				dispatchEvent(new Event("textFieldPaddingBottomChange"));
				
			}
			
		}
		
		//----------------------------------
		//  textFormat
		//----------------------------------
		
		[Bindable(event="textChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTextTicker#textFormat
		 */
		public function get textFormat():TextFormat
		{
			
			return tickerContainer.textFormat;
			
		}
		
		/**
		 * @private
		 */
		public function set textFormat(newFormat:TextFormat):void
		{
			
			tickerContainer.textFormat = newFormat;
			
		}
		
		//----------------------------------
		//  inBetweenLogo
		//----------------------------------
		
		[Deprecated(replacement="inBetweenLogos")]
		[Bindable(event="textChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTextTicker#inBetweenLogo
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
		
		[Bindable(event="textChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTextTicker#inBetweenLogos
		 */
		public function get inBetweenLogos():Array
		{
			
			return tickerContainer.inBetweenLogos;
			
		}
		
		/**
		 * @private
		 */
		public function set inBetweenLogos(newLogos:Array):void
		{
			
			tickerContainer.inBetweenLogos = newLogos;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTickerContainer#addChild()
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			
			return tickerContainer.addChild(child);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTickerContainer#addChildAt()
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			
			return tickerContainer.addChildAt(child, index);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTickerContainer#removeChild()
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			
			return tickerContainer.removeChild(child);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTickerContainer#removeChildAt()
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			
			return tickerContainer.removeChildAt(index);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.AutoScrollTextTicker#updateView()
		 * 
		 */
		public function updateView():void
		{
			
			tickerContainer.updateView();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onComponentResize(event:ResizeEvent):void
		{
			
			// Resize the ticker container also to fit Flex component
			tickerContainer.scrollAreaWidth = width;
			tickerContainer.scrollAreaHeight = height;
			tickerContainer.resetPosition();
			
		}
		
		private function onTextChange(event:AutoScrollTextTickerEvent):void
		{
			
			dispatchEvent(new AutoScrollTextTickerEvent(AutoScrollTextTickerEvent.TEXT_CHANGE, false, false));
			
		}
		
		private function onScroll(event:AutoScrollTickerContainerEvent):void
		{
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL, false, false));
			
		}
		
		private function onScrollLoop(event:AutoScrollTickerContainerEvent):void
		{
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_LOOP, false, false));
			
		}
		
		private function onScrollStart(event:AutoScrollTickerContainerEvent):void
		{
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_START, false, false));
			dispatchEvent(new Event("scrollingChange"));
			
		}
		
		private function onScrollStop(event:AutoScrollTickerContainerEvent):void
		{
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_STOP, false, false));
			dispatchEvent(new Event("scrollingChange"));
			
		}
		
		private function onScrollVelocityChange(event:AutoScrollTickerContainerEvent):void
		{
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_VELOCITY_CHANGE, false, false));
			
		}
		
	}
	
}