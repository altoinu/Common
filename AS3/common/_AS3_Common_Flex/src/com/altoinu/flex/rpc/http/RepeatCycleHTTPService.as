/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.http
{
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	/**
	 * HTTPService component that makes defined service requests over and over to constantly
	 * reload data.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class RepeatCycleHTTPService extends HTTPService
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		// 
		//--------------------------------------------------------------------------
		
		/**
		 * Creates a new HTTPService. This constructor is usually called by the generated code of an MXML document.
		 * You usually use the mx.rpc.http.HTTPService class to create an HTTPService in ActionScript.
		 *
		 * @param rootURL The URL the HTTPService should use when computing relative URLS.
		 *
		 * @param destination An HTTPService destination name in the service-config.xml file.
		 */
		public function RepeatCycleHTTPService(rootURL:String = null, destination:String = null)
		{
			
			super(rootURL, destination);
			
			super.concurrency = "last";
			
			// Repeat timer
			reloadTimer = new Timer(reloadTimeCycle, 1);
			
			// Event listeners
			this.addEventListener(ResultEvent.RESULT, onDataLoadComplete);
			this.addEventListener(FaultEvent.FAULT, onDataLoadFault);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		// 
		//--------------------------------------------------------------------------
		
		/**
		 * Timer to reload external data after waiting for a while.
		 */
		private var reloadTimer:Timer;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  concurrency
		//----------------------------------
		
		/**
		 * = "last" This property cannot be changed for RepeatCycleHTTPService.
		 */
		override public function get concurrency():String
		{
			
			return super.concurrency;
			
		}
		
		/**
		 * @private
		 */
		override public function set concurrency(c:String):void
		{
			
			concurrency = "last";
			
			throw new Error("concurrency can only be \"last\" for RepeatCycleHTTPService.");
			
		}
		
		//----------------------------------
		//  url
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get url():String
		{
			
			return super.url;
			
		}
		
		/**
		 * @private
		 */
		override public function set url(u:String):void
		{
			
			super.url = u;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Time in milliseconds to wait in between service request cycle.
		 */
		public var reloadTimeCycle:Number = 60000;
		
		/**
		 * Time in milliseconds to wait before next service request cycle if fault on HTTPService.
		 */
		public var reloadTimeAfterFault:Number = 5000;
		
		//--------------------------------------------------------------------------
		//
		//  Override methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function cancel(id:String = null):AsyncToken
		{
			
			// Stop timer if it is running
			reloadTimer.reset();
			
			// Load data
			return super.cancel(id);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function send(parameters:Object = null):AsyncToken
		{
			
			// Stop timer if it is running
			reloadTimer.reset();
			
			// Load data
			return super.send(parameters);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function reloadData(event:TimerEvent):void
		{
			
			event.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, reloadData);
			
			send();
			
		}
		
		private function onDataLoadComplete(event:ResultEvent):void
		{
			
			// Reload data after timer wait
			reloadTimer.delay = reloadTimeCycle;
			reloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, reloadData);
			reloadTimer.start();
			
		}
		
		private function onDataLoadFault(event:FaultEvent):void
		{
			
			// Reload data after timer wait
			reloadTimer.delay = reloadTimeAfterFault;
			reloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, reloadData);
			reloadTimer.start();
			
		}
		
	}
	
}