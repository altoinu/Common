/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.events
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class StageVideoPlayerEvent extends VideoPlayerEvent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The StageVideoPlayerEvent.AVAILABLE constant defines the value of the type property of an
		 * <code>unavailble</code> event object.
		 */
		public static const AVAILABLE:String = "availble";
		
		/**
		 * The StageVideoPlayerEvent.UNAVAILABLE constant defines the value of the type property of an
		 * <code>unavailble</code> event object.
		 */
		public static const UNAVAILABLE:String = "unavailble";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StageVideoPlayerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
											  state:String = null, playheadTime:Number = NaN, vp:uint = 0)
		{
			
			super(type, bubbles, cancelable, state, playheadTime, vp);
			
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
			
			return new StageVideoPlayerEvent(type, bubbles, cancelable, state, playheadTime, vp);
			
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