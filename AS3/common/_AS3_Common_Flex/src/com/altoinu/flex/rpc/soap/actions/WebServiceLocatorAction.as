/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.soap.actions
{
	
	import com.altoinu.flex.rpc.soap.WebServiceLocator;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * result event is dispatched when WebServices initiated by this action completes successfully.
	 * 
	 * @eventType mx.rpc.events.ResultEvent.RESULT
	 * 
	 */
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	
	/**
	 * fault event is dispatched when WebServices initiated by this action fails.
	 * 
	 * @eventType mx.rpc.events.FaultEvent.FAULT
	 * 
	 */
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	
	/**
	 * Base class to define and execute action flow using WebService in a WebServiceLocator.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class WebServiceLocatorAction extends EventDispatcher implements IWebServiceLocatorAction
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param serviceID ID of the WebService in <code>serviceLocator</code> that contains operation to be used.
		 * @param operationID ID of the Operation under <code>serviceID</code> to use.
		 * @param serviceLocator (Optional) Service locator that contains WebService and operation to be used.
		 * If this is set to null, then WebServiceLocator.serviceCollections[0] is used.
		 * 
		 */
		public function WebServiceLocatorAction(serviceID:String = null, operationID:String = null, serviceLocator:WebServiceLocator = null)
		{
			
			super();
			
			this.serviceID = serviceID;
			this.operationID = operationID;
			this.serviceLocator = serviceLocator;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  serviceID
		//--------------------------------------
		
		private var _serviceID:String;
		
		/**
		 * @copy com.altoinu.flash.net.servicegroup.IServiceGroupAction#serviceID
		 */
		public function get serviceID():String
		{
			
			return _serviceID;
			
		}
		
		/**
		 * @private
		 */
		public function set serviceID(value:String):void
		{
			
			_serviceID = value;
			
		}
		
		//--------------------------------------
		//  webService
		//--------------------------------------
		
		/**
		 * @copy com.altoinu.flex.rpc.soap.actions.IWebServiceLocatorAction#webService
		 */
		public function get webService():WebService
		{
			
			return serviceLocator.getService(serviceID);
			
		}
		
		//--------------------------------------
		//  operationID
		//--------------------------------------
		
		private var _operationID:String;
		
		/**
		 * @copy com.altoinu.flex.rpc.soap.actions.IWebServiceLocatorAction#operationID
		 */
		public function get operationID():String
		{
			
			return _operationID;
			
		}
		
		/**
		 * @private
		 */
		public function set operationID(value:String):void
		{
			
			_operationID = value;
			
		}
		
		//--------------------------------------
		//  operation
		//--------------------------------------
		
		private var _operation:Operation;
		
		/**
		 * @copy com.altoinu.flex.rpc.soap.actions.IWebServiceLocatorAction#operation
		 */
		public function get operation():Operation
		{
			
			return serviceLocator.getOperation(serviceID, operationID);
			
		}
		
		//--------------------------------------
		//  serviceLocator
		//--------------------------------------
		
		private var _serviceLocator:WebServiceLocator;
		
		/**
		 * @copy com.altoinu.flex.rpc.soap.actions.IWebServiceLocatorAction#serviceLocator
		 */
		public function get serviceLocator():WebServiceLocator
		{
			
			if (_serviceLocator != null)
				return _serviceLocator;
			else
				return WebServiceLocator.serviceCollections[0];
			
		}
		
		/**
		 * @private
		 */
		public function set serviceLocator(targetServiceLocator:WebServiceLocator):void
		{
			
			_serviceLocator = targetServiceLocator;
			
		}
		
		//--------------------------------------
		//  isProcessing
		//--------------------------------------
		
		private var __isProcessing:int = 0;
		
		private function get _isProcessing():int
		{
			
			return __isProcessing;
			
		}
		
		private function set _isProcessing(value:int):void
		{
			
			if (value > 0)
				__isProcessing = value;
			else
				__isProcessing = 0;
			
			dispatchEvent(new Event("isProcessingChange"));
			
		}
		
		[Bindable(event="isProcessingChange")]
		public function get isProcessing():Boolean
		{
			
			return _isProcessing > 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.net.servicegroup.IServiceGroupAction#send()
		 */
		public function send(parameter:Object = null):void
		{
			
			if (serviceID == null)
			{
				
				throw new Error("serviceID for WebServiceLocatorAction is not set.");
				
			}
			else if (operationID == null)
			{
				
				throw new Error("operationID for WebServiceLocatorAction is not set.");
				
			}
			else
			{
				
				_isProcessing++;
				serviceLocator.doOperation(operation, parameter, actionComplete, actionFault);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  private event handlers
		//
		//--------------------------------------------------------------------------
		
		private function actionComplete(event:ResultEvent):void
		{
			
			onOperationComplete(event);
			
			_isProcessing--;
			
		}
		
		private function actionFault(event:FaultEvent):void
		{
			
			onOperationFault(event);
			
			_isProcessing--;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler executed at FaultEvent of the WebService used.
		 * @param event
		 * 
		 */
		protected function onOperationComplete(event:ResultEvent):void
		{
			
			// Dispatch the same result event
			dispatchEvent(event);
			
		}
		
		/**
		 * Event handler executed at FaultEvent of the WebService used.
		 * @param event
		 * 
		 */
		protected function onOperationFault(event:FaultEvent):void
		{
			
			// Dispatch the same fault event
			dispatchEvent(event);
			
		}
		
	}
	
}