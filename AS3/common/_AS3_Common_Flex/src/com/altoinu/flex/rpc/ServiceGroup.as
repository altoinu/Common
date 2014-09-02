/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc
{
	
	import com.altoinu.flex.rpc.events.ServiceGroupEvent;
	import com.altoinu.flex.rpc.queue.IServiceCallQueueItem;
	import com.altoinu.flex.rpc.queue.ServiceCallQueue;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.rpc.AbstractInvoker;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * result event is dispatched when any of the calls to service succeeds.
	 * This event is dispatched after resultEventHandler you specify for <code>call</code>
	 * method completes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.ServiceGroupEvent.SERVICE_RESULT
	 * 
	 */
	[Event(name="serviceResult", type="com.altoinu.flex.rpc.events.ServiceGroupEvent")]
	
	/**
	 * fault event is dispatched when any of the calls to service fails.
	 * This event is dispatched after faultEventHandler you specify for <code>call</code>
	 * method completes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.ServiceGroupEvent.SERVICE_FAULT
	 * 
	 */
	[Event(name="serviceFault", type="com.altoinu.flex.rpc.events.ServiceGroupEvent")]
	
	/**
	 * ServiceGroup is a base class that is extended into mxml component to contain several
	 * HTTPServices and WebServices used in an application so they can all be placed at a single location.
	 * 
	 * @example Here is an example of how to extend this class into mxml component. You can then call specific
	 * service by using <code>call</code> method:
	 * <listing version="3.0">
	 * &lt;rpc:ServiceGroup
	 * &#xA0;&#xA0;&#xA0;xmlns:fx="http://ns.adobe.com/mxml/2009"
	 * &#xA0;&#xA0;&#xA0;xmlns:s="library://ns.adobe.com/flex/spark"
	 * &#xA0;&#xA0;&#xA0;xmlns:mx="library://ns.adobe.com/flex/mx"
	 * &#xA0;&#xA0;&#xA0;xmlns:rpc="com.altoinu.flex.rpc.&#42;"&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;s:HTTPService id="httpservicename1"/&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;s:HTTPService id="httpservicename2"/&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;s:HTTPService id="httpservicename3"/&gt;
	 * ...
	 * 
	 * &#xA0;&#xA0;&#xA0;&lt;s:WebService id="webservicename1" wsdl="wsdlfile1.wsdl"&gt;
	 * &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&lt;s:operation
	 * ...
	 * &#xA0;&#xA0;&#xA0;&lt;s:/WebService&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;s:WebService id="webservicename2" wsdl="wsdlfile2.wsdl"&gt;
	 * &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&lt;s:operation
	 * ...
	 * &#xA0;&#xA0;&#xA0;&lt;s:/WebService&gt;
	 * &#xA0;&#xA0;&#xA0;&lt;s:WebService id="webservicename3" wsdl="wsdlfile3.wsdl"&gt;
	 * &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&lt;s:operation
	 * ...
	 * &#xA0;&#xA0;&#xA0;&lt;s:/WebService&gt;
	 * &lt;/rpc:ServiceGroup&gt;
	 * </listing>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */	
	public class ServiceGroup extends UIComponent implements IServiceGroup
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function ServiceGroup()
		{
			
			super();
			
			includeInLayout = false;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  includeInLayout
		//--------------------------------------
		
		[Bindable("includeInLayoutChanged")]
		[Inspectable(category="General", defaultValue="true")]
		/**
		 * ServiceGroup is an invisible component, so it will not be included in layout. This property is always false.
		 */
		override public function get includeInLayout():Boolean
		{
			
			return super.includeInLayout;
			
		}
		
		/**
		 * @private
		 */
		override public function set includeInLayout(value:Boolean):void
		{
			
			super.includeInLayout = false;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  queue
		//--------------------------------------
		
		private var _queue:ServiceCallQueue = ServiceCallQueue.getInstance();
		
		[Bindable(event="queueChange")]
		/**
		 * ServiceCallQueue used.
		 * 
		 * @default ServiceCallQueue.getInstance().
		 */
		public function get queue():ServiceCallQueue
		{
			
			return _queue;
			
		}
		
		/**
		 * @private
		 */
		public function set queue(newQueue:ServiceCallQueue):void
		{
			
			_queue = newQueue;
			
			dispatchEvent(new Event("queueChange"));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceGroup#call()
		 */
		public function call(serviceOperation:AbstractInvoker,
							 data:Object = null,
							 resultEventHandler:Function = null,
							 faultEventHandler:Function = null,
							 queue:ServiceCallQueue = null):IServiceCallQueueItem
		{
			
			var httpService:HTTPService = (serviceOperation is HTTPService) ? serviceOperation as HTTPService : null;
			var operation:Operation = (serviceOperation is Operation) ? serviceOperation as Operation : null;
			
			// Add result event hanlder to the operation
			var onOperationComplete:Function = function(event:ResultEvent):void
			{
				
				// and call specified event handler
				if (resultEventHandler != null)
					resultEventHandler(event);
				
				dispatchEvent(new ServiceGroupEvent(ServiceGroupEvent.SERVICE_RESULT, false, false, httpService, operation, event, null));
				
			}
			
			var onOperationFault:Function = function(event:FaultEvent):void
			{
				
				// and call specified event handler
				if (faultEventHandler != null)
					faultEventHandler(event);
				
				dispatchEvent(new ServiceGroupEvent(ServiceGroupEvent.SERVICE_FAULT, false, false, httpService, operation, null, event));
				
			}
			
			// Assign operation to queue
			if (queue == null)
				return this.queue.add(serviceOperation, data, onOperationComplete, onOperationFault, this);
			else
				return queue.add(serviceOperation, data, onOperationComplete, onOperationFault, this);
			
		}
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceGroup#callHTTPService()
		 */
		public function callHTTPService(serviceID:String,
										data:Object = null,
										resultEventHandler:Function = null,
										faultEventHandler:Function = null,
										queue:ServiceCallQueue = null):IServiceCallQueueItem
		{
			
			if (getHTTPService(serviceID) == null)
			{
				
				throw new Error("HTTPService with specified service ID does not exist.");
				return null;
				
			}
			else
			{
				
				return call(getHTTPService(serviceID), data, resultEventHandler, faultEventHandler, queue);
				
			}
			
		}
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceGroup#callWebServiceOperation()
		 */
		public function callWebServiceOperation(webServiceID:String,
												operationName:String,
												data:Object = null,
												resultEventHandler:Function = null,
												faultEventHandler:Function = null,
												queue:ServiceCallQueue = null):IServiceCallQueueItem
		{
			
			if (getWebServiceOperation(webServiceID, operationName) == null)
			{
				
				throw new Error("Webservice/Operation with specified webServiceID and/or operationName does not exist.");
				return null;
				
			}
			else
			{
				
				return call(getWebServiceOperation(webServiceID, operationName), data, resultEventHandler, faultEventHandler, queue);
				
			}
			
		}
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceGroup#getHTTPService()
		 */
		public function getHTTPService(serviceID:String):HTTPService
		{
			
			if (this.hasOwnProperty(serviceID) && (this[serviceID] is HTTPService))
				return this[serviceID];
			else
				return null;
			
		}
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceGroup#getWebService()
		 */
		public function getWebService(serviceID:String):WebService
		{
			
			if (this.hasOwnProperty(serviceID) && (this[serviceID] is WebService))
				return this[serviceID];
			else
				return null;
			
		}
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceGroup#getWebServiceOperation()
		 */
		public function getWebServiceOperation(serviceID:String, operationName:String):Operation
		{
			
			if (getWebService(serviceID) != null)
				return getWebService(serviceID)[operationName];
			else
				return null;
			
		}
		
	}
	
}