/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.twitter.models
{
	
	import com.altoinu.flash.customcomponents.twitter.TweetButtonCountBoxPosition;
	
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	
	/**
	 * Parameters used by Tweet Button.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class TweetButtonParameters
	{
		
		public function TweetButtonParameters(url:String = "", via:String = "", text:String = "", related:String = "", count:String = null, lang:String = "", counturl:String = "")
		{
			
			this.url = url;
			this.via = via;
			this.text = text;
			this.related = related;
			
			if (count != null)
				this.count = count;
			
			this.lang = lang;
			this.counturl = counturl;
			
		}
		
		public var url:String = "";
		
		public var via:String = "";
		
		public var text:String = "";
		
		public var related:String = "";
		
		public var count:String = TweetButtonCountBoxPosition.HORIZONTAL;
		
		public var lang:String = "";
		
		public var counturl:String = "";
		
		/**
		 * Using specified tweet button parameters, directly open tweet page in a new browser window.
		 * 
		 * @param targetWindowName - Target attribute or the name of the window to display tweet box. (ex. _blank, _self, etc.)
		 * @param specs Comma separated list of window specs.
		 * 
		 */
		public function tweet(targetWindowName:String = null, specs:String = null):void
		{
			
			var parameters:String = toString();
			if (parameters.length > 0)
				parameters = "?" + parameters;
			
			var tweetURL:String = "https://twitter.com/share"+parameters;
			
			//var tweetURLReq:URLRequest = new URLRequest(tweetURL);
			//navigateToURL(tweetURLReq, "_blank");
			
			ExternalInterface.call("window.open", tweetURL, targetWindowName, specs);
			
		}
		
		public function toString():String
		{
			
			var tweetButtonParams:URLVariables = new URLVariables();
			
			if ((url != null) && (url != ""))
				tweetButtonParams.url = url;
			
			if ((via != null) && (via != ""))
				tweetButtonParams.via = via;
			
			if ((text != null) && (text != ""))
				tweetButtonParams.text = text;
			
			if ((related != null) && (related != ""))
				tweetButtonParams.related = related;
			
			if ((count != null) && (count != ""))
				tweetButtonParams.count = count;
			
			if ((lang != null) && (lang != ""))
				tweetButtonParams.lang = lang;
			
			if ((counturl != null) && (counturl != ""))
				tweetButtonParams.counturl = counturl;
			
			return tweetButtonParams.toString();
			
		}
		
	}
	
}