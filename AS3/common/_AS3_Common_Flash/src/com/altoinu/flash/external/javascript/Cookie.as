/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.external.javascript
{
	
	import com.altoinu.flash.global.TraceControl;
	
	import flash.external.ExternalInterface;
	
	/**
	 * Utility functions to allow Flash to interact with browser cookies.
	 * 
	 * Note: Methods in this class uses flash.external.ExternalInterface to access JavaScript methods.
	 * Make sure AllowScriptAccess is set to allow calling JavaScript from Flash.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Cookie
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const DEBUG_TRACER:TraceControl = new TraceControl("===Cookie: ");
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Sets specified cookie with a specified value.
		 * 
		 * @param name Name of the cookie to set.
		 * @param value Value of the cookie to set.
		 * @param expires Cookie's life specified in milliseconds.  Cookie will expire after specified
		 * time passes and will not be readable after that.  If you do not specify a value, then cookie expires
		 * when browser closes.  If you set this to a negative number, then cookie is deleted.
		 * @param path If you specify this value, then all web pages under the specified path and its subfolders
		 * can access the cookie information.
		 * @param domain If you specify a domain, then all web sites under the same domain can access the stored cookie information.
		 * @param secure If you specify true, then the stored cookie information can only be accessed from HTTPS.
		 * 
		 */
		public static function set_Cookie(name:String, value:String, expires:Number = NaN, path:String = null, domain:String = null, secure:Boolean = false):void
		{
			
			if (!ExternalInterface.available)
			{
				
				DEBUG_TRACER.tracetext("External Interface not available, exiting...");
				return;
				
			}
			
			// set time, it's in milliseconds
			var today:Date = new Date();
			
			// This is when this cookie will expire
			var expires_date:Date = new Date(today.getTime() + (expires));
			
			// Set cookie via JavaScript
			var cookieString:String = name + "=" +escape( value ) +
			((!isNaN(expires)) ? ";expires=" + expires_date.toUTCString() : "" ) + 
			((path != null) ? ";path=" + path : "" ) + 
			((domain != null) ? ";domain=" + domain : "" ) +
			((secure) ? ";secure" : "" );
			
			ExternalInterface.call("function (cookiestring) { document.cookie = cookiestring; }", cookieString);
			
		}
		
		/**
		 * Obtains the value of specified cookie.
		 * @param name Name of the cookie to look up.
		 * @return Value of the cookie.
		 * 
		 */
		public static function get_Cookie(name:String):String
		{
			
			if (!ExternalInterface.available)
			{
				
				DEBUG_TRACER.tracetext("External Interface not available, exiting...");
				return null;
				
			}
			
			try
			{
				
				var cookieString:String = ExternalInterface.call("function () { return document.cookie; }");
				var start:int = cookieString.indexOf( name + "=" );
				var len:int = start + name.length + 1;
				
			}
			catch (e:Error)
			{
				
				DEBUG_TRACER.tracetext("Error has occured retrieving cookie.");
				return null;
				
			}
			
			if (isNaN(start) &&
				(name != cookieString.substring(0, name.length)))
				return null;
			
			if (start == -1)
				return null;
		
			var end:int = cookieString.indexOf( ";", len );
		
			if (end == -1)
				end = cookieString.length;
		
			return unescape(cookieString.substring(len, end));
		
		}
		
		/**
		 * Deletes specified cookie.
		 * @param name
		 * 
		 */
		public static function delete_Cookie(name:String):void
		{
			
			if (!ExternalInterface.available)
			{
				
				DEBUG_TRACER.tracetext("External Interface not available, exiting...");
				return;
				
			}
			
			set_Cookie(name, "", -1000);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Contructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function Cookie()
		{
			
			throw("You do not create an instance of Cookie.  Just call its static functions.");
			
		}
		
	}
	
}