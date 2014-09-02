/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.net.servicegroup
{
	
	/**
	 * Interface that defines properties and methods for ServiceGroup actions.
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IServiceGroupAction
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  serviceID
		//--------------------------------------
		
		/**
		 * ID of the service/URLLoader in ServiceGroup that will be used by this action.
		 */
		function get serviceID():String;
		
		/**
		 * @private
		 */
		function set serviceID(value:String):void
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initiates service operation.
		 * 
		 * @param parameter
		 * 
		 */
		function send(parameter:Object = null):void;
		
	}
	
}