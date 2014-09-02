/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.queue
{
	
	import com.altoinu.flex.rpc.IServiceGroup;
	
	import flash.events.IEventDispatcher;
	
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AsyncToken;
	
	/**
	 * Interface to define service call queue item.
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IServiceCallQueueItem extends IEventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Service operation. HTTPService or Operation.
		 */
		function get operation():AbstractInvoker;
		
		/**
		 * Object containing parameter to be sent to service method when it is called.
		 */
		function get data():Object;
		
		/**
		 * @private
		 */
		function set data(value:Object):void;
		
		/**
		 * Result event handler function(event:ResultEvent):void that is called after service
		 * method completes successfully.
		 */
		function get resultEventHandler():Function;
		
		/**
		 * Fault event handler function(event:FaultEvent):void that is called after service
		 * method completes with fault.
		 */
		function get faultEventHandler():Function;
		
		/**
		 * Service locator <code>operation</code> belongs to.
		 */
		function get serviceLocator():IServiceGroup;
		//function get serviceLocator():Object;
		
		/**
		 * Queue this queue item belongs to.
		 */
		function get serviceLocatorQueue():ServiceCallQueue;
		
		/**
		 * Temporary AsyncToken. Since queue item is not called immediately, AsyncToken
		 * returned from service.send() is not available at first, so this token will
		 * serve as a reference point to connect to actual AsyncToken once queue item
		 * processes the service.
		 */
		function get token():ServiceCallQueueItemAsyncToken;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Makes service call.
		 */
		function process():AsyncToken;
		
	}
	
}