/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents
{
	
	import com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent;
	
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
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
	 *  Dispatched when visible scroll area position and size changes.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE
	 */
	[Event(name="scrollAreaUpdate", type="com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent")]
	
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
	
	/**
	 * Sprite container to automatically scroll contents inside it.  This container can produce
	 * news ticker like effect where contents inside it scroll automatically one after another.
	 * 
	 * <p>Scrolling contents can be added using <code>addChild</code> or <code>addChildAt</code>
	 * methods.  AutoScrollTickerContainer will use each child's index as scrolling order (ex.
	 * <code>getChildAt(0)</code> item scrolls before <code>getChildAt(1)</code>).</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AutoScrollTickerContainer extends Sprite
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const DEGREE45_RADIAN:Number = Math.PI / 4;
		private static const DEGREE90_RADIAN:Number = Math.PI / 2;
		private static const DEGREE135_RADIAN:Number = Math.PI * (3 / 4);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param frameRate
		 * 
		 */
		public function AutoScrollTickerContainer(frameRate:Number = 30)
		{
			
			super();
			
			super.addChild(childContainer);
			
			// Initially, reset position
			positionReset = true;
			
			// Set up timer to do scrolling
			this.frameRate = frameRate;
			
			// This triggers timer
			scrolling = scrolling;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var scrollTimer:Timer;
		private var previousTimeStamp:int;
		
		/**
		 * Setting this to true causes all items to be positioned at initial spot at next scroll cycle.
		 */
		private var positionReset:Boolean = false;
		
		private var childContainer:Sprite = new Sprite();
		private var childDimensions:Dictionary = new Dictionary();
		
		private var maskArea:Sprite;
		private var borderGraphic:Sprite;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  width
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			
			return scrollAreaWidth;
			
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			
			scrollAreaWidth = value;
			
		}
		
		//----------------------------------
		//  height
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			
			return scrollAreaHeight;
			
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			
			scrollAreaHeight = value;
			
		}
		
		//----------------------------------
		//  numChildren
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get numChildren():int
		{
			
			return childContainer.numChildren;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  frameRate
		//----------------------------------
		
		private var _frameRate:Number = 30;
		
		public function get frameRate():Number
		{
			
			return _frameRate;
			
		}
		
		/**
		 * @private
		 */
		public function set frameRate(value:Number):void
		{
			
			var timerRunning:Boolean = false;
			
			if (scrollTimer != null)
			{
				
				// Remove previous timer
				timerRunning = scrollTimer.running;
				stopScrollTimer();
				
			}
			
			// Create new timer
			_frameRate = value;
			scrollTimer = new Timer(1000 / frameRate);
			
			if (timerRunning)
				startScrollTimer();
			
		}
		
		//----------------------------------
		//  scrolling
		//----------------------------------
		
		private var _scrolling:Boolean = true;
		
		/**
		 * Boolean value indicating whether contents are currently scrolling or not.
		 * 
		 * @default true
		 */
		public function get scrolling():Boolean
		{
			
			return _scrolling;
			
		}
		
		/**
		 * @private
		 */
		public function set scrolling(value:Boolean):void
		{
			
			_scrolling = value;
			
			if (_scrolling)
			{
				
				if (!scrollTimer.running)
					startScrolling();
				
			}
			else
			{
				
				if (scrollTimer.running)
					stopScrolling();
				
			}
			
		}
		
		//----------------------------------
		//  scrollAreaRec
		//----------------------------------
		
		/**
		 * Rectangle that defines area within the component where contents will be visible while scrolling.
		 */
		public function get scrollAreaRec():Rectangle
		{
			
			return new Rectangle(scrollAreaX, scrollAreaY, scrollAreaWidth, scrollAreaHeight);
			
		}
		
		//----------------------------------
		//  scrollAreaX
		//----------------------------------
		
		private var _scrollAreaX:Number = 0;
		
		/**
		 * X coordinate of the rectangle that defines the masked area inside AutoScrollTickerContainer that
		 * displays contents scrolling.  Scrolling contents are only visible when they are within the range
		 * defined by scrollAreaX, scrollAreaY, scrollAreaWidth, and scrollAreaHeight.
		 * 
		 * <p>Changing this value will update the mask size immediately.</p>
		 * 
		 * @default 0
		 */
		public function get scrollAreaX():Number
		{
			
			return _scrollAreaX;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollAreaX(value:Number):void
		{
			
			_scrollAreaX = value;
			
			initializeMaskAndBorder(true);
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE, false, false));
			
		}
		
		//----------------------------------
		//  scrollAreaY
		//----------------------------------
		
		private var _scrollAreaY:Number = 0;
		
		/**
		 * Y coordinate of the rectangle that defines the masked area inside AutoScrollTickerContainer that
		 * displays contents scrolling.  Scrolling contents are only visible when they are within the range
		 * defined by scrollAreaX, scrollAreaY, scrollAreaWidth, and scrollAreaHeight.
		 * 
		 * <p>Changing this value will update the mask size immediately.</p>
		 * 
		 * @default 0
		 */
		public function get scrollAreaY():Number
		{
			
			return _scrollAreaY;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollAreaY(value:Number):void
		{
			
			_scrollAreaY = value;
			
			initializeMaskAndBorder(true);
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE, false, false));
			
		}
		
		//----------------------------------
		//  scrollAreaWidth
		//----------------------------------
		
		private var _scrollAreaWidth:Number = 400;
		
		/**
		 * Width of the rectangle that defines the masked area inside AutoScrollTickerContainer that
		 * displays contents scrolling.  Scrolling contents are only visible when they are within the range
		 * defined by scrollAreaX, scrollAreaY, scrollAreaWidth, and scrollAreaHeight.
		 * 
		 * <p>Changing this value will update the mask size immediately.</p>
		 * 
		 * @default 400
		 */
		public function get scrollAreaWidth():Number
		{
			
			return _scrollAreaWidth;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollAreaWidth(value:Number):void
		{
			
			_scrollAreaWidth = value;
			
			initializeMaskAndBorder(true);
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE, false, false));
			
		}
		
		//----------------------------------
		//  scrollAreaHeight
		//----------------------------------
		
		private var _scrollAreaHeight:Number = 400;
		
		/**
		 * Height of the rectangle that defines the masked area inside AutoScrollTickerContainer that
		 * displays contents scrolling.  Scrolling contents are only visible when they are within the range
		 * defined by scrollAreaX, scrollAreaY, scrollAreaWidth, and scrollAreaHeight.
		 * 
		 * <p>Changing this value will update the mask size immediately.</p>
		 * 
		 * @default 200
		 */
		public function get scrollAreaHeight():Number
		{
			
			return _scrollAreaHeight;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollAreaHeight(value:Number):void
		{
			
			_scrollAreaHeight = value;
			
			initializeMaskAndBorder(true);
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE, false, false));
			
		}
		
		//----------------------------------
		//  scrollVelocityX
		//----------------------------------
		
		private var _scrollVelocityX:Number = -100;
		
		/**
		 * Scroll velocity in X direction, in pixels per second.
		 * 
		 * <p>If this is set to 0, then the first child will be positioned
		 * at x = 0.</p>
		 * 
		 * @default -100
		 */
		public function get scrollVelocityX():Number
		{
			
			return _scrollVelocityX;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollVelocityX(value:Number):void
		{
			
			_scrollVelocityX = value;
			
			// reset child order and position
			initializeMaskAndBorder();
			orderChildItems();
			setToStartPosition();
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_VELOCITY_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  scrollVelocityY
		//----------------------------------
		
		private var _scrollVelocityY:Number = 0;
		
		/**
		 * Scroll velocity in Y direction, in pixels per second.
		 * 
		 * <p>If this is set to 0, then the first child will be positioned
		 * at y = 0.</p>
		 * 
		 * @default 0
		 */
		public function get scrollVelocityY():Number
		{
			
			return _scrollVelocityY;
			
		}
		
		/**
		 * @private
		 */
		public function set scrollVelocityY(value:Number):void
		{
			
			_scrollVelocityY = value;
			
			// reset child order and position
			initializeMaskAndBorder();
			orderChildItems();
			setToStartPosition();
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_VELOCITY_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  borderThickness
		//----------------------------------
		
		private var _borderThickness:Number = 0;
		
		/**
		 * Width of the border drawn around the component.  Default is 0, which draws no border.
		 */
		public function get borderThickness():Number
		{
			
			return _borderThickness;
			
		}
		
		/**
		 * @private
		 */
		public function set borderThickness(value:Number):void
		{
			
			if (value < 0)
				value = 0;
			
			_borderThickness = value;
			
			initializeMaskAndBorder(true);
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE, false, false));
			
		}
		
		//----------------------------------
		//  borderColor
		//----------------------------------
		
		private var _borderColor:uint = 0x000000;
		
		/**
		 * Color of the border drawn around the component.
		 * 
		 * @default 0x000000 (black);
		 */
		public function get borderColor():uint
		{
			
			return _borderColor;
			
		}
		
		/**
		 * @private
		 */
		public function set borderColor(value:uint):void
		{
			
			_borderColor = value;
			
			initializeMaskAndBorder(true);
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE, false, false));
			
		}
		
		//----------------------------------
		//  continuousLoop
		//----------------------------------
		
		//private var _continuousLoop:Boolean = false;
		
		/*
		 * If set to true, then first child will continue directly behind the last child
		 * while scrolling.
		 * 
		 * @default false
		 */
		/*
		public function get continuousLoop():Boolean
		{
			
			return _continuousLoop;
			
		}
		*/
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds specified DisplayObject into AutoScrollTickerContainer to scroll within it.
		 * @param child
		 * @return 
		 * 
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			
			// Call addChildAt
			return addChildAt(child, numChildren);
			
		}
		
		/**
		 * Adds specified DisplayObject into AutoScrollTickerContainer to scroll within it.
		 * @param child
		 * @param index
		 * @return 
		 * 
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			
			// First, add new child to display list
			var addedChild:DisplayObject = childContainer.addChildAt(child, index);
			
			// Remember width and height of this child
			// It will be used to position this item
			if (childDimensions[addedChild] == null)
				setChildDimensions(addedChild);
			
			// reset child order and position
			initializeMaskAndBorder();
			orderChildItems();
			setToStartPosition();
			
			return addedChild;
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			
			// Remove reference
			childContainer.removeChild(child);
			
			if (childDimensions[child] != null)
				delete childDimensions[child];
			
			// reset child order and position
			initializeMaskAndBorder();
			orderChildItems();
			setToStartPosition();
			
			return child;
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			
			// Remove reference
			var child:DisplayObject = childContainer.removeChildAt(index);
			
			if (childDimensions[child] != null)
				delete childDimensions[child];
			
			// reset child order and position
			initializeMaskAndBorder();
			orderChildItems();
			setToStartPosition();
			
			return child;
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildAt(index:int):DisplayObject
		{
			
			return childContainer.getChildAt(index);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildByName(name:String):DisplayObject
		{
			
			return childContainer.getChildByName(name);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildIndex(child:DisplayObject):int
		{
			
			return childContainer.getChildIndex(child);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[AutoScrollTickerContainer "+scrollAreaX+","+scrollAreaY+" "+scrollAreaWidth+"x"+scrollAreaHeight+" "+scrollVelocityX+" "+scrollVelocityY+"]";
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function startScrolling():void
		{
			
			previousTimeStamp = getTimer();
			startScrollTimer();
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_START, false, false));
			
		}
		
		private function startScrollTimer():void
		{
			
			if (!scrollTimer.running)
			{
				
				scrollTimer.addEventListener(TimerEvent.TIMER, onTimerScrollItems);
				scrollTimer.start();
				
			}
			
		}
		
		private function stopScrolling():void
		{
			
			stopScrollTimer();
			
			dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_STOP, false, false));
			
		}
		
		private function stopScrollTimer():void
		{
			
			scrollTimer.removeEventListener(TimerEvent.TIMER, onTimerScrollItems);
			scrollTimer.reset();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Remembers the dimensions of specified child which will be used when ordering
		 * it in the ticker.
		 * @param child
		 * 
		 */
		protected function setChildDimensions(child:DisplayObject):void
		{
			
			childDimensions[child] = new Rectangle(0, 0, child.width, child.height);
			
		}
		
		/**
		 * Initializes mask and border.
		 * @param forceBorderAndMaskRecreate
		 * 
		 */
		protected function initializeMaskAndBorder(forceBorderAndMaskRecreate:Boolean = false):void
		{
			
			if (forceBorderAndMaskRecreate || (borderGraphic == null) || (borderGraphic.parent != this))
				drawBorder(borderThickness, borderColor, scrollAreaRec);
			
			if (forceBorderAndMaskRecreate || (maskArea == null) || (maskArea.parent != this))
				drawMaskArea(scrollAreaRec);
			
			if ((borderGraphic != null) && (super.getChildIndex(borderGraphic) < super.numChildren - 1))
				super.addChild(borderGraphic); // Put border on top
			
		}
		
		/**
		 * Posisions childContainer to initial scrolling position.
		 * 
		 */
		protected function setToStartPosition():void
		{
			
			if (childContainer.numChildren > 0)
			{
				
				var scrollAngle:Number = Math.atan2(scrollVelocityY, scrollVelocityX);
				var newPoint:Point = new Point();
				var previousChildPos:Point = new Point(scrollAreaX, scrollAreaY);
				var previousChildRec:Rectangle = new Rectangle(0, 0, scrollAreaWidth, scrollAreaHeight);
				var currentChildRec:Rectangle = new Rectangle(0, 0, childContainer.getChildAt(0).width, childContainer.getChildAt(0).height);
				
				if ((0 <= scrollAngle) && (scrollAngle <= DEGREE45_RADIAN))
				{
					
					newPoint.x = previousChildPos.x - currentChildRec.width;
					newPoint.y = previousChildPos.y - currentChildRec.height * Math.tan(scrollAngle);
					
				}
				else if ((DEGREE45_RADIAN < scrollAngle) && (scrollAngle <= DEGREE90_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x - currentChildRec.width * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x - currentChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y - currentChildRec.height;
					
				}
				else if ((DEGREE90_RADIAN < scrollAngle) && (scrollAngle <= DEGREE135_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x - scrollAreaWidth * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x - previousChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y - currentChildRec.height;
					
				}
				else if ((DEGREE135_RADIAN < scrollAngle) && (scrollAngle <= Math.PI))
				{
					
					newPoint.x = previousChildPos.x + previousChildRec.width;
					newPoint.y = previousChildPos.y + currentChildRec.height * Math.tan(scrollAngle);
					
				}
				else if ((-DEGREE135_RADIAN > scrollAngle) && (scrollAngle >= -Math.PI))
				{
					
					newPoint.x = previousChildPos.x + previousChildRec.width;
					newPoint.y = previousChildPos.y + previousChildRec.height * Math.tan(scrollAngle);
					
				}
				else if ((-DEGREE90_RADIAN > scrollAngle) && (scrollAngle >= -DEGREE135_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x + scrollAreaWidth * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x + previousChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y + previousChildRec.height;
					
				}
				else if ((-DEGREE45_RADIAN > scrollAngle) && (scrollAngle >= -DEGREE90_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x + currentChildRec.width * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x + currentChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y + previousChildRec.height;
					
				}
				else if ((0 > scrollAngle) && (scrollAngle >= -DEGREE45_RADIAN))
				{
					
					newPoint.x = previousChildPos.x - currentChildRec.width;
					newPoint.y = previousChildPos.y - previousChildRec.height * Math.tan(scrollAngle);
					
				}
				
				childContainer.x = Math.round(newPoint.x * 100) / 100;
				childContainer.y = Math.round(newPoint.y * 100) / 100;
				
			}
			
		}
		
		/**
		 * Using scrollVelocityX and scrollVelocityY, order children.
		 * 
		 */
		protected function orderChildItems():void
		{
			
			if (childContainer.numChildren == 0)
				return; // No child to be ordered
			
			var scrollAngle:Number = Math.atan2(scrollVelocityY, scrollVelocityX);
			var newPoint:Point = new Point();
			
			// Organize children in childContainer
			var currentChild:DisplayObject = childContainer.getChildAt(0);
			currentChild.x = 0;
			currentChild.y = 0;
			
			var previousChildPos:Point = new Point(currentChild.x, currentChild.y);
			var currentChildRec:Rectangle;
			var previousChildRec:Rectangle = childDimensions[currentChild];
			if (previousChildRec.width != currentChild.width)
				previousChildRec.width = currentChild.width;
			if (previousChildRec.height != currentChild.height)
				previousChildRec.height = currentChild.height;
			
			var numChildItems:int = childContainer.numChildren;
			for (var i:int = 1; i < numChildItems; i++)
			{
				
				currentChild = childContainer.getChildAt(i);
				
				currentChildRec = childDimensions[currentChild];
				if (currentChildRec.width != currentChild.width)
					currentChildRec.width = currentChild.width;
				if (currentChildRec.height != currentChild.height)
					currentChildRec.height = currentChild.height;
				
				if ((0 <= scrollAngle) && (scrollAngle <= DEGREE45_RADIAN))
				{
					
					newPoint.x = previousChildPos.x - currentChildRec.width;
					newPoint.y = previousChildPos.y - currentChildRec.height * Math.tan(scrollAngle);
					
				}
				else if ((DEGREE45_RADIAN < scrollAngle) && (scrollAngle <= DEGREE90_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x - currentChildRec.width * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x - currentChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y - currentChildRec.height;
					
				}
				else if ((DEGREE90_RADIAN < scrollAngle) && (scrollAngle <= DEGREE135_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x - previousChildRec.width * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x - previousChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y - currentChildRec.height;
					
				}
				else if ((DEGREE135_RADIAN < scrollAngle) && (scrollAngle <= Math.PI))
				{
					
					newPoint.x = previousChildPos.x + previousChildRec.width;
					newPoint.y = previousChildPos.y + currentChildRec.height * Math.tan(scrollAngle);
					
				}
				else if ((-DEGREE135_RADIAN > scrollAngle) && (scrollAngle >= -Math.PI))
				{
					
					newPoint.x = previousChildPos.x + previousChildRec.width;
					newPoint.y = previousChildPos.y + previousChildRec.height * Math.tan(scrollAngle);
					
				}
				else if ((-DEGREE90_RADIAN > scrollAngle) && (scrollAngle >= -DEGREE135_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x + previousChildRec.width * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x + previousChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y + previousChildRec.height;
					
				}
				else if ((-DEGREE45_RADIAN > scrollAngle) && (scrollAngle >= -DEGREE90_RADIAN))
				{
					
					//newPoint.x = previousChildPos.x + currentChildRec.width * Math.tan(DEGREE90_RADIAN - scrollAngle);
					newPoint.x = previousChildPos.x + currentChildRec.width / Math.tan(scrollAngle);
					newPoint.y = previousChildPos.y + previousChildRec.height;
					
				}
				else if ((0 > scrollAngle) && (scrollAngle >= -DEGREE45_RADIAN))
				{
					
					newPoint.x = previousChildPos.x - currentChildRec.width;
					newPoint.y = previousChildPos.y - previousChildRec.height * Math.tan(scrollAngle);
					
				}
				
				previousChildPos.x = Math.round(newPoint.x * 100) / 100;
				previousChildPos.y = Math.round(newPoint.y * 100) / 100;
				
				currentChild.x = previousChildPos.x;
				currentChild.y = previousChildPos.y;
				
				previousChildRec = childDimensions[currentChild];
				
			}
			
		}
		
		/**
		 * Draws mask.
		 * @param maskAreaRec
		 * 
		 */
		protected function drawMaskArea(maskAreaRec:Rectangle):void
		{
			
			if (maskArea == null)
			{
				
				// Create mask object
				maskArea = new Sprite();
				var g:Graphics = maskArea.graphics;
				g.clear();
				g.beginFill(0x0000FF, 1);
				g.moveTo(0, 0);
				g.lineTo(100, 0);
				g.lineTo(100, 100);
				g.lineTo(0, 100);
				g.lineTo(0, 0);
				g.endFill();
				
				super.addChild(maskArea);
				
			}
			
			var halfThickness:Number = Math.floor(borderThickness / 2);
			maskArea.x = maskAreaRec.x - halfThickness;
			maskArea.y = maskAreaRec.y - halfThickness;
			maskArea.width = maskAreaRec.width + borderThickness;
			maskArea.height = maskAreaRec.height + borderThickness;
			maskArea.alpha = 0.25;
			
			this.mask = maskArea;
			
		}
		
		/**
		 * Draws border around masked area.
		 * @param thickness
		 * @param maskAreaRec
		 * 
		 */
		protected function drawBorder(thickness:Number, color:uint, maskAreaRec:Rectangle):void
		{
			
			// Remove previous border
			if ((borderGraphic != null) && (borderGraphic.parent != null))
				borderGraphic.parent.removeChild(borderGraphic);
			
			// Draw new border
			borderGraphic = null;
			if (thickness > 0)
			{
				
				borderGraphic = new Sprite();
				var halfThickness:Number = thickness / 2;
				var g:Graphics = borderGraphic.graphics;
				g.lineStyle(thickness, color, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
				g.drawRect(maskAreaRec.x, maskAreaRec.y, maskAreaRec.width, maskAreaRec.height);
				
				super.addChild(borderGraphic);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Resets all items to initial scrolling position.  If contents are scrolling,
		 * then item positions will be reset at next scroll cycle.
		 * 
		 */
		public function resetPosition():void
		{
			
			if (!scrolling)
			{
				
				// reset child order and position
				initializeMaskAndBorder();
				orderChildItems();
				setToStartPosition();
				
				positionReset = false;
				
			}
			else
			{
				
				positionReset = true;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onTimerScrollItems(event:TimerEvent):void
		{
			
			if (childContainer.numChildren > 0)
			{
				
				// Move childContainer
				var elapsedTime:Number = (getTimer() - previousTimeStamp) / 1000;
				var newPoint:Point = new Point(Math.round((childContainer.x + (scrollVelocityX * elapsedTime)) * 100) / 100,
											   Math.round((childContainer.y + (scrollVelocityY * elapsedTime)) * 100) / 100);
				childContainer.x = newPoint.x;
				childContainer.y = newPoint.y;
				
				initializeMaskAndBorder();
				
				var looped:Boolean = false;
				if (positionReset || !maskArea.hitTestObject(childContainer))
				{
					
					looped = !maskArea.hitTestObject(childContainer);
					
					// reset child order and position
					orderChildItems();
					setToStartPosition();
					
					positionReset = false;
					
				}
				
				previousTimeStamp = getTimer();
				
				dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL, false, false));
				
				if (looped)
					dispatchEvent(new AutoScrollTickerContainerEvent(AutoScrollTickerContainerEvent.SCROLL_LOOP, false, false));
			}
			
		}
		
	}
	
}