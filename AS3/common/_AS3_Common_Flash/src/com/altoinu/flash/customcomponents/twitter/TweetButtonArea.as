/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.twitter
{
	
	import com.altoinu.flash.customcomponents.twitter.events.TweetButtonEvent;
	import com.altoinu.flash.customcomponents.twitter.models.TweetButtonParameters;
	import com.altoinu.flash.external.javascript.AnchorToHTMLPage;
	
	import flash.geom.Rectangle;
	
	/**
	 *  Dispatched when Tweet Button parameter changes.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.twitter.events.TweetButtonEvent.TWEET_PARAMETER_CHANGE
	 */
	[Event(name="tweetParameterChange", type="com.altoinu.flash.customcomponents.twitter.events.TweetButtonEvent")]
	
	/**
	 * Component to handle Tweet Button placement via JavaScript.
	 * 
	 * <p>This class itself does not create Tweet Button, but passes info needed by the HTML
	 * to build it on top of Flash component. It overrides the protected method <code>executeUpdatePositionJSMethod</code> to
	 * do <code>ExternalInterface.call(updatePositionJSMethod, {id: elementID, x: contentCoordinate.x, y: contentCoordinate.y, width: contentWidth, height: contentHeight, options, options})</code>.</p>
	 * 
	 * @see https://dev.twitter.com/docs/tweet-button
	 * @author Kaoru Kawashima
	 * 
	 */
	public class TweetButtonArea extends AnchorToHTMLPage
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param tweetButtonParams
		 * @param updatePositionJSMethod
		 * @param removeJSMethod
		 * @param options
		 * @param targetDivID ID of DIV element on HTML page
		 * 
		 */
		public function TweetButtonArea(tweetButtonParams:TweetButtonParameters,
										updatePositionJSMethod:String = "TweetButtonFlash.addTweetButton",
										removeJSMethod:String = "TweetButtonFlash.removeTweetButton",
										options:Object = null,
										targetDivID:String = null)
		{
			
			super(updatePositionJSMethod, removeJSMethod, "tweet_", options, targetDivID);
			
			this.tweetButtonParams = tweetButtonParams;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var supressParameterChangeEvent:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overriden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  updatePositionJSMethod
		//----------------------------------
		
		/**
		 * @inheritDoc
		 * 
		 * @default "addTweetButton"
		 */
		override public function get updatePositionJSMethod():String
		{
			
			return super.updatePositionJSMethod;
			
		}
		
		//----------------------------------
		//  removeJSMethod
		//----------------------------------
		
		/**
		 * @inheritDoc
		 * 
		 * @default "removeTweetButton"
		 */
		override public function get removeJSMethod():String
		{
			
			return super.removeJSMethod;
			
		}
		
		//----------------------------------
		//  options
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get options():Object
		{
			
			return super.options;
			
		}
		
		/**
		 * @private
		 */
		override public function set options(value:Object):void
		{
			
			if (_options != value)
			{
				
				_options = value;
				
				// Instead of calling update() directly, use event to update here
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  tweetButtonParams
		//----------------------------------
		
		/**
		 * Parameters used by Tweet Button.
		 */
		public function get tweetButtonParams():TweetButtonParameters
		{
			
			return new TweetButtonParameters(url, via, text, related, count, lang, counturl);
			
		}
		
		/**
		 * @private
		 */
		public function set tweetButtonParams(value:TweetButtonParameters):void
		{
			
			supressParameterChangeEvent = true;
			
			if (value == null)
				value = new TweetButtonParameters();
			
			url = value.url;
			via = value.via;
			text = value.text;
			related = value.related;
			count = value.count;
			lang = value.lang;
			counturl = value.counturl;
			
			supressParameterChangeEvent = false;
			
			dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
			
		}
		
		//----------------------------------
		//  url
		//----------------------------------
		
		private var _url:String = "";
		
		public function get url():String
		{
			
			return _url;
			
		}
		
		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			
			if (_url != value)
			{
				
				_url = value;
				
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  via
		//----------------------------------
		
		private var _via:String = "";
		
		public function get via():String
		{
			
			return _via;
			
		}
		
		/**
		 * @private
		 */
		public function set via(value:String):void
		{
			
			if (_via != value)
			{
				
				_via = value;
				
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  text
		//----------------------------------
		
		private var _text:String = "";
		
		public function get text():String
		{
			
			return _text;
			
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			
			if (_text != value)
			{
				
				_text = value;
				
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  related
		//----------------------------------
		
		private var _related:String = "";
		
		public function get related():String
		{
			
			return _related;
			
		}
		
		/**
		 * @private
		 */
		public function set related(value:String):void
		{
			
			if (_related != value)
			{
				
				_related = value;
				
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  count
		//----------------------------------
		
		private var _count:String = TweetButtonCountBoxPosition.HORIZONTAL;
		
		/**
		 * Tweet button positioning, TweetButtonCountBoxPosition.NONE,
		 * TweetButtonCountBoxPosition.HORIZONTAL, or TweetButtonCountBoxPosition.VERTICAL.
		 * 
		 * @default "horizontal"
		 */
		public function get count():String
		{
			
			return _count;
			
		}
		
		/**
		 * @private
		 */
		public function set count(value:String):void
		{
			
			if (_count != value)
			{
				
				if ((value == TweetButtonCountBoxPosition.NONE) || (value == TweetButtonCountBoxPosition.HORIZONTAL) || (value == TweetButtonCountBoxPosition.VERTICAL))
					_count = value;
				else
					throw new Error("Invalid Tweet Button count box position.");
				
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  lang
		//----------------------------------
		
		private var _lang:String = "";
		
		public function get lang():String
		{
			
			return _lang;
			
		}
		
		/**
		 * @private
		 */
		public function set lang(value:String):void
		{
			
			if (_lang != value)
			{
				
				_lang = value;
				
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//----------------------------------
		//  counturl
		//----------------------------------
		
		private var _counturl:String = "";
		
		public function get counturl():String
		{
			
			return _counturl;
			
		}
		
		/**
		 * @private
		 */
		public function set counturl(value:String):void
		{
			
			if (_counturl != value)
			{
				
				_counturl = value;
				
				if (!supressParameterChangeEvent)
					dispatchEvent(new TweetButtonEvent(TweetButtonEvent.TWEET_PARAMETER_CHANGE, false, false));
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function initializeAtAddToStage():void
		{
			
			super.initializeAtAddToStage();
			
			this.addEventListener(TweetButtonEvent.TWEET_PARAMETER_CHANGE, onPropertyUpdate, false, 0, true);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function deInitializeAtRemoveFromStage():void
		{
			
			super.deInitializeAtRemoveFromStage();
			
			this.removeEventListener(TweetButtonEvent.TWEET_PARAMETER_CHANGE, onPropertyUpdate, false);
			
		}
		
		/**
		 * Method to do the actual JavaScript call
		 * <code>ExternalInterface.call(updatePositionJSMethod, {id: elementID, x: contentCoordinate.x, y: contentCoordinate.y, width: contentWidth, height: contentHeight, options: options})</code>
		 * 
		 * @param jsMethod
		 * @param id
		 * @param contentRect
		 * @param options
		 * @param targetDivID
		 * @param extra
		 * 
		 */
		override protected function executeUpdatePositionJSMethod(jsMethod:String,
																  id:String,
																  contentRect:Rectangle,
																  options:Object,
																  targetDivID:String = null,
																  extra:Object = null):void
		{
			
			if (extra == null)
				extra = new Object();
			
			// This method overridden to pass these parameters for Tweet Button
			extra.url = tweetButtonParams.url;
			extra.via = tweetButtonParams.via;
			extra.text = tweetButtonParams.text;
			extra.related = tweetButtonParams.related;
			extra.count = tweetButtonParams.count;
			extra.lang = tweetButtonParams.lang;
			extra.counturl = tweetButtonParams.counturl;
			
			super.executeUpdatePositionJSMethod(jsMethod, id, contentRect, options, targetDivID, extra);
			
			/*
			// Parameters passed to jsMethod
			var parameters:Object = new Object();
			parameters.id = id;
			parameters.x = contentRect.x;
			parameters.y = contentRect.y;
			parameters.width = contentRect.width;
			parameters.height = contentRect.height;
			parameters.options = options;
			
			// This method overridden to pass these parameters for Tweet Button
			parameters.url = tweetButtonParams.url;
			parameters.via = tweetButtonParams.via;
			parameters.text = tweetButtonParams.text;
			parameters.related = tweetButtonParams.related;
			parameters.count = tweetButtonParams.count;
			parameters.lang = tweetButtonParams.lang;
			parameters.counturl = tweetButtonParams.counturl;
			
			ExternalInterface.call(jsMethod, parameters); // Create new Tweet Button HTML component
			*/
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onPropertyUpdate(event:TweetButtonEvent):void
		{
			
			invalidatePositionAndSize();
			
		}
		
	}
	
}