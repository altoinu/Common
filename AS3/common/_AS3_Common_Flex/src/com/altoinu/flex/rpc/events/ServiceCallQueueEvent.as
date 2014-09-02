/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.events
{
	
	import com.altoinu.flex.rpc.queue.IServiceCallQueueItem;
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The ServiceCallQueueEvent class represents events associated with ServiceCallQueue.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ServiceCallQueueEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The ServiceCallQueueEvent.QUEUE_START constant defines the value of the type property of an
		 * <code>queueStart</code> event object.
		 */
		public static const QUEUE_START:String = "queueStart";
		
		/**
		 * The ServiceCallQueueEvent.EXECUTE_NEXT_QUEUE_ITEM constant defines the value of the type property of an
		 * <code>executeNextQueueItem</code> event object.
		 */
		public static const EXECUTE_NEXT_QUEUE_ITEM:String = "executeNextQueueItem";
		
		/**
		 * The ServiceCallQueueEvent.QUEUE_END constant defines the value of the type property of an
		 * <code>queueEnd</code> event object.
		 */
		public static const QUEUE_END:String = "queueEnd";
		
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
		 * @param currentQueueItem
		 * @param previousQueueItem
		 * 
		 */
		public function ServiceCallQueueEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
											  currentQueueItem:IServiceCallQueueItem = null, previousQueueItem:IServiceCallQueueItem = null)
		{
			
			super(type, bubbles, cancelable);
			
			_currentQueueItem = currentQueueItem;
			_previousQueueItem = previousQueueItem;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  currentQueueItem
		//--------------------------------------
		
		private var _currentQueueItem:IServiceCallQueueItem;
		
		public function get currentQueueItem():IServiceCallQueueItem
		{
			
			return _currentQueueItem;
			
		}
		
		//--------------------------------------
		//  previousQueueItem
		//--------------------------------------
		
		private var _previousQueueItem:IServiceCallQueueItem;
		
		public function get previousQueueItem():IServiceCallQueueItem
		{
			
			return _previousQueueItem;
			
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
			
			return new ServiceCallQueueEvent(type, bubbles, cancelable, currentQueueItem, previousQueueItem);
			
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