/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.events
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The StageWebViewUIComponentEvent class represents events associated with StageWebViewUIComponent.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class StageWebViewUIComponentEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The StageWebViewUIComponentEvent.LOCATION_CHANGE constant defines the value of the type property of
		 * an locationChange event object.
		 */
		public static const LOCATION_CHANGE:String = "locationChange";
		
		/**
		 * The StageWebViewUIComponentEvent.LOCATION_CHANGING constant defines the value of the type property of
		 * an locationChanging event object.
		 */
		public static const LOCATION_CHANGING:String = "locationChanging";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * @param stageWebViewEvent
		 * 
		 */
		public function StageWebViewUIComponentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, location:String = null, stageWebViewEvent:Event = null)
		{
			
			super(type, bubbles, cancelable);
			
			this.location = location;
			this.stageWebViewEvent = stageWebViewEvent;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var location:String;
		
		/**
		 * Reference to actual event that was dispatched from StageWebView.
		 */
		public var stageWebViewEvent:Event;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function preventDefault():void
		{
			
			if (stageWebViewEvent)
				stageWebViewEvent.preventDefault(); // do preventDefault() on stageWebViewEvent if it was defined
			else
				super.preventDefault();
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			
			return new StageWebViewUIComponentEvent(type, bubbles, cancelable, location, stageWebViewEvent);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			var eventClassName:String = getQualifiedClassName(this);
			return "[" + eventClassName.substring(eventClassName.lastIndexOf("::") + 2) + " type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + " location=" + location + "]";
			
		}
		
	}
	
}