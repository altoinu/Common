/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.containers
{
	
	import com.altoinu.flash.customcomponents.AutoScrollTickerContainer;
	import com.altoinu.flash.customcomponents.events.AutoScrollTickerContainerEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.IFlexModule;
	import mx.core.IFlexModuleFactory;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.managers.ILayoutManagerClient;
	
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
	
	[DefaultProperty("elements")] 
	
	/**
	 * Flex component version of AutoScrollTickerContainer.
	 * 
	 * @example <listing version="3.0">
	 * &lt;AutoScrollTickerContainerFlex width=&quot;100%&quot; height=&quot;100%&quot;
	 * &#xA0;scrolling=&quot;true&quot;&gt;
	 * &#xA0;&lt;s:Group width=&quot;100&quot; height=&quot;100&quot;&gt;
	 * &#xA0;&#xA0;&lt;s:Label text=&quot;Hello world&quot;/&gt;
	 * &#xA0;&lt;/s:Group&gt;
	 * &#xA0;&lt;s:Group width=&quot;100&quot; height=&quot;100&quot;&gt;
	 * &#xA0;&#xA0;&lt;s:Label text=&quot;How are you&quot;/&gt;
	 * &#xA0;&lt;/s:Group&gt;
	 * &lt;/AutoScrollTickerContainerFlex&gt;
	 * </listing>
	 * 
	 * @author Kaoru Kawashima
	 * @see com.altoinu.flash.customcomponents.AutoScrollTickerContainer
	 */
	public class AutoScrollTickerContainerFlex extends UIComponent
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
		public function AutoScrollTickerContainerFlex()
		{
			
			super();
			
			this.addEventListener(ResizeEvent.RESIZE, onComponentResize, false, 0, true);
			
			// Add ticker container to display list
			tickerContainer.scrollAreaWidth = 0;
			tickerContainer.scrollAreaHeight = 0;
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
		 * AutoScrollTickerContainer container instance that actually does the scrolling contents.
		 */
		protected var tickerContainer:AutoScrollTickerContainer = new AutoScrollTickerContainer();
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _elements:Array;
		
		[ArrayElementType("flash.display.DisplayObject")]
		/**
		 * Elements to be scrolling in the ticker.
		 */
		public function set elements(value:Array):void
		{
			
			if (_elements != value)
			{
				
				var numElements:int;
				var i:int;
				if (_elements != null)
				{
					
					// First remove elements already on
					numElements = _elements.length;
					for (i = 0; i < numElements; i++)
					{
						
						removeChild(_elements[i]);
						
					}
					
				}
				
				_elements = value;
				
				if (_elements != null)
				{
					
					// First remove elements already on
					numElements = _elements.length;
					for (i = 0; i < numElements; i++)
					{
						
						addChild(_elements[i]);
						
					}
					
				}
				
			}
			
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
		//  Overridden properties
		//  These methods are needed in case UIComponent is added so Flex layout manager can
		//  properly initialize components
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set nestLevel(value:int):void
		{
			
			super.nestLevel = value;
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is ILayoutManagerClient)
					ILayoutManagerClient(tickerContainer.getChildAt(i)).nestLevel = value + 1;
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set document(value:Object):void
		{
			
			super.document = value;
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is IUIComponent)
					IUIComponent(tickerContainer.getChildAt(i)).document = value;
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set moduleFactory(factory:IFlexModuleFactory):void
		{
			
			super.moduleFactory = factory;
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is IFlexModule)
					IFlexModule(tickerContainer.getChildAt(i)).moduleFactory = factory;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//  These methods are needed in case UIComponent is added so Flex layout manager can
		//  properly initialize components
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateLayoutDirection():void
		{
			
			super.invalidateLayoutDirection();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is UIComponent)
					UIComponent(tickerContainer.getChildAt(i)).invalidateLayoutDirection();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function regenerateStyleCache(recursive:Boolean):void
		{
			
			super.regenerateStyleCache(recursive);
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is UIComponent)
					UIComponent(tickerContainer.getChildAt(i)).regenerateStyleCache(recursive);
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clearStyle(styleProp:String):void
		{
			
			super.clearStyle(styleProp);
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is UIComponent)
					UIComponent(tickerContainer.getChildAt(i)).clearStyle(styleProp);
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean):void
		{
			
			super.notifyStyleChangeInChildren(styleProp, recursive);
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is UIComponent)
					UIComponent(tickerContainer.getChildAt(i)).notifyStyleChangeInChildren(styleProp, recursive);
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function executeBindings(recurse:Boolean=false):void
		{
			
			super.executeBindings(recurse);
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is UIComponent)
					UIComponent(tickerContainer.getChildAt(i)).executeBindings(recurse);
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize():void
		{
			
			super.initialize();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is IUIComponent)
					IUIComponent(tickerContainer.getChildAt(i)).initialize();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateProperties():void
		{
			
			super.invalidateProperties();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is IInvalidating)
					IInvalidating(tickerContainer.getChildAt(i)).invalidateProperties();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validateProperties():void
		{
			
			super.validateProperties();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is ILayoutManagerClient)
					ILayoutManagerClient(tickerContainer.getChildAt(i)).validateProperties();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateSize():void
		{
			
			super.invalidateSize();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is IInvalidating)
					IInvalidating(tickerContainer.getChildAt(i)).invalidateSize();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validateSize(recursive:Boolean=false):void
		{
			
			super.validateSize(recursive);
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is ILayoutManagerClient)
					ILayoutManagerClient(tickerContainer.getChildAt(i)).validateSize(recursive);
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateDisplayList():void
		{
			
			super.invalidateDisplayList();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is IInvalidating)
					IInvalidating(tickerContainer.getChildAt(i)).invalidateDisplayList();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validateDisplayList():void
		{
			
			super.validateDisplayList();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is ILayoutManagerClient)
					ILayoutManagerClient(tickerContainer.getChildAt(i)).validateDisplayList();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validateNow():void
		{
			
			super.validateNow();
			
			var numItems:int = tickerContainer.numChildren;
			for (var i:int = 0; i < numItems; i++)
			{
				
				if (tickerContainer.getChildAt(i) is IInvalidating)
					IInvalidating(tickerContainer.getChildAt(i)).validateNow();
				
			}
			
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