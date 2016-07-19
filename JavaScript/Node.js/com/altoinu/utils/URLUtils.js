define(function() {
	
	var $URLUtils = function() {
		var me = this;
	};

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
	$URLUtils.getServerNameWithPort = function(url) {
		
		// Find first slash; second is +1, start 1 after.
		var start = url.indexOf('/') + 2;
		var length = url.indexOf('/', start);
		return length == -1 ? url.substring(start) : url.substring(start, length);
		
	};

	/**
	 *  Returns the server name from the specified URL.
	 *  
	 *  @param url The URL to analyze.
	 *  @return The server name of the specified URL.
	 */
	$URLUtils.getServerName = function(url) {
		var sp = $URLUtils.getServerNameWithPort(url);
		
		// If IPv6 is in use, start looking after the square bracket.
		var delim = sp.indexOf(']');
		delim = (delim > -1)? sp.indexOf(':', delim) : sp.indexOf(':');   
		
		if (delim > 0)
			sp = sp.substring(0, delim);
		return sp;
	};

	/**
	 *  Returns the port number from the specified URL.
	 *  
	 *  @param url The URL to analyze.
	 *  @return The port number of the specified URL.
	 */
	$URLUtils.getPort = function(url) {
		var sp = $URLUtils.getServerNameWithPort(url);
		// If IPv6 is in use, start looking after the square bracket.
		var delim = sp.indexOf(']');
		delim = (delim > -1)? sp.indexOf(':', delim) : sp.indexOf(':');          
		var port = 0;
		if (delim > 0)
		{
			var p = Number(sp.substring(delim + 1));
			if (!isNaN(p))
				port = int(p);
		}
		
		return port;
	};

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
	 */
	$URLUtils.getFullURL = function(rootURL, url) {
		if (url != null && !$URLUtils.isHttpURL(url))
		{
			if (url.indexOf('./') == 0)
			{
				url = url.substring(2);
			}
			if ($URLUtils.isHttpURL(rootURL))
			{
				var slashPos;
				
				if (url.charAt(0) == '/')
				{
					// non-relative path, '/dev/foo.bar'.
					slashPos = rootURL.indexOf('/', 8);
					if (slashPos == -1)
						slashPos = rootURL.length;
				}
				else
				{
					// relative path, 'dev/foo.bar'.
					slashPos = rootURL.lastIndexOf('/') + 1;
					if (slashPos <= 8)
					{
						rootURL += '/';
						slashPos = rootURL.length;
					}
				}
				
				if (slashPos > 0)
					url = rootURL.substring(0, slashPos) + url;
			}
		}
		
		return url;
	};

	/**
	 *  Determines if the URL uses the HTTP, HTTPS, or RTMP protocol. 
	 *
	 *  @param url The URL to analyze.
	 * 
	 *  @return <code>true</code> if the URL starts with "http://", "https://", or "rtmp://".
	 */
	$URLUtils.isHttpURL = function(url) {
		return url != null &&
			(url.indexOf('http://') == 0 ||
				url.indexOf('https://') == 0);
	};

	/**
	 *  Determines if the URL uses the secure HTTPS protocol. 
	 *
	 *  @param url The URL to analyze.
	 * 
	 *  @return <code>true</code> if the URL starts with "https://".
	 */
	$URLUtils.isHttpsURL = function(url) {
		return url != null && url.indexOf('https://') == 0;
	};
	
	/**
	 * Returns the protocol section of the specified URL. The following examples
	 * show what is returned based on different URLs:
	 * 
	 * <pre>
	 *  getProtocol(&quot;https://localhost:2700/&quot;) returns &quot;https&quot;
	 *  getProtocol(&quot;rtmp://www.myCompany.com/myMainDirectory/groupChatApp/HelpDesk&quot;) returns &quot;rtmp&quot;
	 *  getProtocol(&quot;rtmpt:/sharedWhiteboardApp/June2002&quot;) returns &quot;rtmpt&quot;
	 *  getProtocol(&quot;rtmp::1234/chatApp/room_name&quot;) returns &quot;rtmp&quot;
	 * </pre>
	 * 
	 * @param url
	 *            String containing the URL to parse.
	 * 
	 * @return The protocol or an empty String if no protocol is specified.
	 */
	$URLUtils.getProtocol = function(url) {
		
		var slash = url.indexOf('/');
		var indx = url.indexOf(':/');
		if (indx > -1 && indx < slash)
		{
			return url.substring(0, indx);
		}
		else
		{
			indx = url.indexOf('::');
			if (indx > -1 && indx < slash)
				return url.substring(0, indx);
		}
		
		return '';
	
	};

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
	 */
	$URLUtils.replaceProtocol = function(uri, newProtocol) {
		return uri.replace($URLUtils.getProtocol(uri), newProtocol);
	};
	
	/**
	 *  Returns a new String with the port replaced with the specified port.
	 *  If there is no port in the specified URI, the port is inserted.
	 *  This method expects that a protocol has been specified within the URI.
	 *
	 *  @param uri String containing the URI in which the port is replaced.
	 *  @param newPort uint containing the new port to subsitute.
	 *
	 *  @return The URI with the new port.
	 */
	$URLUtils.replacePort = function(uri, newPort) {
		var result = '';
		
		// First, determine if IPv6 is in use by looking for square bracket
		var indx = uri.indexOf(']');
		
		// If IPv6 is not in use, reset indx to the first colon
		if (indx == -1)
			indx = uri.indexOf(':');
		
		var portStart = uri.indexOf(':', indx+1);
		var portEnd;
		
		// If we have a port
		if (portStart > -1)
		{
			portStart++; // move past the ':'
			portEnd = uri.indexOf('/', portStart);
			//@TODO: need to throw an invalid uri here if no slash was found
			result = uri.substring(0, portStart) +
				newPort.toString() +
				uri.substring(portEnd, uri.length);
		}
		else
		{
			// Insert the specified port
			portEnd = uri.indexOf('/', indx);
			if (portEnd > -1)
			{
				// Look to see if we have protocol://host:port/
				// if not then we must have protocol:/relative-path
				if (uri.charAt(portEnd+1) == '/')
					portEnd = uri.indexOf('/', portEnd + 2);
				
				if (portEnd > 0)
				{
					result = uri.substring(0, portEnd) +
						':'+ newPort.toString() +
						uri.substring(portEnd, uri.length);
				}
				else
				{
					result = uri + ':' + newPort.toString();
				}
			}
			else
			{
				result = uri + ':'+ newPort.toString();
			}
		}
		
		return result;
	};
	
	return $URLUtils;
	
});