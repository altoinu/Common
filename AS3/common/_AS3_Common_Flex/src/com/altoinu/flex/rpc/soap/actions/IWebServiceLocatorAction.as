/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.soap.actions
{
	
	import com.altoinu.flash.net.servicegroup.IServiceGroupAction;
	import com.altoinu.flex.rpc.soap.WebServiceLocator;
	
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	
	/**
	 * Interface that defines properties and methods for WebServiceLocator actions.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IWebServiceLocatorAction extends IServiceGroupAction
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  webService
		//--------------------------------------
		
		/**
		 * WebService that contains Operation used by IWebServiceLocatorAction.
		 */
		function get webService():WebService;
		
		//--------------------------------------
		//  operationID
		//--------------------------------------
		
		/**
		 * ID of the Operation under <code>serviceID</code> to use.
		 */
		function get operationID():String;
		
		/**
		 * @private
		 */
		function set operationID(value:String):void
		
		//--------------------------------------
		//  operation
		//--------------------------------------
		
		/**
		 * Operation used by IWebServiceLocatorAction.
		 */
		function get operation():Operation;
		
		//--------------------------------------
		//  serviceLocator
		//--------------------------------------
		
		/**
		 * Service locator that contains WebService and Operation used by IWebServiceLocatorAction.
		 * If this is set to null, then WebServiceLocator.serviceCollections[0] is used.
		 */
		function get serviceLocator():WebServiceLocator;
		
		/**
		 * @private
		 */
		function set serviceLocator(targetServiceLocator:WebServiceLocator):void;
		
	}
	
}