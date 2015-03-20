/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.java.android.webkit;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.NumberFormat;
import java.text.ParsePosition;
import java.util.ArrayList;
import java.util.HashMap;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Handler;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

/**
 * WebViewBridge
 * Version 1.0
 * 
 * Requires Gson https://code.google.com/p/google-gson/
 * @author kaoru
 *
 */
public class WebViewBridge extends WebView {

	//--------------------------------------------------------------------------
	//
	//  Constants
	//
	//--------------------------------------------------------------------------
	
	public static final String LOG_TAG = "WebViewBridge";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public WebViewBridge(Context context) {
		
		super(context);
		
		init();
		
	}

	public WebViewBridge(Context context, AttributeSet attrs) {
		
		super(context, attrs);
		
		init();
		
	}

	public WebViewBridge(Context context, AttributeSet attrs, int defStyle) {
		
		super(context, attrs, defStyle);
		
		init();
		
	}

	//--------------------------------------------------------------------------
	//
	//  Private properties
	//
	//--------------------------------------------------------------------------
	
	private CallbackDelegate callbackDelegate;
	private int hashcounter = 0;
	private Gson gson = new Gson();

	//--------------------------------------------------------------------------
	//
	//  Protected properties
	//
	//--------------------------------------------------------------------------
	
	protected boolean contentLoaded = false;
	
	protected ArrayList<HashMap<String, Object>> queuedJavaScriptCommands;
	
	/**
	 * WebViewBridge will detect location change with this
	 * protocol to determine it is a response being sent back to app from HTML/JavaScript.
	 */
	protected String responseProtocol = "kaorulikescurryrice";
	
	/**
	 * JavaScript method in HTML page that will take actual JS method to be called
	 * and name of callback function to be receive response, in form:
	 * function(targetJSMethod, args, returnAS3Handler)
	 */
	protected String bridgeJSFunction = "functionCall";
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	private void init() {
		
		// Enable JavaScript
		WebSettings settings = getSettings();
		settings.setJavaScriptEnabled(true);
		
		super.setWebViewClient(new WebViewClient() {

			/* (non-Javadoc)
			 * @see android.webkit.WebViewClient#onPageStarted(android.webkit.WebView, java.lang.String, android.graphics.Bitmap)
			 */
			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon) {
				
				contentLoaded = false;
				Log.d(LOG_TAG, "onPageStarted: contentLoaded = false");
				
				// TODO:
				// onComplete();
				
				super.onPageStarted(view, url, favicon);
				
			}

			/* (non-Javadoc)
			 * @see android.webkit.WebViewClient#onPageFinished(android.webkit.WebView, java.lang.String)
			 */
			@Override
			public void onPageFinished(WebView view, String url) {
				
				contentLoaded = true;
				Log.d(LOG_TAG, "onPageFinished: contentLoaded = true");
				
				super.onPageFinished(view, url);
				
			}

			/* (non-Javadoc)
			 * @see android.webkit.WebViewClient#onReceivedError(android.webkit.WebView, int, java.lang.String, java.lang.String)
			 */
			@Override
			public void onReceivedError(WebView view, int errorCode,
					String description, String failingUrl) {

				Log.d(LOG_TAG, "onReceivedError: " + view.getUrl());
				Log.d(LOG_TAG, "onReceivedError: " + errorCode);
				Log.d(LOG_TAG, "onReceivedError: " + description);
				Log.d(LOG_TAG, "onReceivedError: " + failingUrl);
				
				super.onReceivedError(view, errorCode, description, failingUrl);
				
			}

			/* (non-Javadoc)
			 * @see android.webkit.WebViewClient#shouldOverrideUrlLoading(android.webkit.WebView, java.lang.String)
			 */
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				
				//Log.d(LOG_TAG, "shouldOverrideUrlLoading: " + view.getUrl());
				//Log.d(LOG_TAG, "shouldOverrideUrlLoading: " + url);
				
				String currentURL = view.getUrl();
				if ((currentURL.length() == 0) ||
						((url.length() > 0) && (currentURL.indexOf(url) == -1))) {
					
					// Trying to go to different page

					Log.d(LOG_TAG, currentURL);
					Log.d(LOG_TAG, view.getOriginalUrl());
					
					if (getProtocol(url).equals(responseProtocol)) {
						
						// Oh look! Nice protocol found...This is my dirty trick to capture data coming back from HTML page
						Log.d(LOG_TAG, "========> Caught data from WebView at shouldOverrideUrlLoading: " + url + " --> process response");
						processResponseFromWebView(url);
						
					} else if (url != view.getOriginalUrl()) {
						
						// OK, it is not that protocol and it is trying to go to different URL
						// so let's just open it
						Log.d(LOG_TAG, "========> Location change captured, current: " + currentURL + " --> to: " + url);
						
						// open same URL normally instead
						Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
						getContext().startActivity(browserIntent);
						
					}
					
					// prevent WebView from chainging its URL
					return true;
					
				} else {
					
					return super.shouldOverrideUrlLoading(view, url);
					
				}
				
			}
			
		});
		
		super.setWebChromeClient(new WebChromeClient());
		
		addJavascriptInterface(new Object(), "AndroidWebViewBridge");
		
		loadWebViewBridgeHTML();
		
	}

	private static String getProtocol(String url) {
		
		int slash = url.indexOf("/");
		int indx = url.indexOf(":/");
		
		if (indx > -1 && indx < slash) {
			
			return url.substring(0, indx);
			
		} else {
			
			indx = url.indexOf("::");
			
			if (indx > -1 && indx < slash)
				return url.substring(0, indx);
			
		}
		
		return "";
		
	}

	private static String encodeURIComponent(String value) {
		
		try {
			
			//return URLEncoder.encode(value, "UTF-8").replace("+", "%20");
			return URLEncoder.encode(value, "UTF-8")
					.replace("+", "%20")
					.replaceAll("\\%28", "(")
					.replaceAll("\\%29", ")")
					.replaceAll("\\%27", "'")
					.replaceAll("\\%21", "!")
					.replaceAll("\\%7E", "~");
			
		} catch (UnsupportedEncodingException e) {
			
			return value;
			
		}
		
	}
	
	private static String decodeURIComponent(String value) {
		
		try {
			
			return URLDecoder.decode(value, "UTF-8");
			
		} catch (UnsupportedEncodingException e) {
			
			return value;
			
		}
		
	}
	
	private static boolean isNumeric(String str) {
		
		NumberFormat formatter = NumberFormat.getInstance();
		ParsePosition pos = new ParsePosition(0);
		formatter.parse(str, pos);
		return str.length() == pos.getIndex();
		
	}
	
	private static String dropProtocol(String url, String protocol) {

		return url.substring(url.indexOf(protocol) + protocol.length() + 3);
		
	}

	private static HashMap<String, Object> createCommandObj(String methodName, Object[] args) {
		
		HashMap<String, Object> command = new HashMap<String, Object>();
		command.put("method", methodName);
		
		int numArgs = (args != null ? args.length : 0);
		if (numArgs > 0)
			command.put("arguments", args);
		
		return command;
		
	}

	private static Object createCommandObj(String methodName) {
		
		return createCommandObj(methodName, null);
		
	}
	
	private void webViewExecuteNextJavaScriptCommand() {
		
		if ((queuedJavaScriptCommands != null) && (queuedJavaScriptCommands.size() > 0)) {
			
			Log.d(LOG_TAG, "<======== Javascript queued call");
			hashcounter++;
			
			// Put all queued JavaScript commands into single string
			String commandString = gson.toJson(queuedJavaScriptCommands);
			for (HashMap<String, Object> command : queuedJavaScriptCommands) {
				
				Log.d(LOG_TAG, "<-- " + command.get("method").toString() + (command.containsKey("arguments") ? ", " + command.get("arguments").toString() : ""));
				
			}
			
			// and send as one hash change
			Log.d(LOG_TAG, "<---- " + hashcounter + "&" + commandString);
			loadUrl("javascript:window.location.hash='" + encodeURIComponent(hashcounter + "&" + commandString) + "'");
			
			queuedJavaScriptCommands = null;
			
		}
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden protected methods
	//
	//--------------------------------------------------------------------------

	/* (non-Javadoc)
	 * @see android.webkit.WebView#onFocusChanged(boolean, int, android.graphics.Rect)
	 */
	@Override
	protected void onFocusChanged(boolean focused, int direction,
			Rect previouslyFocusedRect) {
		
		super.onFocusChanged(focused, direction, previouslyFocusedRect);
		
		// TODO:
		// onFocusIn/Out();
		
	}

	//--------------------------------------------------------------------------
	//
	//  Protected methods
	//
	//--------------------------------------------------------------------------

	protected void loadWebViewBridgeHTML() {
		
		loadUrl("file:///android_asset/html/index.html");
		
	}
	
	protected void callJS(String methodName, Object... args) {
		
		if (contentLoaded) {
			
			// This is my dirty trick #1 to send data to contents in StageWebView
			// HTML page should be watching for hash changing and when it does capture it
			// it should parse data being passed.
			if (queuedJavaScriptCommands == null)
				queuedJavaScriptCommands = new ArrayList<HashMap<String,Object>>();
			
			// Put all JavaScript commands into Array so they will be called all at once later
			// need to do this because hashchange event in HTML page may not capture all changes
			// so I'm sending it as one
			queuedJavaScriptCommands.add(createCommandObj(methodName, args));
			
			if (queuedJavaScriptCommands.size() == 1) {
				
				// Wait in separate thread so queued commands are sent all at once
				final Handler handler = new Handler();
				handler.post(new Runnable() {
					
					@Override
					public void run() {
						webViewExecuteNextJavaScriptCommand();
					}
					
				});
				
			}
			
		} else {
			
			throw new RuntimeException("WebViewBridge has not finished loading yet.");
			
		}
		
	}
	
	protected void processResponseFromWebView(String stringToBeDecoded) {
		
		if (contentLoaded && stringToBeDecoded.indexOf(responseProtocol) != -1) {
			
			// Treat everything after the [responseProtocol]:// as data, "/" delimited
			String paramString = dropProtocol(stringToBeDecoded, responseProtocol);
			
			/* Not sure why I put this here originally...
			if (paramString.indexOf(" ") == -1)
				paramString = paramString.substring(paramString.indexOf(" ")); // drop extra space and anything after it
			*/
			
			// Assume URL encoded JSON pattern {"method":"method1","arguments":[arg1,arg2...]}/{"method":"method2","arguments":[arg1,arg2...]}/...
			String[] responses = paramString.split("/");
			HashMap<String, Object> command;
			String methodName;
			ArrayList<Object> methodArgs;
			Method[] callbackMethods = callbackDelegate.getClass().getMethods();
			String callbackName;
			Class<?>[] callbackParamTypes;
			for (String response : responses) {
				
				command = gson.fromJson(decodeURIComponent(decodeURIComponent(response)), new TypeToken<HashMap<String, Object>>() {}.getType());
				methodName = command.get("method").toString();
				methodArgs = (command.containsKey("arguments") ? (ArrayList<Object>) command.get("arguments") : null);
				
				// Now do something with this data
				Log.d(LOG_TAG, decodeURIComponent(decodeURIComponent(response)));
				Log.d(LOG_TAG, "====> Process " + methodName + ", " + methodArgs.toString());
				
				for (Method callback : callbackMethods) {
					
					callbackName = callback.getName();
					callbackParamTypes = callback.getParameterTypes();
					if (callbackName.equals(methodName) && isArgsMatchMethodParams(methodArgs.toArray(), callbackParamTypes)) {
						
						// Found method matching methodName
						Log.d(LOG_TAG, "--> Execute: "+methodName);
						try {
							
							callback.invoke(callbackDelegate, methodArgs.toArray());
							
						} catch (IllegalAccessException iaE) {
							
							Log.d(LOG_TAG, "IllegalAccessException");
							
						} catch (InvocationTargetException itE) {

							Log.d(LOG_TAG, "InvocationTargetException");
							
						}
						
					}
					
				}
				
			}
			
		}
		
	}
	
	/**
	 * Checks is arguments specified matches paramTypes.
	 * @param args
	 * @param paramTypes
	 * @return
	 */
	private boolean isArgsMatchMethodParams(Object[] args, Class<?>[] paramTypes) {
		
		int numArgs = args.length;
		int numMethodParams = paramTypes.length;
		
		if (numMethodParams != numArgs) {
			
			// number of arguments do not match
			return false;
			
		} else {
			
			// number of arguments match number of parameters
			// check to see if parameter types match
			
			for (int i = 0; i < numMethodParams; i++) {
				
				Log.d(LOG_TAG, args[i].getClass().toString() + ": " + paramTypes[i].toString() + ", " + String.valueOf(args[i].getClass() == paramTypes[i]));
				
				// TODO: use instanceof instead
				if (args[i].getClass() != paramTypes[i])
					return false; // argument i does not match paramType i
				
			}
			
			return true;
			
		}
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden public methods
	//
	//--------------------------------------------------------------------------

	/* (non-Javadoc)
	 * @see android.webkit.WebView#setWebViewClient(android.webkit.WebViewClient)
	 */
	@Override
	public void setWebViewClient(WebViewClient client) {
		
		throw new RuntimeException("setWebViewClient() method is not supported for WebViewBridge.");
		
	}

	/* (non-Javadoc)
	 * @see android.webkit.WebView#setWebChromeClient(android.webkit.WebChromeClient)
	 */
	@Override
	public void setWebChromeClient(WebChromeClient client) {

		throw new RuntimeException("setWebChromeClient() method is not supported for WebViewBridge.");
		
	}

	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------
	
	public void setCallbackDelegate(CallbackDelegate delegate) {
		
		callbackDelegate = delegate;
		
		/*
		Method method;
		try {
			
			Class<?>[] params = {String.class, String.class};
			method = callbackDelegate.getClass().getMethod("awesomeFunction", params);
			Log.d(LOG_TAG, "yes awesomeFunction");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no awesomeFunction");
			
		}
		
		try {
			
			method = callbackDelegate.getClass().getMethod("awesomeFunction", String.class, String.class);
			Log.d(LOG_TAG, "yes awesomeFunction");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no awesomeFunction");
			
		}
		
		try {
			
			method = callbackDelegate.getClass().getMethod("helloFunc");
			Log.d(LOG_TAG, "yes helloFunc");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no helloFunc");
			
		}
		
		try {
			
			method = callbackDelegate.getClass().getMethod("helloWorldFunc");
			Log.d(LOG_TAG, "yes helloWorldFunc");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no helloWorldFunc");
			
		}
		
		try {
			
			method = callbackDelegate.getClass().getMethod("helloWorldFunc", (Class[]) null);
			Log.d(LOG_TAG, "yes helloWorldFunc, (Class[]) null");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no helloWorldFunc, (Class[]) null");
			
		}
		
		try {
			
			method = callbackDelegate.getClass().getMethod("onCallback", (Class[]) null);
			Log.d(LOG_TAG, "yes onCallback");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no onCallback");
			
		}
		
		try {
			
			method = callbackDelegate.getClass().getMethod("onCallback", Object.class);
			Log.d(LOG_TAG, "yes onCallback");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no onCallback");
			
		}
		
		try {
			
			method = callbackDelegate.getClass().getMethod("fakeFunction", (Class[]) null);
			Log.d(LOG_TAG, "yes fakeFunction");
			
		} catch (NoSuchMethodException e) {
			
			Log.d(LOG_TAG, "no fakeFunction");
			
		}
		*/
		
	}

	public void execJavaScript(String jsMethodName) {
		
		execJavaScript(jsMethodName, null);
		
	}

	public void execJavaScript(String jsMethodName, Object[] argsArray) {
		
		callJS(jsMethodName, argsArray);
		
	}
	
	public void execJavaScript(String jsMethodName, Object[] argsArray, Method callback) {
		
		if (callback == null)
			execJavaScript(jsMethodName, argsArray);
		else
			execJavaScript(jsMethodName, argsArray, new CallbackMethod(callback));
		
	}
	
	public void execJavaScript(String jsMethodName, Object[] argsArray, CallbackMethod callback) {

		if (callback == null) {

			// No callback method
			execJavaScript(jsMethodName, argsArray);
			
		} else {
			
			// callback method defined, make sure it is defined in callback delegate

			if (callbackDelegate == null) {

				throw new RuntimeException("Callback delegate not set.");

			} else {

				try {

					Method callbackMethod = callbackDelegate.getClass().getMethod(callback.name, callback.parameterTypes);
					callJS(bridgeJSFunction, createCommandObj(jsMethodName, argsArray), callback.name);

				} catch (NoSuchMethodException e) {

					throw new RuntimeException("Specified callback method does not exist in callback delegate.");

				}

			}
			
		}

	}

	//--------------------------------------------------------------------------
	//
	//  Public static interface
	//
	//--------------------------------------------------------------------------
	
	public static interface CallbackDelegate {
	}
	
	public static class CallbackMethod {
		
		/**
		 * @param name
		 * @param parameterTypes
		 */
		public CallbackMethod(String name, Class<?>[] parameterTypes) {
			this.name = name;
			this.parameterTypes = parameterTypes;
		}
		
		/**
		 * @param method
		 */
		public CallbackMethod(Method method) {
			this.name = method.getName();
			this.parameterTypes = method.getParameterTypes();
		}
		
		public String name;
		public Class<?>[] parameterTypes;
		
	}
	
}
