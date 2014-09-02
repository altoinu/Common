/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.soap
{
	
	import com.altoinu.flex.rpc.ServiceGroup;
	import com.altoinu.flex.rpc.events.WebServiceLocatorEvent;
	import com.altoinu.flex.rpc.queue.IServiceCallQueueItem;
	import com.altoinu.flex.rpc.queue.ServiceCallQueue;
	
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * result event is dispatched when any of the calls to WebServices succeeds.
	 * This event is dispatched after resultEventHandler you specify for <code>send</code>
	 * method completes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.WebServiceLocatorEvent.RESULT
	 * 
	 */
	[Event(name="result", type="com.altoinu.flex.rpc.events.WebServiceLocatorEvent")]
	
	/**
	 * fault event is dispatched when any of the calls to WebServices fails.
	 * This event is dispatched after faultEventHandler you specify for <code>send</code>
	 * method completes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.WebServiceLocatorEvent.FAULT
	 * 
	 */
	[Event(name="fault", type="com.altoinu.flex.rpc.events.WebServiceLocatorEvent")]
	
	
	/**
	 * WebServiceLocator is a base class that is extended into mxml component to contain several WebServices used
	 * in an application so they can all be placed at a single location.
	 * 
	 * @example Here is an example of how to extend this class into mxml component.  You can then call specific WebService by
	 * using <code>send</code> method.
	 * <listing version="3.0">
	 * &lt;soap:WebserviceLocator
	 * &#xA0;&#xA0;&#xA0;xmlns:mx="http://www.adobe.com/2006/mxml"
	 * &#xA0;&#xA0;&#xA0;xmlns:soap="com.altoinu.flex.rpc.soap.&#42;"&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;mx:WebService id="servicename1" wsdl="wsdlfile1.wsdl"&gt;
	 * &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&lt;mx:operation...
	 * &#xA0;&#xA0;&#xA0;&lt;mx:/WebService&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;mx:WebService id="servicename2" wsdl="wsdlfile2.wsdl"&gt;
	 * &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&lt;mx:operation...
	 * &#xA0;&#xA0;&#xA0;&lt;mx:/WebService&gt;
	 * &lt;/soap:WebserviceLocator&gt;
	 * </listing>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */	
	public class WebServiceLocator extends ServiceGroup implements IWebServiceGroup
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  serviceCollections
		//--------------------------------------
		
		private static var _serviceCollections:Array = [];
		
		/**
		 * Array that contains references to all WebServiceLocators created.
		 */
		public static function get serviceCollections():Array
		{
			
			return _serviceCollections.concat();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets reference to the specified WebServiceLocator instance.
		 * @param name
		 * @return 
		 * 
		 */
		public static function getServiceLocator(name:String):WebServiceLocator
		{
			
			var numGroups:int = serviceCollections.length;
			for (var i:int = 0; i < numGroups; i++)
			{
				
				if (WebServiceLocator(serviceCollections[i]).id == name)
					return WebServiceLocator(serviceCollections[i]);
				
			}
			
			return null;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function WebServiceLocator()
		{
			
			super();
			
			_serviceCollections.push(this);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  queue
		//--------------------------------------
		
		private var _queue:ServiceCallQueue = WebServiceCallQueue.getInstance();
		
		[Bindable(event="queueChange")]
		/**
		 * ServiceCallQueue used.
		 * 
		 * @default WebServiceCallQueue.getInstance().
		 */
		override public function get queue():ServiceCallQueue
		{
			
			return _queue;
			
		}
		
		/**
		 * @private
		 */
		override public function set queue(newQueue:ServiceCallQueue):void
		{
			
			_queue = newQueue as WebServiceCallQueue;
			
			dispatchEvent(new Event("queueChange"));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  serviceCallQueue
		//--------------------------------------
		
		private var _serviceCallQueue:WebServiceCallQueue = WebServiceCallQueue.getInstance();
		
		[Deprecated(replacement="WebServiceCallQueue.queue")]
		[Bindable(event="queueChange")]
		/**
		 * ServiceCallQueue used.
		 * 
		 * @default WebServiceCallQueue.getInstance().
		 */
		public function get serviceCallQueue():WebServiceCallQueue
		{
			
			return queue as WebServiceCallQueue;
			
		}
		
		[Deprecated(replacement="WebServiceCallQueue.queue")]
		/**
		 * @private
		 */
		public function set serviceCallQueue(queue:WebServiceCallQueue):void
		{
			
			this.queue = queue;
			
		}
		
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
		public function doOperation(targetOperation:Operation, data:Object = null, resultEventHandler:Function = null, faultEventHandler:Function = null, queue:WebServiceCallQueue = null):IServiceCallQueueItem
		{
			
			// Add result event hanlder to the operation
			var onOperationComplete:Function = function(event:ResultEvent):void
			{
				
				// and call specified event handler
				if (resultEventHandler != null)
					resultEventHandler(event);
				
				dispatchEvent(new WebServiceLocatorEvent(WebServiceLocatorEvent.RESULT, false, false, targetOperation.service, targetOperation, event, null));
				
			};
			
			var onOperationFault:Function = function(event:FaultEvent):void
			{
				
				// and call specified event handler
				if (faultEventHandler != null)
					faultEventHandler(event);
				
				dispatchEvent(new WebServiceLocatorEvent(WebServiceLocatorEvent.FAULT, false, false, targetOperation.service, targetOperation, null, event));
				
			};
			
			return call(targetOperation, data, onOperationComplete, onOperationFault, queue);
			
			/*
			// Assign operation to queue
			if (queue == null)
				return this.queue.add(targetOperation, data, onOperationComplete, onOperationFault, this);
			else
				return queue.add(targetOperation, data, onOperationComplete, onOperationFault, this);
			*/
			
		}
		
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
		public function send(serviceID:String, operation:String, data:Object = null, resultEventHandler:Function = null, faultEventHandler:Function = null, queue:WebServiceCallQueue = null):IServiceCallQueueItem
		{
			
			if (getOperation(serviceID, operation) == null)
			{
				
				throw new Error("Webservice/Operation with specified serviceID and/or operation does not exist.");
				return null;
				
			}
			else
			{
				
				return doOperation(getOperation(serviceID, operation), data, resultEventHandler, faultEventHandler, queue);
				
			}
			
		}
		
		/**
		 * Gets SOAP operation under WebService.
		 * 
		 * @param serviceID WebService ID.
		 * @param operation Operation name under WebService specified by serviceID.
		 * 
		 * @return Operation or null if specified item does not exist.
		 * 
		 */
		public function getOperation(serviceID:String, operation:String):Operation
		{
			
			if (getService(serviceID) != null)
			{
				
				return getService(serviceID)[operation];
				
			}
			
			return null;
			
		}
		
		/**
		 * Gets WebService.
		 * 
		 * @param serviceId
		 * 
		 * @return 
		 * 
		 */
		public function getService(serviceId:String):WebService
		{
			
			if((this.hasOwnProperty(serviceId)) && (this[serviceId] is WebService))
				return this[serviceId];
			else
				return null;
			
		}
		
	}
	
}