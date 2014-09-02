/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.events
{
	
	import flash.events.Event;
	
	/**
	 * The DesignableDAEModelEvent class represents events associated with DesignableDAEModel.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DesignableDAEModelEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The DesignableDAEModelEvent.SELECTTOOL_MOUSE_DOWN constant defines the value of the type property of
		 * an selecttoolMouseDown event object.
		 */
		public static const SELECTTOOL_MOUSE_DOWN:String = "selecttoolMouseDown";
		
		/**
		 * The DesignableDAEModelEvent.SELECTTOOL_MOUSE_UP constant defines the value of the type property of
		 * an selecttoolMouseUp event object.
		 */
		public static const SELECTTOOL_MOUSE_UP:String = "selecttoolMouseUp";
		
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
		 */
		public function DesignableDAEModelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			
			super(type, bubbles, cancelable);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[DesignableDAEModelEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+"]"
			
		}
		
	}
	
}