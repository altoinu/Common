/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.events
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The SlideStackCanvasEvent class represents events associated with SlideStackCanvas.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SlideStackCanvasEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The SlideStackCanvasEvent.ON_SLIDE_START constant defines the value of the type property of
		 * an onSlideStart event object.
		 */
		public static const ON_SLIDE_START:String = "onSlideStart";
		
		/**
		 * The SlideStackCanvasEvent.ON_SLIDE_COMPLETE constant defines the value of the type property of
		 * an onSlideComplete event object.
		 */
		public static const ON_SLIDE_COMPLETE:String = "onSlideComplete";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param type The event type; indicates the action that caused the event.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
		 * @param fromChild Child that was being displayed and going to hide.
		 * @param toChild Child that was hidden and going to display.
		 * 
		 */
		public function SlideStackCanvasEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, fromChild:DisplayObject = null, toChild:DisplayObject = null)
		{
			
			super(type, bubbles, cancelable);
			_fromChild = fromChild;
			_toChild = toChild;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  fromChild
		//----------------------------------
		
		private var _fromChild:DisplayObject;
		
		/**
		 * Child that was being displayed and going to hide.
		 */
		public function get fromChild():DisplayObject
		{
			
			return _fromChild;
			
		}
		
		//----------------------------------
		//  toChild
		//----------------------------------
		
		private var _toChild:DisplayObject;
		
		/**
		 * Child that was hidden and going to display.
		 */
		public function get toChild():DisplayObject
		{
			
			return _toChild;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			
			return new SlideStackCanvasEvent(type, bubbles, cancelable, fromChild, toChild);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			var eventClassName:String = getQualifiedClassName(this);
			return "[" + eventClassName.substring(eventClassName.lastIndexOf("::") + 2) + " type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
			
		}
		
	}
	
}