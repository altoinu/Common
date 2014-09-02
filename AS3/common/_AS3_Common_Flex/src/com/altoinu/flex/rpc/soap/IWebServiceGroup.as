/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.soap
{
	
	import com.altoinu.flex.rpc.IServiceGroup;
	import com.altoinu.flex.rpc.queue.IServiceCallQueueItem;
	
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	
	public interface IWebServiceGroup extends IServiceGroup
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  serviceCallQueue
		//--------------------------------------
		
		[Deprecated(replacement="IServiceGroup.queue")]
		/**
		 * ServiceCallQueue used.
		 */
		function get serviceCallQueue():WebServiceCallQueue;
		
		[Deprecated(replacement="IServiceGroup.queue")]
		/**
		 * @private
		 */
		function set serviceCallQueue(queue:WebServiceCallQueue):void;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Queues and executes the targetOperation.  This is useful when you want to make sure
		 * only one operation is in progress.
		 * 
		 * @param targetOperation WebService operation.
		 * @param data Data to be sent to the method.
		 * @param resultEventHandler function(ResultEvent) to be called when operation completes.
		 * @param faultEventHandler function(FaultEvent) to be called when operation fails.
		 * @param queue WebServiceCallQueue to use.  If null, it will use <code>serviceCallQueue</code>.
		 * 
		 * @return 
		 * 
		 */
		function doOperation(targetOperation:Operation, data:Object = null, resultEventHandler:Function = null, faultEventHandler:Function = null, queue:WebServiceCallQueue = null):IServiceCallQueueItem;
		
		/**
		 * Queues and executes the specified operation in serviceID using data.  This is useful when you want to make sure
		 * only one operation is in progress.
		 * 
		 * @param serviceID WebService ID to use.
		 * @param operation Operation under serviceID to use.
		 * @param data Data to be sent to the method.
		 * @param resultEventHandler function(ResultEvent) to be called when operation completes.
		 * @param faultEventHandler function(FaultEvent) to be called when operation fails.
		 * @param queue WebServiceCallQueue to use.  If null, it will use <code>serviceCallQueue</code>.
		 * 
		 */
		function send(serviceID:String, operation:String, data:Object = null, resultEventHandler:Function = null, faultEventHandler:Function = null, queue:WebServiceCallQueue = null):IServiceCallQueueItem;
		
		/**
		 * Gets SOAP operation under WebService.
		 * 
		 * @param serviceID WebService ID.
		 * @param operation Operation name under WebService specified by serviceID.
		 * 
		 * @return Operation or null if specified item does not exist.
		 * 
		 */
		function getOperation(serviceID:String, operation:String):Operation;
		
		/**
		 * Gets WebService.
		 * 
		 * @param serviceId
		 * 
		 * @return 
		 * 
		 */
		function getService(serviceId:String):WebService;
		
	}
	
}