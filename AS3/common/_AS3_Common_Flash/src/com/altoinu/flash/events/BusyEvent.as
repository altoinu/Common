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
	import flash.utils.getQualifiedClassName;
	
	public class BusyEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const SHOW_BUSY:String = "showBusy";
		public static const HIDE_BUSY:String = "hideBusy";
		
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
		 * @param busyMessage Used for showBusy event, message to display on busy indicator.
		 * 
		 */
		public function BusyEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
								  busyMessage:String = "Please wait...")
		{
			
			super(type, bubbles, cancelable);
			
			this.busyMessage = busyMessage;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var busyMessage:String;
		
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
			
			return new BusyEvent(type, bubbles, cancelable, busyMessage);
			
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