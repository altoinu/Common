/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.http
{
	
	import com.altoinu.flex.rpc.queue.ServiceCallQueue;
	import com.altoinu.flex.rpc.queue.ServiceCallQueueItem;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.http.HTTPService;
	
	/**
	 * Data model used by HTTPServiceCallQueue.
	 * 
	 * @author Kaoru Kawashima
	 * @see com.altoinu.flex.rpc.http.HTTPServiceCallQueue
	 */
	public class HTTPServiceCallQueueItem extends ServiceCallQueueItem
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param operation
		 * @param data
		 * @param resultEventHandler
		 * @param faultEventHandler
		 * @param serviceLocator
		 * 
		 */
		public function HTTPServiceCallQueueItem(operation:HTTPService,
												 data:Object = null,
												 resultEventHandler:Function = null,
												 faultEventHandler:Function = null,
												 serviceLocator:HTTPServiceLocator = null,
												 serviceLocatorQueue:ServiceCallQueue = null)
		{
			
			if (serviceLocatorQueue is HTTPServiceCallQueue)
				super(operation, data, resultEventHandler, faultEventHandler, serviceLocator, serviceLocatorQueue);
			else
				throw new Error("Specified serviceLocatorQueue is not "+getQualifiedClassName(new HTTPServiceCallQueue())+".");
			
		}
		
	}
	
}