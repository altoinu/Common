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
	
	import mx.rpc.AbstractInvoker;
	
	/**
	 * Interface to define service call queue.
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IServiceCallQueue
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Name of the queue.
		 */
		function get name():String;
		
		/**
		 * Returns true when queue is in progress.
		 */
		function get queueInProgress():Boolean;
		
		/**
		 * Contains information on service operation currently in progress.
		 */
		function get currentQueueItem():IServiceCallQueueItem;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Queues specified serviceOperation. If there is nothing in the queue, then the operation
		 * will be called right away.  Otherwise it is held until all previously queued operations complete.
		 * 
		 * @param serviceOperation Either HTTPService or Operation from a WebService to be queued.
		 * @param data Parameters to be passed.
		 * @param resultEventHandler function(ResultEvent) to be called when operation completes.
		 * @param faultEventHandler function(FaultEvent) to be called when operation fails.
		 * @param serviceLocator HTTPServiceLocator or WebServiceLocator this particular serviceOperation
		 * is part of, if any.
		 * @return 
		 * 
		 */
		function add(serviceOperation:AbstractInvoker, data:Object = null, resultEventHandler:Function = null, faultEventHandler:Function = null, serviceLocator:IServiceGroup = null):IServiceCallQueueItem
	}
	
}