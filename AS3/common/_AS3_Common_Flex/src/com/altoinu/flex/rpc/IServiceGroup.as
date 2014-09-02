/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc
{
	
	import com.altoinu.flex.rpc.queue.IServiceCallQueueItem;
	import com.altoinu.flex.rpc.queue.ServiceCallQueue;
	
	import mx.rpc.AbstractInvoker;
	import mx.rpc.http.HTTPService;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	
	public interface IServiceGroup
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  serviceCallQueue
		//--------------------------------------
		
		/**
		 * ServiceCallQueue used.
		 */
		function get queue():ServiceCallQueue;
		
		/**
		 * @private
		 */
		function set queue(queue:ServiceCallQueue):void;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Queues and executes the serviceOperation.
		 * 
		 * @param serviceOperation HTTPService or Operation to be called.
		 * @param data Data to be sent to the method.
		 * @param resultEventHandler function(ResultEvent) to be called when operation completes.
		 * @param faultEventHandler function(FaultEvent) to be called when operation fails.
		 * @param queue ServiceCallQueue to use.  If null, it will use <code>queue</code>.
		 * 
		 * @return 
		 * 
		 */
		function call(serviceOperation:AbstractInvoker,
					  data:Object = null,
					  resultEventHandler:Function = null,
					  faultEventHandler:Function = null,
					  queue:ServiceCallQueue = null):IServiceCallQueueItem;
		
		/**
		 * Queues the HTTPService call specified by serviceID
		 * 
		 * @param serviceID HTTPService ID to use.
		 * @param data Data to be sent to the method.
		 * @param resultEventHandler function(ResultEvent) to be called when HTTPService completes.
		 * @param faultEventHandler function(FaultEvent) to be called when HTTPService fails.
		 * @param queue HTTPServiceCallQueue to use for queueing the call.  If null, it will use <code>queue</code>.
		 * 
		 * @return 
		 * 
		 */
		function callHTTPService(serviceID:String,
								 data:Object = null,
								 resultEventHandler:Function = null,
								 faultEventHandler:Function = null,
								 queue:ServiceCallQueue = null):IServiceCallQueueItem;
		
		/**
		 * Queues and executes specified WebService operation.
		 * 
		 * @param webServiceID WebService ID.
		 * @param operationName WebService operation name.
		 * @param data Data to be sent to the method.
		 * @param resultEventHandler function(ResultEvent) to be called when operation completes.
		 * @param faultEventHandler function(FaultEvent) to be called when operation fails.
		 * @param queue WebServiceCallQueue to use.  If null, it will use <code>queue</code>.
		 * 
		 * @return 
		 * 
		 */
		function callWebServiceOperation(webServiceID:String,
										 operationName:String,
										 data:Object = null,
										 resultEventHandler:Function = null,
										 faultEventHandler:Function = null,
										 queue:ServiceCallQueue = null):IServiceCallQueueItem;
		
		/**
		 * Returns reference to the specified HTTPService.
		 * 
		 * @param serviceID
		 * @return 
		 * 
		 */
		function getHTTPService(serviceID:String):HTTPService;
		
		/**
		 * Returns reference to the specified WebService.
		 * 
		 * @param serviceID
		 * @return 
		 * 
		 */
		function getWebService(serviceID:String):WebService;
		
		/**
		 * Gets SOAP operation under WebService.
		 * 
		 * @param serviceID WebService ID.
		 * @param operation Operation name under WebService specified by serviceID.
		 * 
		 * @return Operation or null if specified item does not exist.
		 * 
		 */
		function getWebServiceOperation(serviceID:String, operationName:String):Operation;
		
	}
	
}