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
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.soap.Operation;
	
	/**
	 * The ServiceGroupEvent class represents events associated with ServiceGroup.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ServiceGroupEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The ServiceGroupEvent.SERVICE_RESULT constant defines the value of the type property of an
		 * <code>serviceResult</code> event object.
		 */
		public static const SERVICE_RESULT:String = "serviceResult";
		
		/**
		 * The ServiceGroupEvent.SERVICE_FAULT constant defines the value of the type property of an
		 * <code>serviceFault</code> event object.
		 */
		public static const SERVICE_FAULT:String = "serviceFault";
		
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
		public function ServiceGroupEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
										  httpService:HTTPService = null,
										  operation:Operation = null,
										  resultEvent:ResultEvent = null,
										  faultEvent:FaultEvent = null)
		{
			
			super(type, bubbles, cancelable);
			
			_httpService = httpService;
			_operation = operation;
			_resultEvent = resultEvent;
			_faultEvent = faultEvent;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  httpService
		//--------------------------------------
		
		private var _httpService:HTTPService;
		
		/**
		 * HTTPService involved in this event.
		 */
		public function get httpService():HTTPService
		{
			
			return _httpService;
			
		}
		
		//--------------------------------------
		//  operation
		//--------------------------------------
		
		private var _operation:Operation;
		
		/**
		 * Operation involved in this event.
		 */
		public function get operation():Operation
		{
			
			return _operation;
			
		}
		
		//--------------------------------------
		//  resultEvent
		//--------------------------------------
		
		private var _resultEvent:ResultEvent;
		
		/**
		 * Reference to the actual ResultEvent dispatched by the service called.
		 */
		public function get resultEvent():ResultEvent
		{
			
			return _resultEvent;
			
		}
		
		//--------------------------------------
		//  faultEvent
		//--------------------------------------
		
		private var _faultEvent:FaultEvent;
		
		/**
		 * Reference to the actual FaultEvent dispatched by the service called.
		 */
		public function get faultEvent():FaultEvent
		{
			
			return _faultEvent;
			
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
			
			return new ServiceGroupEvent(type, bubbles, cancelable, httpService, operation, resultEvent, faultEvent);
			
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