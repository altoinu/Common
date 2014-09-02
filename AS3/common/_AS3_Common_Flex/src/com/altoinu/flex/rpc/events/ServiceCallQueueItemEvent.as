/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.events
{
	
	import flash.events.Event;
	
	/**
	 * The ServiceCallQueueItemEvent class represents events associated with ServiceCallQueueItem.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ServiceCallQueueItemEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The ServiceCallQueueItemEvent.INITIATE constant defines the value of the type property of an open event object.
		 */
		public static const INITIATE:String = "initiate";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function ServiceCallQueueItemEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
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
		override public function clone():Event
		{
			
			return new ServiceCallQueueItemEvent(type, bubbles, cancelable);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[ServiceCallQueueItemEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+"]"
			
		}
		
	}
	
}