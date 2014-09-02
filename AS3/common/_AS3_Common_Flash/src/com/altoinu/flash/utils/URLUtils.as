/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	public class URLUtils
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Returns the domain and port information from the specified URL.
		 *  
		 *  @param url The URL to analyze.
		 *  @return The server name and port of the specified URL.
		 */
		public static function getServerNameWithPort(url:String):String
		{
			
			// Find first slash; second is +1, start 1 after.
			var start:int = url.indexOf("/") + 2;
			var length:int = url.indexOf("/", start);
			return length == -1 ? url.substring(start) : url.substring(start, length);
			
		}
		
		/**
		 *  Returns the server name from the specified URL.
		 *  
		 *  @param url The URL to analyze.
		 *  @return The server name of the specified URL.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getServerName(url:String):String
		{
			var sp:String = getServerNameWithPort(url);
			
			// If IPv6 is in use, start looking after the square bracket.
			var delim:int = sp.indexOf("]");
			delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");   
			
			if (delim > 0)
				sp = sp.substring(0, delim);
			return sp;
		}
		
		/**
		 *  Returns the port number from the specified URL.
		 *  
		 *  @param url The URL to analyze.
		 *  @return The port number of the specified URL.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getPort(url:String):uint
		{
			var sp:String = getServerNameWithPort(url);
			// If IPv6 is in use, start looking after the square bracket.
			var delim:int = sp.indexOf("]");
			delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");          
			var port:uint = 0;
			if (delim > 0)
			{
				var p:Number = Number(sp.substring(delim + 1));
				if (!isNaN(p))
					port = int(p);
			}
			
			return port;
		}
		
		/**
		 *  Converts a potentially relative URL to a fully-qualified URL.
		 *  If the URL is not relative, it is returned as is.
		 *  If the URL starts with a slash, the host and port
		 *  from the root URL are prepended.
		 *  Otherwise, the host, port, and path are prepended.
		 *
		 *  @param rootURL URL used to resolve the URL specified by the <code>url</code> parameter, if <code>url</code> is relative.
		 *  @param url URL to convert.
		 *
		 *  @return Fully-qualified URL.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getFullURL(rootURL:String, url:String):String
		{
			if (url != null && !URLUtils.isHttpURL(url))
			{
				if (url.indexOf("./") == 0)
				{
					url = url.substring(2);
				}
				if (URLUtils.isHttpURL(rootURL))
				{
					var slashPos:Number;
					
					if (url.charAt(0) == '/')
					{
						// non-relative path, "/dev/foo.bar".
						slashPos = rootURL.indexOf("/", 8);
						if (slashPos == -1)
							slashPos = rootURL.length;
					}
					else
					{
						// relative path, "dev/foo.bar".
						slashPos = rootURL.lastIndexOf("/") + 1;
						if (slashPos <= 8)
						{
							rootURL += "/";
							slashPos = rootURL.length;
						}
					}
					
					if (slashPos > 0)
						url = rootURL.substring(0, slashPos) + url;
				}
			}
			
			return url;
		}
		
		// Note: The following code was copied from Flash Remoting's
		// NetServices client components.
		// It is reproduced here to keep the services APIs
		// independent of the deprecated NetServices code.
		// Note that it capitalizes any use of URL in method or class names.
		
		/**
		 *  Determines if the URL uses the HTTP, HTTPS, or RTMP protocol. 
		 *
		 *  @param url The URL to analyze.
		 * 
		 *  @return <code>true</code> if the URL starts with "http://", "https://", or "rtmp://".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function isHttpURL(url:String):Boolean
		{
			return url != null &&
				(url.indexOf("http://") == 0 ||
					url.indexOf("https://") == 0);
		}
		
		/**
		 *  Determines if the URL uses the secure HTTPS protocol. 
		 *
		 *  @param url The URL to analyze.
		 * 
		 *  @return <code>true</code> if the URL starts with "https://".
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function isHttpsURL(url:String):Boolean
		{
			return url != null && url.indexOf("https://") == 0;
		}
		
		/**
		 *  Returns the protocol section of the specified URL.
		 *  The following examples show what is returned based on different URLs:
		 *  
		 *  <pre>
		 *  getProtocol("https://localhost:2700/") returns "https"
		 *  getProtocol("rtmp://www.myCompany.com/myMainDirectory/groupChatApp/HelpDesk") returns "rtmp"
		 *  getProtocol("rtmpt:/sharedWhiteboardApp/June2002") returns "rtmpt"
		 *  getProtocol("rtmp::1234/chatApp/room_name") returns "rtmp"
		 *  </pre>
		 *
		 *  @param url String containing the URL to parse.
		 *
		 *  @return The protocol or an empty String if no protocol is specified.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getProtocol(url:String):String
		{
			var slash:int = url.indexOf("/");
			var indx:int = url.indexOf(":/");
			if (indx > -1 && indx < slash)
			{
				return url.substring(0, indx);
			}
			else
			{
				indx = url.indexOf("::");
				if (indx > -1 && indx < slash)
					return url.substring(0, indx);
			}
			
			return "";
		}
		
		/**
		 *  Replaces the protocol of the
		 *  specified URI with the given protocol.
		 *
		 *  @param uri String containing the URI in which the protocol
		 *  needs to be replaced.
		 *
		 *  @param newProtocol String containing the new protocol to use.
		 *
		 *  @return The URI with the protocol replaced,
		 *  or an empty String if the URI does not contain a protocol.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function replaceProtocol(uri:String,
											   newProtocol:String):String
		{
			return uri.replace(getProtocol(uri), newProtocol);
		}
		
		/**
		 *  Returns a new String with the port replaced with the specified port.
		 *  If there is no port in the specified URI, the port is inserted.
		 *  This method expects that a protocol has been specified within the URI.
		 *
		 *  @param uri String containing the URI in which the port is replaced.
		 *  @param newPort uint containing the new port to subsitute.
		 *
		 *  @return The URI with the new port.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function replacePort(uri:String, newPort:uint):String
		{
			var result:String = "";
			
			// First, determine if IPv6 is in use by looking for square bracket
			var indx:int = uri.indexOf("]");
			
			// If IPv6 is not in use, reset indx to the first colon
			if (indx == -1)
				indx = uri.indexOf(":");
			
			var portStart:int = uri.indexOf(":", indx+1);
			var portEnd:int;
			
			// If we have a port
			if (portStart > -1)
			{
				portStart++; // move past the ":"
				portEnd = uri.indexOf("/", portStart);
				//@TODO: need to throw an invalid uri here if no slash was found
				result = uri.substring(0, portStart) +
					newPort.toString() +
					uri.substring(portEnd, uri.length);
			}
			else
			{
				// Insert the specified port
				portEnd = uri.indexOf("/", indx);
				if (portEnd > -1)
				{
					// Look to see if we have protocol://host:port/
					// if not then we must have protocol:/relative-path
					if (uri.charAt(portEnd+1) == "/")
						portEnd = uri.indexOf("/", portEnd + 2);
					
					if (portEnd > 0)
					{
						result = uri.substring(0, portEnd) +
							":"+ newPort.toString() +
							uri.substring(portEnd, uri.length);
					}
					else
					{
						result = uri + ":" + newPort.toString();
					}
				}
				else
				{
					result = uri + ":"+ newPort.toString();
				}
			}
			
			return result;
		}
		
	}
	
}