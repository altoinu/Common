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
	import com.altoinu.flex.rpc.events.ServiceCallQueueItemEvent;
	import com.altoinu.flex.rpc.http.HTTPServiceLocator;
	import com.altoinu.flex.rpc.soap.WebServiceLocator;
	
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.mx_internal;
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * initiate event is dispatched when service call defined by this queue item is about to be initiated.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.ServiceCallQueueItemEvent.INITIATE
	 * 
	 */
	[Event(name="initiate", type="com.altoinu.flex.rpc.events.ServiceCallQueueItemEvent")]
	
	/**
	 * result event is dispatched when service call made by this queue item succeeds.
	 * 
	 * @eventType mx.rpc.events.ResultEvent.RESULT
	 * 
	 */
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	
	/**
	 * fault event is dispatched when service call made by this queue item fails.
	 * 
	 * @eventType mx.rpc.events.FaultEvent.FAULT
	 * 
	 */
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	
	/**
	 * Queue item used in ServiceCallQueue.
	 * 
	 * @author Kaoru Kawashima
	 * @see com.altoinu.flex.rpc.ServiceCallQueue
	 * 
	 */
	public class ServiceCallQueueItem extends EventDispatcher implements IServiceCallQueueItem
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor.
		//
		//--------------------------------------------------------------------------
		
		/*
		public function ServiceCallQueueItem(operation:AbstractInvoker,
											 data:Object = null,
											 resultEventHandler:Function = null,
											 faultEventHandler:Function = null,
											 serviceLocator:Object = null,
											 serviceLocatorQueue:ServiceCallQueue = null)
		*/
		/**
		 * 
		 * @param operation must be either mx.rpc.http.HTTPService or mx.rpc.soap.Operation.
		 * @param data
		 * @param resultEventHandler
		 * @param faultEventHandler
		 * @param serviceLocator
		 * @param serviceLocatorQueue
		 * 
		 */
		public function ServiceCallQueueItem(operation:AbstractInvoker,
											 data:Object = null,
											 resultEventHandler:Function = null,
											 faultEventHandler:Function = null,
											 serviceLocator:IServiceGroup = null,
											 serviceLocatorQueue:ServiceCallQueue = null)
		{
			
			super();
			
			if ((operation is HTTPService) || (operation is AbstractOperation))
				_operation = operation;
			else
				throw new Error("Specified operation is not "+getQualifiedClassName(new HTTPService())+" or "+getQualifiedClassName(new AbstractOperation())+".");
			
			_data = data;
			_resultEventHandler = resultEventHandler;
			_faultEventHandler = faultEventHandler;
			
			if ((serviceLocator == null) || (serviceLocator is HTTPServiceLocator) || (serviceLocator is WebServiceLocator))
				_serviceLocator = serviceLocator;
			else
				throw new Error("Specified serviceLocator is not "+getQualifiedClassName(new HTTPServiceLocator())+" or "+getQualifiedClassName(new WebServiceLocator())+".");
			
			_serviceLocatorQueue = serviceLocatorQueue;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  operation
		//--------------------------------------
		
		private var _operation:AbstractInvoker;
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#operation
		 */
		public function get operation():AbstractInvoker
		{
			
			return _operation;
			
		}
		
		//--------------------------------------
		//  data
		//--------------------------------------
		
		private var _data:Object;
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#data
		 */
		public function get data():Object
		{
			
			return _data;
			
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			
			_data = value;
			
		}
		
		//--------------------------------------
		//  resultEventHandler
		//--------------------------------------
		
		private var _resultEventHandler:Function;
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#resultEventHandler
		 */
		public function get resultEventHandler():Function
		{
			
			return _resultEventHandler;
			
		}
		
		//--------------------------------------
		//  faultEventHandler
		//--------------------------------------
		
		private var _faultEventHandler:Function;
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#faultEventHandler
		 */
		public function get faultEventHandler():Function
		{
			
			return _faultEventHandler;
			
		}
		
		//--------------------------------------
		//  serviceLocator
		//--------------------------------------
		
		private var _serviceLocator:IServiceGroup;
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#serviceLocator
		 */
		public function get serviceLocator():IServiceGroup
		{
			
			return _serviceLocator;
			
		}
		
		//--------------------------------------
		//  serviceLocatorQueue
		//--------------------------------------
		
		private var _serviceLocatorQueue:ServiceCallQueue;
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#serviceLocatorQueue
		 */
		public function get serviceLocatorQueue():ServiceCallQueue
		{
			
			return _serviceLocatorQueue;
			
		}
		
		//--------------------------------------
		//  token
		//--------------------------------------
		
		private var _token:ServiceCallQueueItemAsyncToken = new ServiceCallQueueItemAsyncToken();
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#token
		 */
		public function get token():ServiceCallQueueItemAsyncToken
		{
			
			return _token;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueueItem#process
		 */
		public function process():AsyncToken
		{
			
			dispatchEvent(new ServiceCallQueueItemEvent(ServiceCallQueueItemEvent.INITIATE, false, false));
			
			var token:AsyncToken;
			
			if (operation is HTTPService)
			{
				
				var httpService:HTTPService = operation as HTTPService;
				httpService.addEventListener(ResultEvent.RESULT, onServiceComplete);
				httpService.addEventListener(FaultEvent.FAULT, onServiceFault);
				
				token = httpService.send(data);
				
			}
			else if (operation is AbstractOperation)
			{
				
				var webserviceOperation:AbstractOperation = operation as AbstractOperation;
				webserviceOperation.addEventListener(ResultEvent.RESULT, onServiceComplete);
				webserviceOperation.addEventListener(FaultEvent.FAULT, onServiceFault);
				
				if (data is Array)
					token = webserviceOperation.send.apply(webserviceOperation, data);
				else
					token = webserviceOperation.send.apply(webserviceOperation, [data]);
				
			}
			else
			{
				
				throw new Error("Specified operation is not "+getQualifiedClassName(new HTTPService())+" or "+getQualifiedClassName(new AbstractOperation())+".");
				
			}
			
			return token;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onServiceComplete(event:ResultEvent):void
		{
			
			event.currentTarget.removeEventListener(ResultEvent.RESULT, onServiceComplete);
			event.currentTarget.removeEventListener(FaultEvent.FAULT, onServiceFault);
			
			_token.sourceToken = event.token;
			_token.mx_internal::applyResult(event);
			
			dispatchEvent(event.clone());
			
		}
		
		private function onServiceFault(event:FaultEvent):void
		{
			
			event.currentTarget.removeEventListener(ResultEvent.RESULT, onServiceComplete);
			event.currentTarget.removeEventListener(FaultEvent.FAULT, onServiceFault);
			
			_token.sourceToken = event.token;
			_token.mx_internal::applyFault(event);
			
			dispatchEvent(event.clone());
			
		}
		
	}
	
}