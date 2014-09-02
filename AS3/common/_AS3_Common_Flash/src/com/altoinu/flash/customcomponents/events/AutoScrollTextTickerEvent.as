/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.events
{
	
	/**
	 * The AutoScrollTextTickerEvent class represents events associated with AutoScrollTextTicker.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AutoScrollTextTickerEvent extends AutoScrollTickerContainerEvent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The AutoScrollTextTickerEvent.TEXT_CHANGE constant defines the value of the type property of an
		 * <code>textChange</code> event object.
		 */
		public static const TEXT_CHANGE:String = "textChange";
		
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
		public function AutoScrollTextTickerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			
			super(type, bubbles, cancelable);
			
		}
		
	}
	
}