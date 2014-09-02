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
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	/**
	 * The HTTPServiceLocatorEvent class represents events associated with ServiceLocator.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class HTTPServiceLocatorEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The HTTPServiceLocatorEvent.RESULT constant defines the value of the type property of an result event object.
		 */
		public static const RESULT:String = "result";
		
		/**
		 * The HTTPServiceLocatorEvent.FAULT constant defines the value of the type property of an fault event object.
		 */
		public static const FAULT:String = "fault";
		
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
		 * @param httpService
		 * @param resultEvent
		 * @param faultEvent
		 * 
		 */
		public function HTTPServiceLocatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, httpService:HTTPService = null, resultEvent:ResultEvent = null, faultEvent:FaultEvent = null)
		{
			
			super(type, bubbles, cancelable);
			
			_httpService = httpService;
			_resultEvent = resultEvent;
			_faultEvent = faultEvent;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * HTTPService involved in this event.
		 */
		private var _httpService:HTTPService;
		
		/**
		 * Reference to the actual ResultEvent dispatched by the service called.
		 */
		private var _resultEvent:ResultEvent;
		
		/**
		 * Reference to the actual FaultEvent dispatched by the service called.
		 */
		private var _faultEvent:FaultEvent;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function get httpService():HTTPService
		{
			
			return _httpService;
			
		}
		
		/**
		 * Reference to the actual ResultEvent dispatched by the service called.
		 */
		public function get resultEvent():ResultEvent
		{
			
			return _resultEvent;
			
		}
		
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
		override public function toString():String
		{
			
			return "[HTTPServiceLocatorEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+"]"
			
		}
		
	}
	
}