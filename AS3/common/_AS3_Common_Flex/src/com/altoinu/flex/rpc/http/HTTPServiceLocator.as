/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.http
{
	
	import com.altoinu.flex.rpc.ServiceGroup;
	import com.altoinu.flex.rpc.events.HTTPServiceLocatorEvent;
	import com.altoinu.flex.rpc.queue.IServiceCallQueueItem;
	import com.altoinu.flex.rpc.queue.ServiceCallQueue;
	
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * result event is dispatched when any of the calls to HTTPService succeeds.
	 * This event is dispatched after resultEventHandler you specify for <code>send</code>
	 * method completes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.HTTPServiceLocatorEvent.RESULT
	 * 
	 */
	[Event(name="result", type="com.altoinu.flex.rpc.events.HTTPServiceLocatorEvent")]
	
	/**
	 * fault event is dispatched when any of the calls to HTTPService fails.
	 * This event is dispatched after faultEventHandler you specify for <code>send</code>
	 * method completes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.HTTPServiceLocatorEvent.FAULT
	 * 
	 */
	[Event(name="fault", type="com.altoinu.flex.rpc.events.HTTPServiceLocatorEvent")]
	
	
	/**
	 * HTTPServiceLocator is a base class that is extended into mxml component to contain several HTTPService used
	 * in an application so they can all be placed at a single location.
	 * 
	 * @example Here is an example of how to extend this class into mxml component.  You can then call specific HTTPService by
	 * using <code>send</code> method.
	 * <listing version="3.0">
	 * &lt;http:HTTPServiceLocator
	 * &#xA0;&#xA0;&#xA0;xmlns:mx="http://www.adobe.com/2006/mxml"
	 * &#xA0;&#xA0;&#xA0;xmlns:http="com.altoinu.flex.rpc.http.&#42;"&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;mx:HTTPService id="servicename1"/&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;mx:HTTPService id="servicename2"/&gt;
	 * &lt;/http:HTTPServiceLocator&gt;
	 * </listing>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */	
	public class HTTPServiceLocator extends ServiceGroup
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
		 * Gets reference to the specified HTTPServiceLocator instance.
		 * @param name
		 * @return 
		 * 
		 */
		public static function getServiceGroup(name:String):HTTPServiceLocator
		{
			
			var numGroups:int = serviceCollections.length;
			for (var i:int = 0; i < numGroups; i++)
			{
				
				if (HTTPServiceLocator(serviceCollections[i]).id == name)
					return HTTPServiceLocator(serviceCollections[i]);
				
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
		public function HTTPServiceLocator()
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
		
		private var _queue:ServiceCallQueue = HTTPServiceCallQueue.getInstance();
		
		[Bindable(event="queueChange")]
		/**
		 * ServiceCallQueue used.
		 * 
		 * @default HTTPServiceCallQueue.getInstance().
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
			
			_queue = newQueue as HTTPServiceCallQueue;
			
			dispatchEvent(new Event("queueChange"));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  appendPOSTDataToURL
		//--------------------------------------
		
		private var _appendPOSTDataToURL:Boolean = false;
		
		[Inspectable(category="Other", enumeration="true,false", defaultValue="false")]
		/**
		 * If set to true, then ServiceCallQueue used by this HTTPServiceLocator will append same parameters as querystring on the URL
		 * being called for each HTTPService.
		 */
		public function get appendPOSTDataToURL():Boolean
		{
			
			return _appendPOSTDataToURL;
			
		}
		
		/**
		 * @private
		 */
		public function set appendPOSTDataToURL(value:Boolean):void
		{
			
			_appendPOSTDataToURL = value;
			
		}
		
		//--------------------------------------
		//  serviceCallQueue
		//--------------------------------------
		
		private var _serviceCallQueue:HTTPServiceCallQueue = HTTPServiceCallQueue.getInstance();
		
		[Deprecated(replacement="HTTPServiceLocator.queue")]
		[Bindable(event="queueChange")]
		/**
		 * ServiceCallQueue used.
		 * 
		 * @default HTTPServiceCallQueue.getInstance().
		 */
		public function get serviceCallQueue():HTTPServiceCallQueue
		{
			
			return queue as HTTPServiceCallQueue;
			
		}
		
		[Deprecated(replacement="HTTPServiceLocator.queue")]
		/**
		 * @private
		 */
		public function set serviceCallQueue(queue:HTTPServiceCallQueue):void
		{
			
			this.queue = queue;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Queues the HTTPService call specified by serviceID using data.  This is useful when you want to make sure
		 * only one HTTPService is in progress.
		 * 
		 * @param serviceID HTTPService ID to use.
		 * @param data Data to be sent to the method.
		 * @param resultEventHandler function(ResultEvent) to be called when HTTPService completes.
		 * @param faultEventHandler function(FaultEvent) to be called when HTTPService fails.
		 * @param queue HTTPServiceCallQueue to use for queueing the call.  If null, it will use <code>HTTPServiceLocator.queue</code>.
		 * 
		 * @return 
		 * 
		 */
		public function send(serviceID:String, data:Object = null, resultEventHandler:Function = null, faultEventHandler:Function = null, queue:HTTPServiceCallQueue = null):IServiceCallQueueItem
		{
			
			if (getService(serviceID) == null)
			{
				
				throw new Error("HTTPService with specified service ID does not exist.");
				
			}
			else
			{
				
				// Add result event hanlder to the operation
				var onOperationComplete:Function = function(event:ResultEvent):void
				{
					
					// call specified event handler
					if (resultEventHandler != null)
						resultEventHandler(event);
					
					dispatchEvent(new HTTPServiceLocatorEvent(HTTPServiceLocatorEvent.RESULT, false, false, getService(serviceID), event, null));
					
				};
				
				var onOperationFault:Function = function(event:FaultEvent):void
				{
					
					// call specified event handler
					if (faultEventHandler != null)
						faultEventHandler(event);
					
					dispatchEvent(new HTTPServiceLocatorEvent(HTTPServiceLocatorEvent.FAULT, false, false, getService(serviceID), null, event));
					
				};
				
				return call(getService(serviceID), data, onOperationComplete, onOperationFault, queue);
				
				/*
				// Assign operation to queue
				if (queue == null)
					return this.queue.add(getService(serviceID), data, onOperationComplete, onOperationFault, this);
				else
					return queue.add(getService(serviceID), data, onOperationComplete, onOperationFault, this);
				*/
				
			}
			
		}
		
		/**
		 * Returns reference to the specified HTTPService.
		 * 
		 * @param serviceId
		 * 
		 * @return 
		 * 
		 */
		public function getService(serviceId:String):HTTPService
		{
			
			if(this.hasOwnProperty(serviceId) && (this[serviceId] is HTTPService))
				return this[serviceId];
			else
				return null;
			
		}
		
	}
	
}