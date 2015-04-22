/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.air.mx.controls
{
	
	import com.altoinu.air.net.LocalStorageCache;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.URLUtil;
	
	/**
	 * Component to display StageWebView and allows communication between AIR and HTML/JavaScript.
	 * 
	 * TODO: still somewhat work in progress...
	 * Known issue: It works on Android and iOS, but not on AIR debugger. callJavaScript causes LocationChangeEvent
	 * to get dispatched even though it is not supposed to.
	 * 
	 * @author Kaoru Kawashima
	 * @version 1.1.2
	 * 
	 */
	public class StageWebViewBridgeUIComponent extends StageWebViewUIComponent
	{
		
		private static const objDescription:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Class static methods
		//
		//--------------------------------------------------------------------------
		
		private static function describeType(value:*):XML
		{
			
			if (value is Class)
			{
				
				// Return object description of Class as is
				return flash.utils.describeType(value);
				
			}
			else
			{
				
				var className:String = getQualifiedClassName(value);
				if (!objDescription.hasOwnProperty(className))
				{
					
					// Let's remember result of flash.utils.describeType for this object type
					// since this AS3 method is performance hog
					objDescription[className] = flash.utils.describeType(value);
					
				}
				
				return objDescription[className];
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StageWebViewBridgeUIComponent()
		{
			
			super();
			
			loadWebViewBridgeHTML();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var hashcounter:uint = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var queuedJavaScriptCommands:Array;
		
		/**
		 * StageWebViewBridgeUIComponent will detect location change with this
		 * protocol to determine it is a response being sent back to AIR from HTML/JavaScript.
		 */
		protected var responseProtocol:String = "kaorulikescurryrice";
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  callbackDelegate
		//--------------------------------------
		
		private var _callbackDelegate:Object;
		
		[Bindable(event="callbackDelegateChange")]
		/**
		 * Specifies object with callback methods that receives calls from
		 * HTML/JavaScript displayed in StageWebView.
		 * 
		 * <p>For example, by setting this object to <code>this</code>, HTML page
		 * will be able to call its public methods.</p>
		 */
		public function get callbackDelegate():Object
		{
			
			return _callbackDelegate;
			
		}
		
		/**
		 * @private
		 */
		public function set callbackDelegate(value:Object):void
		{
			
			if (_callbackDelegate !== value)
			{
				
				_callbackDelegate = value;
				dispatchEvent(new Event("callbackDelegateChange"));
				
			}
			
		}
		
		/*
		[Deprecated(replacement="callbackDelegate")]
		[Bindable(event="callbackDelegateChange")]
		public function get callbackTarget():Object
		{
			
			return callbackDelegate;
			
		}
		
		[Deprecated(replacement="callbackDelegate")]
		public function set callbackTarget(value:Object):void
		{
			
			callbackDelegate = value;
			
		}
		*/
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function dropProtocol(url:String, protocol:String):String
		{
			
			return url.substring(url.indexOf(protocol) + protocol.length + 3);
			
		}
		
		private static function createCommandObj(methodName:String, args:Array = null, callbackMethodName:String = null):Object
		{
			
			// Command
			var command:Object = {
				method: methodName
			};
			
			// and argument to be passed
			var numArgs:int = (args != null ? args.length : 0);
			if (numArgs > 0)
				command.arguments = args;
			
			if (callbackMethodName != null)
				command.callback = callbackMethodName;
			
			return command;
			
		}
		
		/**
		 * Executes specified JavaScript command by changing the source to <code>javascript:...</code>.
		 * 
		 */
		private function webViewExecuteNextJavaScriptCommand():void
		{
			
			if (queuedJavaScriptCommands &&
				(queuedJavaScriptCommands.length > 0) &&
				(stageWebView != null))
			{
				
				trace("<======== Javascript queued call");
				hashcounter++;
				
				// Put all queued JavaScript commands into single string
				var commandString:String = JSON.stringify(queuedJavaScriptCommands);
				for each (var command:Object in queuedJavaScriptCommands)
				{
					
					trace("<-- " + command.method + (command.hasOwnProperty("arguments") ? ", " + command.arguments : "") + (command.hasOwnProperty("callback") ? ", " + command.callback : ""));
					
				}
				
				// and send as one hash change
				trace("<---- " + hashcounter + "&" + commandString);
				//webView.loadURL("javascript:window.location.hash='" + encodeURIComponent(commandString) + "'");
				//source = "javascript:window.location.hash='" + encodeURIComponent(commandString) + "'";
				source = "javascript:window.location.hash='" + encodeURIComponent(hashcounter + "&" + commandString) + "'";
				_contentLoaded = true; // Content will not change, so we manually set this flag to true here
				
				queuedJavaScriptCommands = null;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Loads necessary HTML/JS
		 * 
		 */
		protected function loadWebViewBridgeHTML():void
		{
			
			// Copy necessary files from application directory to storage directory
			// Otherwise StageWebView cannot load them
			LocalStorageCache.copyToLocal(File.applicationDirectory.resolvePath("html/jquery-1.7.2.min.js"), "html/jquery-1.7.2.min.js");
			LocalStorageCache.copyToLocal(File.applicationDirectory.resolvePath("html/utils.js"), "html/utils.js");
			LocalStorageCache.copyToLocal(File.applicationDirectory.resolvePath("html/WebViewBridge.js"), "html/WebViewBridge.js");
			var dest:File = LocalStorageCache.copyToLocal(File.applicationDirectory.resolvePath("html/index.html"), "html/index.html");
			
			// load in StageWebView
			trace(escape(dest.nativePath));
			trace(dest.exists);
			source = "file://" + escape(dest.nativePath);
			
		}
		
		/**
		 * This method will serve as a bridge to HTML page in StageWebView. It will take arguments
		 * and pass it as URL hash, which HTML page will detect through hash change event.
		 * 
		 * @param methodName
		 * @param callbackMethodName
		 * @param args
		 * 
		 */
		protected function callJS(methodName:String, callbackMethodName:String, ...args):void
		{
			
			if (contentLoaded)
			{
				
				// This is my dirty trick #1 to send data to contents in StageWebView
				// HTML page should be watching for hash changing and when it does capture it
				// it should parse data being passed.
				// Need to do this way because iOS prevents javascript:whatever method being call directly.
				
				if (!queuedJavaScriptCommands)
					queuedJavaScriptCommands = [];
				
				// Put all JavaScript commands into Array so they will be called all at once later
				// need to do this because hashchange event in HTML page may not capture all changes
				// so I'm sending it as one
				//queuedJavaScriptCommands.push(hash);
				queuedJavaScriptCommands.push(createCommandObj(methodName, args, callbackMethodName));
				
				if (queuedJavaScriptCommands.length == 1)
					callLater(webViewExecuteNextJavaScriptCommand);
				
			}
			
		}
		
		/**
		 * This method processes the action that came from html page.
		 * 
		 * @param stringToBeDecoded
		 * 
		 */
		protected function processResponseFromStageWebView(stringToBeDecoded:String):void
		{
			
			if (contentLoaded && (stringToBeDecoded.indexOf(responseProtocol + "://") >= 0))
			{
				
				// Treat everything after the [responseProtocol]:// as data, "/" delimited
				stringToBeDecoded = dropProtocol(stringToBeDecoded, responseProtocol); // drop protocol
				
				/* Not sure why I put this here originally...
				if (stringToBeDecoded.indexOf(" ") == -1)
				stringToBeDecoded = stringToBeDecoded.substring(stringToBeDecoded.indexOf(" ")); // drop extra space and anything after it
				*/
				
				// Assume URL encoded JSON pattern {"method":"method1","arguments":[arg1,arg2...]}/{"method":"method2","arguments":[arg1,arg2...]}/...
				var responses:Array = stringToBeDecoded.split("/");
				var command:Object;
				var methodName:String;
				var methodArgs:Array;
				for each (var response:String in responses)
				{
					
					command = JSON.parse(decodeURIComponent(response as String));
					methodName = command.method;
					methodArgs = (command.hasOwnProperty("arguments") ? command.arguments : null);
					
					// Now do something with this data
					trace(decodeURIComponent(response));
					trace("====> Process " + methodName, methodArgs);
					
					// See if specified method exists
					if (callbackDelegate.hasOwnProperty(methodName) &&
						(callbackDelegate[methodName] != null) &&
						(callbackDelegate[methodName] is Function))
					{
						
						// Found corresponding function, execute with rest as arguments
						trace("--> Execute: "+methodName);
						var targetFunction:Function = callbackDelegate[methodName];
						targetFunction.apply(callbackDelegate, methodArgs);
						
					}
					else
					{
						
						trace("--> No corresponding method: " + methodName);
						
					}
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This method will serve as a bridge to HTML page and also back to
		 * AIR app via <code>callback</code>, so if there is a return value(s)
		 * in specified <code>jsMethodName</code> they are passed to the AS3 method.
		 * 
		 * @param jsMethodName
		 * @param argsArray Array of arguments to be passed to <code>jsMethodName</code>
		 * @param callback <code>function(...args):void</code> in <code>callbackDelegate</code>
		 * that will be called with return values from JavaScript method being called.
		 * Return values of the JavaScript method should be array with element(s) matching
		 * argument(s) of callback function.
		 */
		public function execJavaScript(jsMethodName:String, argsArray:Array = null, callback:Function = null):void
		{
			
			var callJSArgs:Array = [jsMethodName];
			if (callback == null)
			{
				
				// No callback method
				
				callJSArgs.push(null); // no callback for 2nd arg
				
			}
			else
			{
				
				// callback method defined, make sure it is defined
				
				var callbackValid:Boolean = false;
				
				//var type:XML = ClassUtil.describeType(callbackDelegate);
				var type:XML = describeType(callbackDelegate);
				for each (var method:XML in type.method)
				{
					
					if (callbackDelegate.hasOwnProperty(String(method.@name)) &&
						(callbackDelegate[String(method.@name)] == callback))
					{
						
						// specified callback exists in callbackDelegate
						
						// Convert callback method name to string
						var callbackMethodName:String = String(method.@name);
						callJSArgs.push(callbackMethodName);
						callbackValid = true;
						
					}
					
				}
				
				if (!callbackValid) {
					
					throw new Error("Specified callback " + String(method.@name) + " is not public method of " + getQualifiedClassName(callbackDelegate));
					return;
					
				}
				
			}
			
			if ((argsArray != null) && (argsArray.length > 0))
				callJSArgs = callJSArgs.concat(argsArray);
			
			callJS.apply(this, callJSArgs);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * locationChanging handler. This will capture response from HTML/JavaScript through URL changing.
		 * @param event
		 * 
		 */
		override protected function onLocationChanging(event:LocationChangeEvent):void
		{
			
			super.onLocationChanging(event);
			
			if ((stageWebView.location.length == 0) ||
				((event.location.length > 0) && (stageWebView.location.indexOf(event.location) == -1)))
			{
				
				// Trying to go to different page
				
				trace(event);
				trace(stageWebView.location);
				trace(source);
				
				// prevent StageWebView from changing its URL
				event.preventDefault();
				
				var url:String = event.location;
				if (URLUtil.getProtocol(url) == responseProtocol)
				{
					
					// Oh look! Nice protocol found...This is my dirty trick to capture data coming back from HTML page
					trace("========> Caught data from StageWebView at " + event.type + ": " + url + " --> process response in AS3");
					processResponseFromStageWebView(url);
					
				}
				else if (url != source)
				{
					
					// OK, it is not that protocol and it is trying to go to different URL
					// so let's just open it
					trace("========> Location change captured, current: " + stageWebView.location + " --> to: " + url);
					
					// open same URL through navigateToURL instead
					navigateToURL(new URLRequest(url), "_blank");
					
				}
				
			}
			
		}
		
		/**
		 * error event handler. For iOS. Unlike Android, redirect to URL with invalid
		 * protocol causes StageWebView to dispatch ErrorEvent.ERROR event
		 * @param event
		 * 
		 * @return true if error event should be dispatched, ignore if false
		 * 
		 */
		override protected function onError(event:ErrorEvent):Boolean
		{
			
			if (event.text.indexOf(responseProtocol) != -1)
			{
				
				// error happened because protocol specified is one specified
				// by responseProtocol, which indicates we should parse
				// URL (event.text) and execute AS3 code
				trace("========> Caught data from StageWebView at " + event.type + ": " + event.text + " --> process response in AS3");
				processResponseFromStageWebView(event.text);
				
				// and return false so error event is not actually dispatched
				return false;
				
			}
			else
			{
				
				trace("Unknown error: " + event);
				
				return super.onError(event);
				
			}
			
		}
		
	}
	
}