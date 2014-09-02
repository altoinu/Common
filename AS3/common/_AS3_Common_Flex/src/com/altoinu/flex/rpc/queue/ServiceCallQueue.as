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
	import com.altoinu.flex.rpc.events.ServiceCallQueueEvent;
	import com.altoinu.flex.rpc.http.HTTPServiceCallQueueItem;
	import com.altoinu.flex.rpc.http.HTTPServiceLocator;
	import com.altoinu.flex.rpc.soap.WebServiceCallQueueItem;
	import com.altoinu.flex.rpc.soap.WebServiceLocator;
	
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.soap.Operation;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * Dispatched when first queue item executes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.ServiceCallQueueEvent.QUEUE_START
	 * 
	 */
	[Event(name="queueStart", type="com.altoinu.flex.rpc.events.ServiceCallQueueEvent")]
	
	/**
	 * Dispatched when next queue item executes.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.ServiceCallQueueEvent.EXECUTE_NEXT_QUEUE_ITEM
	 * 
	 */
	[Event(name="executeNextQueueItem", type="com.altoinu.flex.rpc.events.ServiceCallQueueEvent")]
	
	/**
	 * Dispatched when last queue item has finished executing.
	 * 
	 * @eventType com.altoinu.flex.rpc.events.ServiceCallQueueEvent.QUEUE_END
	 * 
	 */
	[Event(name="queueEnd", type="com.altoinu.flex.rpc.events.ServiceCallQueueEvent")]
	
	/**
	 * Queues remote procedure calls (RPC, such as HTTPService and WebService Operation) and execute them in order.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @see com.altoinu.flex.rpc.http.HTTPSericeLocator
	 */
	public class ServiceCallQueue extends EventDispatcher implements IServiceCallQueue
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class resources
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static var _instance:ServiceCallQueue;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns reference to the instance of ServiceCallQueue through Singleton model.
		 * 
		 * @return instance of ServiceCallQueue
		 */
		public static function getInstance():ServiceCallQueue
		{
			
			if (!_instance)
				_instance = new ServiceCallQueue();
			
			return _instance;
			
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
		public function ServiceCallQueue()
		{
			
			super();
			
			if (name == null)
			{
				
				var newName:String = getQualifiedClassName(this);
				name = newName.substr(newName.lastIndexOf("::") + 2);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected var _queue:ArrayCollection = new ArrayCollection();
		
		/**
		 * @private
		 */
		protected var _queueCursor:IViewCursor;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  name
		//--------------------------------------
		
		private var _name:String;
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueue#name
		 */
		public function get name():String
		{
			
			return _name;
			
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			
			_name = value;
			
		}
		
		//--------------------------------------
		//  queueInProgress
		//--------------------------------------
		
		/**
		 * @private
		 */
		protected var _queueInProgress:Boolean = false;
		
		[Bindable(event="queueStart")]
		[Bindable(event="executeNextQueueItem")]
		[Bindable(event="queueEnd")]
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueue#queueInProgress
		 */
		public function get queueInProgress():Boolean
		{
			
			return _queueInProgress;
			
		}
		
		//--------------------------------------
		//  currentQueueItem
		//--------------------------------------
		
		[Bindable(event="queueStart")]
		[Bindable(event="executeNextQueueItem")]
		[Bindable(event="queueEnd")]
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueue#currentQueueItem
		 */
		public function get currentQueueItem():IServiceCallQueueItem
		{
			
			if ((_queueCursor != null) && (_queueCursor.current != null))
				return _queueCursor.current as IServiceCallQueueItem;
			else
				return null;
				
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Makes the actual web service call on specified queue item.
		 * @param queueItem
		 * 
		 */
		protected function sendData(queueItem:IServiceCallQueueItem):void
		{
			
			queueItem.process();
			
		}
		
		/**
		 * Processes next item in queue.
		 * @return Reference to the next queue item processed, or null if there are no more.
		 * 
		 */
		protected function processNextItem():IServiceCallQueueItem
		{
			
			var previousQueueItem:IServiceCallQueueItem = currentQueueItem;
			var prevOperationName:String = getOperationName(previousQueueItem.operation);
			var nextQueueItem:IServiceCallQueueItem;
			
			if (_queueCursor.moveNext())
			{
				
				// If there's another item in our queue, execute it
				nextQueueItem = currentQueueItem;
				var nextOperationName:String = getOperationName(nextQueueItem.operation);
				trace(name+", "+prevOperationName+" COMPLETE, EXECUTING NEXT - "+nextOperationName);
				
				sendData(nextQueueItem);
				
				dispatchEvent(new ServiceCallQueueEvent(ServiceCallQueueEvent.EXECUTE_NEXT_QUEUE_ITEM, false, false, nextQueueItem, previousQueueItem));
				
			}
			else
			{
				
				trace(name+", "+prevOperationName+" COMPLETE");
				
				_queueInProgress = false;
				
				dispatchEvent(new ServiceCallQueueEvent(ServiceCallQueueEvent.QUEUE_END, false, false, nextQueueItem, previousQueueItem));
				
			}
			
			return nextQueueItem;
			
		}
		
		protected function getOperationName(targetOperation:AbstractInvoker):String
		{
			
			if ((targetOperation is AbstractOperation) || targetOperation.hasOwnProperty("name"))
				return targetOperation.toString() + ": " + targetOperation["name"];
			else if (targetOperation is HTTPService)
				return targetOperation.toString() + ": " + HTTPService(targetOperation).url;
			else
				return targetOperation.toString();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flex.rpc.IServiceCallQueue#add()
		 */
		public function add(serviceOperation:AbstractInvoker, data:Object = null,
							resultEventHandler:Function = null, faultEventHandler:Function = null,
							serviceLocator:IServiceGroup = null):IServiceCallQueueItem
		{
			
			var newQueueItem:IServiceCallQueueItem;
			
			if (serviceOperation is HTTPService)
			{
				
				newQueueItem = new HTTPServiceCallQueueItem(serviceOperation as HTTPService, data, resultEventHandler, faultEventHandler, serviceLocator as HTTPServiceLocator, this);
				
			}
			else if (serviceOperation is Operation)
			{
				
				newQueueItem = new WebServiceCallQueueItem(serviceOperation as Operation, data, resultEventHandler, faultEventHandler, serviceLocator as WebServiceLocator, this);
				
			}
			else if (serviceOperation is AbstractOperation)
			{
				
				newQueueItem = new ServiceCallQueueItem(serviceOperation, data, resultEventHandler, faultEventHandler, serviceLocator, this);
				
			}
			else
			{
				
				// serviceOperation is not HTTPService or Operation
				
				throw new Error("Specified operation is not "+getQualifiedClassName(new HTTPService())+" or "+getQualifiedClassName(new AbstractOperation())+".");
				
				return;
				
			}
			
			newQueueItem.addEventListener(ResultEvent.RESULT, onOperationComplete);
			newQueueItem.addEventListener(FaultEvent.FAULT, onOperationFaultEvent);
			
			_queueInProgress = true;
			
			var operationName:String = getOperationName(serviceOperation);
			
			if (_queue.length == 0)
			{
					
				// Queue doesn't exist yet.  Create it.
				// Execute this operation immediately.
				
				trace(name+" QUEUE; EXECUTING FIRST OPERATION - "+operationName);
				_queue.addItem(newQueueItem);
				_queueCursor = _queue.createCursor();
				
				sendData(newQueueItem);
				
				dispatchEvent(new ServiceCallQueueEvent(ServiceCallQueueEvent.QUEUE_START, false, false, newQueueItem, null));
				
			}
			else if (_queueCursor.afterLast)
			{
				
				// The last operation finished already.
				// Execute this operation immediately.
				_queue.removeAll();	 // Do some garbage collection
				
				trace(name+" QUEUED. EXECUTING - "+operationName);
				_queue.addItem(newQueueItem);
				_queueCursor = _queue.createCursor();
				
				sendData(newQueueItem);
				
				dispatchEvent(new ServiceCallQueueEvent(ServiceCallQueueEvent.QUEUE_START, false, false, newQueueItem, null));
				
			}
			else
			{
				
				// Add this item to the end of the queue
				// and wait.
				trace(name+" QUEUED - "+operationName);
				_queue.addItem(newQueueItem);
				
			}
			
			return newQueueItem;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Executed when a service operation completes.
		 * @param event
		 * 
		 */
		protected function onOperationComplete(event:ResultEvent):void
		{
			
			event.currentTarget.removeEventListener(ResultEvent.RESULT, onOperationComplete);
			event.currentTarget.removeEventListener(FaultEvent.FAULT, onOperationFaultEvent);
			
			var queueItem:IServiceCallQueueItem = event.currentTarget as IServiceCallQueueItem;
			
			// Execute event listener assigned to this queue item
			if (queueItem.resultEventHandler != null)
				queueItem.resultEventHandler(event);
			
			processNextItem();
			
		}
		
		/**
		 * Executed when a service operation fails.
		 * @param event
		 * 
		 */
		protected function onOperationFaultEvent(event:FaultEvent):void
		{
			
			// FaultEvent............ ignore this and lets go to the next one
			
			event.currentTarget.removeEventListener(ResultEvent.RESULT, onOperationComplete);
			event.currentTarget.removeEventListener(FaultEvent.FAULT, onOperationFaultEvent);
			
			var queueItem:IServiceCallQueueItem = event.currentTarget as IServiceCallQueueItem;
			
			// Execute event listener assigned to this queue item
			if (queueItem.faultEventHandler != null)
				queueItem.faultEventHandler(event);
			
			var operationName:String = getOperationName(queueItem.operation);
			
			trace("FaultEvent on: "+operationName);
			processNextItem();
			
		}
		
	}
	
}