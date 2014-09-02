/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.soap
{
	
	import com.altoinu.flex.rpc.queue.ServiceCallQueue;
	
	/**
	 * Queues WebService operation calls so they are executed in order. Normally, you do not have to
	 * use this class directly since WebServiceLocator handles most of the heavy lifting using this class.
	 *  
	 * @author Kaoru Kawashima
	 * 
	 * @see com.altoinu.flex.rpc.soap.WebServiceLocator
	 */
	public class WebServiceCallQueue extends ServiceCallQueue
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class resources
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static var _instance:WebServiceCallQueue;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns reference to the instance of WebServiceCallQueue through Singleton model.
		 * 
		 * @return instance of WebServiceCallQueue
		 */
		public static function getInstance():WebServiceCallQueue
		{
			
			if (!_instance)
				_instance = new WebServiceCallQueue();
			
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
		public function WebServiceCallQueue():void
		{
			
			super();
			
		}
		
	}
	
}