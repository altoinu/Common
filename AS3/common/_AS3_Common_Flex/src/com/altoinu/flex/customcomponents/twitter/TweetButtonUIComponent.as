/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.twitter
{
	
	import com.altoinu.flash.customcomponents.twitter.TweetButtonArea;
	import com.altoinu.flash.customcomponents.twitter.TweetButtonCountBoxPosition;
	import com.altoinu.flash.customcomponents.twitter.events.TweetButtonEvent;
	import com.altoinu.flash.customcomponents.twitter.models.TweetButtonParameters;
	import com.altoinu.flex.customcomponents.mx.controls.external.javascript.AnchorToHTMLPageUIComponent;
	
	import flash.events.Event;
	
	/**
	 *  Dispatched when Tweet Button parameter changes.
	 *
	 *  @eventType com.altoinu.twitter.supportClasses.events.TweetButtonEvent.TWEET_PARAMETER_CHANGE
	 */
	[Event(name="tweetParameterChange", type="com.altoinu.flash.customcomponents.twitter.events.TweetButtonEvent")]
	
	/**
	 * Flex UIComponent to display <code>TweetButtonArea</code>.
	 * 
	 * @author Kaoru Kawashima
	 * @see com.altoinu.twitter.supportClasses.components.TweetButtonArea
	 * 
	 */
	public class TweetButtonUIComponent extends AnchorToHTMLPageUIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function TweetButtonUIComponent()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  updatePositionJSMethod
		//----------------------------------
		
		private var _updatePositionJSMethod:String = "TweetButtonFlash.addTweetButton";
		
		/**
		 * @default "addTweetButton"
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#updatePositionJSMethod
		 */
		override public function get updatePositionJSMethod():String
		{
			
			if (anchor != null)
				return anchor.updatePositionJSMethod;
			else
				return _updatePositionJSMethod;
			
		}
		
		/**
		 * @private
		 */
		override public function set updatePositionJSMethod(value:String):void
		{
			
			if (anchor != null)
				throw new Error("updatePositionJSMethod can only be set once.");
			
			_updatePositionJSMethod = value;
			
		}
		
		//----------------------------------
		//  removeJSMethod
		//----------------------------------
		
		private var _removeJSMethod:String = "TweetButtonFlash.removeTweetButton";
		
		/**
		 * @default "removeTweetButton"
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#removeJSMethod
		 */
		override public function get removeJSMethod():String
		{
			
			if (anchor != null)
				return anchor.removeJSMethod;
			else
				return _removeJSMethod;
			
		}
		
		/**
		 * @private
		 */
		override public function set removeJSMethod(value:String):void
		{
			
			if (anchor != null)
				throw new Error("removeJSMethod can only be set once.");
			
			_removeJSMethod = value;
			
		}
		
		//----------------------------------
		//  options
		//----------------------------------
		
		/**
		 * @private
		 */
		override public function set options(value:Object):void
		{
			
			super.options = value;
			
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  fbLikeButtonArea
		//----------------------------------
		
		public function get tweetButtonArea():TweetButtonArea
		{
			
			return anchor as TweetButtonArea;
			
		}
		
		//----------------------------------
		//  tweetButtonParams
		//----------------------------------
		
		private var _tweetButtonParams:TweetButtonParameters;
		
		[Bindable(event="tweetButtonParamsChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#tweetButtonParams
		 */
		public function get tweetButtonParams():TweetButtonParameters
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.tweetButtonParams;
			else if (_tweetButtonParams != null)
				return _tweetButtonParams;
			else
				return new TweetButtonParameters(url, via, text, related, count, lang, counturl);
			
		}
		
		/**
		 * @private
		 */
		public function set tweetButtonParams(value:TweetButtonParameters):void
		{
			
			_tweetButtonParams = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.tweetButtonParams = value;
			
			dispatchEvent(new Event("tweetButtonParams"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  url
		//----------------------------------
		
		private var _url:String = "";
		
		[Bindable(event="urlChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#url
		 */
		public function get url():String
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.url;
			else
				return _url;
			
		}
		
		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			
			_url = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.url = value;
			
			dispatchEvent(new Event("urlChange"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  via
		//----------------------------------
		
		private var _via:String = "";
		
		[Bindable(event="viaChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#via
		 */
		public function get via():String
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.via;
			else
				return _via;
			
		}
		
		/**
		 * @private
		 */
		public function set via(value:String):void
		{
			
			_via = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.via = value;
			
			dispatchEvent(new Event("viaChange"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  text
		//----------------------------------
		
		private var _text:String = "";
		
		[Bindable(event="textChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#text
		 */
		public function get text():String
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.text;
			else
				return _text;
			
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			
			_text = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.text = value;
			
			dispatchEvent(new Event("textChange"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  related
		//----------------------------------
		
		private var _related:String = "";
		
		[Bindable(event="relatedChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#related
		 */
		public function get related():String
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.related;
			else
				return _related;
			
		}
		
		/**
		 * @private
		 */
		public function set related(value:String):void
		{
			
			_related = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.related = value;
			
			dispatchEvent(new Event("relatedChange"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  count
		//----------------------------------
		
		private var _count:String = TweetButtonCountBoxPosition.HORIZONTAL;
		
		[Inspectable(category="Other", enumeration="none,horizontal,vertical", defaultValue="horizontal")]
		[Bindable(event="countChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#count
		 */
		public function get count():String
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.count;
			else
				return _count;
			
		}
		
		/**
		 * @private
		 */
		public function set count(value:String):void
		{
			
			_count = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.count = value;
			
			dispatchEvent(new Event("countChange"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  lang
		//----------------------------------
		
		private var _lang:String = "";
		
		[Bindable(event="langChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#lang
		 */
		public function get lang():String
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.lang;
			else
				return _lang;
			
		}
		
		/**
		 * @private
		 */
		public function set lang(value:String):void
		{
			
			_lang = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.lang = value;
			
			dispatchEvent(new Event("langChange"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  counturl
		//----------------------------------
		
		private var _counturl:String = "";
		
		[Bindable(event="counturlChange")]
		/**
		 * @copy com.altoinu.twitter.supportClasses.components.TweetButtonArea#counturl
		 */
		public function get counturl():String
		{
			
			if (tweetButtonArea != null)
				return tweetButtonArea.counturl;
			else
				return _counturl;
			
		}
		
		/**
		 * @private
		 */
		public function set counturl(value:String):void
		{
			
			_counturl = value;
			
			if (tweetButtonArea != null)
				tweetButtonArea.counturl = value;
			
			dispatchEvent(new Event("counturlChange"));
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function initializeComponent():void
		{
			
			// Create TweetButtonArea instead of normal AnchorToHTMLPage component
			_anchor = new TweetButtonArea(tweetButtonParams, updatePositionJSMethod, removeJSMethod, options, targetDivID);
			
			super.initializeComponent()
			
		}
		
	}
	
}