/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.events
{
	
	import flash.events.Event;
	
	/**
	 * The TimerCountDownEvent class represents events associated with TimerCountDown.
	 * @author Kaoru Kawashima
	 * 
	 * @see com.altoinu.flash.utils.TimerCountDown
	 */
	public class TimerCountDownEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The TimerCountDownEvent.TICK constant defines the value of the type property of an
		 * <code>tick</code> event object.
		 */
		public static const TICK:String = "tick";
		
		/**
		 * The TimerCountDownEvent.COMPLETE constant defines the value of the type property of an
		 * <code>complete</code> event object.
		 */
		public static const COMPLETE:String = "complete";
		
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
		 * @param result Result data, if any.
		 * 
		 */
		public function TimerCountDownEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			
			super(type, bubbles, cancelable);
			
		}
		
	}
	
}