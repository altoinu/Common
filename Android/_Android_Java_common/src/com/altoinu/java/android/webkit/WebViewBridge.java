/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.java.android.webkit;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Handler;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.webkit.JsPromptResult;
import android.webkit.JsResult;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.altoinu.java.android.utils.StringUtils;
import com.altoinu.java.android.utils.URIUtils;
import com.altoinu.java.android.utils.ViewUtils;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

/**
 * WebViewBridge
 * Version 1.1.2
 * 
 * Requires:
 * Gson https://code.google.com/p/google-gson/
 * Code_Samples/Android Projects/WebViewBridgeExample/assets/html/*
 * 
 * See example: Code_Samples/Android Projects/WebViewBridgeExample
 * @author kaoru
 *
 */
public class WebViewBridge extends WebView {

	// --------------------------------------------------------------------------
	//
	// Constants
	//
	// --------------------------------------------------------------------------

	public static final String LOG_TAG = "WebViewBridge";

	// --------------------------------------------------------------------------
	//
	// Constructor
	//
	// --------------------------------------------------------------------------

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

	// --------------------------------------------------------------------------
	//
	// Private properties
	//
	// --------------------------------------------------------------------------

	private CallbackDelegate callbackDelegate;
	private int hashcounter = 0;
	private Gson gson = new Gson();

	// --------------------------------------------------------------------------
	//
	// Protected properties
	//
	// --------------------------------------------------------------------------

	protected boolean contentLoaded = false;

	protected ArrayList<HashMap<String, Object>> queuedJavaScriptCommands;

	/**
	 * WebViewBridge will detect location change with this protocol to determine
	 * it is a response being sent back to app from HTML/JavaScript.
	 */
	protected String responseProtocol = "kaorulikescurryrice";

	// --------------------------------------------------------------------------
	//
	// Private methods
	//
	// --------------------------------------------------------------------------

	private void init() {

		final Context webViewContext = getContext();

		// Enable JavaScript
		WebSettings settings = getSettings();
		settings.setJavaScriptEnabled(true);

		super.setWebViewClient(new WebViewBridgeClient(webViewContext));
		//super.setWebChromeClient(new WebChromeClient());
		super.setWebChromeClient(new WebViewBridgeChromeClient(webViewContext));

		addJavascriptInterface(new Object(), "AndroidWebViewBridge");

		loadWebViewBridgeHTML();

	}

	private static int[] getChromeWebViewVersion(WebView webView) {
		
		String userAgent = webView.getSettings().getUserAgentString();
		Pattern chromePattern = Pattern.compile("Chrome\\/([0-9\\.]+)");
		Matcher chromeMatcher = chromePattern.matcher(userAgent);

		if (chromeMatcher.find()) {
			
			String versionValues[] = chromeMatcher.group(1).split("\\.");
			int versionNum[] = new int[versionValues.length];
			for (int i = 0; i < versionValues.length; i++) {
				
				try {
					versionNum[i] = Integer.parseInt(versionValues[i]);
				} catch (NumberFormatException nfe) {
					versionNum[i] = -1;
				}
				
			}
			
			return versionNum;
			
		} else {
			
			return null;
			
		}
		
	}

	private static HashMap<String, Object> createCommandObj(String methodName) {

		return createCommandObj(methodName, null);

	}

	private static HashMap<String, Object> createCommandObj(String methodName,
			Object[] args) {

		CallbackMethod nocallback = null;
		return createCommandObj(methodName, args, nocallback);
		
	}

	private static HashMap<String, Object> createCommandObj(String methodName,
			Object[] args, Method callback) {
		
		return createCommandObj(methodName, args, new CallbackMethod(callback));
		
	}
	
	private static HashMap<String, Object> createCommandObj(String methodName,
			Object[] args, CallbackMethod callback) {
		
		HashMap<String, Object> command = new HashMap<String, Object>();
		command.put("method", methodName);

		int numArgs = (args != null ? args.length : 0);
		if (numArgs > 0)
			command.put("arguments", args);

		if (callback != null)
			command.put("callback", callback.name);
		
		return command;
		
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

			// Not sure why but this does not work anymore
			//loadUrl("javascript:window.location.hash='" + URIUtils.encodeURIComponent(hashcounter + "&" + commandString) + "'");
			// but these do
			//loadUrl("javascript:alert('bleh!')");
			//loadUrl("javascript:window.location='http://www.yahoo.com'");
			
			// this works
			evaluateJavascript("window.location.hash='" + URIUtils.encodeURIComponent(hashcounter + "&" + commandString) + "'", new ValueCallback<String>() {
				@Override
				public void onReceiveValue(String value) {}
			});

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

	protected void callJS(String methodName, CallbackMethod callback, Object... args) {

		if (contentLoaded) {

			// This is my dirty trick #1 to send data to contents in StageWebView
			// HTML page should be watching for hash changing and when it does capture it
			// it should parse data being passed.
			if (queuedJavaScriptCommands == null)
				queuedJavaScriptCommands = new ArrayList<HashMap<String,Object>>();

			// Put all JavaScript commands into Array so they will be called all at once later
			// need to do this because hashchange event in HTML page may not capture all changes
			// so I'm sending it as one
			queuedJavaScriptCommands.add(createCommandObj(methodName, args, callback));

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
			String paramString = StringUtils.dropURLProtocol(stringToBeDecoded, responseProtocol);

			// Not sure why I put this here originally...
			//if (paramString.indexOf(" ") == -1)
			//	paramString = paramString.substring(paramString.indexOf(" ")); // drop extra space and anything after it

			// Assume URL encoded JSON pattern {"method":"method1","arguments":[arg1,arg2...]}/{"method":"method2","arguments":[arg1,arg2...]}/...
			String[] responses = paramString.split("/");
			HashMap<String, Object> command;
			String methodName;
			ArrayList<Object> methodArgs;
			Method[] callbackMethods = callbackDelegate.getClass().getMethods();
			String callbackName;
			Class<?>[] callbackParamTypes;
			for (String response : responses) {

				command = gson.fromJson(URIUtils.decodeURIComponent(URIUtils.decodeURIComponent(response)), new TypeToken<HashMap<String, Object>>() {}.getType());
				methodName = command.get("method").toString();
				methodArgs = (command.containsKey("arguments") ? (ArrayList<Object>) command.get("arguments") : null);

				// Now do something with this data
				Log.d(LOG_TAG, URIUtils.decodeURIComponent(URIUtils.decodeURIComponent(response)));
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

				//Log.d(LOG_TAG, args[i].getClass().toString() + ": " + paramTypes[i].toString() + ", " + String.valueOf(args[i].getClass() == paramTypes[i]));

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

		// No callback method
		callJS(jsMethodName, null, argsArray);

	}

	public void execJavaScript(String jsMethodName, Object[] argsArray,
			Method callback) {

		if (callback == null)
			execJavaScript(jsMethodName, argsArray);
		else
			execJavaScript(jsMethodName, argsArray,
					new CallbackMethod(callback));

	}

	public void execJavaScript(String jsMethodName, Object[] argsArray,
			CallbackMethod callback) {

		if (callback == null) {

			// No callback method
			execJavaScript(jsMethodName, argsArray);

		} else {

			// callback method defined, make sure it is defined in callback
			// delegate

			if (callbackDelegate == null) {

				throw new RuntimeException("Callback delegate not set.");

			} else {

				try {

					// This line will check to make sure specified callback
					// exists
					Method callbackMethod = callbackDelegate.getClass()
							.getMethod(callback.name, callback.parameterTypes);

					// If so, execute command
					callJS(jsMethodName, callback, argsArray);

				} catch (NoSuchMethodException e) {

					// If not, error will be thrown
					throw new RuntimeException(
							"Specified callback method does not exist in callback delegate.");

				}

			}

		}

	}

	// --------------------------------------------------------------------------
	//
	// Public static interface
	//
	// --------------------------------------------------------------------------

	/**
	 * Wrapper interface to define callback methods
	 * 
	 */
	public static interface CallbackDelegate {
	}

	// --------------------------------------------------------------------------
	//
	// Public static class
	//
	// --------------------------------------------------------------------------

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

	// --------------------------------------------------------------------------
	//
	// internal class
	//
	// --------------------------------------------------------------------------

	class WebViewBridgeClient extends WebViewClient {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public WebViewBridgeClient(Context context) {

			super();

			webViewContext = context;

		}

		//--------------------------------------------------------------------------
		//
		//  Private variables
		//
		//--------------------------------------------------------------------------

		private Context webViewContext;

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

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

			Log.d(LOG_TAG, "shouldOverrideUrlLoading");
			
			String currentURL = view.getUrl();
			
			if ((currentURL.length() == 0) ||
					((url.length() > 0) && (currentURL.indexOf(url) == -1))) {

				// Trying to go to different page

				Log.d(LOG_TAG, currentURL);
				Log.d(LOG_TAG, view.getOriginalUrl());

				if (StringUtils.getURLProtocol(url).equals(responseProtocol)) {

					// Oh look! Nice protocol found...This is my dirty trick to capture data coming back from HTML page
					Log.d(LOG_TAG, "========> Caught data from WebView at shouldOverrideUrlLoading: " + url + " --> process response");
					processResponseFromWebView(url);

				} else if (url != view.getOriginalUrl()) {

					// OK, it is not that protocol and it is trying to go to different URL
					// so let's just open it
					Log.d(LOG_TAG, "========> Location change captured, current: " + currentURL + " --> to: " + url);

					// open same URL normally instead
					Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
					webViewContext.startActivity(browserIntent);

				}

				// prevent WebView from chainging its URL
				return true;

			} else {

				return super.shouldOverrideUrlLoading(view, url);

			}

		}

	}

	class WebViewBridgeChromeClient extends WebChromeClient {

		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------

		private static final int PROMPT_INPUT_TEXT = 1;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public WebViewBridgeChromeClient(Context context) {

			super();

			webViewContext = context;

		}

		//--------------------------------------------------------------------------
		//
		//  Private variables
		//
		//--------------------------------------------------------------------------

		private Context webViewContext;
		private JsResult mResult;
		private JsPromptResult promptresult;

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/*
		 * (non-Javadoc) Android WebView M40 does not include capability to do
		 * JavaScript alert/confirm/prompt, so they have to be implemented here
		 * https://plus.google.com/104420146897771890981/posts/3tgs9NV3ird
		 */
		@Override
		public boolean onJsAlert(WebView view, String url, String message,
				JsResult result) {

			Log.d(LOG_TAG, "onJsAlert: " + url + " " + message);

			int[] webViewVersion = WebViewBridge.getChromeWebViewVersion(view);
			Log.d(LOG_TAG, view.getSettings().getUserAgentString());
			Log.d(LOG_TAG, String.valueOf(webViewVersion[0]));
			
			if (webViewVersion[0] == 40) {
				
				mResult = result;
				promptresult = null;
				
				AlertDialog dialog = new AlertDialog.Builder(webViewContext)
				.setTitle("JavaScript Alert").setMessage(message)
				.setOnCancelListener(new CancelListener())
				.setPositiveButton("Ok", new PositiveListener()).create();
				dialog.getWindow().setType(
						WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
				dialog.show();
				return true;
				
			} else {
				
				return false;
				
			}

		}

		@Override
		public boolean onJsConfirm(WebView view, String url, String message,
				JsResult result) {

			Log.d(LOG_TAG, "onJsConfirm: " + url + " " + message);

			int[] webViewVersion = WebViewBridge.getChromeWebViewVersion(view);
			Log.d(LOG_TAG, view.getSettings().getUserAgentString());
			Log.d(LOG_TAG, String.valueOf(webViewVersion[0]));
			
			if (webViewVersion[0] == 40) {
				
				mResult = result;
				promptresult = null;
				
				AlertDialog dialog = new AlertDialog.Builder(webViewContext)
				.setTitle("JavaScript Confirm").setMessage(message)
				.setOnCancelListener(new CancelListener())
				.setNegativeButton("Cancel", new CancelListener())
				.setPositiveButton("Ok", new PositiveListener()).create();
				dialog.getWindow().setType(
						WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
				dialog.show();
				return true;
				
			} else {
				
				return false;
				
			}

		}

		@Override
		public boolean onJsPrompt(WebView view, String url, String message,
				String defaultValue, JsPromptResult result) {

			Log.d(LOG_TAG, "onJsPrompt: " + url + " " + message + " "
					+ defaultValue);
			
			int[] webViewVersion = WebViewBridge.getChromeWebViewVersion(view);
			Log.d(LOG_TAG, view.getSettings().getUserAgentString());
			Log.d(LOG_TAG, String.valueOf(webViewVersion[0]));
			
			if (webViewVersion[0] == 40) {
				
				mResult = result;
				promptresult = result;
	
				LinearLayout layoutPromptView = new LinearLayout(webViewContext);
				layoutPromptView.setOrientation(LinearLayout.VERTICAL);
				layoutPromptView.setGravity(Gravity.CENTER_HORIZONTAL);
				LinearLayout.LayoutParams layoutParamsPromptView = new LinearLayout.LayoutParams(
						LinearLayout.LayoutParams.MATCH_PARENT,
						LinearLayout.LayoutParams.MATCH_PARENT);
				layoutPromptView.setLayoutParams(layoutParamsPromptView);
				layoutPromptView.setPadding(ViewUtils.dpToPx(4, webViewContext), ViewUtils.dpToPx(4, webViewContext), ViewUtils.dpToPx(4, webViewContext), ViewUtils.dpToPx(4, webViewContext));
				
				TextView textPromptMessage = new TextView(webViewContext);
				textPromptMessage.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
				textPromptMessage.setText(message);
				layoutPromptView.addView(textPromptMessage);
				
				EditText editTextPrompt = new EditText(webViewContext);
				editTextPrompt.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
				editTextPrompt.setMinWidth(ViewUtils.dpToPx(250, webViewContext));
				editTextPrompt.setInputType(EditorInfo.TYPE_CLASS_TEXT);
				editTextPrompt.setHorizontalScrollBarEnabled(true);
				editTextPrompt.setSelectAllOnFocus(true);
				editTextPrompt.setId(PROMPT_INPUT_TEXT);
				editTextPrompt.setText(defaultValue);
				
				layoutPromptView.addView(editTextPrompt);
				
				final AlertDialog dialog = new AlertDialog.Builder(webViewContext)
						.setTitle("JavaScript Prompt")
						.setView(layoutPromptView)
						.setOnCancelListener(new CancelListener())
						.setNegativeButton("Cancel", new CancelListener())
						.setPositiveButton("Ok", new OnPromptClickListener()).create();
				dialog.getWindow().setType(
						WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
				dialog.getWindow().setGravity(Gravity.CENTER);
				dialog.show();
				
				/*
				editTextPrompt.setOnFocusChangeListener(new OnFocusChangeListener() {
					@Override
					public void onFocusChange(View v, boolean hasFocus) {
						if (hasFocus) {
							//dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
							//dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
							dialog.getWindow().setGravity(Gravity.CENTER);
						}
					}
				});
				*/
				
				return true;
				
			} else {
				
				return false;
				
			}

		}

		//--------------------------------------------------------------------------
		//
		//  Internal classes
		//
		//--------------------------------------------------------------------------

		class OnPromptClickListener implements DialogInterface.OnClickListener {

			@Override
			public void onClick(DialogInterface dialog, int which) {
				EditText promptInputText = (EditText) ((AlertDialog) dialog).findViewById(PROMPT_INPUT_TEXT);
				promptresult.confirm(promptInputText.getText().toString());
			}

		}

		class CancelListener implements DialogInterface.OnCancelListener, 
		DialogInterface.OnClickListener {

			@Override
			public void onCancel(DialogInterface dialogInterface) {
				mResult.cancel();
			}

			@Override
			public void onClick(DialogInterface dialogInterface, int which) {
				mResult.cancel();
			}

		}

		class PositiveListener implements DialogInterface.OnClickListener {

			@Override
			public void onClick(DialogInterface dialogInterface, int which) {
				mResult.confirm();
			}

		}

	}

}
