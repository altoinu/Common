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
	
	import mx.rpc.AbstractService;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.Operation;

	/**
	 * The WebServiceLocatorEvent class represents events associated with WebServiceLocator.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class WebServiceLocatorEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The WebServiceLocatorEvent.RESULT constant defines the value of the type property of an result event object.
		 */
		public static const RESULT:String = "result";
		
		/**
		 * The WebServiceLocatorEvent.FAULT constant defines the value of the type property of an fault event object.
		 */
		public static const FAULT:String = "fault";
		
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
		 * @param webservice
		 * @param operation
		 * @param resultEvent
		 * @param faultEvent
		 * 
		 */
		public function WebServiceLocatorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, webservice:AbstractService = null, operation:Operation = null, resultEvent:ResultEvent = null, faultEvent:FaultEvent = null)
		{
			
			super(type, bubbles, cancelable);
			
			_webservice = webservice;
			_operation = operation;
			_resultEvent = resultEvent;
			_faultEvent = faultEvent;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Webservice involved in this event.
		 */
		private var _webservice:AbstractService;
		
		/**
		 * Operation involved in this event.
		 */
		private var _operation:Operation;
		
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
		
		/**
		 * Webservice involved in this event.
		 */
		public function get webservice():AbstractService
		{
			
			return _webservice;
			
		}
		
		/**
		 * Operation involved in this event.
		 */
		public function get operation():Operation
		{
			
			return _operation;
			
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
			
			return "[WebServiceLocatorEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+"]"
			
		}
		
	}
	
}