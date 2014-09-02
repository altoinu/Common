/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.air.utils";
	var version = "1.1.1";
	console.log(namespace + " - WebViewBridge.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * This class will serve as a bridge between HTML and mobile app which has HTML
	 * page in its web view.
	 * 
	 * @param callbackTarget
	 */
	ns.WebViewBridge = function(callbackTarget) {

		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------

		var me = this;

		var paramsToApp = "";

		// --------------------------------------------------------------------------
		//
		// Public properties
		//
		// --------------------------------------------------------------------------

		this.callbackTarget = (callbackTarget ? callbackTarget : this);

		// --------------------------------------------------------------------------
		//
		// Private methods
		//
		// --------------------------------------------------------------------------

		/**
		 * Given command object, execute method if it is found in either "callbackTarget"
		 * or "this" and return result as {result: return value}. If specified method
		 * cannot be found, then this function will return null.
		 * 
		 * @param command
		 *            command object in form "{method: method name, arguments: [arg1, arg2...]},"
		 *            (arguments optional)
		 */
		var processResponseFromApp = function(command) {

			var thisItem;
			var methodName = command.method;

			// check to see if specified methodName exists either in me.callbackTarget
			if (methodName in me.callbackTarget)
				thisItem = me.callbackTarget;
			// or this WebViewBridge
			else if (methodName in me)
				thisItem = me;
			// if not found in it, then window
			// else if (methodName in window)
			// thisItem = window;

			if (thisItem) {

				// call methodName specified (with arguments if they exist)
				var method = thisItem[methodName];
				var methodArgs = (command.hasOwnProperty("arguments") ? command.arguments : null);

				// alert(methodName + "\n" + methodArgs);
				return {
					result: method.apply(thisItem, methodArgs)
				};

			} else {

				// If reached here, then methodName specified is not
				// found in me.callbackTarget or me

			}

			return null;

		};

		var processParamsToApp = function() {

			// now, actually pass parameters to app through location href
			if (!$.browser.mozilla && !$.browser.ie)
				window.location.href = "kaorulikescurryrice://" + paramsToApp;

			paramsToApp = ""; // clear

		};

		// --------------------------------------------------------------------------
		//
		// Public methods
		//
		// --------------------------------------------------------------------------

		/**
		 * This method will serve as a bridge from HTML/JS to app displaying the web view.
		 * It tries to redirect to URL with invalid protocol, which app's web view should
		 * capture (ex. AIR AS3's LocationChangeEvent on Android and ErrorEvent on iOS).
		 * 
		 * @param args
		 *            Specify one or more parameters to pass back
		 */
		this.callAppMethod = function(args) {

			var numArgs = arguments.length;

			// Build parameters to pass in format
			// {method: arguments[0], arguments: [arguments[1], arguments[2], ...]}
			if (numArgs > 0) {

				// First parameter is method name
				var paramsToPass = {
					method: arguments[0]
				};

				if (numArgs > 1) // rest are arguments
					paramsToPass.arguments = Array.prototype.slice.call(arguments, 1);

				// Set timeout to pass parameters to app later at once
				if (paramsToApp.length == 0)
					setTimeout(processParamsToApp, 1);

				// URL encode
				var urlencodedParam = encodeURIComponent(JSON.stringify(paramsToPass));
				if (navigator.userAgent.toLowerCase().indexOf("android") != -1)
					urlencodedParam = encodeURIComponent(urlencodedParam); // need to double encode for AIR on Android
				
				// queue params
				paramsToApp += (paramsToApp.length > 0 ? "/" : "") + urlencodedParam;

			}

		};

		/**
		 * This method will serve as a bridge from app to HTML/JS, then back
		 * to app for return data. First, command is executed from
		 * app. The return value will be passed to method
		 * <code>callbackMethodName(...args)</code> in the app,
		 * 
		 * @param command
		 *            command object in form "{method: method name, arguments: [arg1, arg2...]},"
		 *            (arguments optional)
		 * @param callbackMethodName
		 *            Method name (ex AS3 method in AIR) in the app to be called with
		 *            return value(s) from targetJSMethod
		 */
		this.functionCall = function(command, callbackMethodName) {

			var response = processResponseFromApp(command);

			if (response) {

				// Then call app method back with returned value
				var returnCallParams = [
					callbackMethodName
				];

				var returnVal = response.result;

				if (returnVal) {

					if (typeof returnVal == "object") {

						// Push each item separately
						for ( var i in returnVal) {

							returnCallParams.push(returnVal[i]);

						}

					} else {

						// Normal object so just push
						returnCallParams.push(returnVal);

					}

				}

				me.callAppMethod.apply(me, returnCallParams);

			}

		};

		// --------------------------------------------------------------------------
		//
		// Event handlers
		//
		// --------------------------------------------------------------------------

		var onHashChange = function() {

			var hash = decodeURIComponent(window.location.hash);

			if (hash != "") {

				// First data (up to first &) will be ignored. On app end,
				// this is simply a "counter," an integer that gets
				// incremented by 1 every time hash change is called.
				// Something changing in hash makes sure that this
				// hashchange event happens
				var commands = JSON.parse(hash.substring(hash.indexOf("&") + 1));
				var numCommands = commands.length;
				for (var i = 0; i < numCommands; i++) {

					var response = processResponseFromApp(commands[i]);

				}

				// First data (up to first &) will be ignored. On app end, this
				// is simply a "counter," an integer that gets incremented by 1
				// everytime hash change is called. Something changing
				// in hash makes sure that this hashchange event happens

				// var paramString =
				// window.location.hash.substring(window.location.hash.indexOf("&")
				// + 1);

				// processResponseFromApp(paramString);
				// me.callAppMethod("onJavaScriptExecuteComplete");

			}

		};

		// --------------------------------------------------------------------------
		//
		// Initializations
		//
		// --------------------------------------------------------------------------

		// Through hash change I will be capturing commands from outside
		// I need to do this because iOS prevents direct javascript: on
		// StageWebView in AIR app
		if ("onhashchange" in window)
			window.addEventListener("hashchange", onHashChange, false);
		else
			alert("Sorry, this feature is not supported on your device.");

	};

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
