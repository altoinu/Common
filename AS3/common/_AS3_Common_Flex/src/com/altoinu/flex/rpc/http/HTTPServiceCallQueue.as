/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.rpc.http
{
	
	import com.altoinu.flex.rpc.queue.IServiceCallQueueItem;
	import com.altoinu.flex.rpc.queue.ServiceCallQueue;
	
	import flash.net.URLRequestMethod;
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	/**
	 * Queues HTTPService so they are executed in order. Normally, you do not have to
	 * use this class directly since HTTPServiceLocator handles most of the heavy lifting using this class.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @see com.altoinu.flex.rpc.http.HTTPSericeLocator
	 */
	public class HTTPServiceCallQueue extends ServiceCallQueue
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class resources
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static var _instance:HTTPServiceCallQueue;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns reference to the instance of HTTPServiceCallQueue through Singleton model.
		 * 
		 * @return instance of HTTPServiceCallQueue
		 */
		public static function getInstance():HTTPServiceCallQueue
		{
			
			if (!_instance)
				_instance = new HTTPServiceCallQueue();
			
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
		public function HTTPServiceCallQueue():void
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _originalURL:String = "";
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function sendData(queueItem:IServiceCallQueueItem):void
		{
			
			var serviceOperation:HTTPService = queueItem.operation as HTTPService;
			_originalURL = serviceOperation.url;
			
			if (queueItem.serviceLocator != null)
			{
				
				var serviceLocator:HTTPServiceLocator = queueItem.serviceLocator as HTTPServiceLocator;
				
				// If POST method, put data into query string just in case
				if ((serviceOperation.method == URLRequestMethod.POST) && (serviceLocator.appendPOSTDataToURL))
					serviceOperation.url = addParameterAsQueryString(serviceOperation.url, queueItem.data);
				
			}
			
			super.sendData(queueItem);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function addParameterAsQueryString(targetURL:String, parameters:Object):String
		{
			
			if (parameters == null)
			{
				
				// No parameters, return URL as is
				return targetURL;
				
			}
			else if (!(parameters is XML) && !(parameters is Object))
			{
				
				var errorMessage:String = "Unrecognized data type: "+getQualifiedClassName(parameters);
				trace(errorMessage);
				throw new Error(errorMessage);
				
				return targetURL;
				
			}
			
			
			if (parameters is XML)
			{
				
				var convertedParameters:Object = new Object();
				for each (var prop:XML in XML(parameters).elements())
				{
					
					convertedParameters[String(prop.name())] = prop.toString();
					
				}
				
				parameters = convertedParameters;
				
			}
			
			if (targetURL.indexOf("?") == -1)
			{
				
				// Add ? to start querystring
				targetURL += "?";
				
			}
			
			// First, strip out all query strings that may be in the targetURL already
			var queryStringStartIndex:int = targetURL.indexOf("?");
			var queryStringParameters:Object = new Object();
			if (targetURL.charAt(targetURL.length - 1) != "?")
			{
				
				// Last char is not ?, so that means there is query string
				var targetURLQueryString:String = targetURL.substring(queryStringStartIndex + 1);
				var targetURLQueryStringParameters:Array = targetURLQueryString.split("&");
				var numTargetURLParameters:int = targetURLQueryStringParameters.length;
				for (var i:int = 0; i < numTargetURLParameters; i++)
				{
					
					var targetURLParamData:Array = targetURLQueryStringParameters[i].split("=");
					queryStringParameters[targetURLParamData[0]] = targetURLParamData[1];
					
				}
				
			}
			
			// Add parameters to URL as querystring
			for (var paramName:String in parameters)
			{
				
				queryStringParameters[paramName] = parameters[paramName];
				var parameterIndex:int = targetURL.indexOf(paramName, queryStringStartIndex);
				var replacementParameter:String = paramName + "=" + parameters[paramName];
				if (parameterIndex == -1)
				{
					
					// This parameter is not in querystring, so append it at the end
					targetURL += ((targetURL.charAt(targetURL.length - 1) == "?" ? "" : "&") + replacementParameter);
					
				}
				else
				{
					
					// Replace the parameter
					var ampAfterReplaceParameter:int = targetURL.indexOf("&", parameterIndex)
					targetURL = targetURL.substring(0, parameterIndex) + replacementParameter + (ampAfterReplaceParameter == -1 ? "" : targetURL.substring(ampAfterReplaceParameter));
					
				}
				
			}
			
			targetURL = targetURL.substring(0, queryStringStartIndex + 1);
			for (var newPropName:String in queryStringParameters)
			{
				
				if (targetURL.charAt(targetURL.length - 1) != "?")
					targetURL += "&";
				
				targetURL += (newPropName + "=" + queryStringParameters[newPropName]);
				
			}
			
			return targetURL;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function onOperationComplete(event:ResultEvent):void
		{
			
			var queueItem:IServiceCallQueueItem = event.currentTarget as IServiceCallQueueItem;
			HTTPService(queueItem.operation).url = _originalURL;
			
			super.onOperationComplete(event);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onOperationFaultEvent(event:FaultEvent):void
		{
			
			var queueItem:IServiceCallQueueItem = event.currentTarget as IServiceCallQueueItem;
			HTTPService(queueItem.operation).url = _originalURL;
			
			super.onOperationFaultEvent(event);
			
		}
		
	}
	
}