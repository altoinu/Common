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
	
	/**
	 * The AutoScrollTickerContainerEvent class represents events associated with AutoScrollTickerContainer.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AutoScrollTickerContainerEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The AutoScrollTickerContainerEvent.SCROLL constant defines the value of the type property of an
		 * <code>scroll</code> event object.
		 */
		public static const SCROLL:String = "scroll";
		
		/**
		 * The AutoScrollTickerContainerEvent.SCROLL_START constant defines the value of the type property of an
		 * <code>scrollStart</code> event object.
		 */
		public static const SCROLL_START:String = "scrollStart";
		
		/**
		 * The AutoScrollTickerContainerEvent.SCROLL_STOP constant defines the value of the type property of an
		 * <code>scrollStop</code> event object.
		 */
		public static const SCROLL_STOP:String = "scrollStop";
		
		/**
		 * The AutoScrollTickerContainerEvent.SCROLL_AREA_UPDATE constant defines the value of the type property of an
		 * <code>scrollAreaUpdate</code> event object.
		 */
		public static const SCROLL_AREA_UPDATE:String = "scrollAreaUpdate";
		
		/**
		 * The AutoScrollTickerContainerEvent.SCROLL_VELOCITY_CHANGE constant defines the value of the type property of an
		 * <code>scrollVelocityChange</code> event object.
		 */
		public static const SCROLL_VELOCITY_CHANGE:String = "scrollVelocityChange";
		
		/**
		 * The AutoScrollTickerContainerEvent.SCROLL_LOOP constant defines the value of the type property of an
		 * <code>scrollLoop</code> event object.
		 */
		public static const SCROLL_LOOP:String = "scrollLoop";
		
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
		 * 
		 */
		public function AutoScrollTickerContainerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			
			super(type, bubbles, cancelable);
			
		}
		
	}
	
}