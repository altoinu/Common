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
	
	/**
	 * The ViewSwitchEvent class represents events associated with AutoViewSwitchStack.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ViewSwitchEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The ViewSwitchEvent.CYCLESTART constant defines the value of the type property of an cyclestart event object.
		 */
		public static const CYCLESTART:String = "cyclestart";
		
		/**
		 * The ViewSwitchEvent.CYCLEEND constant defines the value of the type property of an cycleend event object.
		 */
		public static const CYCLEEND:String = "cycleend";
		
		/**
		 * The ViewSwitchEvent.SEQUENCE_END constant defines the value of the type property of an sequenceEnd event object.
		 */
		public static const SEQUENCE_END:String = "sequenceEnd";
		
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
		public function ViewSwitchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			
			return "[ViewSwitchEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+"]"
			
		}
		
	}
	
}