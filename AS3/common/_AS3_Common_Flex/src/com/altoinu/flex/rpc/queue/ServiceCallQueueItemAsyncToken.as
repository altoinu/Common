/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.queue
{
	
	import mx.core.mx_internal;
	import mx.messaging.messages.IMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;
	
	public class ServiceCallQueueItemAsyncToken extends AsyncToken
	{
		
		//--------------------------------------------------------------------------
		//
		// Constructor
		// 
		//--------------------------------------------------------------------------
		
		public function ServiceCallQueueItemAsyncToken(sourceToken:AsyncToken = null)
		{
			
			super();
			
			this.sourceToken = sourceToken;
			
		}
		
		//--------------------------------------------------------------------------
		//
		// Public properties
		// 
		//--------------------------------------------------------------------------
		
		//----------------------------------
		// sourceToken
		//----------------------------------

		private var _sourceToken:AsyncToken;

		public function get sourceToken():AsyncToken
		{
			
			return _sourceToken;
			
		}

		/**
		 * @private
		 */
		public function set sourceToken(value:AsyncToken):void
		{
			
			if (_sourceToken != value)
			{
				
				_sourceToken = value;
				
				super.mx_internal::setMessage(value ? value.message : null);
				super.mx_internal::setResult(value ? value.result : null);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		// Overridden Methods
		// 
		//--------------------------------------------------------------------------
		
		override mx_internal function setMessage(message:IMessage):void
		{
			
			super.mx_internal::setMessage(message);
			
			if (_sourceToken)
				_sourceToken.setMessage(message);
			
		}
		
		override mx_internal function setResult(newResult:Object):void
		{
			
			super.mx_internal::setResult(newResult);
			
			if (_sourceToken)
				_sourceToken.setResult(newResult);
			
		}
		
	}
	
}